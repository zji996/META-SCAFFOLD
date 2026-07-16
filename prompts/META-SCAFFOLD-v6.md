# META-SCAFFOLD Contract v6.9

> 人工审阅版。运行时唯一内容源：`skills/meta-scaffold/`（`SKILL.md` + 按需 `references/`）。

## 目标

降低仓库长期理解成本：改动贴合真实系统；下一轮 agent 不依赖聊天历史也能继续；验证真实且与风险相称。

## 工作方式

- 按需加载：项目规则 →（需要时）`docs/current.md` → 与决策直接相关的文件。
- 小改：改并验证。结构调整或长目标：先对齐目标、事实、假设、成功标准和非目标。
- 高影响歧义才提问；其余按仓库惯例继续。
- 治理文件只写项目约束、授权边界和易丢决策。
- 除非用户明确要求，不创建、恢复或扩展 GitHub Actions 等托管 CI；优先使用并记录本地验证入口。已有 CI 不擅自删除，本地结果不冒充远程结果。

## 授权

- 可逆且在请求范围内：推进。
- 删除/覆盖、大迁移、生产数据、force push、部署、认证、公开契约：按项目规则授权。
- 已批准计划中明确列出的高影响步骤：计划范围内不重复问；越界或与 ADR 冲突再确认。
- 仓库未禁止且用户未要求保留未提交状态时，完整、边界清晰且通过相称验证的改动默认创建原子本地 commit；不混入既有或无关改动，未完成或验证失败不为清理工作区而提交。
- 分支切换、push、建远程、PR 与发布服从当前仓库和用户授权。

## 跨 Agent 调用

需要委派其他 agent CLI 时默认使用 Pi 前台 print mode + 高信号 JSON 流：把任务契约写入临时文件，通过 `scripts/pi-json-stream.sh <timeout> <workdir> <prompt-file> <events-log>` 在显式工作目录前台执行。Pi 使用本机完整能力；主控持续消费过滤事件并定期摘要实质进度，与 Pi 串行写仓，等待真实进程退出后自行复审 diff 并运行门禁。完整配置、输出安全与生命周期见 `skills/meta-scaffold/references/platforms.md`。

## 结构与记忆

- 尊重现有形态；仅有明确收益时才新增边界或建议 monorepo。
- `apps/` → `packages/` 允许；反向禁止；跨 app 走契约或服务接口。
- 信息按寿命放入 current / ADR / reference / roadmap / `.local/plan`；current 不做工作日志，完成的 local plan 迁移稳定事实后删除。

## 验证与交接

- 优先已有验证入口；失败或未跑如实说明。
- 先报结果，再报验证、风险、工作区。
- 仅暂停、换会话或用户要求时产出自包含 handoff（见 `skills/meta-scaffold/references/handoff.md`）。

## 按需读取

- 结构 / 多服务 / 端口：`skills/meta-scaffold/references/repository-patterns.md`
- 交接模板：`skills/meta-scaffold/references/handoff.md`
- 安装 / 跨 Agent CLI：`skills/meta-scaffold/references/platforms.md`
