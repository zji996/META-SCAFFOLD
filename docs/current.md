# META-SCAFFOLD Current Context

## Current focus

v6.8.0 publishes the purpose-driven runtime as a global Pi package, switches cross-agent delegation to Pi print mode, and keeps project-local vendoring optional.

## Next

1. Measure false-trigger rate, cross-session recovery, and persistent context cost in real Pi/Codex/Kilo/Cursor work.
2. Audit consuming repositories for project-vendored copies and migrate them to user-level packages where version pinning is not required.
3. Keep repository-specific authorization and commit policy inline in consuming AGENTS; add adapters only for real platform requirements.

## Confirmed

- Runtime source of truth: `skills/meta-scaffold/`; prompts, dist, and templates are thin review or compatibility surfaces.
- Repository structure and commit/PR/release policy belong to the consuming repository.
- The skill keeps only the general rule that explicitly approved plan steps do not require repeated authorization.
- Handoffs are self-contained and generated only for pauses, session changes, agent changes, or explicit requests.
- Codex, Kilo, and Cursor install the same directory; Kilo remote discovery uses `skills/index.json`.
- Pi consumes the public repository as a user-level git package; `pi update --extensions` refreshes it without copying the skill into each project.

## Boundaries

- Keep the Agent Skills runtime small and platform-neutral.
- Installers overwrite only an existing `meta-scaffold` destination and only with explicit force.
- Do not turn line count into the goal; retain rules that materially prevent authorization, verification, dependency, or handoff failures.

## Verification

```bash
./scripts/check.sh
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/meta-scaffold
```
