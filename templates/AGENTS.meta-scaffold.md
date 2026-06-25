# AGENTS.md

本项目使用 META-SCAFFOLD v6。

## 必须遵守

在检查、重组、编写文档或修改本仓库前，遵守：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

默认中文沟通，除非本仓库已经明确使用其他语言约定。

## 上下文读取顺序

1. 用户请求。
2. 当前 `AGENTS.md`。
3. `docs/current.md`。
4. `docs/reference/architecture.md`。
5. 任务明确提到的文件。
6. package、workspace、命令入口文件。
7. 用户要求继续 goal、推进 plan 或明确提到时，才读 `.local/plan/plan.md`（或项目约定的 active goal 文件）。
8. roadmap、operations、decisions 或更广泛搜索，只在需要时读取。

## 工具使用纪律

- 多个相互独立的读取/搜索一次性并行发起，不串行浪费。
- 编辑前先读文件；对未读文件不做大范围 `replaceAll`。
- 用专用工具而非 shell 做文件操作（Read 而非 `cat`，Edit 而非 `sed`）。
- 开发服务器、watcher、长进程用进程管理工具，不用 `&`/`nohup`。
- 危险或不可逆命令默认不执行，除非用户明确授权。

## 子 Agent 编排（条件化，不强求）

- 仅当任务可拆成独立、无顺序依赖、无共享写、自包含且够重的子任务时，才并行分发。
- 有顺序依赖、写同一文件、线性小任务时不分发。
- 模型/平台不擅长并行则回退串行；不把"用 subagent"写成硬性要求。

## 边界

- 先检查真实仓库状态，再提出结构建议。
- 只修改和请求直接相关的文件。
- 代码 commit 是可逆操作（git 兜底），跑完验证门禁即提交，不逐个问——commit 是 checkpoint 便于 review，不是定案。
- 方向性 docs 写入（新建 ADR、改写决策记录、roadmap 方向变更）需用户确认后再提交；`docs/current.md` 客观状态更新除外。
- 未确认前不要删除、移动或覆盖已有文件；不删预先存在的 dead code（可指出）。
- 不要为了完整感创建空目录；不把未来计划写成当前事实。
- `apps/` 放独立运行单元；`packages/` 或 `libs/` 放共享能力。
- 默认禁止 `packages/* -> apps/*`；默认禁止 `apps/A -> apps/B` 直接 import。
- 跨 app 协作应通过 contracts、API、schema、event 或 queue。

## 验证

优先使用项目已有命令。如果没有，说明缺口并提出最薄的稳定命令入口。

```bash
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

或：

```bash
./manage.sh check all
./manage.sh test
./manage.sh build
```

验证是硬门禁：命令不存在不假装运行过；失败不静默换命令；不用 silent fallback 掩盖关键路径错误；失败如实报告。

## 持久上下文

如果改动会影响后续工作，只把和判断相关的信息写入 `docs/current.md`：当前目标、用户意图/背景、已确认方向、边界/不要改什么、当前状态、完成标准、验证命令、下一步。

## 长目标进度

如果项目使用 `.local/plan/plan.md`（推荐，与本地产物同归 `.local/`，整体 gitignore）或 `docs/plan.md` 等 active goal 文件推进多轮任务，在文件顶部维护可恢复执行账本：

```markdown
## Goal Execution Ledger

Last updated: YYYY-MM-DD
Current focus: <one sentence>
Next unchecked item: <copy the exact checklist item or write "none">
Blockers: <none, or concrete blocker>

### Active Checklist

- [ ] Small, verifiable task
- [x] Completed task with date or short evidence when useful
```

继续 goal 时先读 ledger，从第一个未勾选项继续；交接前更新 checkbox、`Next unchecked item` 和 blocker。稳定事实和已确认决策仍写入 `docs/current.md`、roadmap 或 reference，不要只留在 ignored plan 文件里。

Goal 预授权：把会触发硬门禁的不可逆操作（建表/迁移、认证、契约改动）作为 task 显式写进 goal。用户确认 plan 即对该 goal task 范围预授权，推进时直接执行 + 勾选 ledger，不再逐个问——只有超出 task 范围、与决策记录冲突或不可回滚操作（force push、删生产数据）才停下问。goal 内的 schema/设计 proposal 是设计产物，与决策一致即自动放行执行，不二次确认。

Commit 纪律：代码改动 + commit 是可逆操作（git 兜底），跑完验证门禁即提交，不逐个问——commit 是 checkpoint 便于 review，不是定案。方向性 docs 写入（新建 ADR、改写决策记录、roadmap 方向变更）需用户确认后再提交；`docs/current.md` 客观状态更新除外。

上游完整 skill：

```text
https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md
```
