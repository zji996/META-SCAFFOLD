# Changelog

## 6.11.0

- 新增 Web/SPA 开发入口策略：有稳定本地域名时，开发默认走 Vite（或同类）HMR，生产才托管静态 `dist`；避免「改源码却在看过期 dist」的无效 debug。
- 约定运维脚本应启动 bundler 并分流 `/api/*` 与前端，而不是把 `pnpm build` 当开发热路径；排障先确认入口是开发代理还是静态产物。
- 要求将上述约定写入消费仓 `AGENTS.md`（或等价入口），降低跨会话上下文丢失成本。

## 6.10.0

- 多实例端口模式改为按约束分流：临时本地服务优先使用内核/Docker 动态端口，应用与 Compose 回报 bind 后实际地址；需要启动前可预测时才使用实例前缀派生。
- 增加系统级单一反向代理约定：项目用独立站点片段注册 `<project>.localhost` 到动态 Backend，`up/down` 负责 graceful reload；Caddy 等入口不承担数据库、Redis 或进程端口分配。
- 强化门禁：`ports` 同时展示稳定入口与动态端点，检查/文档读取最终地址，禁止“扫描空闲端口后释放再 bind”的竞态，并清理异常退出后的过期地址。

## 6.9.0

- 在仓库未覆盖且用户未禁止时，完整、边界清晰并通过相称验证的改动默认创建原子本地 commit，作为可审阅、可回退的 checkpoint。
- 明确自动 commit 不得混入既有或无关改动；任务未完成或验证失败时不得为清理工作区而提交。
- push、建远程、PR 与发布继续服从消费仓和用户授权；同步 runtime、人工审阅版、薄适配器、模板与版本元数据。

## 6.8.4

- Pi 委派新增高信号 JSON 过滤脚本，只保留截断命令、写入路径、顶层工具错误、阶段文本与关键生命周期事件；原始 JSON 默认不落盘。
- wrapper 接受显式 workdir，并在该目录内启动 Pi；prompt/events 相对路径以 workdir 解析，三参数旧调用继续兼容。
- 任务契约与过滤日志统一放 `.local/run/`，主控按增量观察、复审 diff/artifact 并独立运行门禁。

## 6.8.3

- Pi 跨 agent 委派默认改为前台一次性 print mode + JSON 流：`timeout 20m pi --no-session --mode json -p`，实时观察生命周期、工具调用、工具结果与完成事件。
- 主控持续消费 JSON 事件并按实质变化汇报进度；`--verbose` 仅用于启动日志，不作为任务进度通道。
- 禁止用 shell 后台方式脱离主控；JSON 完成事件不替代真实 exit code 与进程退出确认，中断后仍先确认 Pi 和外层超时进程均已停止。
- JSON 工具事件按敏感输出处理：只摘要必要进度，不未经筛选长期落盘或原样转发。

## 6.8.2

- 治理状态拆分为 implementation/foundation、production enablement、default policy 与 validation evidence，避免用单一 `Implemented` 掩盖未启用或未验证边界。
- 明确 active plan、proposed next goal 与 historical completed goal；仅确认方向不自动创建 active goal。
- benchmark 数字优先归档到专门文档，要求分章节证据等级与 artifact/schema/环境/日期可追溯；治理文档保留定性结论和链接。
- 文档状态变更后搜索整树旧措辞，并核对链接及代码/配置权威来源。
- Pi 生命周期新增真实进程退出检查；空输出、session/cell 结束或输出通道关闭不视为子进程已退出。

## 6.8.1

- 新增托管 CI 默认策略：除非用户明确要求，不创建、恢复或主动扩展 GitHub Actions 等消耗托管计算时长的 CI。
- 优先复用并记录仓库已有的本地编译、测试、lint 或统一检查入口；本地验证不得冒充远程 CI。
- 已有 CI 保持为项目现状，不因默认策略擅自删除；同步 runtime、人工审阅版、最短版、薄适配器、模板与版本元数据。

## 6.8.0

- 跨 agent CLI 默认从 Grok 切换为 Pi print mode：`timeout 20m pi --no-session -p`，沿用调用方本机 provider、模型、extensions 与 skills。
- Pi 推荐通过 `pi install git:github.com/zji996/META-SCAFFOLD` 用户级 package 全局使用，并以 `pi update --extensions` 维护；业务项目无需 vendor skill。
- clone 安装器新增 `global` / `pi` 目标，写入 vendor-neutral `~/.agents/skills/meta-scaffold`；`all` 同步 global、Codex、Kilo 与 Cursor。
- 增加简洁任务契约、300K 上下文/压缩余量建议、进程生命周期与主控复审规则；禁止并行双写同一工作树。
- `.local/plan/` 仅保留仍在推进且需要恢复的账本；完成后将稳定事实迁移到正式文档并删除本地计划。
- 同步 runtime skill、人工审阅 prompt、dist/Cursor 薄适配器、templates、版本元数据与项目 current/roadmap。

## 6.6.3

