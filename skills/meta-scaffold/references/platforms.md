# Platform Installation

`skills/meta-scaffold/` 是公共仓库中的唯一运行时内容源，也是 Agent Skills / Pi package 的标准发布目录。消费项目不需要复制该目录；全局安装只是在用户级发现位置或 Pi package cache 中引用同一份发布内容。

## Pi 全局安装（推荐）

```bash
pi install git:github.com/zji996/META-SCAFFOLD
```

该命令写入用户级 `~/.pi/agent/settings.json`，对所有项目生效。更新公共版本：

```bash
pi update --extensions
```

维护者若希望本地 clone 的修改在新 Pi 会话中立即生效，可安装本地 package：

```bash
pi install /absolute/path/to/META-SCAFFOLD
```

不要同时安装 git package、本地 package和 `~/.agents/skills/meta-scaffold` 副本，否则同名 skill 会产生 collision warning。项目只在需要固定版本或团队共享设置时使用 `pi install -l ...`。

## 本地 clone 同步

```bash
./scripts/install-agent-skill.sh global
./scripts/install-agent-skill.sh codex
./scripts/install-agent-skill.sh kilo
./scripts/install-agent-skill.sh cursor
./scripts/install-agent-skill.sh all
```

默认只安装到空位置。刷新已存在的 META-SCAFFOLD：

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all
```

`all` 会同步 vendor-neutral global 目录及三个平台目录。默认位置：

- Pi / Agent Skills：`${META_SCAFFOLD_GLOBAL_SKILLS_ROOT:-~/.agents/skills}/meta-scaffold`
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

## 跨 Agent CLI（默认 Pi）

其他 agent 经 shell 委派子任务时默认使用 Pi 的前台一次性 print 模式，并以 JSON 流观察执行过程。Pi 从当前目录读取 `AGENTS.md` 等上下文；本机 provider、模型和密钥由 Pi 自身配置，不写入仓库或提示词。

```bash
# 调研或实现；是否修改由任务本身决定
(cd <repo> && timeout 20m pi --no-session --mode json -p "<任务>")
```

- Pi 默认使用本机完整工具、extensions 与 skills；不按任务类型额外裁剪能力。
- `--no-session` 仅表示这次委派不写会话历史，不限制模型在本次任务中的上下文与工具使用。
- `--mode json` 实时输出生命周期、工具调用、工具结果与完成事件；主控持续消费事件，并按正在读取、修改和验证的实质变化定期汇报进度。
- 保持命令在前台运行，通过调用平台的 session/cell 轮询机制读取增量输出；不要用 shell `&`、`nohup` 或脱离主控的静默后台进程。
- `--verbose` 主要增加启动日志，不替代 `--mode json` 的任务进度可见性。
- `timeout` 防止无人值守任务长期占用；若平台没有该命令，使用平台等价超时机制。
- 主控与子 agent 串行写仓；子任务结束后主控 `git diff` 并跑仓库验证。
- JSON 事件可能包含工具参数、文件内容或命令结果；只向用户摘要必要进度，不未经筛选长期落盘或原样转发敏感输出。
- Pi 配置与认证留在 `~/.pi/agent/`；密钥不进入仓库、命令参数或任务文本。

推荐长仓库审计使用 300K 上下文，并保持保守压缩余量。自定义模型条目：

```json
{
  "contextWindow": 300000
}
```

`~/.pi/agent/settings.json`：

```json
{
  "compaction": {
    "enabled": true,
    "reserveTokens": 32768,
    "keepRecentTokens": 40000
  }
}
```

即使底层模型支持 500K，也默认使用 300K 控制延迟与上下文噪声；确有超长单次材料时再按任务提高。

### 简洁任务契约

```text
先读取并遵守 AGENTS.md 及与任务直接相关的文档。
任务：<具体、可验收的结果>。
边界：<仅填写真实存在的非目标、高影响操作或兼容性约束>。
成功：<行为与边界标准>。
验证：运行 <定向测试或仓库门禁>。
交付：直接完成修改；最后简述 diff、验证和残余风险。
```

### 任务选择与复审

- 只读审计、测试、文档、服务工程、核心算法和跨模块实现均可委派；风险越高，成功标准和主控复审越严格。
- 写仓前记录基线 `git status --short`；完成后只审允许范围内的 diff，并确认没有回滚用户修改。
- Pi 的测试结果只是证据之一；主控在同一工作树重新运行与风险相称的验证。

### 进程与会话生命周期

- `pi --no-session --mode json -p` 是前台一次性子进程；正常返回后不保留委派会话。
- JSON 完成事件、平台工具报告空输出、session/cell 结束或输出通道关闭，都不等于 Pi 与外层 `timeout` 进程已退出。主控必须取得真实 exit code，并在写仓前用平台或 OS 进程查询确认两者均已消失。
- 主控不得在 Pi 仍写仓时并行修改同一文件。调用被中断或超时时，先确认进程退出，再审 diff。
- 外部超时只约束进程生命周期，不替代任务验收与 Git 复审。
