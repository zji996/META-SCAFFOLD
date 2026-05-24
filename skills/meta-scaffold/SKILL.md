---
name: meta-scaffold
description: Project structure and AI-collaboration governance skill. Use when creating, reorganizing, maintaining, or handing off software repositories; deciding monorepo/app/package boundaries; writing AGENTS/CLAUDE/Cursor rules; maintaining docs/current.md; defining verification commands; or compressing context for future AI work.
license: MIT
version: 5.0.0
---

# META-SCAFFOLD

META-SCAFFOLD is a repository-governance skill for AI coding agents. It is not a directory template. It tells the agent how to inspect reality, make minimal structural decisions, modify safely, verify work, and leave compact handoff context.

Default to Chinese for user communication and collaborative project docs unless the user asks otherwise or the repository already uses another language.

## Core stance

The agent's job is to reduce long-term project confusion, not to make the repository look “professional”. Always prefer:

1. **Reality before structure** — inspect the current repository before proposing architecture or folders.
2. **User-confirmed direction before fresh opinions** — do not reopen decisions every round.
3. **Context cost before document volume** — make the next human or AI need fewer files, not more files.
4. **Runnable state before elegant plans** — every meaningful change needs a verification command or acceptance check.
5. **Current facts before future wishes** — never write planned work as if it already exists.
6. **Natural shape before forced templates** — respect existing conventions such as `src/`, `services/`, `libs/`, or `packages/`.
7. **Minimum necessary change** — no drive-by refactors, formatting sweeps, dependency churn, or speculative abstractions.

Success test:

> Can the next AI pick up faster, misunderstand less, modify more safely, and verify more easily?

## When to activate

Use this skill when the task touches any of these areas:

- Starting a new software repository.
- Reorganizing an existing repository.
- Deciding whether a project should be monorepo-shaped.
- Distinguishing `apps/`, `packages/`, `libs/`, `services/`, `infra/`, `scripts/`, and `docs/`.
- Creating or updating `AGENTS.md`, `CLAUDE.md`, Cursor rules, or other AI collaboration instructions.
- Creating or maintaining `docs/current.md`, architecture docs, roadmap docs, runbooks, or decisions.
- Defining stable command entry points such as `pnpm`, `make`, `just`, `task`, or `manage.sh`.
- Performing handoff after a multi-step coding or documentation task.

For trivial edits, compress the protocol, but keep the safety constraints.

## Operating protocol

Default flow:

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

### 1. Inspect: read before changing

Before editing, identify the real state of:

- repository entry points: README, AGENTS, CLAUDE, workspace config, Makefile, justfile, taskfile, manage script;
- app/process entry points: `apps`, `src`, `services`, `cmd`, `routes`, `pages`, `workers`, `cli`;
- shared modules: `packages`, `libs`, `shared`, `core`, `contracts`, `ui`, `config`;
- documentation: `docs/current.md`, architecture, roadmap, operations, decisions;
- verification commands: lint, typecheck, test, build, check, dev;
- infrastructure: Docker, CI, deployment, migrations, environment examples;
- files explicitly mentioned by the user.

Do not modify files during inspection.

### 2. Frame: restate goal and success criteria

For non-trivial work, briefly state:

```text
Goal: ...
Known facts: ...
Assumptions: ...
Success criteria: ...
Will not do: ...
```

Ask only for high-impact ambiguity. For low-risk ambiguity, choose a safe default and continue.

### 3. Decide: separate risk levels

| Risk level | Default handling | Examples |
| --- | --- | --- |
| Low, reversible | choose safe default and continue | wording, local naming, small script fix |
| Medium, multi-file | preview before applying | new docs layout, command entry, shared package split |
| High, irreversible or conflicting | ask first | deletion, large migration, destructive DB changes, public API break, auth/permission change |

Do not ask questions merely to look careful. Do not pretend certainty when the change is risky.

### 4. Preview: describe the intended diff

Before substantial changes, say:

```text
Will change: ...
Files touched: ...
Files not touched: ...
Reason: ...
Verification: ...
Risk/rollback: ...
```

If the user explicitly authorized direct edits, this can be one concise sentence.

### 5. Apply: change the minimum necessary files

Default constraints:

- Do not delete unknown files.
- Do not overwrite user content.
- Do not move directories at scale without approval.
- Do not rewrite existing implementation when a small patch solves the task.
- Do not add dependencies unless necessary and explained.
- Do not format the whole repository unless the project command requires it.
- Match existing style rather than imposing the examples from this skill.

Every changed line should be traceable to the user request or to a verification failure.

### 6. Verify: prove or explain

Prefer existing commands. Common order:

