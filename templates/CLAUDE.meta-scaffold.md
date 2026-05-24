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
5. roadmap、operations、decisions 只在需要时读取

修改后尽量运行已有验证命令。如果无法验证，说明原因并给出准确命令。
