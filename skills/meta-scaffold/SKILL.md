---
name: meta-scaffold
description: 项目结构与 AI 协作治理 skill。用于创建、重组、维护或交接软件仓库；判断 monorepo/app/package 边界；编写 AGENTS/CLAUDE/Cursor 规则；维护 docs/current.md、docs/decision（ADR）与 .local/plan 的 Goal Execution Ledger；定义验证命令；规范工具使用与子 agent 编排；压缩未来 AI 工作上下文。
license: MIT
version: 6.4.3
---

# META-SCAFFOLD

给 AI coding agent 使用的仓库治理 skill。不是目录模板，也不是框架模板；规定 agent 如何先理解真实仓库，再做最小必要结构判断、安全修改、验证和交接。完整契约见 `prompts/META-SCAFFOLD-v6.md`，本文件是它的压缩 skill 入口。

默认中文沟通，除非用户另有要求或仓库已明确使用其他语言。

## 立场

降低项目长期混乱度，而不是让仓库看起来"专业"。最终标准：下一轮 AI 能不能更快接上、更少误解、更稳修改、更容易验证。

七条优先级（冲突时按序）：现实先于结构、已确认方向先于新观点、上下文成本先于文档数量、可验证先于优雅、当前事实先于未来愿望、自然形态先于强制模板、最小必要改动。

## 何时启用

任务涉及仓库结构、文档、AI 交接、验证流程、多步骤任务交接时启用。简单任务压缩流程，但不跳过安全约束。

## 执行协议

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

- **Inspect**：先读现状（仓库/应用入口、共享模块、文档、验证命令、基础设施、用户提到的文件），不改文件。
- **Frame**：复杂任务前简述目标、已确认事实、假设、成功标准、不会做什么。只问高影响歧义，低风险用安全默认值继续。
- **Decide**：低风险可逆→安全默认值；中风险多文件→Preview 后 Apply；高风险不可逆或冲突（删文件/大迁移/DB/公开 API/认证）→先问用户。
- **Preview**：重大改动前说明计划 diff（会改什么/碰哪些文件/不碰哪些/为何/如何验证/回滚）。已授权可直接改时压缩成一句。
- **Apply**：匹配仓库现有风格，每行改动可追溯到用户请求或验证失败。
- **Verify**：优先运行已有命令；无法验证就准确说明原因并给出用户可运行命令。
- **Handoff**：报告改了什么、验证了什么、什么失败或未跑、剩余风险、下一轮起点。
- **Compact**：只把仍影响未来工作的判断写入 `docs/current.md`；用 active plan 时更新顶部执行账本。

## 工具使用纪律

- 先读后改；对未读文件不做 `replaceAll` 等大范围操作。
- 独立读取/搜索并行发起（后步依赖前步时串行）。
- 危险或不可逆命令默认不执行；长进程用进程管理工具不用 `&`/`nohup`。

## 子 Agent 编排（条件化）

不强求。当任务能拆成**全部满足**以下条件的子任务时，并行分发收益明显：

- 独立（无顺序依赖）、无共享写（不写同一文件）、自包含（能独立产出可验证结果）、够重（值得分发开销）。

不适合：有顺序依赖、写同一文件、线性小任务、上下文共享密集难划边界。分发时给自包含指令并说明返回什么；收回后由主 agent 汇总、去重、冲突裁决。模型/平台不擅长并行则回退串行，不强制；worktree 仅用于需写隔离的并行，纯研究无需隔离。

## 仓库形态与边界

**monorepo 是 AI 协作的推荐默认形态**：一次 Inspect 全局视野 + 共享层自然沉淀 + 统一验证。用少量空间换最大 agent 操作空间。已有 polyrepo 不强制合并，新项目默认 monorepo。安全默认值：按边界思考，只落地真实需要的目录。`apps/` 放可独立运行/构建/部署的单元；`packages/` 或 `libs/` 放共享能力（ui/contracts/config/core/test-utils/sdk）。

依赖方向（硬约束）：

```text
apps/*      -> packages/*  允许
packages/*  -> apps/*      禁止
apps/A      -> apps/B      默认禁止
```

