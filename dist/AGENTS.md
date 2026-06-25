# AGENTS.md

## META-SCAFFOLD v6

把本节作为 AI coding agent 的项目治理契约。默认中文协作和编写项目交接文档，除非用户另有要求或仓库已明确使用其他语言。

核心协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

执行协议：

1. 修改文件前先检查真实仓库。
2. 非简单任务先说明目标、假设、成功标准和非目标。
3. 只对高影响歧义提问；低风险歧义使用安全默认值继续。
4. 重大改动前先 Preview。
5. 只修改任务所需文件。
6. 使用已有命令验证，或说明为什么无法验证。
7. 交接时说明变更文件、验证结果、风险和下一轮起点。
8. 保持 `docs/current.md` 简洁，只记录仍会影响未来工作的内容。
9. 继续 long-running goal 时，先读 `.local/plan/plan.md` 顶部执行账本，从第一个未勾选项接着做，交接前更新 checkbox、`Next unchecked item` 和 blocker。

工具使用纪律：

- 先读后改；对未读文件不做大范围 `replaceAll`。
- 独立读取/搜索并行发起（后步依赖前步时串行）。
- 危险或不可逆命令默认不执行；长进程用进程管理工具不用 `&`/`nohup`。

子 Agent 编排（条件化，不强求）：任务可拆成独立、无共享写、自包含且够重的子任务时才并行分发；有顺序依赖或写同一文件则串行。

仓库结构规则：

- **monorepo 是 AI 协作的推荐默认形态**：一次 Inspect 全局视野 + 共享层自然沉淀 + 统一验证。用少量空间换最大 agent 操作空间。新项目默认 monorepo，只落地真实需要的目录。
- `apps/` 放可独立运行、构建或部署的单元。
- `packages/` 或 `libs/` 放共享代码。
- 默认依赖方向：允许 `apps/* -> packages/*`；禁止 `packages/* -> apps/*`；默认禁止 `apps/A -> apps/B`。
- 跨 app 协作应使用 HTTP、RPC、queue、event、schema、protobuf 或 contracts package，而不是直接 import。

文档规则：

- 最小有用文档：`docs/current.md`、`docs/roadmap.md`、`docs/reference/architecture.md`、`docs/decision/`（ADR）+ `docs/decision/INDEX.md`（一行索引）。
- `docs/current.md` 只记当前焦点 + 短期下一步（最多 5 项）+ 阻塞 + 关键架构事实 + 验证命令。已完成 goal 不在此留存细节（归 roadmap 一行指针），修复历史归 `git log`。目的是让下一轮 AI 用最少 token 接上当前工作。
- `docs/decision/`（ADR）是核心设计记忆：用户方向性想法常细碎跨会话，ADR 是沉淀点。每个「为什么这么做」记一条编号记录（`00NN-slug.md`），新决策覆盖旧决策不改旧文件。`INDEX.md` 一行列所有 ADR + 状态。agent 读 ADR 即知「这条路已想过，不要重新提议」。
- `docs/roadmap.md` 已完成阶段只留一行指针（细节归 architecture/git log），其余是未来方向、阶段目标、非目标。
- `docs/plan.md` 或 `.local/plan/plan.md` 可作为快速变化的 active goal ledger；用 Markdown checkbox 保存可恢复进度，不保存稳定事实或 secrets。优先 `.local/plan/`（与本地产物同归 `.local/`，整体 gitignore）。
- `.local/` 收运行时产物（pid/logs/bin）+ 活跃 plan + sub-agent backlog，整体 gitignore。子目录：`dev/`、`plan/`、`backlog/`。
- `.local/backlog/<agent-slug>.md` 异步委派不稳定 sub-agent：主 agent 写委派意图后继续自己工作，不探测不等待；sub-agent 被调起时读自己 backlog 拉任务。不写 `state.json` 健康追踪。
- `docs/reference/` 只写当前事实，未实现内容标 `Status: Not Implemented`。
- 未来计划写入 roadmap，不得写成已实现事实。

验证规则（硬门禁）：

- 优先使用已有命令，例如 `pnpm lint`、`pnpm typecheck`、`pnpm test`、`pnpm build`、`make check`、`just check`、`task check` 或 `./manage.sh check all`。
- README、AGENTS、CI 和 AI 交接应指向同一组命令。
- 命令不存在不假装运行过；验证失败不静默换命令；不用 silent fallback 掩盖关键路径错误；失败如实报告。

硬门禁（不做，除非用户明确授权）：

- 代码 commit 是可逆操作（git 兜底），跑完验证门禁即提交，不逐个问——commit 是 checkpoint 便于 review，不是定案。`docs/current.md` 客观状态更新同理。
- 方向性 docs 写入（新建 ADR、改写决策记录、roadmap 方向变更）需用户确认后再提交。
- 已批准 plan 的 goal task 范围内操作（建表/migration、认证、契约）视为预授权，推进时直接执行不逐个问；超出范围、与决策冲突或不可回滚操作（force push、删生产数据）仍需先问。
- 未批准移动、删除或覆盖已有文件。
- 顺手重构或格式化无关文件；未说明原因新增依赖；为不可能场景堆防御代码。
- 删除预先存在的 dead code（可指出不擅自清理）。
- 改变公开 API、DB schema、认证权限、部署流程。
- 把 secret、token、真实密钥写进文档或示例。
- 为了显得完整创建空目录；把共享库放进 `apps/`；让共享包依赖 apps。
- 把 AI 推测写成项目事实；用 silent fallback 掩盖失败。
