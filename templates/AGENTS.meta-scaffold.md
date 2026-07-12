# AGENTS.md

本项目使用 META-SCAFFOLD v6.8 处理仓库治理、结构、项目记忆、验证与跨会话交接。

相关任务先读 `skills/meta-scaffold/SKILL.md`。核心约定：

- 按需读上下文；小改直接改并验证；结构调整或长目标才先对齐目标与计划。
- 尊重现有形态；结构与提交策略以本文件为准。
- 高影响操作遵循本项目授权规则；已批准计划内明确步骤不重复阻塞。
- 跨 agent 默认用 Pi `--no-session -p`；外部超时、串行写仓，主控复核验证。
- 优先已有验证；失败或未跑如实说明。
- 记忆按寿命放入 current / ADR / reference / roadmap；local plan 只留未完成账本。
- 输出自包含；仅暂停或换会话时生成 handoff。

建议顺序：用户请求 → 本文件 → `docs/current.md`（若相关）→ 任务文件 → 必要的 architecture/ADR/plan/命令入口。

上游：<https://github.com/zji996/META-SCAFFOLD>
