# AGENTS.md

## META-SCAFFOLD v6.6

仓库治理、结构调整、项目记忆或跨会话交接任务优先使用 `meta-scaffold` skill。若当前 agent 不支持 skills，遵循以下最小契约：

- 先读用户请求、当前目录项目规则和直接相关文件；需要当前状态时再读 `docs/current.md`。
- 小任务直接修改并验证；多文件或结构调整才先说明目标、事实、假设、成功标准和非目标。
- 尊重现有仓库形态。只有部署、所有权、复用或验证成本明确受益时才新增 app/package 边界或建议 monorepo。
- 采用 `apps/`/`packages/` 时，允许 app 依赖共享包，禁止共享包反向依赖 app；跨 app 走契约或服务接口。
- 高影响操作按项目规则取得授权；已批准计划内明确步骤不重复阻塞。
- 优先运行已有验证入口；失败或未运行必须如实说明，不 silent fallback。
- 项目记忆按寿命放入 `docs/current.md`、ADR、reference、roadmap 或本地 plan，不把 current 写成工作日志。
- 结果和交接必须自包含，不使用“见上文”代替关键事实。只有暂停或换会话时才生成 handoff prompt。

运行时完整内容：`skills/meta-scaffold/SKILL.md`。
