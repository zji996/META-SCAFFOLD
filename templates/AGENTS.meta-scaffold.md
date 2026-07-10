# AGENTS.md

本项目使用 META-SCAFFOLD v6.6 处理仓库治理、结构、项目记忆、验证入口和跨会话交接。

相关任务先读取 `skills/meta-scaffold/SKILL.md`。核心约定：

- 按任务需要读取上下文，不一次加载完整仓库。
- 小任务直接修改并验证；结构调整或长目标才显式说明事实、假设、成功标准和计划。
- 尊重现有仓库形态，不把 monorepo、commit、sub-agent 或平台工具当全局默认。
- 高影响操作遵循本项目授权规则；已批准计划内步骤不重复阻塞。
- 优先运行已有验证入口，失败或未运行如实说明。
- 项目记忆按寿命放入 current、ADR、reference、roadmap 或 local plan。
- 输出与交接必须自包含；仅在暂停或换会话时生成 handoff prompt。

建议上下文顺序：用户请求 → 本文件 → `docs/current.md`（若相关）→ 任务文件 → 必要的 architecture/ADR/plan/命令入口。

上游：<https://github.com/zji996/META-SCAFFOLD>
