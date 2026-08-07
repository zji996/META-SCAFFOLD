#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"
MODE="${2:-all}"
RAW_BASE="${META_SCAFFOLD_RAW_BASE:-https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main}"
SCRIPT_SOURCE="${BASH_SOURCE[0]:-}"
SCRIPT_DIR=""
LOCAL_ROOT=""

if [[ -n "$SCRIPT_SOURCE" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" 2>/dev/null && pwd || true)"
  if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/../skills/meta-scaffold/SKILL.md" ]]; then
    LOCAL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  fi
fi

mkdir -p "$TARGET_DIR"

fetch_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -n "$LOCAL_ROOT" && -f "$LOCAL_ROOT/$src" ]]; then
    cp "$LOCAL_ROOT/$src" "$dest"
  else
    curl -fsSL "$RAW_BASE/$src" -o "$dest"
  fi
}

append_block_once() {
  local file="$1"
  local marker="$2"
  local block="$3"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if grep -Fq "$marker" "$file"; then
    echo "skip: $file already contains $marker"
  else
    printf '\n%s\n' "$block" >> "$file"
    echo "updated: $file"
  fi
}

reject_project_skill_vendor() {
  cat >&2 <<'EOF'
META-SCAFFOLD no longer vendors skills/meta-scaffold into consumer repos.

Install the skill at user scope instead:
  ./scripts/install-agent-skill.sh all
  # or: pi install git:github.com/zji996/META-SCAFFOLD

Project scaffolding (AGENTS/CLAUDE/Cursor rule/docs templates) uses:
  ./scripts/install.sh [target-dir] [agents|claude|cursor|templates|all]
EOF
  exit 2
}

install_agents() {
  local marker="<!-- META-SCAFFOLD:START -->"
  local block
  block=$(cat <<'EOF'
<!-- META-SCAFFOLD:START -->
## META-SCAFFOLD

本仓库的 AI 契约入口是本文件与 `docs/current.md`。治理约定（验证、授权、记忆寿命、交接）由用户级 `meta-scaffold` skill 提供；**不要**在业务仓 vendor `skills/meta-scaffold/`。

小任务直接修改并验证；复杂任务才显式说明事实、假设、成功标准和计划。输出与交接必须自包含，只有暂停或换会话时才生成 handoff prompt。
<!-- META-SCAFFOLD:END -->
EOF
)
  append_block_once "$TARGET_DIR/AGENTS.md" "$marker" "$block"
}

install_claude() {
  local marker="<!-- META-SCAFFOLD:START -->"
  local block
  block=$(cat <<'EOF'
<!-- META-SCAFFOLD:START -->
## META-SCAFFOLD

项目契约见 `AGENTS.md`，当前状态见 `docs/current.md`。仓库治理细节由用户级 `meta-scaffold` skill 提供；不要在本仓复制 `skills/meta-scaffold/`。

小改直接改并验证；复杂任务才先对齐事实、假设、成功标准和计划。
<!-- META-SCAFFOLD:END -->
EOF
)
  append_block_once "$TARGET_DIR/CLAUDE.md" "$marker" "$block"
}

install_cursor() {
  fetch_file "dist/CURSOR.mdc" "$TARGET_DIR/.cursor/rules/meta-scaffold.mdc"
  echo "installed: .cursor/rules/meta-scaffold.mdc"
}

copy_if_absent() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" ]]; then
    echo "skip existing: ${dest#$TARGET_DIR/}"
  else
    fetch_file "$src" "$dest"
    echo "installed: ${dest#$TARGET_DIR/}"
  fi
}

install_templates() {
  copy_if_absent "templates/docs/current.md" "$TARGET_DIR/docs/current.md"
  copy_if_absent "templates/docs/roadmap.md" "$TARGET_DIR/docs/roadmap.md"
  copy_if_absent "templates/docs/decision/INDEX.md" "$TARGET_DIR/docs/decision/INDEX.md"
  copy_if_absent "templates/docs/reference/architecture.md" "$TARGET_DIR/docs/reference/architecture.md"
  copy_if_absent "templates/scaffold.plan.yaml" "$TARGET_DIR/scaffold.plan.yaml"
}

case "$MODE" in
  skill)
    reject_project_skill_vendor
    ;;
  agents)
    install_agents
    ;;
  claude)
    install_claude
    ;;
  cursor)
    install_cursor
    ;;
  templates)
    install_templates
    ;;
  all)
    install_agents
    install_claude
    install_cursor
    install_templates
    ;;
  *)
    echo "Usage: $0 [target-dir] [agents|claude|cursor|templates|all]" >&2
    echo "Skill installs are user-level only: ./scripts/install-agent-skill.sh all" >&2
    exit 2
    ;;
esac