跨 app 协作通过 HTTP/RPC/queue/event/OpenAPI/protobuf/contracts package，不直接 import。已有项目用 `src/`、`services/`、`modules/`、`cmd/` 时优先尊重现状。

## 文档系统

最小结构：`README.md`、`AGENTS.md`、`docs/current.md`、`docs/roadmap.md`、`docs/reference/architecture.md`、`docs/decision/`。`decision/` 是核心文档，不是可选。

- **`docs/current.md`（短期焦点）**：AI 在根部说明后优先读的上下文压缩。**只记当前焦点、短期下一步、阻塞、关键架构事实、验证命令**。已完成 goal 不在此留存细节——压缩成一行指针指向 roadmap 或状态表。修复历史归 `git log`。目标是让下一轮 AI 用最少 token 接上当前工作。
- **`docs/decision/`（ADR，核心设计记忆）**：用户的方向性想法常是细碎、跨会话的；ADR 是这些想法的沉淀点。每个「为什么这么做」记一条编号记录（`00NN-short-slug.md`），新决策覆盖旧决策而非改旧文件。`docs/current.md` 顶部指向当前活跃决策。价值：把用户零散的判断积累成项目的设计记忆，让项目随用户想法逐步推进而非每次从零开始；agent 读 ADR 即知「这条路已想过，不要重新提议」。**首次为既有项目批量补建历史 ADR 属可逆治理**（把已存在的隐含决策显式化），可直接执行后在交接时提示用户 review，不按逐条方向性写入门禁处理；之后日常逐条新增仍按方向性写入规则。
- **`docs/roadmap.md`**：已完成阶段（一行指针 + 可附一两句定性结论/里程碑意义，细节归 architecture/git log）、未来方向、阶段目标、非目标。
- **`docs/decision/INDEX.md`**：一行列所有 ADR + 状态（active/superseded by 00NN/deprecated），agent 一眼扫完方向决策，ADR 多了再加。
- **`.local/plan/plan.md`**（可选，活跃 goal ledger）：长目标/多轮 goal 的可恢复进度。顶部放 Goal Execution Ledger（Last updated / Current focus / Next unchecked item / Blockers / Active Checklist）。用户要求继续 goal 时从第一个未勾选项接着做，交接前更新 checkbox。把会触发硬门禁的不可逆操作（建表/迁移、认证、契约）作为 task 写进 goal，配合「Goal 预授权」避免重复阻塞。
- **`.local/` 仓库本地产物区（推荐）**：运行时产物（pid/日志/构建二进制/缓存）+ 活跃 plan + sub-agent backlog 统一收进 `.local/`，整体 `.gitignore`。`docs/` 只放稳定可入库文档，本地临时产物有统一去处；比散落 `/tmp` 更可靠（不被系统清理、跨机器路径一致）。按产物类型分子目录，**命名沿用项目既有约定**（「自然形态先于强制模板」），如 `.local/run/`、`.local/plan/`、`.local/backlog/`；不强制 `dev/pids|logs|bin`。
- **`.local/backlog/<agent-slug>.md`**（异步委派）：不稳定的 sub-agent（如 codex、特定模型实例）用异步 backlog 委派——主 agent 把委派意图写成 backlog，不探测不等待不降级自干，继续自己的工作；sub-agent 被独立调起时读自己 backlog 拉走任务，完成后回写结果指针。不写 `state.json` 健康追踪（容量不可预测、探活能过但重任务即拒会拖累主 agent）。
- **`docs/reference/`**：只写当前真实系统，未实现内容标 `Status: Not Implemented`。

## 上下文加载

默认顺序：用户请求 → AGENTS/CLAUDE → docs/current.md → architecture → 任务文件 → 命令入口 →（要求继续 goal 时）.local/plan/plan.md →（被作为 sub-agent 调起时）.local/backlog/<my-slug>.md → 必要时 roadmap/decision/INDEX/搜索。预算分级 T0（问答）→ T1（小改）→ T2（多文件/结构）→ T3（重构/迁移）。文档与代码冲突时以可运行代码为准。

## 命令入口与验证

沿用已有入口（`pnpm`/`make`/`just`/`task`/`cargo`/`go test`/`pytest`）；没有则补薄 `manage.sh`/`justfile`。README、AGENTS、CI、AI 交接指向同一套命令。

