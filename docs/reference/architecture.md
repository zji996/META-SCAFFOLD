# META-SCAFFOLD Repository Architecture

## Purpose

This repository packages the META-SCAFFOLD v5 meta prompt as reusable artifacts for AI coding agents.

## Source of truth

- `skills/meta-scaffold/SKILL.md`: primary reusable skill.
- `skills/meta-scaffold/agents/openai.yaml`: Codex/OpenAI skill UI metadata.
- `prompts/META-SCAFFOLD-v5.md`: full v5 contract.

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

## Verification

`./scripts/check.sh` validates required files, skill metadata, plugin JSON, README import path, and local installer behavior.
