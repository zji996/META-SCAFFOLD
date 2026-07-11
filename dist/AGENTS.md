# AGENTS.md

## META-SCAFFOLD v6.6

仓库治理、结构调整、项目记忆或跨会话交接优先用 `meta-scaffold` skill。不支持 skills 时遵循：

- 按需读项目规则与相关文件；需要当前状态再读 `docs/current.md`。
- 小改直接改并验证；结构调整或长目标才先对齐目标、事实、假设、成功标准和非目标。
- 尊重现有形态；仅有明确收益时才新增边界或建议 monorepo。
- `apps/` → 共享包允许，反向禁止；跨 app 走契约或服务接口。
- 高影响操作按项目规则授权；已批准计划内明确步骤不重复阻塞。
- 提交 / PR 策略服从本仓库规则。
- 跨 agent 只走 headless CLI；默认不互调、不并行双写；主控复核验证。
- 优先已有验证；失败或未跑如实说明。
- 记忆按寿命放入 current / ADR / reference / roadmap / local plan。
- 结果自包含；仅暂停或换会话时生成 handoff。

运行时：`skills/meta-scaffold/SKILL.md`。
