# META-SCAFFOLD

> 一个可复用的 AI 项目协作元提示词 / Skill。  
> 目标：让 coding agent 先理解真实仓库，再做最小必要改动，并用验证和交接闭环结束任务。

META-SCAFFOLD v6 不是目录模板，也不是某个框架模板。它是一份**元提示词 / 协作契约**，适合发布成 public 仓库，然后被其他项目通过 raw URL、Git submodule、Git subtree、`skills/` 目录、`AGENTS.md`、`CLAUDE.md` 或 Cursor rules 引用。

v6 的核心：工具使用纪律、条件化子 Agent 编排、Spec/Plan 驱动开发、权限硬门禁，以及把完整契约压缩到约 410 行（合并重复、删除模型已知常识）。`prompts/META-SCAFFOLD-v6.md` 是唯一事实源。

核心协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

---

## 最方便的引用方法

以下命令默认 public 仓库地址为：

```text
https://github.com/zji996/META-SCAFFOLD
```

如果你 fork 或迁移到别的账号，把命令里的 `zji996/META-SCAFFOLD` 替换成你的仓库即可。

### 方式 A：安装到 Codex 全局 skills，推荐优先

如果你主要使用 Codex，优先把它安装到 Codex 的全局 skill 库：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

Codex 会安装到：

```text
${CODEX_HOME:-~/.codex}/skills/meta-scaffold
```

安装后重启 Codex，新的 skill 才会被加载。维护本仓库时，也可以从本地 clone 刷新当前 Codex 安装：

```bash
./scripts/install-codex-skill.sh
```

如果本地已经安装过，脚本会跳过。需要替换时：

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-codex-skill.sh
```

### 方式 B：一键安装到当前项目

在目标项目根目录运行：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh | bash -s -- . all
```

它会安装或追加：

```text
skills/meta-scaffold/SKILL.md
skills/meta-scaffold/agents/openai.yaml
AGENTS.md                      # 追加 META-SCAFFOLD 引用段，不覆盖已有内容
CLAUDE.md                      # 追加 META-SCAFFOLD 引用段，不覆盖已有内容
.cursor/rules/meta-scaffold.mdc
docs/current.md                # 文件不存在时才创建
docs/roadmap.md                # 文件不存在时才创建
docs/reference/architecture.md # 文件不存在时才创建
scaffold.plan.yaml             # 文件不存在时才创建
```

只安装 skill：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh | bash -s -- . skill
```

只安装文档模板：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh | bash -s -- . templates
```

### 方式 C：只复制 Skill 文件，轻量

```bash
mkdir -p skills/meta-scaffold
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/meta-scaffold/SKILL.md \
  -o skills/meta-scaffold/SKILL.md
```

然后在目标项目的 `AGENTS.md` 或 `CLAUDE.md` 里加一句：

```markdown
Before inspecting, restructuring, documenting, or modifying this project, read and follow `skills/meta-scaffold/SKILL.md`.
```

中文项目可以写成：

```markdown
当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程时，先读取并遵守 `skills/meta-scaffold/SKILL.md`。
```

### 方式 D：直接生成 AGENTS.md / CLAUDE.md

适合还没有 AI 协作入口的新项目：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/templates/AGENTS.meta-scaffold.md -o AGENTS.md
```

Claude Code 风格项目：

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/templates/CLAUDE.meta-scaffold.md -o CLAUDE.md
```

如果项目已有 `AGENTS.md`，建议追加而不是覆盖：

```bash
printf '\n\n---\n\n' >> AGENTS.md
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/templates/AGENTS.meta-scaffold.md >> AGENTS.md
```

### 方式 E：Cursor 项目规则

```bash
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/.cursor/rules/meta-scaffold.mdc \
  -o .cursor/rules/meta-scaffold.mdc
```

### 方式 F：Git submodule，适合长期跟随更新

```bash
git submodule add https://github.com/zji996/META-SCAFFOLD.git vendor/META-SCAFFOLD
mkdir -p skills
ln -s ../vendor/META-SCAFFOLD/skills/meta-scaffold skills/meta-scaffold
```

更新：

```bash
git submodule update --remote vendor/META-SCAFFOLD
```

### 方式 G：Git subtree，适合不想维护 submodule 的项目

```bash
git subtree add --prefix=vendor/META-SCAFFOLD https://github.com/zji996/META-SCAFFOLD.git main --squash
```

更新：

