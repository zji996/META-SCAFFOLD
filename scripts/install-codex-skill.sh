#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
DEST_ROOT="${1:-$CODEX_HOME_DIR/skills}"
DEST="$DEST_ROOT/meta-scaffold"
FORCE="${META_SCAFFOLD_FORCE_INSTALL:-0}"

if [[ ! -f "$ROOT/skills/meta-scaffold/SKILL.md" ]]; then
  echo "missing: $ROOT/skills/meta-scaffold/SKILL.md" >&2
  exit 1
fi

is_meta_scaffold_dest() {
  [[ -f "$DEST/SKILL.md" ]] && grep -q '^name: meta-scaffold$' "$DEST/SKILL.md"
}

mkdir -p "$DEST_ROOT"

if [[ -e "$DEST" ]]; then
  if [[ "$FORCE" == "1" ]]; then
    if ! is_meta_scaffold_dest; then
      echo "refuse to replace non-meta-scaffold path: $DEST" >&2
      echo "Remove it manually if this path is intentionally reusable." >&2
      exit 1
    fi
    rm -rf "$DEST"
  else
    echo "skip: $DEST already exists" >&2
    echo "Set META_SCAFFOLD_FORCE_INSTALL=1 to replace it." >&2
    exit 0
  fi
fi

cp -R "$ROOT/skills/meta-scaffold" "$DEST"

echo "installed: $DEST"
echo "Restart Codex to pick up new skills."
