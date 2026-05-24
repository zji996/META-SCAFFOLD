#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required=(
  "README.md"
  "README.en.md"
  "AGENTS.md"
  "CLAUDE.md"
  "CURSOR.md"
  "LICENSE"
  "Makefile"

  "VERSION"
  "CHANGELOG.md"
  ".gitattributes"
  ".github/workflows/check.yml"
  "skills/meta-scaffold/SKILL.md"
  "skills/meta-scaffold/README.md"
  "skills/meta-scaffold/agents/openai.yaml"
  "prompts/META-SCAFFOLD-v5.md"
  "prompts/META-SCAFFOLD-v5.short.md"
  "dist/AGENTS.md"
  "dist/CLAUDE.md"
  "dist/CURSOR.mdc"
  "templates/AGENTS.meta-scaffold.md"
  "templates/CLAUDE.meta-scaffold.md"
  "templates/scaffold.plan.yaml"
  "templates/docs/current.md"
  "templates/docs/roadmap.md"
  "templates/docs/reference/architecture.md"
  "scripts/install-codex-skill.sh"
  "scripts/smoke-remote.sh"
  "scripts/install.sh"
  "scripts/check.sh"
  ".claude-plugin/plugin.json"
  ".cursor/rules/meta-scaffold.mdc"
  "docs/current.md"
  "docs/reference/architecture.md"
)

for f in "${required[@]}"; do
  [[ -f "$f" ]] || { echo "missing: $f" >&2; exit 1; }
done

grep -q '^name: meta-scaffold$' skills/meta-scaffold/SKILL.md || { echo "missing skill name" >&2; exit 1; }
grep -q '^description:' skills/meta-scaffold/SKILL.md || { echo "missing skill description" >&2; exit 1; }
grep -q '^license: MIT$' skills/meta-scaffold/SKILL.md || { echo "missing skill license" >&2; exit 1; }
grep -q 'Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact' skills/meta-scaffold/SKILL.md || { echo "missing protocol" >&2; exit 1; }
grep -q 'zji996/META-SCAFFOLD' README.md || { echo "README missing public import path" >&2; exit 1; }

python3 -m json.tool .claude-plugin/plugin.json >/dev/null

# Test local installer without touching the repo.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
./scripts/install.sh "$tmp" all >/dev/null
[[ -f "$tmp/skills/meta-scaffold/SKILL.md" ]] || { echo "installer failed skill" >&2; exit 1; }
[[ -f "$tmp/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "installer failed skill metadata" >&2; exit 1; }
[[ -f "$tmp/.cursor/rules/meta-scaffold.mdc" ]] || { echo "installer failed cursor rule" >&2; exit 1; }
[[ -f "$tmp/docs/current.md" ]] || { echo "installer failed docs/current.md" >&2; exit 1; }
grep -q 'META-SCAFFOLD' "$tmp/AGENTS.md" || { echo "installer failed AGENTS append" >&2; exit 1; }

codex_home="$tmp/codex-home"
CODEX_HOME="$codex_home" ./scripts/install-codex-skill.sh >/dev/null
[[ -f "$codex_home/skills/meta-scaffold/SKILL.md" ]] || { echo "codex skill installer failed" >&2; exit 1; }

bad_dest="$tmp/not-meta-scaffold"
mkdir -p "$bad_dest/skills/meta-scaffold"
printf '%s\n' 'not a skill' > "$bad_dest/skills/meta-scaffold/SKILL.md"
if CODEX_HOME="$bad_dest" META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-codex-skill.sh >/dev/null 2>&1; then
  echo "codex skill installer replaced non-meta-scaffold path" >&2
  exit 1
fi

echo "META-SCAFFOLD repo check passed."
