#!/usr/bin/env bash
set -euo pipefail

REMOTE=""
WORKDIR=""
MODULE_VCS="synopsys/vcs/Q-2020.03-SP2"
MODULE_VERDI="synopsys/verdi/R-2020.12-SP1"
MODULE_LICENSE="license"
VERDI_HOME="/nfs/tools/synopsys/verdi/R-2020.12-SP1"
MAKE_TARGET="run"
SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=no"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --workdir) WORKDIR="$2"; shift 2 ;;
    --module-vcs) MODULE_VCS="$2"; shift 2 ;;
    --module-verdi) MODULE_VERDI="$2"; shift 2 ;;
    --module-license) MODULE_LICENSE="$2"; shift 2 ;;
    --verdi-home) VERDI_HOME="$2"; shift 2 ;;
    --make-target) MAKE_TARGET="$2"; shift 2 ;;
    *) echo "未知参数: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$REMOTE" || -z "$WORKDIR" ]]; then
  echo "用法: $0 --remote <远端主机> --workdir <共享目录> [--module-vcs ...] [--module-verdi ...] [--module-license ...] [--verdi-home ...] [--make-target run]" >&2
  exit 2
fi

ssh $SSH_OPTS "$REMOTE" "
  source /etc/profile >/dev/null 2>&1 || true
  module load $MODULE_VCS $MODULE_VERDI $MODULE_LICENSE >/dev/null 2>&1
  export VERDI_HOME='$VERDI_HOME'
  export NOVAS_HOME='${VERDI_HOME}'
  cd '$WORKDIR'
  make clean || true
  make VERDI_HOME='$VERDI_HOME'
  make '$MAKE_TARGET'
  fsdbreport counter.fsdb -s /tb_counter/count -o fsdb_summary.txt
  fsdbreport counter.fsdb -strobe '/tb_counter/clk==1' -s /tb_counter/en -s /tb_counter/count -o fsdb_strobe.txt
  ls -l simv simv.log counter.fsdb fsdb_summary.txt fsdb_strobe.txt
"
