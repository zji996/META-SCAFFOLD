# Changelog

## 6.1.0

- Add Goal pre-authorization: irreversible operations within a confirmed plan's goal tasks (schema/migration, auth, contract changes) are pre-authorized on plan approval, executed directly without per-step confirmation; still ask when beyond task scope, conflicting with decision records, or irreversible (force push, deleting production data).
- Add proposal non-blocking mechanism: schema/design proposals produced within a goal are design artifacts, auto-released for execution when consistent with plan decisions; only ask when a proposal introduces decisions not covered by the plan.
- Keep all distributions (SKILL / AGENTS / CLAUDE / CURSOR / templates / short) derived from the single source of truth.

## 6.0.0

- Add disciplined tool-use rules: parallel independent reads/searches, read-before-edit, dedicated tools over shell, process-managed long-running tasks.
- Add conditional sub-agent orchestration (parallel dispatch only when tasks are independent, no-shared-write, self-contained, and heavy enough); never mandatory, fall back to serial when the model/platform is not suited.
- Add spec/plan-driven development: turn tasks into verifiable states; minimal spec before non-trivial work.
- Add explicit permission and hard-gate layer (read-only / reversible edit / irreversible-destructive) consolidating the previously scattered "avoid" lists.
- Strengthen verification into a hard gate: never fake a run, never silently swap commands, never silent-fallback over critical-path failures.
- Add optional Kilo platform adaptation appendix (agent_manager / task / background_process / suggest / question).
- High-signal rewrite: merge duplicated sections (stance / behavior / safety / anti-patterns / self-check into one), remove model-known common sense. Full contract 983 -> ~410 lines.
- Establish `prompts/META-SCAFFOLD-v6.md` as the single source of truth; remove v5 prompt files (no backward compatibility — downstream imports must migrate to v6).

## 5.0.0

- Package META-SCAFFOLD v5 as a reusable skill.
- Add one-command installer for target projects.
- Add AGENTS, CLAUDE, Cursor, plugin-style, and template distributions.
- Prefer Chinese for the short embedded prompt and local Claude instructions.
- Prefer Chinese for the main Codex skill body and AI-facing distributions.
- Add remote smoke verification and safer Codex local skill replacement.
- Add active goal ledger guidance for `docs/plan.md` style long-running plans.
