# META-SCAFFOLD Contract v6.6

> 人工审阅版。运行时唯一内容源：`skills/meta-scaffold/`（`SKILL.md` + 按需 `references/`）。

## 目标

降低仓库长期理解成本：改动贴合真实系统；下一轮 agent 不依赖聊天历史也能继续；验证真实且与风险相称。

## 工作方式

- 按需加载：项目规则 →（需要时）`docs/current.md` → 与决策直接相关的文件。
- 小改：改并验证。结构调整或长目标：先对齐目标、事实、假设、成功标准和非目标。
- 高影响歧义才提问；其余按仓库惯例继续。
- 治理文件只写项目约束、授权边界和易丢决策。

## 授权

- 可逆且在请求范围内：推进。
- 删除/覆盖、大迁移、生产数据、force push、部署、认证、公开契约：按项目规则授权。
- 已批准计划中明确列出的高影响步骤：计划范围内不重复问；越界或与 ADR 冲突再确认。
- 提交 / 分支 / PR / 发布服从当前仓库。

## 结构与记忆

- 尊重现有形态；仅有明确收益时才新增边界或建议 monorepo。
- `apps/` → `packages/` 允许；反向禁止；跨 app 走契约或服务接口。
- 信息按寿命放入 current / ADR / reference / roadmap / `.local/plan`；current 不做工作日志。

## 验证与交接

- 优先已有验证入口；失败或未跑如实说明。
- 先报结果，再报验证、风险、工作区。
- 仅暂停、换会话或用户要求时产出自包含 handoff（见 `skills/meta-scaffold/references/handoff.md`）。

## 按需读取

- 结构 / 多服务 / 端口：`skills/meta-scaffold/references/repository-patterns.md`
- 交接模板：`skills/meta-scaffold/references/handoff.md`
- 安装：`skills/meta-scaffold/references/platforms.md`
