---
name: meta-scaffold
description: 治理软件仓库的结构、AI 协作上下文、决策记录、验证入口与交接。用于新建或重组仓库、维护 AGENTS/CLAUDE/rules、设计 monorepo 或 package 边界、整理 docs/current/ADR/roadmap、推进多轮实施计划，或压缩下一轮 agent 所需上下文；普通单点编码或问答无需触发。
license: MIT
metadata:
  author: zji996
  version: "6.8.0"
---

# META-SCAFFOLD

降低仓库长期理解成本：当前改动贴合真实系统，下一轮 agent 用更少上下文安全接手。

## 优化什么

- 尊重已确认方向与现有边界，再谈结构变化。
- 验证真实、与风险相称。
- 结论与交接脱离聊天历史仍可执行。
- 治理文件只写项目特有约束、授权边界和易丢决策。

## 先读什么

按需加载，不扫全仓：

1. 用户请求与生效的 `AGENTS.md` / `CLAUDE.md` / 平台规则
2. 涉及当前状态或多轮工作时：`docs/current.md`
3. 与当前决策直接相关的 architecture、ADR、plan、命令入口、任务文件

代码与真实配置优先于文档；发现漂移就指出。小改直接改并验证；结构调整或长目标才先对齐目标、事实、假设、成功标准和非目标。

## 能改什么

- 可逆且在请求范围内：按仓库惯例推进。
- 删除/覆盖、大迁移、生产数据、force push、部署、认证、公开契约：按项目规则授权；缺授权先问。
- 已批准计划中明确列出的高影响步骤：该计划范围内视为已授权；越界或与 ADR 冲突则再确认。
- 提交、分支、PR、发布策略服从当前仓库，不由本 skill 统一规定。
- 用当前 agent 提供的等价工具即可；平台能力不是业务规则。

## 跨 Agent 调用

需要把子任务交给其他 agent CLI 时，默认使用 Pi：

- 只委派目标清晰、可验收的任务；Pi 默认使用本机完整工具、extensions 与 skills，自主读取上下文和完成范围内工作。
- 使用 `pi --no-session -p` 一次性执行，并用外部超时限制无人值守进程；不额外缩减模型或工具能力。
- 提示词保持短而完整：任务、必要边界、成功标准和验证；仓库已有事实让 Pi 自行读取，不重复粘贴。
- 主控必须等子进程退出，自行复审 diff 并运行项目门禁；子 agent 不代替最终责任。

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
- 先报结果，再报验证、风险、工作区。
- 仅暂停、跨会话或用户要求时产出自包含 handoff；模板见 [references/handoff.md](references/handoff.md)。
- 仍影响未来工作的事实才写入 `docs/current.md`。

安装与平台发现见 [references/platforms.md](references/platforms.md)。
