# META-SCAFFOLD

> 面向 coding agent 的仓库治理 skill：理解真实仓库，做最小必要改变，维护可恢复的项目记忆，并用真实验证结束工作。

META-SCAFFOLD v6.14 遵循 [Agent Skills](https://agentskills.io/) 目录格式，同一份 skill 可用于 Pi、Codex、Kilo Code、Cursor 和其他兼容实现。

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
├── references/
│   ├── handoff.md
│   ├── platforms.md
│   └── repository-patterns.md
└── scripts/
    └── pi-json-stream.sh
```

`SKILL.md` 保持精简；交接模板、仓库模式和平台安装只在任务相关时加载。Pi、Codex、Kilo、Cursor 不维护多份正文。

## 全局使用（二选一）

只使用 skill、无需 shell 委派 wrapper 时，Pi 可把公共仓库作为用户级 package 安装：

```bash
pi install git:github.com/zji996/META-SCAFFOLD
```

以后更新：

```bash
pi update --extensions
```

`skills/meta-scaffold/` 仍保留在本公共仓库中，因为它是 Agent Skills 和 Pi package 的标准源码/发布目录；它不是要求业务项目 vendor 的路径。不要同时安装 git package、本地 package 和同名全局副本，以免 Pi 报 skill collision。

需要稳定调用 `$HOME/.agents/skills/meta-scaffold/scripts/pi-json-stream.sh` 时，使用下文 vendor-neutral global 安装，不再安装 Pi package。Pi 会自动发现 `~/.agents/skills`。

维护者可以 clone 本仓后安装本地 package，使源码修改在新会话直接生效：

```bash
make link-pi-local
```

## 本地同步全局目录

从 clone 同步同一版本到 vendor-neutral global、Codex、Kilo 和 Cursor 的用户级发现目录：

```bash
./scripts/install-agent-skill.sh all
```

也可单独安装：

```bash
./scripts/install-agent-skill.sh global
./scripts/install-agent-skill.sh codex
./scripts/install-agent-skill.sh kilo
./scripts/install-agent-skill.sh cursor
```

默认目标：

- Agent Skills / Pi：`${META_SCAFFOLD_GLOBAL_SKILLS_ROOT:-~/.agents/skills}/meta-scaffold`
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

## 安装到项目（脚手架，不复制 skill）

Skill 只装用户级（见上文）。项目脚手架：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh \
  | bash -s -- . all
```

安装器会：

- **不**往业务仓写入 `skills/meta-scaffold/`。
- 向现有 `AGENTS.md` / `CLAUDE.md` 追加薄引用块（指向本文件契约 + 用户级 skill），不覆盖原内容。
- 安装精简 Cursor rule（同样不指向仓内 skill 路径）。
- 仅在不存在时创建 current、roadmap、ADR INDEX、architecture 和 plan 模板。

可选模式：`agents`、`claude`、`cursor`、`templates`、`all`。`skill` 模式会拒绝并提示改用 `install-agent-skill.sh`。

## v6.14 策略

- HTTP 入口按浏览器位置选拓扑，不拆两套 skill。同机（WSL/本机）继续系统 Caddy + `*.localhost` + Vite HMR。
- 远程 GPU / Cursor Remote + 公网 Caddy/FRP：公网默认静态 edge（与 Vite 同端口置换、同源 `/v1`）；不要 FRP Vite、API、worker、进度口、数据库；`local_ip` 用局域网 IP。edge 改前端须 `manage.sh`/`make` rebuild。
- 远程机不要再套一套 `*.localhost` 当日常入口；消费仓写明公网暴露哪些 UI（如 web+admin）。前端热改走 Cursor 转发或内网 Vite。

## v6.13 策略

- 同机多项目默认用系统级 Caddy + 独立 site + `*.localhost` 防冲；日常入口是域名，不是端口号。不要把全仓统一端口偏移当治理主轴。
- upstream / DB / 缓存端口只要本机不冲突即可；`urls` 列约定域名，`ports` 仅诊断；停干净后勿把入口表展示成已可访问。
- 需要数小时内验证 UI、而生产功能必须经过真实 auth/API/状态时，使用独立开发态设计 sandbox；mock 画布不进入生产导航、镜像、静态托管或发布构建。
- 设计定稿以截图加场景说明冻结视觉与状态；sandbox 可运行不等于生产功能已实现，真实功能仍在生产 App 按完整约束实现和验证。
- 临时本地服务优先使用内核/Docker 动态端口，并通过 `ports` 自省真实地址；只有端口必须预先可预测时才使用实例前缀派生。
- 一台开发机只保留一个系统级 Caddy 等 HTTP 入口，项目用独立站点片段把 `<project>.localhost` 指向动态 Backend；数据库和 Redis 不经过反向代理。
- 仓库未覆盖且用户未禁止时，完整、边界清晰并通过相称验证的改动默认创建原子本地 commit。

## v6.9 基础

- 仓库未覆盖且用户未禁止时，完整、边界清晰并通过相称验证的改动默认创建原子本地 commit。
- 自动 commit 只包含本任务改动；未完成或验证失败不为清理工作区而提交。
- push、建远程、PR 与发布继续按消费仓和用户授权执行。

## v6.8 基础

- Pi 默认通过用户级 git package 全局安装和更新，业务项目无需复制 skill。
- 跨 agent CLI 默认使用 Pi 前台 print mode + JSON 流，主控持续观察进度、串行写仓并复核验证。
- 治理状态分开 implementation、production enablement、default policy 与 evidence；建议 goal 不冒充 active plan。
- benchmark 数字集中归档并可追溯；Pi 委派以真实进程退出而非输出通道结束为准。
- monorepo、sub-agent、handoff prompt 不作为全局默认。
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
| [`scripts/install-agent-skill.sh`](./scripts/install-agent-skill.sh) | Global/Codex/Kilo/Cursor 统一同步 |
| [`scripts/install.sh`](./scripts/install.sh) | 项目脚手架（不 vendor skill） |
| [`scripts/check.sh`](./scripts/check.sh) | 本仓库验证 |

## 维护

```bash
./scripts/check.sh
make refresh-global  # 从当前 clone 刷新 global/Codex/Kilo/Cursor 用户级副本
```

推送后再运行远端 smoke：

```bash
./scripts/smoke-remote.sh
```

当前版本：`v6.14.1` / `Stable Draft`

## License

MIT
