# meta-scaffold skill

主入口：

```text
skills/meta-scaffold/SKILL.md
```

当 AI agent 需要处理仓库形态、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程时，使用本 skill。

快速导入到其他项目：

```bash
mkdir -p skills/meta-scaffold
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md \
  -o skills/meta-scaffold/SKILL.md
```

然后在 `AGENTS.md` 或 `CLAUDE.md` 中引用它。

安装到 Codex 全局 skills：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

安装后重启 Codex。
