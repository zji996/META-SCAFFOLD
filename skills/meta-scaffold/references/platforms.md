# Platform Installation

`skills/meta-scaffold/` 是公共仓库中的唯一运行时内容源，也是 Agent Skills / Pi package 的标准发布目录。消费项目不需要复制该目录；全局安装只是在用户级发现位置或 Pi package cache 中引用同一份发布内容。

## Pi 全局安装（二选一）

仅使用 skill、无需 shell 委派 wrapper 时，可以安装 Pi package：

```bash
pi install git:github.com/zji996/META-SCAFFOLD
```

该命令写入用户级 `~/.pi/agent/settings.json`，对所有项目生效。更新公共版本：

```bash
pi update --extensions
```

需要稳定调用 `$HOME/.agents/skills/meta-scaffold/scripts/pi-json-stream.sh` 时，改用下文 `global` 安装目标，不再安装 Pi package。Pi 会自动发现 `~/.agents/skills`；两种方式同时存在会产生同名 collision。

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

其他 agent 经 shell 委派子任务时默认使用 Pi 的前台一次性 print 模式，并以高信号 JSON 流观察执行过程。Pi 从显式工作目录读取 `AGENTS.md` 等上下文；本机 provider、模型和密钥由 Pi 自身配置，不写入仓库或提示词。

```bash
repo_root="$(git rev-parse --show-toplevel)"
prompt="$repo_root/.local/run/pi-task.prompt"
events="$repo_root/.local/run/pi-task.events.jsonl"
mkdir -p "$repo_root/.local/run"
# 用 apply_patch 或等价安全方式创建任务契约，不把长 prompt 放命令行。
$HOME/.agents/skills/meta-scaffold/scripts/pi-json-stream.sh \
  20m "$repo_root" "$prompt" "$events"
```

- Pi 默认使用本机完整工具、extensions 与 skills；不按任务类型额外裁剪能力。
- `--no-session` 仅表示这次委派不写会话历史，不限制模型在本次任务中的上下文与工具使用。
- 四参数调用显式固定 Pi workdir；prompt/events 相对路径也以该 workdir 解析。兼容的三参数调用继承当前目录，只用于调用方已明确固定 cwd 的场景。
- `--mode json` 原始事件体积很大：tool args 可能包含编辑全文，message update 可能很长。默认必须先经 `scripts/pi-json-stream.sh` 过滤，不把原始流送入主控上下文或落盘。
- 过滤流只保留：截断到 180 字符的 bash 命令、edit/write 路径、顶层 `.isError` 工具错误、截断到 500 字符的阶段文本、retry/compaction/agent_end/settled 生命周期。read、成功工具结果和编辑正文默认丢弃。
- prompt 单独放 `.local/run/*.prompt`，过滤事件写 `.local/run/*.events.jsonl`；日志以 `umask 077` 创建，仅供当前任务按需回看，不进入长期项目记忆，任务收口后删除。
- 保持命令在前台运行，通过调用平台的 session/cell 轮询机制读取增量输出；不要用 shell `&`、`nohup` 或脱离主控的静默后台进程。
- `--verbose` 主要增加启动日志，不替代 `--mode json` 的任务进度可见性。
- `timeout` 防止无人值守任务长期占用；若平台没有该命令，使用平台等价超时机制。
- 主控与子 agent 串行写仓；子任务结束后主控 `git diff` 并跑仓库验证。
- 每 30–60 秒轮询增量；没有实质变化不重复汇报。用户更新只保留最近阶段结论、当前动作和下一验证。
- 需要追因时先查 `tail -n 20 <events-log>` 或 `rg '"e":"(tool_error|edit|write|retry)"' <events-log>`；仍不够再检查 artifact、diff 或定向重跑。
- 不默认保存原始 JSON。只有定位控制器问题时才临时保存，先 `umask 077`，任务结束后删除。
- `settled` 或进程退出 0 不单独证明任务成功；上游 retry 耗尽时 Pi 也可能正常退出。必须同时看到最终阶段文本，并由主控复审 diff、artifact 与验证结果。
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

- `scripts/pi-json-stream.sh` 在显式 workdir 内运行 `pi --no-session --mode json -p` 前台一次性子进程，并用 `set -o pipefail` 保留 Pi/timeout/jq/tee 的失败状态。
- JSON 完成事件、平台工具报告空输出、session/cell 结束或输出通道关闭，都不等于 Pi 与外层 `timeout` 进程已退出。主控必须取得真实 exit code，并在写仓前用平台或 OS 进程查询确认两者均已消失。
- 主控不得在 Pi 仍写仓时并行修改同一文件。调用被中断或超时时，先确认进程退出，再审 diff。
- 外部超时只约束进程生命周期，不替代任务验收与 Git 复审。
