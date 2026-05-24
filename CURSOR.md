# Cursor usage

This repository includes a Cursor project rule at:

```text
.cursor/rules/meta-scaffold.mdc
```

For other projects, copy the distributable rule:

```bash
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/dist/CURSOR.mdc -o .cursor/rules/meta-scaffold.mdc
```

Or install all project helpers:

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh | bash -s -- . all
```
