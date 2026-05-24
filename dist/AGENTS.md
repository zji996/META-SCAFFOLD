# AGENTS.md

## META-SCAFFOLD

Use this section as a project governance contract for AI coding agents.

Default language: Chinese for collaboration and project handoff docs unless the user asks otherwise or the repository already uses another language.

Core protocol:

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

When the task touches repository structure, project governance, AI handoff, documentation layout, monorepo boundaries, context compression, or verification workflows:

1. Inspect the real repository before changing files.
2. State goal, assumptions, success criteria, and non-goals for non-trivial work.
3. Ask only for high-impact ambiguity; use safe defaults for low-risk ambiguity.
4. Preview substantial changes before applying.
5. Change only files required by the task.
6. Verify using existing commands, or explain why verification cannot run.
7. Handoff with changed files, verification result, risks, and next starting point.
8. Keep `docs/current.md` compact; record only information that still affects future work.

Repository shape rules:

- Think in monorepo boundaries, but create only directories that are needed now.
- `apps/` contains independently runnable/buildable/deployable units.
- `packages/` or `libs/` contains shared code.
- Default dependency direction: `apps/* -> packages/*` allowed; `packages/* -> apps/*` forbidden; `apps/A -> apps/B` forbidden by default.
- Cross-app collaboration should use HTTP, RPC, queues, events, schemas, protobuf, or contracts packages, not direct imports.

Documentation rules:

- Minimum useful docs: `docs/current.md`, `docs/roadmap.md`, `docs/reference/architecture.md`.
- `docs/current.md` is current collaboration context, not chat history.
- `docs/reference/` writes current facts only.
- Future plans go to roadmap/current and must not be written as implemented facts.

Verification rules:

- Prefer existing commands such as `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build`, `make check`, `just check`, `task check`, or `./manage.sh check all`.
- README, AGENTS, CI, and AI handoff should point to the same command set.
- Do not hide failures behind silent fallbacks.

Avoid:

- empty directories created only to look complete;
- over-splitting docs;
- turning one request into many micro-tasks;
- drive-by refactors or formatting sweeps;
- moving, deleting, or overwriting unknown files without approval;
- putting shared libraries inside `apps/`;
- making shared packages depend on apps.
