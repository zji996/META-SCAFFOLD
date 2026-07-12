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
  "skills/meta-scaffold/references/handoff.md"
  "skills/meta-scaffold/references/platforms.md"
  "skills/meta-scaffold/references/repository-patterns.md"
  "skills/index.json"
  "prompts/META-SCAFFOLD-v6.md"
  "prompts/META-SCAFFOLD-v6.short.md"
  "dist/AGENTS.md"
  "dist/CLAUDE.md"
  "dist/CURSOR.mdc"
  "templates/AGENTS.meta-scaffold.md"
  "templates/CLAUDE.meta-scaffold.md"
  "templates/scaffold.plan.yaml"
  "templates/docs/current.md"
  "templates/docs/roadmap.md"
  "templates/docs/decision/INDEX.md"
  "templates/docs/reference/architecture.md"
  "scripts/install-codex-skill.sh"
  "scripts/install-agent-skill.sh"
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

version="$(tr -d '[:space:]' < VERSION)"
grep -q '^name: meta-scaffold$' skills/meta-scaffold/SKILL.md || { echo "missing skill name" >&2; exit 1; }
grep -q '^description:' skills/meta-scaffold/SKILL.md || { echo "missing skill description" >&2; exit 1; }
grep -q '^license: MIT$' skills/meta-scaffold/SKILL.md || { echo "missing skill license" >&2; exit 1; }
grep -q "version: \"$version\"" skills/meta-scaffold/SKILL.md || { echo "skill metadata version mismatch" >&2; exit 1; }
grep -q '降低仓库长期理解成本' skills/meta-scaffold/SKILL.md || { echo "missing purpose statement" >&2; exit 1; }
grep -q 'references/handoff.md' skills/meta-scaffold/SKILL.md || { echo "missing handoff reference" >&2; exit 1; }
grep -q 'references/repository-patterns.md' skills/meta-scaffold/SKILL.md || { echo "missing repository-patterns reference" >&2; exit 1; }
grep -q 'zji996/META-SCAFFOLD' README.md || { echo "README missing public import path" >&2; exit 1; }
grep -q "v$version" README.md || { echo "README version mismatch" >&2; exit 1; }

python3 -m json.tool .claude-plugin/plugin.json >/dev/null
python3 -m json.tool skills/index.json >/dev/null
python3 - "$version" <<'PY'
import json
import sys

version = sys.argv[1]
with open(".claude-plugin/plugin.json", encoding="utf-8") as handle:
    plugin = json.load(handle)
if plugin.get("version") != version:
    raise SystemExit("plugin version mismatch")

with open("skills/index.json", encoding="utf-8") as handle:
    index = json.load(handle)
skills = index.get("skills", [])
if len(skills) != 1 or skills[0].get("name") != "meta-scaffold":
    raise SystemExit("skills index must expose exactly meta-scaffold")
for relative in skills[0].get("files", []):
    path = f"skills/meta-scaffold/{relative}"
    try:
        open(path, encoding="utf-8").close()
    except OSError as exc:
        raise SystemExit(f"skills index references missing file: {path}") from exc
PY

cmp dist/CURSOR.mdc .cursor/rules/meta-scaffold.mdc >/dev/null || { echo "Cursor distributions drifted" >&2; exit 1; }

# Test local installer without touching the repo.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
./scripts/install.sh "$tmp" all >/dev/null
[[ -f "$tmp/skills/meta-scaffold/SKILL.md" ]] || { echo "installer failed skill" >&2; exit 1; }
[[ -f "$tmp/skills/meta-scaffold/agents/openai.yaml" ]] || { echo "installer failed skill metadata" >&2; exit 1; }
[[ -f "$tmp/skills/meta-scaffold/references/platforms.md" ]] || { echo "installer failed skill references" >&2; exit 1; }
[[ -f "$tmp/.cursor/rules/meta-scaffold.mdc" ]] || { echo "installer failed cursor rule" >&2; exit 1; }
[[ -f "$tmp/docs/current.md" ]] || { echo "installer failed docs/current.md" >&2; exit 1; }
[[ -f "$tmp/docs/decision/INDEX.md" ]] || { echo "installer failed docs/decision/INDEX.md" >&2; exit 1; }
grep -q 'META-SCAFFOLD' "$tmp/AGENTS.md" || { echo "installer failed AGENTS append" >&2; exit 1; }

