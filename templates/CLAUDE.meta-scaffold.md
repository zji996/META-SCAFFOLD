# CLAUDE.md

## META-SCAFFOLD

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程时，先读取并遵守：

```text
skills/meta-scaffold/SKILL.md
```

默认协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

默认上下文顺序：

1. `CLAUDE.md` / `AGENTS.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. 任务明确提到的文件
5. `docs/plan.md` 只在用户要求继续 goal、推进 plan 或该文件被明确提到时读取
6. roadmap、operations、decisions 只在需要时读取

修改后尽量运行已有验证命令。如果无法验证，说明原因并给出准确命令。

如果项目使用 `docs/plan.md` 或其他 active goal 文件推进多轮任务，文件顶部应有 `Goal Execution Ledger` 和 Markdown checkbox。继续 goal 时从第一个未勾选项接着做，交接前更新 checkbox、`Next unchecked item` 和 blocker；稳定事实仍写入 `docs/current.md`、roadmap 或 reference。