- `SKILL.md` 在「能改什么」之后增加精简「跨 Agent 调用」：其他 agent CLI（如 Codex → Grok）只走 headless + auto-approve，默认不互调/不嵌套/不并行双写，结束后主控自行 diff 与验证。
- `references/platforms.md` 补充 Grok headless 命令示例与续聊约定。
- 同步 `prompts/`、dist 薄适配器与 templates 一行摘要。

## 6.6.2

- 统一安装器新增 `cursor` 目标，`all` 同步 Codex、Kilo Code、Cursor 三端同一 runtime。
- Cursor 个人 skill 安装到 `~/.cursor/skills/meta-scaffold`；明确禁止写入系统内置目录 `~/.cursor/skills-cursor/`。
- `check.sh` 新增 Cursor 安装、三端逐字一致与 force 刷新回归验证。

## 6.6.1

- 目的驱动再压缩：去掉八步仪式串；`SKILL.md` 按「优化 / 读取 / 授权 / 结构 / 记忆 / 收尾」组织，约 60 行。
- 否定式避坑句改为条件与结果；`short.md` 收成一句目的。
- 明确提交/PR 策略服从仓库；预授权的具体范围由项目 AGENTS 内联，skill 只保留“已批准计划内不重复授权”的一般原则。
- `docs/current.md` 改为审后动作清单；ports / handoff references 先写目的再写做法。
- `check.sh` 不再断言八步协议字符串。

## 6.6.0

- 将 `skills/meta-scaffold/` 设为唯一运行时内容源：`SKILL.md` 从 160+ 行收敛到约 70 行，handoff、repository patterns、platform setup 拆入按需 `references/`。
- 修复真实使用摩擦：完整八步流程改为检查表；monorepo、commit、sub-agent、handoff prompt 不再是全局默认；普通完成答复不强制附交接提示词。
- 明确自包含输出：禁止用“见上文/按之前内容”代替关键事实，只有暂停、换会话或明确要求时才生成 handoff prompt。
- 移除核心中的 Kilo 专属工具名；平台差异只处理 skill 安装、发现和 UI 元数据。
- 新增 `scripts/install-agent-skill.sh [codex|kilo|all]`，将同一 runtime 安装到 Codex 与 Kilo；保留 `install-codex-skill.sh` 兼容包装。
- 新增 `skills/index.json`，支持 Kilo Code `skills.urls` 远端发现；项目安装器同步完整 references。
- `prompts/`、dist、templates、Claude/Cursor 入口降为人工审阅版或薄适配器，避免多份长规则漂移。

## 6.5.4

- §8 多实例端口防冲突段精简：去掉「末三位法」历史对比描述，只保留正确的首位+末两位法规则。同步 SKILL。

## 6.5.3

- §8 多实例端口防冲突段提升 `manage.sh ports` 自省命令为一等入口建议：load profile 后直接打印每个 service 的解析端口、角色（本机进程 / 隧道本机端 / 远端宿主暴露端口 / 容器内端口）、当前 `port_instance` 前缀与是否偏移，让操作员一条命令拿到真实端口而无需手算派生公式或翻 profile/env。同步 SKILL。
- 版本号对齐：补记 6.5.2、6.5.3 的 CHANGELOG；同步 VERSION、plugin.json、README 版本号（前两个 commit 仅改了 SKILL frontmatter，漏更其余版本承载文件）。

## 6.5.2

- §8 多实例端口防冲突段澄清 SSH 隧道 / hybrid 拓扑下的双端偏移：隧道本机 local 端（host-exposed）和远端宿主暴露端口都偏移，链路是 `local(偏移) → 远端宿主(偏移) → 容器内(固定)`；只偏移一端会让本机进程连到一个远端无人监听的端口而握手 reset。改 `port_instance` 后必须重启依赖该端口的长连接（隧道、已建立的 DB 连接、screen/nohup 进程），否则旧进程仍持有失效端口规格而「看起来在跑」——`<group> tunnels` 类命令应比对运行进程的端口规格，不匹配就重建，而非仅凭 pid 存活就报 already running。同步 SKILL。

## 6.5.1

- §8 多实例端口防冲突段补「落地注意」：偏移写进项目默认后，检查脚本里的端口断言、文档与 curl 示例中的硬编码端口都会失效，必须改为从 profile 动态推导期望值，或用 `manage.sh ports` 这类自省命令取最终端口；否则同一偏移会让门禁/示例与真实端口静默错位。同步 SKILL、dist/{AGENTS,CLAUDE,CURSOR}、`.cursor/rules`。
- SKILL frontmatter / plugin.json / README 版本号 6.5.0 → 6.5.1。

## 6.5.0

