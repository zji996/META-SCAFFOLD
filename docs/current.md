# META-SCAFFOLD Current Context

## Current goal

Maintain META-SCAFFOLD v6 as a reusable public skill repository. v6.5 adds the structured Handoff Prompt mechanism (a paste-ready session-start loader emitted at long-session close, complementing current.md's session-reopen pointer) and an optional multi-instance port-collision pattern (`port_instance` derivation `<prefix> + <first digit × 100 + base % 100>`, avoiding the ×000 collision of the naive last-three-digits approach). v6.1–6.4 layered Goal pre-authorization, the `.local/` artifacts zone, ADR as core doc, current.md short-focus tightening, and T0/T1 fast path.

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
