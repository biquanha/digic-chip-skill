#!/usr/bin/env bash
set -euo pipefail

REMOTE=""
OUTPUT="eda_tool_probe.txt"
SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=no"
SKIP_MODULE_AVAIL=0

TOOLS=(
  vcs verdi urg dve vlogan vhdlan
  spyglass sg_shell
  vcf vcf_shell jaspergold
  dc_shell design_vision fm_shell pt_shell primetime
  xrun irun qverilog vsim vlog vopt simvision
)

usage() {
  echo "用法: $0 [--remote eda01] [--output eda_tool_probe.txt] [--skip-module-avail]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    --skip-module-avail) SKIP_MODULE_AVAIL=1; shift 1 ;;
    *) usage; exit 2 ;;
  esac
done

run_probe_body() {
  source /etc/profile >/dev/null 2>&1 || true
  echo "[INFO] host=$(/bin/hostname 2>/dev/null || uname -n)"
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

  if [[ "$SKIP_MODULE_AVAIL" -eq 1 ]]; then
    echo
    echo "[INFO] skip module avail"
    return 0
  fi

  echo
  for key in synopsys/vcs synopsys/verdi spyglass cadence mentor questa xcelium; do
    echo "[MODULE] $key"
    if command -v timeout >/dev/null 2>&1; then
      timeout 8s bash -lc "module -t avail '$key' 2>/dev/null | sed -n '1,40p'" || echo "[WARN] module avail timeout: $key"
    else
      module -t avail "$key" 2>/dev/null | sed -n '1,40p' || true
    fi
  done
}

if [[ -n "$REMOTE" ]]; then
  ssh $SSH_OPTS "$REMOTE" "SKIP_MODULE_AVAIL=$SKIP_MODULE_AVAIL bash -s" <<'EOF' | tee "$OUTPUT"
set -euo pipefail
TOOLS=(
  vcs verdi urg dve vlogan vhdlan
  spyglass sg_shell
  vcf vcf_shell jaspergold
  dc_shell design_vision fm_shell pt_shell primetime
  xrun irun qverilog vsim vlog vopt simvision
)
run_probe_body() {
  source /etc/profile >/dev/null 2>&1 || true
  echo "[INFO] host=$(/bin/hostname 2>/dev/null || uname -n)"
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
  if [[ "${SKIP_MODULE_AVAIL:-0}" -eq 1 ]]; then
    echo
    echo "[INFO] skip module avail"
    return 0
  fi
  echo
  for key in synopsys/vcs synopsys/verdi spyglass cadence mentor questa xcelium; do
    echo "[MODULE] $key"
    if command -v timeout >/dev/null 2>&1; then
      timeout 8s bash -lc "module -t avail '$key' 2>/dev/null | sed -n '1,40p'" || echo "[WARN] module avail timeout: $key"
    else
      module -t avail "$key" 2>/dev/null | sed -n '1,40p' || true
    fi
  done
}
run_probe_body
EOF
else
  run_probe_body | tee "$OUTPUT"
fi
