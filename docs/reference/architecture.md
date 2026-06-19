# META-SCAFFOLD Repository Architecture

## Purpose

This repository packages the META-SCAFFOLD v6 meta prompt as reusable artifacts for AI coding agents.

## Source of truth

- `skills/meta-scaffold/SKILL.md`: primary reusable skill.
- `skills/meta-scaffold/agents/openai.yaml`: Codex/OpenAI skill UI metadata.
- `prompts/META-SCAFFOLD-v6.md`: full v6 contract (single source of truth).
- `prompts/META-SCAFFOLD-v6.short.md`: shortest embeddable version.

## Distribution files

- `dist/AGENTS.md`: single-file AGENTS distribution.
- `dist/CLAUDE.md`: single-file CLAUDE distribution.
- `dist/CURSOR.mdc`: single-file Cursor rule distribution.
- `.claude-plugin/plugin.json`: plugin-style metadata.
- `.cursor/rules/meta-scaffold.mdc`: Cursor rule used by this repository.

## Templates

- `templates/docs/current.md`: current context handoff template.
- `templates/docs/roadmap.md`: future-direction template.
- `templates/docs/reference/architecture.md`: current architecture reference template.
- `templates/scaffold.plan.yaml`: optional structural decision snapshot.

## Installer

`scripts/install.sh` can run from a local clone or through a raw GitHub URL. It installs selected artifacts into a target project and avoids overwriting existing docs/templates.

`scripts/install-codex-skill.sh` installs the local clone into `${CODEX_HOME:-~/.codex}/skills/meta-scaffold`. Forced replacement is allowed only when the destination already identifies as `name: meta-scaffold`.

`scripts/smoke-remote.sh` verifies the public raw installer and the Codex GitHub skill installer from temporary directories.

## Verification

`./scripts/check.sh` validates required files, skill metadata, plugin JSON, README import path, local installer behavior, and Codex local installer safety.
