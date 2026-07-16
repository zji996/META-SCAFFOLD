# AGENTS.md

## META-SCAFFOLD v6.9

仓库治理、结构调整、项目记忆或跨会话交接优先用 `meta-scaffold` skill。不支持 skills 时遵循：

- 按需读项目规则与相关文件；需要当前状态再读 `docs/current.md`。
- 小改直接改并验证；结构调整或长目标才先对齐目标、事实、假设、成功标准和非目标。
- 尊重现有形态；仅有明确收益时才新增边界或建议 monorepo。
- `apps/` → 共享包允许，反向禁止；跨 app 走契约或服务接口。
- 高影响操作按项目规则授权；已批准计划内明确步骤不重复阻塞。
- 仓库未禁止时，完整且验证通过的边界清晰改动默认创建不混入既有改动的原子本地 commit；push / PR / 发布仍按本仓库授权。
- 除非用户明确要求，不新增、恢复或扩展托管 CI；优先使用本地验证入口。
- 跨 agent 默认用 Pi `--no-session --mode json -p` 前台执行；持续观察进度、外部超时、串行写仓，主控复核验证。
- 优先已有验证；失败或未跑如实说明。
- 记忆按寿命放入 current / ADR / reference / roadmap；local plan 只留未完成账本。
- 结果自包含；仅暂停或换会话时生成 handoff。

运行时：`skills/meta-scaffold/SKILL.md`。
