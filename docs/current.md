# META-SCAFFOLD Current Context

## Current goal

Maintain META-SCAFFOLD v5 as a reusable public skill repository that Codex can install first as a global skill, with per-project imports as secondary options.

## Confirmed direction

- Repository name: `META-SCAFFOLD`.
- Main reusable entry: `skills/meta-scaffold/SKILL.md`.
- Codex/OpenAI UI metadata entry: `skills/meta-scaffold/agents/openai.yaml`.
- Full contract source: `prompts/META-SCAFFOLD-v5.md`.
- Skill body and primary AI-facing distributions are Chinese-first.
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
