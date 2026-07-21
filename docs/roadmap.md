# META-SCAFFOLD Roadmap

## 近期

- 以 v6.11.0 作为 Pi/Codex/Kilo/Cursor 共用的目的驱动单 runtime 基线：Pi 委派使用前台 JSON 流，本地门禁优先于新增托管 CI，验证后的边界清晰改动默认创建原子本地 commit；多项目开发优先动态端口自省与单一系统入口。
- 用真实治理任务继续验证四维状态、goal 生命周期、benchmark 证据归档与 Pi 进程退出检查。
- 推进消费仓从 project-vendored skill 迁移到用户级 Pi package 或 vendor-neutral global install；仅需固定版本时保留项目级安装。
- 用误触发率、跨会话恢复率、常驻 token 成本评估，而不是规则行数。
- 检查消费仓是否仍引用已删除的 skill 章节，并把自动 commit 的覆盖条件及 push / PR / 发布授权留在各自 AGENTS。

## 后续

- 仅在真实 Agent Skills 实现需要时新增或调整薄适配器、remote manifest。

## 非目标

- 本仓库不是项目生成器。
- 不强制 monorepo、固定文档树、push / PR / 发布策略或 sub-agent 编排；消费仓可覆盖本地 commit 默认值。
- 不替代项目自身的架构、权限和发布决策。
