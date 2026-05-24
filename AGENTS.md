# AGENTS.md

本仓库把 META-SCAFFOLD 发布为可复用的 AI-agent skill。

修改仓库结构、分发文件、安装脚本或文档前，先读取：

1. `skills/meta-scaffold/SKILL.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. 任务明确要求的文件

默认中文协作，除非用户另有要求，或被编辑文件本身就是英文文件。

## 维护规则

- 保持 `skills/meta-scaffold/SKILL.md` 作为主要可复用 skill。
- 保持 `prompts/META-SCAFFOLD-v5.md` 作为完整契约源。
- 保持 `dist/AGENTS.md`、`dist/CLAUDE.md`、`.cursor/rules/meta-scaffold.mdc` 和 `dist/CURSOR.mdc` 与 skill 对齐。
- 除非必要，不要添加重型构建工具。
- 不要覆盖 examples/templates，除非保留向后兼容的导入路径。
- 结构性改动后运行 `./scripts/check.sh`。

## 验证

```bash
./scripts/check.sh
```

- Plugin manifest: `.claude-plugin/plugin.json` 应指向 `./skills/meta-scaffold`。
