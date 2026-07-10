# Platform Installation

`skills/meta-scaffold/` 是唯一运行时内容源。不要维护 Codex、Kilo、Cursor 三份正文；安装器只把同一目录同步到不同发现位置。

## 本地 clone 同步

```bash
./scripts/install-agent-skill.sh codex
./scripts/install-agent-skill.sh kilo
./scripts/install-agent-skill.sh cursor
./scripts/install-agent-skill.sh all
```

默认只安装到空位置。刷新已存在的 META-SCAFFOLD：

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all
```

默认位置：

- Codex：`${CODEX_HOME:-~/.codex}/skills/meta-scaffold`
- Kilo Code：`${KILO_HOME:-~/.kilo}/skills/meta-scaffold`
- Cursor：`${CURSOR_HOME:-~/.cursor}/skills/meta-scaffold`

安装后开启新会话；Kilo Code 也可使用 `/reload` 重新扫描。不要写入 `~/.cursor/skills-cursor/`，该目录由 Cursor 管理内置 skills。

## GitHub 安装

Codex 可从仓库路径安装 `skills/meta-scaffold`。Kilo Code 可在 `kilo.jsonc` 中配置同一发布目录：

```jsonc
{
  "skills": {
    "urls": [
      "https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/"
    ]
  }
}
```

该 URL 读取 `skills/index.json`，其中列出的文件与本地三端安装目录完全相同。Cursor 个人 skill 使用 `~/.cursor/skills/`；项目 skill 使用 `.cursor/skills/`。

## 平台边界

- skill 正文描述治理语义，不指定平台专属工具名。
- UI 元数据放 `agents/openai.yaml`；不影响 Kilo Code。
- 平台缺少某个工具时使用其提供的等价能力，不因此改变授权、验证或文档规则。
