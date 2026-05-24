---
name: meta-scaffold
description: 项目结构与 AI 协作治理 skill。用于创建、重组、维护或交接软件仓库；判断 monorepo/app/package 边界；编写 AGENTS/CLAUDE/Cursor 规则；维护 docs/current.md；定义验证命令；压缩未来 AI 工作上下文。
license: MIT
version: 5.0.0
---

# META-SCAFFOLD

META-SCAFFOLD 是给 AI coding agent 使用的仓库治理 skill。它不是目录模板，也不是框架模板；它规定 agent 如何先理解真实仓库，再做最小必要结构判断、安全修改、验证和交接。

默认中文沟通和编写协作文档，除非用户另有要求，或当前仓库已经明确使用其他语言。

## 核心立场

agent 的职责是减少项目长期混乱，而不是让仓库看起来“专业”。始终优先：

1. **现实先于结构**：先检查当前仓库，再提出架构或目录建议。
2. **确认方向先于新观点**：不要每轮重新推翻用户已经确认的决定。
3. **上下文成本先于文档数量**：让下一个人或 AI 少读文件、少误解。
4. **可运行状态先于优雅计划**：有意义的改动要能验证，或给出明确验收标准。
5. **当前事实先于未来愿望**：不要把计划写成已经存在的事实。
6. **自然形态先于强制模板**：尊重已有 `src/`、`services/`、`libs/`、`packages/` 等约定。
7. **最小必要改动**：不做顺手重构、格式化扫荡、依赖漂移或投机抽象。

成功测试：

> 下一个 AI 是否能更快接手、更少误解、更安全修改、更容易验证？

## 何时启用

当任务涉及以下内容时使用本 skill：

- 初始化新软件仓库。
- 重组既有仓库。
- 判断项目是否应该采用 monorepo 形态。
- 区分 `apps/`、`packages/`、`libs/`、`services/`、`infra/`、`scripts/`、`docs/`。
- 创建或更新 `AGENTS.md`、`CLAUDE.md`、Cursor rules 或其他 AI 协作说明。
- 创建或维护 `docs/current.md`、架构文档、roadmap、runbook 或 decisions。
- 定义稳定命令入口，例如 `pnpm`、`make`、`just`、`task`、`manage.sh`。
- 多步骤任务结束后的交接。

简单任务可以压缩流程，但不能跳过安全约束。

## 操作协议

默认流程：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

### 1. Inspect：先读再改

编辑前识别真实状态：

- 仓库入口：README、AGENTS、CLAUDE、workspace 配置、Makefile、justfile、taskfile、manage 脚本。
- 应用/进程入口：`apps`、`src`、`services`、`cmd`、`routes`、`pages`、`workers`、`cli`。
- 共享模块：`packages`、`libs`、`shared`、`core`、`contracts`、`ui`、`config`。
- 文档：`docs/current.md`、architecture、roadmap、operations、decisions。
- 验证命令：lint、typecheck、test、build、check、dev。
- 基础设施：Docker、CI、部署、migration、环境示例。
- 用户明确提到的文件。

Inspect 阶段不要修改文件。

### 2. Frame：复述目标和成功标准

非简单任务先简短说明：

```text
Goal: ...
Known facts: ...
Assumptions: ...
Success criteria: ...
Will not do: ...
```

只询问高影响歧义。低风险歧义使用安全默认值继续。

### 3. Decide：区分风险

| 风险级别 | 默认处理 | 示例 |
| --- | --- | --- |
| 低风险、可逆 | 使用安全默认值继续 | 文案、小命名、本地脚本修正 |
| 中风险、多文件 | Preview 后再 Apply | 新文档布局、命令入口、共享包拆分 |
| 高风险、不可逆或冲突 | 先问用户 | 删除文件、大迁移、破坏性数据库变更、公开 API break、认证/权限变化 |

不要为了显得谨慎而提问。风险高时也不要假装确定。

### 4. Preview：说明计划 diff

重大改动前说明：

```text
Will change: ...
Files touched: ...
Files not touched: ...
Reason: ...
Verification: ...
Risk/rollback: ...
```

如果用户已明确授权直接编辑，可以压缩成一句话。

### 5. Apply：只改必要文件

默认约束：

- 不删除未知文件。
- 不覆盖用户内容。
- 未获批准不做大规模移动目录。
- 小补丁能解决时，不重写已有实现。
- 不新增依赖，除非必要且解释原因。
- 不格式化整个仓库，除非项目命令要求。
- 匹配仓库现有风格，而不是强行套用本 skill 示例。

每个 changed line 都应能追溯到用户请求或验证失败。

### 6. Verify：证明或说明

优先使用已有命令。常见顺序：

