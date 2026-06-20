# META-SCAFFOLD Current Context

## Current goal

Maintain META-SCAFFOLD v6 as a reusable public skill repository. v6 adds disciplined tool use, conditional sub-agent orchestration, spec/plan-driven development, and explicit permission hard-gates, while compressing the full contract from 983 to ~410 lines by removing duplicates and model-known common sense. v6.1 adds Goal pre-authorization so confirmed plans no longer re-block on every irreversible goal task. v6.2 adds the `.local/` repo-local artifacts zone (runtime pids/logs/binaries + active goal ledger unified under `.local/`, one-line gitignore), moves the default plan path to `.local/plan/plan.md`, adds ADR guidance, and adds multi-service `manage.sh up|down|logs` orchestration guidance.

## Confirmed direction

- Repository name: `META-SCAFFOLD`.
- Main reusable entry: `skills/meta-scaffold/SKILL.md`.
- Codex/OpenAI UI metadata entry: `skills/meta-scaffold/agents/openai.yaml`.
- Single source of truth (full contract): `prompts/META-SCAFFOLD-v6.md`.
- Shortest embeddable version: `prompts/META-SCAFFOLD-v6.short.md`.
- No v5 backward compatibility: v5 prompt files were removed; downstream imports must migrate to v6.
- Skill body and primary AI-facing distributions are Chinese-first.
- All distributions (SKILL / AGENTS / CLAUDE / CURSOR / templates / plugin / cursor rule) derive from the v6 contract; do not maintain long-form copies separately.
- Long-running goals should use a top-of-file `Goal Execution Ledger` in
  `docs/plan.md` or another active goal file: Markdown checkboxes, `Next
  unchecked item`, and blockers. Stable facts still belong in `docs/current.md`,
  roadmap, or reference docs.
- Root README must explain convenient import methods.
- Public GitHub target assumed by install commands: `zji996/META-SCAFFOLD`.
- Preferred Codex install command uses the preinstalled skill installer:
  `python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py --repo zji996/META-SCAFFOLD --path skills/meta-scaffold`.
- Local Codex install refresh entry: `./scripts/install-codex-skill.sh`.
- Remote smoke entry for raw URL and Codex GitHub install: `./scripts/smoke-remote.sh`.

## Boundaries

- Keep the repository lightweight.
- Do not add package managers or build tools unless needed.
- Do not make templates look like mandatory architecture.
- Keep installation safe: append or create, avoid overwriting existing project files.
- Sub-agent orchestration is conditional, never mandatory; never write "must use subagent".

## Verification

```bash
./scripts/check.sh
```

Optional remote smoke:

```bash
./scripts/smoke-remote.sh
```

## Next starting point

- For distribution changes, run `./scripts/check.sh`, then `./scripts/smoke-remote.sh` after pushing.
- Refresh the local Codex install with `META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-codex-skill.sh`.
