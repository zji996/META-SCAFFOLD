# AGENTS.md

Use Meta Scaffold v5 for this project.

## Required behavior

Before inspecting, restructuring, documenting, or modifying this repository, follow:

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

Default language: Chinese, unless this repository already uses another language convention.

## Context loading order

1. User request.
2. This `AGENTS.md`.
3. `docs/current.md`.
4. `docs/reference/architecture.md`.
5. Files explicitly mentioned by the task.
6. Package/workspace/command entrypoint files.
7. Roadmap, operations, decisions, or broader search only when needed.

## Guardrails

- Inspect real repository state before proposing structure.
- Touch only files directly related to the request.
- Do not delete, move, or overwrite existing files without confirmation.
- Do not create empty directories just for completeness.
- Do not write future plans as current facts.
- `apps/` contains independently runnable units.
- `packages/` or `libs/` contains shared capabilities.
- `packages/* -> apps/*` is forbidden by default.
- `apps/A -> apps/B` direct import is forbidden by default.
- Cross-app collaboration should go through contracts, APIs, schemas, events, or queues.

## Verification

Prefer existing project commands. If none exist, state the gap and propose the thinnest stable command entry.

Common examples:

```bash
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

or:

```bash
./manage.sh check all
./manage.sh test
./manage.sh build
```

## Durable context

If a change affects future work, update `docs/current.md` with only judgment-relevant information:

- current goal;
- user intent / background;
- confirmed direction;
- boundaries / do not change;
- current state;
- acceptance criteria;
- verification commands;
- next step.

Full upstream skill:

```text
https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md
```
