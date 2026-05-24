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

install_skill() {
  fetch_file "skills/meta-scaffold/SKILL.md" "$TARGET_DIR/skills/meta-scaffold/SKILL.md"
  fetch_file "skills/meta-scaffold/agents/openai.yaml" "$TARGET_DIR/skills/meta-scaffold/agents/openai.yaml"
  echo "installed: skills/meta-scaffold/SKILL.md"
  echo "installed: skills/meta-scaffold/agents/openai.yaml"
}

install_agents() {
  local marker="<!-- META-SCAFFOLD:START -->"
  local block
  block=$(cat <<'EOF'
<!-- META-SCAFFOLD:START -->
## META-SCAFFOLD

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程时，先读取并遵守 `skills/meta-scaffold/SKILL.md`。

默认协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```
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

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程时，先读取并遵守 `skills/meta-scaffold/SKILL.md`。

默认协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```
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
  copy_if_absent "templates/docs/reference/architecture.md" "$TARGET_DIR/docs/reference/architecture.md"
  copy_if_absent "templates/scaffold.plan.yaml" "$TARGET_DIR/scaffold.plan.yaml"
}

case "$MODE" in
  skill)
    install_skill
    ;;
  agents)
    install_skill
    install_agents
    ;;
  claude)
    install_skill
    install_claude
    ;;
  cursor)
    install_cursor
    ;;
  templates)
    install_templates
    ;;
  all)
    install_skill
    install_agents
    install_claude
    install_cursor
    install_templates
    ;;
  *)
    echo "Usage: $0 [target-dir] [skill|agents|claude|cursor|templates|all]" >&2
    exit 2
    ;;
esac
