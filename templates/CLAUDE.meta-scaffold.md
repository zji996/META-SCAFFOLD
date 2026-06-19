# CLAUDE.md

## META-SCAFFOLD v6

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩、工具使用纪律、子 agent 编排或验证流程时，先读取并遵守：

```text
skills/meta-scaffold/SKILL.md
```

默认协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

工具使用纪律：

- 独立的读取/搜索一次性并行发起；编辑前先读文件；用专用工具而非 shell 做文件操作。
- 开发服务器/watcher 用进程管理工具，不用 `&`/`nohup`；危险或不可逆命令默认不执行。

子 Agent 编排（条件化，不强求）：任务可拆成独立、无共享写、自包含且够重的子任务时才并行分发；不擅长则回退串行。

默认上下文顺序：

1. `CLAUDE.md` / `AGENTS.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. 任务明确提到的文件
5. `docs/plan.md` 只在用户要求继续 goal、推进 plan 或该文件被明确提到时读取
6. roadmap、operations、decisions 只在需要时读取

修改后尽量运行已有验证命令。如果无法验证，说明原因并给出准确命令。验证是硬门禁：失败不静默换命令，不假装运行过。

如果项目使用 `docs/plan.md` 或其他 active goal 文件推进多轮任务，文件顶部应有 `Goal Execution Ledger` 和 Markdown checkbox。继续 goal 时从第一个未勾选项接着做，交接前更新 checkbox、`Next unchecked item` 和 blocker；稳定事实仍写入 `docs/current.md`、roadmap 或 reference。
