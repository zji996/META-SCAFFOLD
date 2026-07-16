---
name: meta-scaffold
description: 治理软件仓库的结构、AI 协作上下文、决策记录、验证入口与交接。用于新建或重组仓库、维护 AGENTS/CLAUDE/rules、设计 monorepo 或 package 边界、整理 docs/current/ADR/roadmap、推进多轮实施计划，或压缩下一轮 agent 所需上下文；普通单点编码或问答无需触发。
license: MIT
metadata:
  author: zji996
  version: "6.9.0"
---

# META-SCAFFOLD

降低仓库长期理解成本：当前改动贴合真实系统，下一轮 agent 用更少上下文安全接手。

## 优化什么

- 尊重已确认方向与现有边界，再谈结构变化。
- 验证真实、与风险相称。
- 结论与交接脱离聊天历史仍可执行。
- 治理文件只写项目特有约束、授权边界和易丢决策。

## CI 默认策略

- 除非用户明确要求，不创建、恢复或主动扩展 GitHub Actions（`.github/workflows/`）等消耗托管计算时长的 CI。
- 优先复用仓库已有的本地编译、测试、lint 或统一检查入口，并把真实命令写入 agent 入口或项目文档；本地验证结果不得冒充远程 CI 结果。
- 已存在的 CI 属于项目现状，不因本策略擅自删除；若任务必须修改它，先确认用户请求或仓库规则已明确授权。

## 先读什么

按需加载，不扫全仓：

1. 用户请求与生效的 `AGENTS.md` / `CLAUDE.md` / 平台规则
2. 涉及当前状态或多轮工作时：`docs/current.md`
3. 与当前决策直接相关的 architecture、ADR、plan、命令入口、任务文件

代码与真实配置优先于文档；发现漂移就指出。小改直接改并验证；结构调整或长目标才先对齐目标、事实、假设、成功标准和非目标。

## 状态怎么写

- 分开记录 implementation/foundation、production enablement、default policy 与 validation evidence；不用单一 `Implemented` 覆盖四个维度。
- 区分 active plan、proposed next goal 与 historical completed goal；用户只确认方向时，不自动写成 active goal。
- 性能数字优先归档到专门 benchmark 文档；current/roadmap/ADR 保留定性结论与链接。证据等级按表格或章节标注，每组数字可追溯到 artifact、schema、环境与日期。

## 能改什么

- 可逆且在请求范围内：按仓库惯例推进。
- 删除/覆盖、大迁移、生产数据、force push、部署、认证、公开契约：按项目规则授权；缺授权先问。
- 已批准计划中明确列出的高影响步骤：该计划范围内视为已授权；越界或与 ADR 冲突则再确认。
- 仓库未另行规定且用户未禁止时，完整且通过相称验证的边界清晰改动默认创建原子本地 commit，作为可审阅 checkpoint；不得混入既有或无关改动，任务未完成或验证失败不为清理工作区而提交。
- 分支切换、push、建远程、PR 与发布服从当前仓库和用户授权，不由本 skill 自动扩张。
- 用当前 agent 提供的等价工具即可；平台能力不是业务规则。

## 跨 Agent 调用

需要把子任务交给其他 agent CLI 时，默认使用 Pi：

- 只委派目标清晰、可验收的任务；Pi 默认使用本机完整工具、extensions 与 skills，自主读取上下文和完成范围内工作。
- 将任务契约写入临时 prompt 文件，使用 `scripts/pi-json-stream.sh <timeout> <workdir> <prompt-file> <events-log>` 前台一次性执行；显式 workdir 固定 Pi 的项目上下文，三参数旧调用仍继承当前目录。
- 脚本只输出高信号过滤事件；主控持续消费生命周期、截断命令、写入路径、工具错误与阶段文本，原始 JSON 默认不落盘。
- 每 30–60 秒轮询增量；没有实质变化不重复汇报。需要追因时先查过滤日志，再查 artifact/diff 或定向重跑。
- 提示词保持短而完整：任务、必要边界、成功标准和验证；仓库已有事实让 Pi 自行读取，不重复粘贴。
- 主控必须等子进程真实退出，自行复审 diff 并运行项目门禁；中断后先确认 Pi 与外层超时进程均已停止，子 agent 不代替最终责任。

命令、提示词模板与进程生命周期见 [references/platforms.md](references/platforms.md)。

## 结构怎么定

- 尊重现有形态；仅当部署、所有权、复用或验证成本有明确收益时才新增边界或建议 monorepo。
- 采用 `apps/` / `packages/` 时：app → 共享包允许，反向禁止；跨 app 走契约 / RPC / HTTP / 事件 / 队列。
- 不为完整感建空目录或抽象层。细节见 [references/repository-patterns.md](references/repository-patterns.md)。

## 记到哪里

按信息寿命选择；缺文件时只在有真实用途时创建：

| 位置 | 放什么 |
| --- | --- |
| `docs/current.md` | 近期焦点、阻塞、验证入口、下一步；短于它所链材料 |
| `docs/decision/` | 影响未来选择的为什么；新 ADR supersede 旧 ADR |
| `docs/reference/` | 当前真实系统；未实现须标注 |
| `docs/roadmap.md` | 未来方向与阶段目标 |
| `.local/plan/` | 仅存仍在推进、需要恢复的本地账本；完成后迁移稳定事实并删除，不存 secrets |

## 如何收尾

- 跑仓库已有验证，范围与风险相称；失败或未跑如实说明。
- 修改状态、术语或文档布局后，搜索整个治理文档树的旧措辞与同义表述，并核对链接与至少一个代码/配置权威来源。
- 先报结果，再报验证、风险、工作区。
- 仅暂停、跨会话或用户要求时产出自包含 handoff；模板见 [references/handoff.md](references/handoff.md)。
- 仍影响未来工作的事实才写入 `docs/current.md`。

安装与平台发现见 [references/platforms.md](references/platforms.md)。
