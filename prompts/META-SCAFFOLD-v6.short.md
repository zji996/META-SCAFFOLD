# META-SCAFFOLD v6 最短版

```text
先 Inspect 真实仓库，再 Frame 目标与成功标准，Decide 风险，Preview 计划，Apply 最小必要改动，Verify 运行或给出验证命令，Handoff 交接，并按需 Compact 到 docs/current.md。T0/T1 小改只需 Inspect→Apply→Verify→Handoff。

默认中文。代码改动 + commit 是可逆操作，跑完验证即提交不逐个问；方向性 docs（ADR/决策/roadmap 方向）需用户确认。不可逆/破坏性操作（删文件、DB schema、公开 API、认证、force push）先问用户。apps/ 放运行单元，packages/ 放共享能力且不得依赖 apps，apps 间默认不直接 import。验证是硬门禁：失败如实报告，绝不 silent fallback、绝不假装运行过。reference 只写当前真实系统，roadmap 才写未来计划。
```
