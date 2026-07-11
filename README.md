# META-SCAFFOLD

> 面向 coding agent 的仓库治理 skill：理解真实仓库，做最小必要改变，维护可恢复的项目记忆，并用真实验证结束工作。

META-SCAFFOLD v6.6 遵循 [Agent Skills](https://agentskills.io/) 目录格式，同一份 skill 可用于 Codex、Kilo Code、Cursor 和其他兼容实现。

它不是目录模板，也不替模型重复讲通用编码常识。核心只保留会改变工程结果的内容：

- 项目事实和聊天历史分离，输出与交接自包含。
- 高影响操作与已批准计划的授权边界。
- 依赖、运行单元和共享包边界。
- current / ADR / reference / roadmap / local plan 的信息寿命。
- 验证诚信：失败不假装通过，不 silent fallback。

流程按改动风险缩放：小改直接改并验证；结构调整或长目标才先对齐目标与计划。

## 一个运行时版本

唯一运行时内容源：

```text
skills/meta-scaffold/
├── SKILL.md
├── agents/openai.yaml
└── references/
    ├── handoff.md
    ├── platforms.md
    └── repository-patterns.md
```

`SKILL.md` 保持精简；交接模板、仓库模式和平台安装只在任务相关时加载。Codex、Kilo、Cursor 不维护三份正文。

## 本地同步 Codex + Kilo + Cursor

从 clone 同步同一版本到三个全局发现目录：

```bash
./scripts/install-agent-skill.sh all
```

也可单独安装：

```bash
./scripts/install-agent-skill.sh codex
./scripts/install-agent-skill.sh kilo
./scripts/install-agent-skill.sh cursor
```

默认目标：

- Codex：`${CODEX_HOME:-~/.codex}/skills/meta-scaffold`
- Kilo Code：`${KILO_HOME:-~/.kilo}/skills/meta-scaffold`
- Cursor：`${CURSOR_HOME:-~/.cursor}/skills/meta-scaffold`

已有同名 skill 默认不覆盖。确认刷新：

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all
```

旧入口 `./scripts/install-codex-skill.sh` 继续可用，内部调用统一安装器。

## 从 GitHub 使用

Codex：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

Kilo Code 可在 `kilo.jsonc` 使用同一发布目录：

```jsonc
{
  "skills": {
    "urls": [
      "https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/"
    ]
  }
}
```

Kilo 会读取 [`skills/index.json`](./skills/index.json)。新会话会重新发现 skills；需要时使用 `/reload`。

## 安装到项目

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh \
  | bash -s -- . all
```

安装器会：

- 安装完整 `skills/meta-scaffold/`，包含 references 和 OpenAI UI 元数据。
- 向现有 `AGENTS.md` / `CLAUDE.md` 追加薄引用块，不覆盖原内容。
- 安装 Cursor rule。
- 仅在不存在时创建 current、roadmap、ADR INDEX、architecture 和 plan 模板。

可选模式：`skill`、`agents`、`claude`、`cursor`、`templates`、`all`。

## 设计变化

v6.6 针对实际使用中的上下文摩擦做了收敛：

- monorepo、commit、sub-agent、handoff prompt 不再是全局默认。
- 普通完成答复不再强制附加可粘贴交接模板。
- 禁止用“见上文”“按之前内容”代替关键事实。
- Kilo 平台工具名从核心规则移除；平台差异只负责安装和发现。
- 多服务、`.local/`、多实例端口等专项模式移入按需 reference。
- `prompts/`、dist、templates 改为人工审阅版或薄适配器，避免多份规则漂移。

## 主要文件

| 路径 | 作用 |
| --- | --- |
| [`skills/meta-scaffold/SKILL.md`](./skills/meta-scaffold/SKILL.md) | 精简运行时核心 |
| [`skills/meta-scaffold/references/`](./skills/meta-scaffold/references/) | 按需细节 |
| [`skills/index.json`](./skills/index.json) | Kilo remote manifest |
| [`prompts/META-SCAFFOLD-v6.md`](./prompts/META-SCAFFOLD-v6.md) | 人工审阅版契约 |
| [`dist/`](./dist/) | 不支持 skills 的薄分发件 |
| [`scripts/install-agent-skill.sh`](./scripts/install-agent-skill.sh) | Codex/Kilo/Cursor 统一同步 |
| [`scripts/install.sh`](./scripts/install.sh) | 项目安装器 |
| [`scripts/check.sh`](./scripts/check.sh) | 本仓库验证 |

## 维护

```bash
./scripts/check.sh
```

推送后再运行远端 smoke：

```bash
./scripts/smoke-remote.sh
```

当前版本：`v6.6.3` / `Stable Draft`

## License

MIT
