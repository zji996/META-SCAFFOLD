#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ $# -gt 0 ]]; then
  export META_SCAFFOLD_CODEX_SKILLS_ROOT="$1"
fi
exec "$ROOT/scripts/install-agent-skill.sh" codex
