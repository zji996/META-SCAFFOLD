# AGENTS.md

This repository publishes META-SCAFFOLD as a reusable AI-agent skill.

Before modifying repository structure, distribution files, install scripts, or documentation, read:

1. `skills/meta-scaffold/SKILL.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. the file explicitly requested by the task

Default language for user-facing collaboration is Chinese unless the user asks otherwise or the edited file is already English.

## Maintenance rules

- Keep `skills/meta-scaffold/SKILL.md` as the primary reusable skill.
- Keep `prompts/META-SCAFFOLD-v5.md` as the full contract source.
- Keep `dist/AGENTS.md`, `dist/CLAUDE.md`, `.cursor/rules/meta-scaffold.mdc`, and `dist/CURSOR.mdc` aligned with the skill.
- Do not add heavy build tooling unless needed.
- Do not overwrite examples/templates without preserving backward-compatible import paths.
- Run `./scripts/check.sh` after structural changes.

## Verification

```bash
./scripts/check.sh
```

- Plugin manifest: `.claude-plugin/plugin.json` should point to `./skills/meta-scaffold`.