**多服务本地编排**：后端多服务（微服务/多语言栈）需本地并起时，避免裸 `go run <svc> &` / `nohup`（留孤儿进程、pid 不可控）。在 `manage.sh` 封装 `<group> up|down|logs` 子命令：`up` = 并行 build 二进制 + 后台起（写 pidfile 到 `.local/`，自动注入各服务 env 端口）；`down` = 按 pidfile 干净停；`logs` = tail 不停服务。`up/down` 符合操作动词直觉；pidfile 落 `.local/`（见文档系统）。改代码后 `down && up` 重编重启，或 `up --no-build` 秒起复用二进制。

**Fallback 硬门禁**：能运行就运行，不能就说明原因；命令不存在不假装运行过；失败不静默换命令；不用 silent fallback 掩盖关键路径错误；失败如实报告跑了什么、失败在哪、是否本轮引起、已修什么、剩余风险。

## Spec / Plan 驱动

中等复杂功能先写简短 spec（目标/验收/范围/验证），可就是 plan.md 的一个 goal + checklist。拆成可独立验证的小任务；有顺序依赖串行，独立无共享写可并行。完成 = 验收命令通过 + 边界未破坏 + 改动可追溯到 spec。

**Goal 预授权（避免重复阻塞）**：把会触发硬门禁的不可逆操作（建表/迁移、认证、契约改动）作为 task 显式写进 goal。用户确认 plan 即对该 goal task 范围预授权，推进时直接执行 + 勾选 ledger，不再逐个问——只有超出 task 范围或与决策记录冲突才停下问。goal 内的 schema/设计 proposal 是设计产物，与决策一致即自动放行执行，不二次确认。

## 权限与硬门禁

- **代码 commit 是可逆操作**（git 兜底），跑完验证门禁即提交，不逐个问——commit 是 checkpoint 便于 review，不是定案。`docs/current.md` 客观状态更新同理。
- **方向性 docs 写入**（新建 ADR、改写决策记录、roadmap 方向变更）影响后续 AI 与人，需用户确认后再提交（首次为既有项目批量补建历史 ADR 属可逆治理，可直接执行后提示 review）。
- **不可逆/破坏性操作**（删除、覆盖、大迁移、目录搬家、DB schema、公开 API、认证权限、部署流程、force push）必须先问用户，默认拒绝。
- **例外：已批准 plan 的预授权范围**。当操作属于用户已确认 plan 的 goal 明确列出的 task 目标产物、且与 plan 决策记录一致，即视为已获预授权，直接执行（并记入进度日志），不逐个问确认——否则同一硬门禁会在每个 goal 上重复阻塞。覆盖该 goal task 范围的建表/migration、认证代码、契约修改。仍必须先问：超出当前 goal task 范围、与决策记录冲突、删除/覆盖已存在文件、不可回滚操作（force push、删生产数据）。
- **proposal 机制不阻塞**：goal 内产出 schema/设计 proposal 是设计产物；写定后若与 plan 决策一致即自动放行执行，无需二次人工确认；只有 proposal 引入了 plan 未涵盖且影响后续的决策才需要问。推进 agent 自行核对「goal task 范围 + plan 决策记录」，不要把已确认 goal 的固有操作误判为 blocked。
- 未批准不移动/删除/覆盖已有文件；不删预先存在的 dead code（可指出）；只清理本轮自己产生的 unused/orphan。
- 不顺手重构或格式化无关文件；不无说明新增依赖；不为不可能场景堆防御代码。
- 不把 secret/token 写进文档；不把 AI 推测写成事实；不把未来计划写成已实现。
- 不为完整建空目录；不把共享库放进 `apps/`；不让 `packages/` 依赖 `apps/`。

## Kilo 平台适配（可选）

运行环境为 Kilo 时：写隔离/多版本对比用 `agent_manager`（worktree），纯研究用 `task`；开发服务器/watcher 用 `background_process` 不用 `&`；完成非平凡改文件后用 `suggest` 建议 code review；高影响歧义用 `question`。均条件触发，不强求，不擅长则回退串行。

## 输出风格

短而准确，不写流水账。复杂工作编辑前给短计划、结束后给紧凑交接；简单工作保持简短，但仍说明验证状态。
