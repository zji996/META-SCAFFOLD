# Changelog

## 6.4.1

- monorepo 从「可选思考方向」升为「AI 协作推荐默认形态」：§5 开头明确「一次 Inspect 全局视野 + 共享层自然沉淀 + 统一验证，用少量空间换最大 agent 操作空间」，新项目默认 monorepo。同步 §13 最短版、SKILL.md、dist/AGENTS.md/CLAUDE.md/CURSOR.mdc。
- `docs/decision/`（ADR）从「复杂后再加的可选」升为核心文档，与 current/roadmap/reference 并列：§6.1 最小结构加入 `docs/decision/`；新增 §6.3 详述 ADR 作为「用户细碎方向性想法的沉淀点」——每个 why 记一条编号记录、新决策覆盖旧决策不改旧文件、agent 读 ADR 即知「这条路已想过不要重新提议」。原 §6.4 operations+decisions 合并精简。
- `docs/current.md` 定位收紧为「短期焦点」：§6.2 明确「只记当前焦点 + 短期下一步 + 阻塞 + 关键架构事实 + 验证命令；已完成 goal 不在此留存细节（归 roadmap 一行指针），修复历史归 git log；目的是让下一轮 AI 用最少 token 接上当前工作」。templates/AGENTS.meta-scaffold.md 同步。
- dist/AGENTS.md + dist/CLAUDE.md + dist/CURSOR.mdc 仓库结构规则 + 文档规则同步以上三点。
- 版本号 6.4.0 → 6.4.1（VERSION / plugin.json / README / 本机 skill 同步）。

## 6.4.0

- Trim §3 tool-use discipline from 30 lines to 3: "read before edit, parallel independent reads, dangerous commands default off" — the removed content (search layering, Read-over-cat, no-auto-retry) is model default behavior, writing it out implies "without this rule the agent would misbehave" and wastes per-turn context. v6.md keeps the full version as reference; dist/templates/SKILL use the 3-line compression.
- Add T0/T1 fast path to §2: simple tasks (Q&A, single-file fix) skip Frame/Decide/Preview/Compact, only do Inspect→Apply→Verify→Handoff; T2/T3 (multi-file, refactor, migration) run full 8 steps. Makes the compression explicit so agents don't run full ceremony on a one-line change.
- Compress §13 shortest version: removed 60% overlap with §1/§5/§8/§10, kept only the 8-step flow + commit rule + permission gate + boundary + verification hard-gate.
- Compress Appendix A Kilo table: dropped "corresponding contract principle" column (redundant with row content) and the trailing restatement paragraph; merged into a 5-row table + 1-line closure.
- Trim SKILL "when to enable" from 10 trigger conditions to 1 sentence (skill is always callable once installed; the 10 conditions don't decide activation).
- Sync dist/{AGENTS,CLAUDE,CURSOR}, templates/{AGENTS,CLAUDE}, root CLAUDE.md to the 3-line tool/sub-agent compression.
- Bump version 6.3.0 → 6.4.0.

## 6.3.0

- Reclassify `git commit` from "irreversible operation" to "reversible edit": code changes + commit are the agent's job, run verification gate then commit, don't ask per-step — commit is a checkpoint for review, not a final decision; `git revert`/`git reset` is the safety net. This removes the friction where the agent stops to ask "commit?" after every round (user says yes ~90% of the time) without gaining safety, since commit is fully reversible.
- Add "directional docs write-in" gate: writing ADR / decision records / roadmap direction changes requires user confirmation before commit, because wrong directions mislead future AI and humans (impact larger than a code change). `docs/current.md` objective status updates are exempt (factual record, not direction).
- Update prompts (single source v6.md §2.3/§10/§13), short prompt, SKILL, dist (AGENTS/CLAUDE/CURSOR), templates (AGENTS/CLAUDE), plugin.json, README version line to stay consistent.

## 6.2.0

- Add `.local/` repo-local artifacts zone recommendation: runtime artifacts (multi-service background pids/logs, build binaries, cache) and local working docs (e.g. active goal ledger) are unified under `.local/`, ignored wholesale via one line, instead of per-file ignoring or scattering to `/tmp`. `docs/` holds only stable committable docs; local transient artifacts get a single home. Subdirectories by purpose (`.local/dev/`, `.local/plan/`).
- Move the default active goal ledger path from `docs/plan.md` to `.local/plan/plan.md` (with `docs/plan.md` still allowed as a fallback); update prompts (single source), SKILL, dist (AGENTS/CLAUDE/CURSOR), templates, and cursor rule to stay consistent.
- Add ADR (`docs/decision/`) to the doc-system guidance: record direction-level decisions that later AI might overturn as numbered records; new decisions supersede old ones rather than editing old files; `docs/current.md` points to active decisions.
- Add multi-service local orchestration guidance to the command-entry section: avoid bare `go run <svc> &` / `nohup`; encapsulate `<group> up|down|logs` subcommands in `manage.sh` (build binaries + pidfile under `.local/` + background spawn); `up/down` matches operational verb intuition.
- Bump plugin.json version (was stale at 6.0.0) and README version line to 6.2.0.

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