```bash
git subtree pull --prefix=vendor/META-SCAFFOLD https://github.com/zji996/META-SCAFFOLD.git main --squash
```

然后在 `AGENTS.md` 中引用：

```markdown
Read `vendor/META-SCAFFOLD/skills/meta-scaffold/SKILL.md` before structural, documentation, or code changes.
```

---

## 一句话提示词

```text
先 Inspect 真实仓库，再 Frame 目标与成功标准，Decide 风险，Preview 计划，Apply 最小必要改动，Verify 运行或给出验证命令，Handoff 交接结果，并在需要时 Compact 到 docs/current.md。
```

---

## 核心文件

| 路径 | 用途 |
| --- | --- |
| [`skills/meta-scaffold/SKILL.md`](./skills/meta-scaffold/SKILL.md) | 推荐入口。给支持 skills 的 agent 使用。 |
| [`skills/meta-scaffold/agents/openai.yaml`](./skills/meta-scaffold/agents/openai.yaml) | Codex/OpenAI skill UI 元数据。 |
| [`prompts/META-SCAFFOLD-v6.md`](./prompts/META-SCAFFOLD-v6.md) | 完整 v6 契约（唯一事实源）。适合人工审阅或复制进团队规范。 |
| [`prompts/META-SCAFFOLD-v6.short.md`](./prompts/META-SCAFFOLD-v6.short.md) | 最短可嵌入版。适合放到系统提示词或 AGENTS 顶部。 |
| [`dist/AGENTS.md`](./dist/AGENTS.md) | 单文件 AGENTS 分发版本。 |
| [`dist/CLAUDE.md`](./dist/CLAUDE.md) | 单文件 CLAUDE 分发版本。 |
| [`dist/CURSOR.mdc`](./dist/CURSOR.mdc) | 单文件 Cursor rule 分发版本。 |
| [`templates/AGENTS.meta-scaffold.md`](./templates/AGENTS.meta-scaffold.md) | 下游项目可直接复制的 `AGENTS.md` 模板。 |
| [`templates/CLAUDE.meta-scaffold.md`](./templates/CLAUDE.meta-scaffold.md) | 下游项目可直接复制的 `CLAUDE.md` 模板。 |
| [`templates/scaffold.plan.yaml`](./templates/scaffold.plan.yaml) | 可选的结构决策快照模板。 |
| [`templates/docs/current.md`](./templates/docs/current.md) | `docs/current.md` 上下文压缩模板。 |
| [`.cursor/rules/meta-scaffold.mdc`](./.cursor/rules/meta-scaffold.mdc) | Cursor 项目规则。 |
| [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) | Claude plugin 风格元数据。 |
| [`scripts/install.sh`](./scripts/install.sh) | 下游项目安装脚本。 |
| [`scripts/install-codex-skill.sh`](./scripts/install-codex-skill.sh) | 从本地 clone 安装到 Codex 全局 skills。 |
| [`scripts/check.sh`](./scripts/check.sh) | 本仓库结构检查脚本。 |

---

## 什么时候启用这个 Skill

- 新项目初始化。
- 既有项目治理。
- monorepo / `apps` / `packages` / `libs` / `services` 边界判断。
- 补 `README`、`AGENTS`、`docs/current.md`、`architecture`、`roadmap`。
- 修改已有代码但需要避免无关重构。
- 统一验证命令、命令入口或交接格式。

## 不是什么

META-SCAFFOLD 不是固定目录模板，也不是项目生成器。它规定的是 AI 如何读项目、做判断、改最小 diff、验证和交接。

---

## 维护这个仓库

仓库已经按 public 仓库分发，其他项目可以通过 Codex skill installer、raw URL、submodule 或 subtree 导入。维护时建议：

- 修改 skill、分发文件、安装脚本或文档后运行本地检查。
- 需要验证远端 raw URL 和 Codex GitHub 安装链路时运行远端 smoke test。
- 修改完成后提交并推送到 `main`。

```bash
./scripts/check.sh
./scripts/smoke-remote.sh
```

如果要从当前 clone 更新本机 Codex 安装：

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-codex-skill.sh
```

---

## 本仓库验证

```bash
bash scripts/check.sh
```

验证内容包括：必需文件存在、Skill frontmatter 存在、README 引用路径存在、plugin JSON 可解析、安装脚本可在临时目录安装成功。

远端 smoke test：

```bash
./scripts/smoke-remote.sh
```

## 版本

当前版本：`v6.4.1` / `Stable Draft`

## License

MIT