```bash
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

或项目已有入口：

```bash
make check
just check
task check
./manage.sh check all
```

如果无法验证，准确说明原因，并给出用户可运行的命令。不要用 silent fallback 掩盖失败。

### 7. Handoff：紧凑交接

结束时报告：

- 改了什么；
- 验证了什么；
- 什么失败或未运行；
- 剩余风险；
- 下一轮从哪里开始。

### 8. Compact：更新上下文，不复制历史

长线项目只把仍会影响未来工作的判断写入 `docs/current.md`。不要粘贴聊天记录。不要重复 README、architecture 或 roadmap 内容。

## 仓库形态指导

可以按 monorepo 边界思考，但不要强行做成 monorepo。只有当项目存在多个独立运行单元、共享 contracts/config/UI/core，或需要统一验证与 AI 协作规则时，monorepo 才有明显收益。

安全默认值：

> 按 monorepo 边界思考，但只创建当前真正需要的目录。

参考形态：

```text
<repo>/
  README.md
  AGENTS.md
  .env.example

  apps/
    admin-web/
    api/
    studio-web/
    worker/

  packages/
    ui/
    config/
    contracts/
    core/

  infra/
  scripts/
  docs/
```

如果项目已有一致约定，优先尊重现状。

### `apps/`

`apps/` 放运行单元，不是放所有代码。一个目录属于 `apps/`，通常意味着它能独立启动、构建、部署，或代表清晰的用户/服务/进程入口。

常见候选：

```text
apps/admin-web
apps/studio-web
apps/api
apps/worker
apps/desktop
apps/mobile
apps/cli
```

当 `api` 和 `worker` 是独立运行平面时，可以放在 `apps/`。

### `packages/` 或 `libs/`

共享可复用代码放在 `packages/` 或 `libs/`，不要放在 `apps/` 内。

典型共享区域：

```text
packages/ui
packages/contracts
packages/config
packages/core
```

默认依赖方向：

```text
apps/*      -> packages/*  允许
packages/*  -> apps/*      禁止
apps/A      -> apps/B      默认禁止
```

跨 app 协作应通过 HTTP、RPC、queue、event、OpenAPI、JSON Schema、protobuf 或 contracts package，而不是 app 之间直接 import。

## 文档模型

文档不是第二套系统。文档的价值是让下一个人或 AI 能准确继续。

最小有用文档：

```text
docs/
  README.md
  current.md
  roadmap.md
  reference/
    architecture.md
```

只有项目真的需要时才增加：

```text
docs/reference/operations.md
docs/reference/decisions.md
```

内容变大后再拆目录：

```text
docs/runbooks/
docs/decisions/
```

### `docs/current.md`

这是 AI 在根部协作说明之后优先读取的项目上下文文件。它回答：

- 当前目标；
- 背景和用户意图；
- 已确认方向；
- 不要改动的边界；
- 当前状态；
- 完成标准；
- 验证命令；
- 下一步从哪里继续。

它不是完整任务追踪器，也不是聊天记录。

### `docs/reference/`

只写当前事实：架构、模块职责、数据流、配置、API、协议、本地运行流程、部署现实。未实现内容必须标记 `Status: Not Implemented`，或移到 roadmap/current。

### `docs/roadmap.md`

写未来方向、阶段目标、非目标和长期边界。不要把 roadmap 条目写成当前事实。

### Operations 和 decisions

重复流程写成 operations/runbook。容易被未来 AI 推翻的决策写成 decision。

## 上下文读取顺序

不要每轮读全仓库。默认顺序：

```text
1. AGENTS.md 或等价 agent instructions
2. docs/current.md
3. docs/reference/architecture.md
4. 用户明确提到的文件
5. roadmap、operations、decisions 只在需要时读取
```

如果上下文不足，说明缺口；除非下一步是高风险改动，否则使用安全默认值继续。

## 命令入口和验证

项目需要一个稳定命令入口，但工具名不重要。

优先级：

1. 保留已有稳定命令，例如 `pnpm`、`make`、`just`、`task`、`cargo`、`go test`。
2. 如果没有统一入口，添加薄封装 `manage.sh`。
3. `manage.sh` 只做路由，不要把复杂业务逻辑藏进去。

README、AGENTS、CI 和 AI 交接应指向同一组命令。

## 可选决策快照

只有结构决策变复杂时才使用 `scaffold.plan.yaml`。它记录 AI 需要知道的判断，不替代真实项目配置。

示例：

```yaml
scaffold:
  contract_version: 5
  mode: existing
  execution_mode: preview_then_apply

repo:
  shape: monorepo
  app_dir: apps
  shared_dir: packages
  docs_entry: docs/current.md
  command_entry: pnpm

ai_collaboration:
  language: zh-first
  default_context:
    - AGENTS.md
    - docs/current.md
    - docs/reference/architecture.md
  preview_before_apply: true
  verify_after_apply: true
```

## 反模式

避免：

- 为了显得完整而创建空目录；
- 把文档拆得过细，导致没人知道读哪里；
- 把一个请求拆成几十个微任务；
- 把未来计划写进 reference docs；
- 每轮重新争论已确认的项目结构；
- 每个 app 使用不同命令约定；
- 把共享库放进 `apps/`；
- 让 `packages/` 依赖 `apps/`；
- 未批准就移动、删除或覆盖已有文件；
- 用 silent fallback 掩盖关键路径错误。

## 输出风格

足够明确，让下一步安全。复杂工作在编辑前给短计划，结束后给紧凑交接。简单工作保持简短，但仍说明验证状态。
