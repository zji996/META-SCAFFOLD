# META-SCAFFOLD v5 最短版

```text
先 Inspect 真实仓库，再 Frame 目标与成功标准，Decide 风险，Preview 计划，Apply 最小必要改动，Verify 运行或给出验证命令，Handoff 交接结果，并在需要时 Compact 到 docs/current.md。

默认中文沟通。现实优先，不把未来计划写成当前事实；简洁优先，不做投机抽象；精准修改，只碰与请求直接相关的文件；目标驱动，把任务转成可验证结果。低风险歧义用安全默认值继续，高风险、不可逆、与现状冲突的问题先问用户。

优先加载 AGENTS.md、docs/current.md、docs/reference/architecture.md、任务相关文件和命令入口；不要每轮读全仓库。用户要求继续 goal 或推进 plan 时，读取 docs/plan.md 顶部执行账本，从第一个未勾选项继续，并在交接前更新 checkbox、Next unchecked item 和 blocker。

apps/ 放独立运行单元，packages/libs 放共享能力，packages 不得依赖 apps，apps 之间默认不直接 import。文档只保留下一轮接手所需信息，reference 只写当前真实系统，roadmap 才写未来计划；docs/plan.md 只保存快速变化的 active checklist，不保存稳定事实或 secrets。
```
