# meta-scaffold skill

Main entry:

```text
skills/meta-scaffold/SKILL.md
```

Use this skill when an AI agent needs to reason about repository shape, project governance, AI handoff, documentation layout, monorepo boundaries, context compression, or verification workflows.

Quick import into another project:

```bash
mkdir -p skills/meta-scaffold
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/main/skills/meta-scaffold/SKILL.md \
  -o skills/meta-scaffold/SKILL.md
```

Then reference it from `AGENTS.md` or `CLAUDE.md`.

Install into Codex global skills:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

Restart Codex after installation.
