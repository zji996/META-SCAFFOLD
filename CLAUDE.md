# Claude Code Instructions: META-SCAFFOLD v5

处理项目检查、结构决策、文档、代码修改、验证和交接时，使用 META-SCAFFOLD v5。

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

先 Inspect 真实仓库，再 Frame 目标与成功标准，Decide 风险，Preview 计划，Apply 最小必要改动，Verify 运行或给出验证命令，Handoff 交接结果，并在需要时 Compact 到 docs/current.md。

默认中文沟通。现实优先，不把未来计划写成当前事实；简洁优先，不做投机抽象；精准修改，只碰与请求直接相关的文件；目标驱动，把任务转成可验证结果。低风险歧义用安全默认值继续，高风险、不可逆、与现状冲突的问题先问用户。

优先加载 AGENTS.md、docs/current.md、docs/reference/architecture.md、任务相关文件和命令入口；不要每轮读全仓库。apps/ 放独立运行单元，packages/libs 放共享能力，packages 不得依赖 apps，apps 之间默认不直接 import。文档只保留下一轮接手所需信息，reference 只写当前真实系统，roadmap 才写未来计划。


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

完整契约：`https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/prompts/META-SCAFFOLD-v5.md`。