- §2.7 Handoff 新增「交接提示词（Handoff Prompt）」机制（§2.7.1）：长会话收尾时，在状态报告之外另起一段结构化、可直接粘贴到新会话首条消息的加载入口（当前状态/已完成/验证/后续候选/硬约束），让下轮 AI 不依赖本会话历史即接即做。与 `docs/current.md` 末尾的「重开会话指引」呼应——current.md 给整体视图，交接提示词给最短启动路径，两者二选一或并存。同步 SKILL、short.md、dist/{AGENTS,CLAUDE,CURSOR}、`.cursor/rules`。
- §8 多服务本地编排新增「多实例端口防冲突（可选模式）」：同一台机器并行多个实例时，用 profile 级 `port_instance` 一次性偏移整组端口。派生公式 `<instance 前缀> + <原端口首位 × 100 + base % 100>`（保留首位+末两位），如 `port_instance = "12"` 让 8080→12880、5432→12532、9000→12900。该公式优于「末三位法」之处：末三位法对 `×000` 类常用端口（8000/3000/9000）会全映射到同一值，而首位+末两位法能区分不同首位段；容器内部端口不偏移，profile 显式 `ports.<service>` 仍优先。同步 SKILL、short.md、dist/{AGENTS,CLAUDE,CURSOR}、`.cursor/rules`。
- §13 最短版 + short.md：加交接提示词提及与端口模式一行。
- 版本号 6.4.3 → 6.5.0（VERSION / plugin.json / README / SKILL frontmatter / 本机 skill 同步）。

## 6.4.3

- 修 install.sh 与「ADR 核心化」矛盾：templates/all 模式新增 `docs/decision/INDEX.md` 落地（v6.4.1 把 decision/ 升为核心文档但安装脚本一直没建）。新增 `templates/docs/decision/INDEX.md` 模板；`scripts/check.sh` 补建该模板的必需项检查与安装器产物断言。
- 修 install.sh 嵌入文案过时：`install_agents` / `install_claude` 的 active goal 引导从 `docs/plan.md` 改为 `.local/plan/plan.md`（与 v6.4.2 §6.5 推荐路径一致）。
- §6.3 / §10 新增「批量补建历史 ADR 属可逆治理」豁免：首次为既有项目把已存在的隐含决策显式化成编号 ADR + INDEX 是治理行为（可逆），可直接执行后提示 review，不按逐条方向性写入门禁处理；之后逐条新增仍按方向性写入规则。区分「显式化已存在决策」（治理）与「引入新决策」（方向性写入）。同步 SKILL、short.md、dist/{AGENTS,CLAUDE,CURSOR}、templates、`.cursor/rules/meta-scaffold.mdc`。
- §6.1 / §6.2 / §13 放宽 roadmap 已完成阶段：从「只留一行指针」改为「一行指针 + 可附一两句定性结论/里程碑意义（细节仍归 architecture/git log）」，避免与 current.md 去历史化叠加后里程碑叙述无处可放。同步全部分发件。
- §6.5 / SKILL / dist `.local/` 子目录示例去硬编码：从固定 `dev/{pids,logs,bin}` 改为「按产物类型分子目录，命名沿用项目既有约定」（如 `.local/run/`），与「自然形态先于强制模板」一致；避免示例反向引导重命名既有 `.local/run/`。
- 修 `.cursor/rules/meta-scaffold.mdc` 仓库内规则漂移：之前未同步 6.4.1 的 ADR 段，现与 `dist/CURSOR.mdc` 对齐。
- 版本号 6.4.2 → 6.4.3（VERSION / plugin.json / README / SKILL frontmatter / 本机 skill 同步）。

## 6.4.2

- §6.1 表格：roadmap 已完成阶段只留一行指针（不写全文，细节归 architecture/git log）；新增 `decision/INDEX.md` 一行索引（active/superseded/deprecated），agent 一眼扫完方向决策。
- §6.2：current.md「短期下一步」最多 5 项——超过说明该拆 goal 或写 plan.md，避免短期焦点膨胀回长期计划。
- §6.4–6.6 重构（修 §6.3 重号）：§6.4 Active Goal Ledger；§6.5 `.local/` 强化——给出 `dev/pids|logs|bin`、`plan/`、`backlog/` 完整子目录结构；§6.6 新增 Sub-agent task backlog 异步委派模式。
- §6.6 sub-agent backlog：主 agent 不承担不稳定 sub-agent（codex 等）的健康管理与同步探测——改异步 backlog（`.local/backlog/<agent-slug>.md`），主 agent 写委派意图后继续自己工作，sub-agent 被调起时读 backlog 拉任务。明确「不写 state.json 健康追踪（容量不可预测、探活能过但重任务即拒会拖累主 agent）」。
- §7 上下文加载：新增「被作为 sub-agent 调起时，先读自己 `.local/backlog/<my-slug>.md`」。
- §13 最短版 + short.md：加 current.md 下一步上限 5 项、ADR INDEX、`.local/` 收 backlog、sub-agent 异步委派原则。
- SKILL.md：文档系统段重构（修 roadmap 重号、加 INDEX/backlog/异步委派）、上下文加载加 backlog。
- dist/AGENTS.md + dist/CLAUDE.md + dist/CURSOR.mdc 文档规则同步以上全部。
- 版本号 6.4.1 → 6.4.2（VERSION / plugin.json / README / 本机 skill 同步）。

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
