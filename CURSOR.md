# Cursor usage

Install the skill once at user scope:

```bash
./scripts/install-agent-skill.sh cursor
# or: ./scripts/install-agent-skill.sh all
```

This lands in `~/.cursor/skills/meta-scaffold/` and is discovered across projects. Do not copy `skills/meta-scaffold/` into consumer repos.

Optional compact project rule (governance bullets only; still points agents at `AGENTS.md`):

```text
.cursor/rules/meta-scaffold.mdc
```

```bash
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/dist/CURSOR.mdc -o .cursor/rules/meta-scaffold.mdc
```

Or scaffold AGENTS/CLAUDE/docs templates without vendoring the skill:

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh | bash -s -- . all
```
