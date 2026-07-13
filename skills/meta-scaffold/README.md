# meta-scaffold

运行时入口为 `SKILL.md`，细节按需读取 `references/`。同一目录同时支持 Pi、Codex、Kilo Code、Cursor 和其他 Agent Skills 实现。

本地同步：

```bash
./scripts/install-agent-skill.sh all
```

Pi 可使用用户级 package，或使用 `~/.agents/skills` 中带稳定 shell wrapper 路径的 global 安装；二者不要同时安装。

完整安装说明见仓库根 `README.md`。
