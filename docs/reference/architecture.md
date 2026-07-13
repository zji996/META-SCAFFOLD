# META-SCAFFOLD Repository Architecture

## Purpose

This repository packages META-SCAFFOLD as one Agent Skills-compatible runtime for Pi, Codex, Kilo Code, Cursor, and other coding agents.

## Source of truth

- `skills/meta-scaffold/`: runtime source of truth.
- `skills/meta-scaffold/SKILL.md`: concise core workflow and governance rules.
- `skills/meta-scaffold/references/`: handoff, repository-pattern, and platform details loaded only when relevant.
- `skills/meta-scaffold/agents/openai.yaml`: Codex/OpenAI skill UI metadata.
- `skills/index.json`: Kilo Code remote skill manifest.
- `prompts/META-SCAFFOLD-v6.md`: human-review contract derived from the runtime skill.
- `prompts/META-SCAFFOLD-v6.short.md`: shortest embeddable version.

The source layout is a package boundary, not a requirement for consuming repositories to vendor the skill. Pi loads the repository globally as a git or local package; other harnesses receive the same directory through their user-level discovery paths.

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

`scripts/install-agent-skill.sh` installs the same runtime directory into the vendor-neutral `~/.agents/skills`, Codex, Kilo Code, Cursor, or all targets. Forced replacement is allowed only when the destination already identifies as `name: meta-scaffold`.

Pi may use `pi install git:github.com/zji996/META-SCAFFOLD` for skill-only consumption. Workflows that call the stable delegation wrapper path use the vendor-neutral `~/.agents/skills` installation instead; the two forms must not coexist.

`scripts/install-codex-skill.sh` remains a compatibility wrapper for the Codex-only path.

`scripts/smoke-remote.sh` verifies the public raw installer, Kilo remote manifest, and Codex GitHub skill installer from temporary directories.

## Verification

`./scripts/check.sh` validates required files, metadata, JSON manifests, project installation, identical global/Codex/Kilo/Cursor installs, and safe replacement behavior.
