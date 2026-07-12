#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/skills/meta-scaffold"
TARGET="${1:-all}"
FORCE="${META_SCAFFOLD_FORCE_INSTALL:-0}"
CODEX_SKILLS_ROOT="${META_SCAFFOLD_CODEX_SKILLS_ROOT:-${CODEX_HOME:-$HOME/.codex}/skills}"
KILO_SKILLS_ROOT="${META_SCAFFOLD_KILO_SKILLS_ROOT:-${KILO_HOME:-$HOME/.kilo}/skills}"
CURSOR_SKILLS_ROOT="${META_SCAFFOLD_CURSOR_SKILLS_ROOT:-${CURSOR_HOME:-$HOME/.cursor}/skills}"
GLOBAL_SKILLS_ROOT="${META_SCAFFOLD_GLOBAL_SKILLS_ROOT:-$HOME/.agents/skills}"

[[ -f "$SOURCE/SKILL.md" ]] || { echo "missing: $SOURCE/SKILL.md" >&2; exit 1; }

install_to() {
  local platform="$1"
  local dest_root="$2"
  local dest="$dest_root/meta-scaffold"

  mkdir -p "$dest_root"
  if [[ -e "$dest" ]]; then
    if [[ ! -f "$dest/SKILL.md" ]] || ! grep -q '^name: meta-scaffold$' "$dest/SKILL.md"; then
      echo "refuse to replace non-meta-scaffold path: $dest" >&2
      return 1
    fi
    if [[ "$FORCE" != "1" ]]; then
      echo "skip: $dest already exists"
      echo "Set META_SCAFFOLD_FORCE_INSTALL=1 to refresh it."
      return 0
    fi
    rm -rf "$dest"
  fi

  cp -R "$SOURCE" "$dest"
  echo "installed ($platform): $dest"
}

case "$TARGET" in
  codex)
    install_to codex "$CODEX_SKILLS_ROOT"
    ;;
  kilo)
    install_to kilo "$KILO_SKILLS_ROOT"
    ;;
  cursor)
    install_to cursor "$CURSOR_SKILLS_ROOT"
    ;;
  pi|global)
    install_to global "$GLOBAL_SKILLS_ROOT"
    ;;
  all)
    install_to global "$GLOBAL_SKILLS_ROOT"
    install_to codex "$CODEX_SKILLS_ROOT"
    install_to kilo "$KILO_SKILLS_ROOT"
    install_to cursor "$CURSOR_SKILLS_ROOT"
    ;;
  *)
    echo "Usage: $0 [global|pi|codex|kilo|cursor|all]" >&2
    exit 2
    ;;
esac

echo "Start a new session to load the skill; Kilo Code may also use /reload."
