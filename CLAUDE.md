# Claude Code Instructions: META-SCAFFOLD v6

处理项目检查、结构决策、文档、代码修改、验证和交接时，使用 META-SCAFFOLD v6。

本仓库的权威 skill 文件：

```text
skills/meta-scaffold/SKILL.md
```

复制到其他项目时，本文件可以单独使用。更推荐同时安装完整 skill：

```bash
mkdir -p skills/meta-scaffold
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md -o skills/meta-scaffold/SKILL.md
```

## 核心协议

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

## 规则

先 Inspect 真实仓库，再 Frame 目标与成功标准，Decide 风险，Preview 计划，Apply 最小必要改动，Verify 运行或给出验证命令，Handoff 交接结果，并按需 Compact 到 docs/current.md。

默认中文沟通。现实优先、最小改动、当前事实先于未来愿望。工具使用有纪律：独立读取/搜索批量并行、先读后改、危险命令默认不执行。子 agent 仅在任务可拆成独立、无共享写、自包含的子任务时并行分发；模型/平台不擅长则回退串行，不强求。中等复杂功能先写可验证 spec 再动手。

低风险歧义用安全默认值继续，高风险/不可逆/与现状冲突先问用户。apps/ 放运行单元，packages/ 放共享能力且不得依赖 apps，apps 间默认不直接 import。验证是硬门禁：失败如实报告，绝不 silent fallback、绝不假装运行过。文档只留下一轮接手所需信息，reference 只写当前真实系统，roadmap 才写未来计划。

## 工具使用纪律

- 独立的读取/搜索一次性并行发起，不串行浪费。
- 编辑前先读文件；对未读文件不做大范围 `replaceAll`。
- 用专用工具而非 shell 做文件操作（Read 而非 `cat`，Edit 而非 `sed`）。
- 开发服务器/watcher 用进程管理工具，不用 `&`/`nohup`。
- 危险或不可逆命令默认不执行，除非用户明确授权。

## 子 Agent 编排（条件化）

- 仅当任务可拆成独立、无顺序依赖、无共享写、自包含且够重的子任务时，才并行分发。
- 有顺序依赖、写同一文件、线性小任务时不分发。
- 模型/平台不擅长并行则回退串行；不把"用 subagent"写成硬性要求。

## 输出约束

非简单任务使用简洁状态更新：

```text
Goal: ...
Known facts: ...
Assumptions: ...
Success criteria: ...
```

编辑前：

```text
Will change: ...
Files: ...
Will not change: ...
Verification: ...
Risk: ...
```

交接时：

```text
Completed: ...
Changed files: ...
Verification: ...
Remaining risks: ...
Next step: ...
```

完整契约：`https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/prompts/META-SCAFFOLD-v6.md`。
