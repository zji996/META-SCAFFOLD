#!/usr/bin/env bash
set -euo pipefail

REPO="${META_SCAFFOLD_REPO:-zji996/META-SCAFFOLD}"
REF="${META_SCAFFOLD_REF:-refs/heads/main}"
RAW_BASE="${META_SCAFFOLD_RAW_BASE:-https://raw.githubusercontent.com/$REPO/$REF}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

target="$tmp/project"
codex_home="$tmp/codex-home"

curl -fsSL "$RAW_BASE/scripts/install.sh" | bash -s -- "$target" all >/dev/null

[[ -f "$target/skills/meta-scaffold/SKILL.md" ]] || { echo "remote installer missing skill" >&2; exit 1; }
[[ -f "$target/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "remote installer missing skill metadata" >&2; exit 1; }
[[ -f "$target/.cursor/rules/meta-scaffold.mdc" ]] || { echo "remote installer missing cursor rule" >&2; exit 1; }
grep -q 'META-SCAFFOLD' "$target/AGENTS.md" || { echo "remote installer missing AGENTS block" >&2; exit 1; }

CODEX_HOME="$codex_home" python3 "$HOME/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo "$REPO" \
  --path skills/meta-scaffold \
  --ref "${META_SCAFFOLD_GITHUB_REF:-main}" >/dev/null

[[ -f "$codex_home/skills/meta-scaffold/SKILL.md" ]] || { echo "codex GitHub installer missing skill" >&2; exit 1; }
[[ -f "$codex_home/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "codex GitHub installer missing skill metadata" >&2; exit 1; }

echo "META-SCAFFOLD remote smoke passed."
