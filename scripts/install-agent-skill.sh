#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/skills/meta-scaffold"
TARGET="all"
FORCE="${META_SCAFFOLD_FORCE_INSTALL:-0}"
USE_LINK="${META_SCAFFOLD_LINK:-${META_SCAFFOLD_SYMLINK:-0}}"

CODEX_SKILLS_ROOT="${META_SCAFFOLD_CODEX_SKILLS_ROOT:-${CODEX_HOME:-$HOME/.codex}/skills}"
KILO_SKILLS_ROOT="${META_SCAFFOLD_KILO_SKILLS_ROOT:-${KILO_HOME:-$HOME/.kilo}/skills}"
CURSOR_SKILLS_ROOT="${META_SCAFFOLD_CURSOR_SKILLS_ROOT:-${CURSOR_HOME:-$HOME/.cursor}/skills}"
GEMINI_SKILLS_ROOT="${META_SCAFFOLD_GEMINI_SKILLS_ROOT:-${GEMINI_HOME:-$HOME/.gemini}/skills}"
GLOBAL_SKILLS_ROOT="${META_SCAFFOLD_GLOBAL_SKILLS_ROOT:-$HOME/.agents/skills}"

# Parse flags and target argument
while [[ $# -gt 0 ]]; do
  case "$1" in
    --link|--symlink|-s)
      USE_LINK=1
      shift
      ;;
    --copy|-c)
      USE_LINK=0
      shift
      ;;
    --force|-f)
      FORCE=1
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: install-agent-skill.sh [options] [global|pi|codex|kilo|cursor|gemini|all]

Options:
  --link, --symlink, -s   Create symlinks pointing to local repo source (auto-updates on git pull)
  --copy, -c              Copy files statically into target skill directory (default)
  --force, -f             Overwrite existing meta-scaffold installation
  -h, --help              Show this help message

Environment variables:
  META_SCAFFOLD_LINK=1           Enable symlink mode
  META_SCAFFOLD_FORCE_INSTALL=1  Enable force overwrite
EOF
      exit 0
      ;;
    global|pi|codex|kilo|cursor|gemini|all)
      TARGET="$1"
      shift
      ;;
    *)
      echo "Unknown option or target: $1" >&2
      echo "Usage: $0 [--link|--copy] [--force] [global|pi|codex|kilo|cursor|gemini|all]" >&2
      exit 2
      ;;
  esac
done

[[ -f "$SOURCE/SKILL.md" ]] || { echo "missing: $SOURCE/SKILL.md" >&2; exit 1; }

install_to() {
  local platform="$1"
  local dest_root="$2"
  local dest="$dest_root/meta-scaffold"

  mkdir -p "$dest_root"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ ! -f "$dest/SKILL.md" ]] || ! grep -q '^name: meta-scaffold$' "$dest/SKILL.md"; then
      echo "refuse to replace non-meta-scaffold path: $dest" >&2
      return 1
    fi
    if [[ "$FORCE" != "1" ]]; then
      if [[ "$USE_LINK" == "1" && -L "$dest" ]] && [[ "$(readlink -f "$dest" 2>/dev/null || true)" == "$(readlink -f "$SOURCE" 2>/dev/null || true)" ]]; then
        echo "ok (already linked): $dest"
        return 0
      fi
      echo "skip: $dest already exists"
      echo "Set META_SCAFFOLD_FORCE_INSTALL=1 or use --force to refresh it."
      return 0
    fi
    rm -rf "$dest"
  fi

  if [[ "$USE_LINK" == "1" ]]; then
    ln -sfn "$SOURCE" "$dest"
    echo "linked ($platform): $dest -> $SOURCE"
  else
    cp -R "$SOURCE" "$dest"
    echo "installed ($platform): $dest"
  fi
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
  gemini)
    install_to gemini "$GEMINI_SKILLS_ROOT"
    ;;
  pi|global)
    install_to global "$GLOBAL_SKILLS_ROOT"
    ;;
  all)
    install_to global "$GLOBAL_SKILLS_ROOT"
    install_to codex "$CODEX_SKILLS_ROOT"
    install_to kilo "$KILO_SKILLS_ROOT"
    install_to cursor "$CURSOR_SKILLS_ROOT"
    install_to gemini "$GEMINI_SKILLS_ROOT"
    ;;
esac

echo "Start a new session to load the skill; Kilo Code may also use /reload."
