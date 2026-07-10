---
name: meta-scaffold
description: 治理软件仓库的结构、AI 协作上下文、决策记录、验证入口与交接。用于新建或重组仓库、维护 AGENTS/CLAUDE/rules、设计 monorepo 或 package 边界、整理 docs/current/ADR/roadmap、推进多轮实施计划，或压缩下一轮 agent 所需上下文；普通单点编码或问答无需触发。
license: MIT
metadata:
  author: zji996
  version: "6.6.0"
---

# META-SCAFFOLD

目标不是套模板，而是降低仓库的长期理解成本：让当前修改贴合真实系统，让下一轮 agent 能用更少上下文安全接手。

## 工作方式

把 `Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact` 当检查表，不当仪式。

- 小任务：读相关上下文，完成修改，运行相称验证，直接报告结果。
- 结构调整、多文件变更或长目标：先说明目标、已确认事实、关键假设、成功标准和不做什么，再实施。
- 只在高影响歧义会改变方案或授权范围时提问；其余按仓库惯例和低风险默认继续。
- 不重复解释模型本来就具备的通用能力。只有项目规则、领域约束或失败后果值得写入治理文件。

## 读取上下文

按任务需要逐步加载，不一次读完整仓库：

1. 用户请求与当前目录生效的 `AGENTS.md`、`CLAUDE.md` 或平台规则。
2. `docs/current.md`，若存在且任务涉及当前状态或多轮工作。
3. 架构、ADR、plan、命令入口和任务文件，只读与当前决策直接相关的部分。

文档与代码冲突时，以可运行代码和真实配置为当前事实，同时指出文档漂移。不要用“见上文”“按之前说的”代替关键事实；输出和交接应在脱离聊天历史后仍可理解。

## 判断与授权

- 已确认方向优先于重新设计；先理解已有边界，再提出变化。
- 可逆、任务内的修改可按用户请求推进。删除、覆盖、大迁移、生产数据、force push、部署、认证或公开契约等高影响操作，遵循项目规则并在缺少授权时先问。
- 已批准计划中明确列出的高影响步骤可视为该计划范围内的授权；超出范围或与 ADR 冲突时重新确认。
- 不把平台能力或工具可用性写成业务规则。使用当前 agent 实际提供的等价工具即可。

## 仓库与依赖

- 尊重仓库现有形态。只有在部署、所有权、复用或验证成本上有明确收益时才新增 app/package 边界或建议 monorepo。
- 若采用 `apps/` 与 `packages/`：运行单元可依赖共享包，共享包不得反向依赖 app；跨 app 通过契约、RPC、HTTP、事件或队列协作。
- 不为“看起来完整”创建空目录、抽象层或文档。每个新增结构都应服务当前真实需求。
- 更详细的结构、文档和多服务模式，仅在相关任务中读取 [references/repository-patterns.md](references/repository-patterns.md)。

## 项目记忆

按信息寿命选择位置，不强制所有仓库都具备全部文件：

- `docs/current.md`：仍影响近期工作的焦点、阻塞、验证入口和下一步；删除已失效状态，修复历史交给 git。
- `docs/decision/`：影响未来选择的“为什么”；新决策 supersede 旧决策，不篡改历史。
- `docs/reference/`：当前真实系统；未实现内容明确标注。
- `docs/roadmap.md`：未来方向与阶段目标。
- `.local/plan/`：快速变化、可恢复的本地执行账本，不存稳定事实或 secrets。

只在信息确实会被后续 agent 使用时写文档。`docs/current.md` 应短于它所链接的材料，而不是成为完整工作日志。

## 验证与交接

- 优先运行仓库已有验证入口，覆盖范围与风险相称。命令不存在或失败时如实说明，不用无关命令或 silent fallback 制造通过感。
- 交接先讲结果，再讲验证、剩余风险和工作区状态。不要复述过程流水账。
- 只有在任务暂停、跨会话继续或用户明确要交接时，才生成可粘贴的 handoff prompt；模板见 [references/handoff.md](references/handoff.md)。普通完成答复不附模板。
- 只有仍会影响未来工作的事实才 compact 到 `docs/current.md`。

## 跨平台使用

核心语义对 Codex、Kilo Code 和其他 Agent Skills 实现保持一致；平台差异只放在安装、发现路径和可选 UI 元数据中。安装与同步见 [references/platforms.md](references/platforms.md)。
