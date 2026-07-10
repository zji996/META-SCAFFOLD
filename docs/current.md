# META-SCAFFOLD Current Context

## Current goal

Prepare v6.6.0 for review as one Agent Skills-compatible runtime shared by Codex and Kilo Code.

## Confirmed direction

- `skills/meta-scaffold/` is the runtime source of truth.
- `SKILL.md` contains only core governance decisions; handoff, repository patterns, and platform setup load from `references/` when relevant.
- Prompts, dist files, templates, Claude, and Cursor entries are human-review copies or thin adapters, not independent rule sets.
- Small tasks must not perform the full workflow as ceremony.
- Monorepo, commits, subagents, handoff prompts, and platform-specific tools are conditional, not global defaults.
- Handoffs and status reports must be self-contained and must not rely on chat history or “see above.”
- Codex and Kilo install the exact same directory through `scripts/install-agent-skill.sh`; Kilo remote discovery uses `skills/index.json`.

## Boundaries

- Keep the repository lightweight and compatible with the Agent Skills format.
- Preserve legacy install entry points when a thin wrapper is sufficient.
- Installers may replace only an existing path that identifies as `name: meta-scaffold`, and only with explicit force.
- Do not add platform tool names to core governance semantics.

## Verification

```bash
./scripts/check.sh
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/meta-scaffold
```

After publishing, run `./scripts/smoke-remote.sh` and refresh local installs with:

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all
```
