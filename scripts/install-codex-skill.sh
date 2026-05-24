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

mkdir -p "$DEST_ROOT"

if [[ -e "$DEST" ]]; then
  if [[ "$FORCE" == "1" ]]; then
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
