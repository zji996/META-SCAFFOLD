# AGENTS.md

本项目使用 META-SCAFFOLD v5。

## 必须遵守

在检查、重组、编写文档或修改本仓库前，遵守：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

默认中文沟通，除非本仓库已经明确使用其他语言约定。

## 上下文读取顺序

1. 用户请求。
2. 当前 `AGENTS.md`。
3. `docs/current.md`.
4. `docs/reference/architecture.md`.
5. 任务明确提到的文件。
6. package、workspace、命令入口文件。
7. roadmap、operations、decisions 或更广泛搜索，只在需要时读取。

## 边界

- 先检查真实仓库状态，再提出结构建议。
- 只修改和请求直接相关的文件。
- 未确认前不要删除、移动或覆盖已有文件。
- 不要为了完整感创建空目录。
- 不要把未来计划写成当前事实。
- `apps/` 放独立运行单元。
- `packages/` 或 `libs/` 放共享能力。
- 默认禁止 `packages/* -> apps/*`。
- 默认禁止 `apps/A -> apps/B` 直接 import。
- 跨 app 协作应通过 contracts、API、schema、event 或 queue。

## 验证

优先使用项目已有命令。如果没有，说明缺口并提出最薄的稳定命令入口。

常见示例：

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

## 持久上下文

如果改动会影响后续工作，只把和判断相关的信息写入 `docs/current.md`：

- 当前目标；
- 用户意图 / 背景；
- 已确认方向；
- 边界 / 不要改什么；
- 当前状态；
- 验收标准；
- 验证命令；
- 下一步。

## 长目标进度

如果项目使用 `docs/plan.md` 或其他 active goal 文件推进多轮任务，在文件顶部维护可恢复执行账本：

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

上游完整 skill：

```text
https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md
```
