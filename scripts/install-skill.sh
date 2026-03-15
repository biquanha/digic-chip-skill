#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="codex"
DRY_RUN="false"
CODEX_SKILLS_DIR="${CODEX_HOME:-${HOME}/.codex}/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
SKILL_NAMES=("rtl-remote-vcs-wave")

log() {
  printf '[install-skill] %s\n' "$*"
}

die() {
  printf '[install-skill] 错误: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<USAGE
用法:
  scripts/install-skill.sh [选项]

选项:
  --target {codex|claude|both}   安装目标，默认 codex
  --codex-skills-dir PATH        Codex skills 目录，默认 \${CODEX_HOME:-~/.codex}/skills
  --claude-skills-dir PATH       Claude skills 目录，默认 ~/.claude/skills
  --dry-run                      仅打印操作，不实际写入
  -h, --help                     显示帮助
USAGE
}

copy_skill() {
  local skill="$1"
  local dest_root="$2"
  local src="$REPO_ROOT/skills/$skill"
  local dest="$dest_root/$skill"
  [[ -f "$src/SKILL.md" ]] || die "缺少 $src/SKILL.md"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY-RUN 复制 $src -> $dest"
    return
  fi

  mkdir -p "$dest_root"
  rm -rf "$dest"
  cp -R "$src" "$dest"
}

install_target() {
  local label="$1"
  local dest_root="$2"
  log "安装目标: $label"
  log "技能目录: $dest_root"
  for skill in "${SKILL_NAMES[@]}"; do
    copy_skill "$skill" "$dest_root"
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ -n "${2:-}" ]] || die "--target 需要参数"
      TARGET="$2"
      shift 2
      ;;
    --codex-skills-dir)
      [[ -n "${2:-}" ]] || die "--codex-skills-dir 需要参数"
      CODEX_SKILLS_DIR="$2"
      shift 2
      ;;
    --claude-skills-dir)
      [[ -n "${2:-}" ]] || die "--claude-skills-dir 需要参数"
      CLAUDE_SKILLS_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "未知参数: $1"
      ;;
  esac
done

case "$TARGET" in
  codex)
    install_target codex "$CODEX_SKILLS_DIR"
    ;;
  claude)
    install_target claude "$CLAUDE_SKILLS_DIR"
    ;;
  both)
    install_target codex "$CODEX_SKILLS_DIR"
    install_target claude "$CLAUDE_SKILLS_DIR"
    ;;
  *)
    die "--target 必须是 codex / claude / both"
    ;;
esac

log "安装完成"
