#!/usr/bin/env bash
set -euo pipefail

REMOTE=""
OUTPUT="eda_tool_probe.txt"
SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=no"

TOOLS=(
  vcs verdi urg dve vlogan vhdlan
  spyglass sg_shell
  vcf vcf_shell jaspergold
  dc_shell design_vision fm_shell pt_shell primetime
  xrun irun qverilog vsim vlog vopt simvision
)

usage() {
  echo "用法: $0 [--remote eda01] [--output eda_tool_probe.txt]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    *) usage; exit 2 ;;
  esac
done

run_probe() {
  source /etc/profile >/dev/null 2>&1 || true
  echo "[INFO] host=$(hostname 2>/dev/null || uname -n)"
  echo "[INFO] date=$(date '+%F %T' 2>/dev/null || true)"
  echo
  for tool in "${TOOLS[@]}"; do
    path=$(command -v "$tool" 2>/dev/null || true)
    if [[ -n "$path" ]]; then
      echo "FOUND:$tool:$path"
    else
      echo "MISS:$tool"
    fi
  done
  echo
  for key in synopsys/vcs synopsys/verdi spyglass cadence mentor questa xcelium; do
    echo "[MODULE] $key"
    module -t avail "$key" 2>/dev/null | sed -n '1,40p' || true
  done
}

if [[ -n "$REMOTE" ]]; then
  ssh $SSH_OPTS "$REMOTE" 'bash -s' <<'EOF' | tee "$OUTPUT"
set -euo pipefail
TOOLS=(
  vcs verdi urg dve vlogan vhdlan
  spyglass sg_shell
  vcf vcf_shell jaspergold
  dc_shell design_vision fm_shell pt_shell primetime
  xrun irun qverilog vsim vlog vopt simvision
)
source /etc/profile >/dev/null 2>&1 || true
echo "[INFO] host=$(hostname 2>/dev/null || uname -n)"
echo "[INFO] date=$(date '+%F %T' 2>/dev/null || true)"
echo
for tool in "${TOOLS[@]}"; do
  path=$(command -v "$tool" 2>/dev/null || true)
  if [[ -n "$path" ]]; then
    echo "FOUND:$tool:$path"
  else
    echo "MISS:$tool"
  fi
done
echo
for key in synopsys/vcs synopsys/verdi spyglass cadence mentor questa xcelium; do
  echo "[MODULE] $key"
  module -t avail "$key" 2>/dev/null | sed -n '1,40p' || true
done
EOF
else
  run_probe | tee "$OUTPUT"
fi
