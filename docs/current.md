# META-SCAFFOLD Current Context

## Current focus

v6.6.1 purpose-driven runtime is the review-approved baseline: the skill is organized around what to optimize, read, authorize, structure, remember, and report, without a mandatory workflow string.

## Next

1. Measure false-trigger rate, cross-session recovery, and persistent context cost in real Codex/Kilo work.
2. Audit consuming repositories for stale references to removed skill sections; keep repository-specific authorization and commit policy inline in their own AGENTS.
3. Add adapters only when a real Agent Skills implementation requires one.

## Confirmed

- Runtime source of truth: `skills/meta-scaffold/`; prompts, dist, and templates are thin review or compatibility surfaces.
- Repository structure and commit/PR/release policy belong to the consuming repository.
- The skill keeps only the general rule that explicitly approved plan steps do not require repeated authorization.
- Handoffs are self-contained and generated only for pauses, session changes, agent changes, or explicit requests.
- Codex and Kilo install the same directory; remote discovery uses `skills/index.json`.

## Boundaries

- Keep the Agent Skills runtime small and platform-neutral.
- Installers overwrite only an existing `meta-scaffold` destination and only with explicit force.
- Do not turn line count into the goal; retain rules that materially prevent authorization, verification, dependency, or handoff failures.

## Verification

```bash
./scripts/check.sh
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/meta-scaffold
```