```bash
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

or project-specific equivalents:

```bash
make check
just check
task check
./manage.sh check all
```

If verification cannot be run, explain exactly why and give the command the user should run. Do not hide failures behind silent fallbacks.

### 7. Handoff: leave a compact status

At the end, report:

- what changed;
- what was verified;
- what failed or was not run;
- remaining risks;
- where the next round should start.

### 8. Compact: update context, not history

For long-running projects, update `docs/current.md` only with information that still affects future work. Do not paste chat history. Do not duplicate README, architecture, or roadmap content.

## Repository shape guidance

Think in monorepo boundaries when useful, but do not force monorepo structure. A monorepo is useful when there are multiple independently runnable apps or processes, shared contracts/config/UI/core logic, or a need for unified validation and AI collaboration rules.

Safe default:

> Think in monorepo boundaries, but create only directories that are actually needed now.

Reference shape:

```text
<repo>/
  README.md
  AGENTS.md
  .env.example

  apps/
    admin-web/
    api/
    studio-web/
    worker/

  packages/
    ui/
    config/
    contracts/
    core/

  infra/
  scripts/
  docs/
```

Respect existing project conventions when they are already coherent.

### `apps/`

`apps/` contains runnable units, not all code. A directory belongs in `apps/` when it can independently start, build, deploy, or represent a clear user/service/process entry point.

Good candidates:

```text
apps/admin-web
apps/studio-web
apps/api
apps/worker
apps/desktop
apps/mobile
apps/cli
```

`api` and `worker` can live under `apps/` when they are independent runtime planes.

### `packages/` or `libs/`

Shared reusable code belongs in `packages/` or `libs/`, not inside `apps/`.

Typical shared areas:

```text
packages/ui
packages/contracts
packages/config
packages/core
```

Default dependency direction:

```text
apps/*      -> packages/*  allowed
packages/*  -> apps/*      forbidden
apps/A      -> apps/B      forbidden by default
```

Cross-app collaboration should happen through HTTP, RPC, queues, events, OpenAPI, JSON Schema, protobuf, or a contracts package, not direct imports between apps.

## Documentation model

Docs are not a second system. They exist so the next person or AI can continue accurately.

Minimum useful docs:

```text
docs/
  README.md
  current.md
  roadmap.md
  reference/
    architecture.md
```

Only add more when the project needs them:

```text
docs/reference/operations.md
docs/reference/decisions.md
```

Later, split into directories only when content becomes large:

```text
docs/runbooks/
docs/decisions/
```

### `docs/current.md`

This is the first project-context file an AI should read after root agent instructions. It should answer:

- current goal;
- background and user intent;
- confirmed direction;
- boundaries not to change;
- current status;
- completion criteria;
- verification commands;
- where to continue next.

It is not a full task tracker and not a transcript.

### `docs/reference/`

Write only current reality: architecture, module responsibilities, data flow, config, APIs, protocols, local run flow, deployment reality. Unimplemented content must be marked `Status: Not Implemented` or moved to roadmap/current.

### `docs/roadmap.md`

Write future direction, phase goals, non-goals, and long-term boundaries. Do not write roadmap items as current facts.

### Operations and decisions

If a process repeats, document it as operations/runbook. If a decision is likely to be overturned by future AI, document it as a decision.

## Context loading order

Do not read the whole repository every round. Default order:

```text
1. AGENTS.md or equivalent agent instructions
2. docs/current.md
3. docs/reference/architecture.md
4. files explicitly mentioned by the task
5. roadmap, operations, decisions only when needed
```

If context is insufficient, name the gap and choose a safe default unless the next change is high risk.

## Command entry and validation

A project needs one stable command entry, but the tool name does not matter.

Priority:

1. Keep existing stable commands such as `pnpm`, `make`, `just`, `task`, `cargo`, `go test`.
2. If there is no unified entry, add a thin `manage.sh`.
3. Keep `manage.sh` as routing only; do not hide complex business logic inside it.

README, AGENTS, CI, and AI handoff should point to the same commands.

## Optional decision snapshot

Use `scaffold.plan.yaml` only when structural decisions become complex. It records AI-relevant decisions; it does not replace real project config.

Example:

```yaml
scaffold:
  contract_version: 5
  mode: existing
  execution_mode: preview_then_apply

repo:
  shape: monorepo
  app_dir: apps
  shared_dir: packages
  docs_entry: docs/current.md
  command_entry: pnpm

ai_collaboration:
  language: zh-first
  default_context:
    - AGENTS.md
    - docs/current.md
    - docs/reference/architecture.md
  preview_before_apply: true
  verify_after_apply: true
```

## Anti-patterns

Avoid:

- creating empty directories to look complete;
- splitting docs so much that nobody knows what to read;
- turning one request into dozens of micro-tasks;
- writing future plans into reference docs;
- re-litigating confirmed project structure every round;
- giving each app a different command convention;
- putting shared libraries in `apps/`;
- making `packages/` depend on `apps/`;
- moving, deleting, or overwriting existing files without approval;
- using silent fallbacks to hide critical-path errors.

## Output style

Be explicit enough to make the next action safe. For complex work, show a short plan before editing and a compact handoff after. For simple work, keep the response short but still name verification status.
