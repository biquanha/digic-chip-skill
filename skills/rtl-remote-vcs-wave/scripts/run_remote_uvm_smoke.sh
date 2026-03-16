#!/usr/bin/env bash
set -euo pipefail

REMOTE=""
WORKDIR=""
TESTNAME="smoke_test"
MODULE_VCS="synopsys/vcs/Q-2020.03-SP2"
MODULE_VERDI="synopsys/verdi/R-2020.12-SP1"
MODULE_LICENSE="license"
VERDI_HOME="/nfs/tools/synopsys/verdi/R-2020.12-SP1"
SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=no"
FSDB_NAME="tb.fsdb"
SIM_LOG="sim.log"
COMPILE_LOG="vcs_compile.log"
SUMMARY_LOG="uvm_smoke_summary.txt"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --workdir) WORKDIR="$2"; shift 2 ;;
    --testname) TESTNAME="$2"; shift 2 ;;
    --module-vcs) MODULE_VCS="$2"; shift 2 ;;
    --module-verdi) MODULE_VERDI="$2"; shift 2 ;;
    --module-license) MODULE_LICENSE="$2"; shift 2 ;;
    --verdi-home) VERDI_HOME="$2"; shift 2 ;;
    *) echo "未知参数: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$REMOTE" || -z "$WORKDIR" ]]; then
  echo "用法: $0 --remote <远端主机> --workdir <工程目录> [--testname smoke_test]" >&2
  exit 2
fi

ssh $SSH_OPTS "$REMOTE" bash <<EOF
set -euo pipefail
source /etc/profile >/dev/null 2>&1 || true
module load $MODULE_VCS $MODULE_VERDI $MODULE_LICENSE >/dev/null 2>&1 || true
export VERDI_HOME='$VERDI_HOME'
export NOVAS_HOME='$VERDI_HOME'
cd '$WORKDIR/sim'
make clean || true
make comp VERDI_HOME='$VERDI_HOME'
make sim VERDI_HOME='$VERDI_HOME' TESTNAME='$TESTNAME' || true
{
  echo "[INFO] remote=$REMOTE"
  echo "[INFO] workdir=$WORKDIR"
  echo "[INFO] testname=$TESTNAME"
  echo "[INFO] verdi_home=$VERDI_HOME"
  echo "[INFO] artifacts"
  ls -l simv '$COMPILE_LOG' '$SIM_LOG' '$FSDB_NAME' 2>/dev/null || true
  echo
  echo "[INFO] compile_tail"
  tail -n 20 '$COMPILE_LOG' 2>/dev/null || true
  echo
  echo "[INFO] sim_key_lines"
  grep -E "UVM_(ERROR|FATAL)|TestCase Passed|compare_count|error_count|SCB_SUMMARY|TEST PASS|TEST FAIL" '$SIM_LOG' 2>/dev/null || true
} | tee '$SUMMARY_LOG'

if [[ ! -f simv ]]; then
  echo "[ERROR] simv 未生成" >&2
  exit 11
fi
if [[ ! -f '$FSDB_NAME' ]]; then
  echo "[ERROR] FSDB 未生成: $FSDB_NAME" >&2
  exit 12
fi
if grep -Eq "UVM_ERROR\s*:\s*[1-9]" '$SIM_LOG' 2>/dev/null; then
  echo "[ERROR] 检测到 UVM_ERROR 非 0" >&2
  exit 13
fi
if grep -Eq "UVM_FATAL\s*:\s*[1-9]" '$SIM_LOG' 2>/dev/null; then
  echo "[ERROR] 检测到 UVM_FATAL 非 0" >&2
  exit 14
fi
if grep -Eq "error_count=([1-9][0-9]*)|total error count:\s*([1-9][0-9]*)" '$SIM_LOG' 2>/dev/null; then
  echo "[ERROR] scoreboard error_count 非 0" >&2
  exit 15
fi

fsdbreport '$FSDB_NAME' -o fsdb_report.txt >/dev/null 2>&1 || true
if [[ -f fsdb_report.txt ]]; then
  echo "[INFO] fsdb_report generated" | tee -a '$SUMMARY_LOG'
fi

echo "[PASS] remote UVM smoke 验收通过" | tee -a '$SUMMARY_LOG'
EOF
