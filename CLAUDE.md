# CLAUDE.md

本仓库维护 META-SCAFFOLD。处理分发、文档、安装器或 skill 内容前依次读取：

1. `skills/meta-scaffold/SKILL.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. 当前任务文件

`skills/meta-scaffold/` 是运行时唯一内容源。`prompts/` 是人工审阅版，`dist/`、templates、Cursor/Claude 入口是薄适配器，不应各自扩展新规则。

修改后运行：

```bash
./scripts/check.sh
```
