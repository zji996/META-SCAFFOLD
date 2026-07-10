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
manifest="$tmp/index.json"

curl -fsSL "$RAW_BASE/scripts/install.sh" | bash -s -- "$target" all >/dev/null

[[ -f "$target/skills/meta-scaffold/SKILL.md" ]] || { echo "remote installer missing skill" >&2; exit 1; }
[[ -f "$target/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "remote installer missing skill metadata" >&2; exit 1; }
[[ -f "$target/skills/meta-scaffold/references/platforms.md" ]] || { echo "remote installer missing skill references" >&2; exit 1; }
[[ -f "$target/.cursor/rules/meta-scaffold.mdc" ]] || { echo "remote installer missing cursor rule" >&2; exit 1; }
grep -q 'META-SCAFFOLD' "$target/AGENTS.md" || { echo "remote installer missing AGENTS block" >&2; exit 1; }

curl -fsSL "$RAW_BASE/skills/index.json" -o "$manifest"
python3 -m json.tool "$manifest" >/dev/null
grep -q 'references/platforms.md' "$manifest" || { echo "remote Kilo manifest missing references" >&2; exit 1; }
while IFS= read -r file; do
  curl -fsSL "$RAW_BASE/skills/meta-scaffold/$file" -o /dev/null
done < <(python3 - "$manifest" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    index = json.load(handle)
for file in index["skills"][0]["files"]:
    print(file)
PY
)

CODEX_HOME="$codex_home" python3 "$HOME/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo "$REPO" \
  --path skills/meta-scaffold \
  --ref "${META_SCAFFOLD_GITHUB_REF:-main}" >/dev/null

[[ -f "$codex_home/skills/meta-scaffold/SKILL.md" ]] || { echo "codex GitHub installer missing skill" >&2; exit 1; }
[[ -f "$codex_home/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "codex GitHub installer missing skill metadata" >&2; exit 1; }
[[ -f "$codex_home/skills/meta-scaffold/references/platforms.md" ]] || { echo "codex GitHub installer missing skill references" >&2; exit 1; }

echo "META-SCAFFOLD remote smoke passed."
