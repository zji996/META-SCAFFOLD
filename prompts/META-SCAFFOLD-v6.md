# META-SCAFFOLD Contract v6.6

> 供人工审阅和不支持 Agent Skills 的环境使用。运行时唯一内容源是
> `skills/meta-scaffold/`：核心规则在 `SKILL.md`，细节按需放在 `references/`。

## 1. 目标

降低软件仓库的长期理解成本，而不是套统一模板。衡量标准是：

- 当前修改是否尊重真实系统和已确认方向。
- 结构是否减少依赖、所有权和验证歧义。
- 下一轮 agent 是否能在不依赖聊天历史的情况下继续。
- 验证结果是否真实、可复现、与风险相称。

## 2. 使用原则

`Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact`
是检查表，不是每个任务都要显式表演的固定流程。

- 单点问答或小改：Inspect、Apply、Verify、Handoff 即可。
- 多文件、结构变化或长目标：补充目标、事实、假设、成功标准、非目标和计划 diff。
- 只有高影响歧义才阻塞提问；低风险细节服从仓库惯例。
- 不把模型已有的通用编码能力重新写成规则。治理文件只保存项目约束、授权边界和容易丢失的决策。

## 3. 上下文加载

按需渐进加载：

1. 用户请求和当前目录生效的项目规则。
2. 涉及当前状态或多轮工作时读 `docs/current.md`。
3. 只读取与当前决策相关的 architecture、ADR、plan、命令入口和任务文件。

代码、配置和可运行行为是当前事实。文档冲突时指出漂移，不把旧文档当事实。

任何结论、交接或计划都应自包含。不要用“如前所述”“见上文”“继续之前的内容”代替关键状态。

## 4. 判断与授权

- 已确认方向优先，先理解现有边界再重新设计。
- 可逆且属于请求范围的修改可继续执行。
- 删除、覆盖、大迁移、生产数据、force push、部署、认证或公开契约等高影响操作，按项目规则取得授权。
- 已批准计划中明确列出的高影响步骤，在该计划范围内不重复请求授权；越界或与 ADR 冲突时重新确认。
- commit、分支、PR 和发布策略服从当前仓库，不由通用 skill 擅自规定。

## 5. 仓库结构

尊重仓库自然形态。只有在部署、所有权、复用或验证上有明确收益时才新增边界或推荐 monorepo。

采用 `apps/` 与 `packages/` 时，推荐依赖方向：

```text
apps/*      -> packages/*  允许
packages/*  -> apps/*      禁止
apps/A      -> apps/B      默认通过契约协作
```

跨运行单元使用 HTTP、RPC、queue、event、schema、protobuf 或 contracts package。不要为完整感创建空目录、抽象层或文档。

## 6. 项目记忆

按信息寿命选择位置，文件不存在时仅在有真实用途时创建：

- `docs/current.md`：近期焦点、阻塞、验证入口和短期下一步。
- `docs/decision/`：影响未来选择的原因；新 ADR supersede 旧 ADR。
- `docs/reference/`：当前真实系统。
- `docs/roadmap.md`：未来方向和阶段目标。
- `.local/plan/`：快速变化、可恢复且不入库的执行账本。

修复历史归 git。`docs/current.md` 不应成为完整工作日志，通常保持少量活跃项即可。

## 7. 验证

- 优先运行仓库已有命令入口，覆盖范围与改动风险相称。
- 无法运行时说明具体原因和未覆盖风险。
- 不把不存在的命令说成已执行，不用无关命令或 silent fallback 掩盖失败。
- README、项目规则和交接应指向同一套真实验证入口。

## 8. 交接与压缩

完成答复先写结果，再写验证、剩余风险和工作区状态。普通任务不强制生成额外交接提示词。

只有暂停、换会话、换 agent 或用户明确要求时，才产出自包含 handoff：HEAD、未提交文件、完成结果、实际验证、阻塞、下一步和最相关约束。模板见 `skills/meta-scaffold/references/handoff.md`。

只有仍影响未来工作的事实才写入 `docs/current.md`；稳定设计进入 reference/ADR，执行细节留在 plan/git。

## 9. 可选模式

以下内容不常驻核心上下文，仅在任务相关时读取：

- 仓库结构、文档、多服务、`.local/`、多实例端口：`references/repository-patterns.md`
- 跨会话交接模板：`references/handoff.md`
- Codex/Kilo 安装与发现：`references/platforms.md`

平台只影响 skill 的发现路径和 UI 元数据，不改变治理语义，也不应在核心规则里绑定具体工具名。
