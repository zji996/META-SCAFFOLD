# CLAUDE.md

## META-SCAFFOLD v6

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩、工具使用纪律、子 agent 编排或验证流程时，先读取并遵守：

```text
skills/meta-scaffold/SKILL.md
```

默认协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

工具使用纪律：

- 独立读取/搜索并行发起；编辑前先读文件。
- 危险或不可逆命令默认不执行；长进程用进程管理工具不用 `&`/`nohup`。

子 Agent 编排（条件化，不强求）：任务可拆成独立、无共享写、自包含且够重的子任务时才并行分发；不擅长则回退串行。

默认上下文顺序：

1. `CLAUDE.md` / `AGENTS.md`
2. `docs/current.md`
3. `docs/reference/architecture.md`
4. 任务明确提到的文件
5. `.local/plan/plan.md` 只在用户要求继续 goal、推进 plan 或该文件被明确提到时读取
6. roadmap、operations、decisions 只在需要时读取

修改后尽量运行已有验证命令。如果无法验证，说明原因并给出准确命令。验证是硬门禁：失败不静默换命令，不假装运行过。

如果项目使用 `.local/plan/plan.md`（推荐，与本地产物同归 `.local/`，整体 gitignore）或 `docs/plan.md` 等 active goal 文件推进多轮任务，文件顶部应有 `Goal Execution Ledger` 和 Markdown checkbox。继续 goal 时从第一个未勾选项接着做，交接前更新 checkbox、`Next unchecked item` 和 blocker；稳定事实仍写入 `docs/current.md`、roadmap 或 reference。

Goal 预授权：把会触发硬门禁的不可逆操作（建表/迁移、认证、契约改动）作为 task 写进 goal。用户确认 plan 即对该 goal task 范围预授权，推进时直接执行不逐个问；只有超出 task 范围、与决策冲突或不可回滚操作（force push、删生产数据）才停下问。goal 内的 schema/设计 proposal 与决策一致即自动放行执行，不二次确认。

Commit 纪律：代码改动 + commit 是可逆操作（git 兜底），跑完验证门禁即提交，不逐个问——commit 是 checkpoint 便于 review，不是定案。方向性 docs 写入（新建 ADR、改写决策记录、roadmap 方向变更）需用户确认后再提交；`docs/current.md` 客观状态更新除外。