remote_installer="$tmp/install-remote.sh"
remote_target="$tmp/remote-project"
cp scripts/install.sh "$remote_installer"
META_SCAFFOLD_RAW_BASE="file://$ROOT" bash "$remote_installer" "$remote_target" skill >/dev/null
[[ -f "$remote_target/skills/meta-scaffold/references/platforms.md" ]] || { echo "remote-style installer failed skill references" >&2; exit 1; }

codex_home="$tmp/codex-home"
kilo_home="$tmp/kilo-home"
cursor_home="$tmp/cursor-home"
global_home="$tmp/global-home"
META_SCAFFOLD_GLOBAL_SKILLS_ROOT="$global_home/skills" CODEX_HOME="$codex_home" KILO_HOME="$kilo_home" CURSOR_HOME="$cursor_home" ./scripts/install-agent-skill.sh all >/dev/null
[[ -f "$codex_home/skills/meta-scaffold/SKILL.md" ]] || { echo "codex skill installer failed" >&2; exit 1; }
[[ -f "$kilo_home/skills/meta-scaffold/SKILL.md" ]] || { echo "kilo skill installer failed" >&2; exit 1; }
[[ -f "$cursor_home/skills/meta-scaffold/SKILL.md" ]] || { echo "cursor skill installer failed" >&2; exit 1; }
[[ -f "$global_home/skills/meta-scaffold/SKILL.md" ]] || { echo "global skill installer failed" >&2; exit 1; }
cmp "$codex_home/skills/meta-scaffold/SKILL.md" "$kilo_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "agent skill installs drifted" >&2; exit 1; }
cmp "$codex_home/skills/meta-scaffold/SKILL.md" "$cursor_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "Cursor skill install drifted" >&2; exit 1; }
cmp "$codex_home/skills/meta-scaffold/SKILL.md" "$global_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "global skill install drifted" >&2; exit 1; }

printf '\n# stale local copy\n' >> "$codex_home/skills/meta-scaffold/SKILL.md"
META_SCAFFOLD_GLOBAL_SKILLS_ROOT="$global_home/skills" CODEX_HOME="$codex_home" KILO_HOME="$kilo_home" CURSOR_HOME="$cursor_home" META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all >/dev/null
cmp "$codex_home/skills/meta-scaffold/SKILL.md" "$kilo_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "forced agent skill refresh drifted" >&2; exit 1; }
cmp "$codex_home/skills/meta-scaffold/SKILL.md" "$cursor_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "forced Cursor skill refresh drifted" >&2; exit 1; }
cmp skills/meta-scaffold/SKILL.md "$codex_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "forced agent skill refresh is stale" >&2; exit 1; }
cmp skills/meta-scaffold/SKILL.md "$global_home/skills/meta-scaffold/SKILL.md" >/dev/null || { echo "forced global skill refresh is stale" >&2; exit 1; }

legacy_root="$tmp/legacy-codex-skills"
./scripts/install-codex-skill.sh "$legacy_root" >/dev/null
[[ -f "$legacy_root/meta-scaffold/SKILL.md" ]] || { echo "legacy Codex installer wrapper failed" >&2; exit 1; }

bad_dest="$tmp/not-meta-scaffold"
mkdir -p "$bad_dest/skills/meta-scaffold"
printf '%s\n' 'not a skill' > "$bad_dest/skills/meta-scaffold/SKILL.md"
if META_SCAFFOLD_CODEX_SKILLS_ROOT="$bad_dest/skills" META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh codex >/dev/null 2>&1; then
  echo "codex skill installer replaced non-meta-scaffold path" >&2
  exit 1
fi

echo "META-SCAFFOLD repo check passed."
