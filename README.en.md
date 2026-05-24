# META-SCAFFOLD

> A reusable AI project-collaboration meta-prompt / skill.  
> Goal: make coding agents inspect the real repository first, apply the smallest necessary change, verify outcomes, and hand off cleanly.

META-SCAFFOLD v5 is not a directory template or framework template. It is a reusable project-governance skill that can be installed through raw URLs, Git submodule, Git subtree, `skills/`, `AGENTS.md`, `CLAUDE.md`, or Cursor rules.

Core protocol:

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

## Recommended install

If you use Codex, install META-SCAFFOLD into the global Codex skills directory first:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

Codex installs it to:

```text
${CODEX_HOME:-~/.codex}/skills/meta-scaffold
```

Restart Codex after installation. Before the GitHub repo is published, install from a local clone instead:

```bash
./scripts/install-codex-skill.sh
```

Replace an existing local install with:

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-codex-skill.sh
```

## Per-project install

Install everything into a target project:

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/scripts/install.sh | bash -s -- . all
```

Install only the skill:

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/scripts/install.sh | bash -s -- . skill
```

Manual install:

```bash
mkdir -p skills/meta-scaffold
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/skills/meta-scaffold/SKILL.md \
  -o skills/meta-scaffold/SKILL.md
```

Then add this to your project `AGENTS.md` or `CLAUDE.md`:

```markdown
Before inspecting, restructuring, documenting, or modifying this project, read and follow `skills/meta-scaffold/SKILL.md`.
```

## Other entry points

```bash
# Per-project AGENTS.md
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/templates/AGENTS.meta-scaffold.md -o AGENTS.md

# Per-project CLAUDE.md
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/templates/CLAUDE.meta-scaffold.md -o CLAUDE.md

# Cursor project rule
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/.cursor/rules/meta-scaffold.mdc -o .cursor/rules/meta-scaffold.mdc
```

## Versioned import

Submodule:

```bash
git submodule add https://github.com/zji996/META-SCAFFOLD.git vendor/META-SCAFFOLD
```

Subtree:

```bash
git subtree add --prefix=vendor/META-SCAFFOLD https://github.com/zji996/META-SCAFFOLD.git main --squash
```

## Main files

| Path | Purpose |
| --- | --- |
| `skills/meta-scaffold/SKILL.md` | Main reusable skill. |
| `skills/meta-scaffold/agents/openai.yaml` | Codex/OpenAI skill UI metadata. |
| `prompts/META-SCAFFOLD-v5.md` | Full v5 contract. |
| `prompts/META-SCAFFOLD-v5.short.md` | Short embeddable prompt. |
| `dist/AGENTS.md` | Single-file AGENTS distribution. |
| `dist/CLAUDE.md` | Single-file CLAUDE distribution. |
| `dist/CURSOR.mdc` | Single-file Cursor rule distribution. |
| `scripts/install.sh` | Installer for target projects. |
| `scripts/install-codex-skill.sh` | Local clone installer for Codex global skills. |
| `scripts/check.sh` | Repository integrity check. |

## Publish

```bash
cd META-SCAFFOLD
git init -b main
git add .
git commit -m "Initial Meta Scaffold v5 skill"
gh repo create zji996/META-SCAFFOLD --public --source=. --remote=origin --push
```

## License

MIT
