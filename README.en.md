# META-SCAFFOLD

> A repository-governance skill for coding agents: understand the real system, make the smallest necessary change, preserve recoverable project memory, and finish with honest verification.

META-SCAFFOLD v6.8 uses the [Agent Skills](https://agentskills.io/) format. The same runtime works with Pi, Codex, Kilo Code, Cursor, and other compatible agents.

It does not impose a directory template or restate generic coding ability. Its core covers only decisions that materially affect engineering outcomes: authorization boundaries, dependency ownership, durable project memory, self-contained handoffs, and verification integrity.

## One runtime

`skills/meta-scaffold/` is the runtime source of truth. `SKILL.md` stays concise; handoff, repository, and platform details live in `references/` and load only when relevant.

For skill-only Pi use, install the public repository once at user scope instead of vendoring it into every project:

```bash
pi install git:github.com/zji996/META-SCAFFOLD
pi update --extensions
```

The `skills/meta-scaffold/` path remains the standard package source layout; consuming projects do not need to copy it. Maintainers can run `make link-pi-local` for a live local checkout.

For the stable shell wrapper path at `~/.agents/skills/meta-scaffold/scripts/pi-json-stream.sh`, use the global Agent Skills installation below instead of the Pi package. Do not install both because Pi will report a skill-name collision.

Sync the same local clone to the vendor-neutral global directory, Codex, Kilo Code, and Cursor:

```bash
./scripts/install-agent-skill.sh all
```

Refresh an existing installation:

```bash
META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all
```

Default destinations:

- Agent Skills / Pi: `${META_SCAFFOLD_GLOBAL_SKILLS_ROOT:-~/.agents/skills}/meta-scaffold`
- Codex: `${CODEX_HOME:-~/.codex}/skills/meta-scaffold`
- Kilo Code: `${KILO_HOME:-~/.kilo}/skills/meta-scaffold`
- Cursor: `${CURSOR_HOME:-~/.cursor}/skills/meta-scaffold`

## GitHub installation

Codex:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo zji996/META-SCAFFOLD \
  --path skills/meta-scaffold
```

Kilo Code can load the same release through `kilo.jsonc`:

```jsonc
{
  "skills": {
    "urls": [
      "https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/skills/"
    ]
  }
}
```

The URL serves [`skills/index.json`](./skills/index.json).

## Project installation

```bash
curl -fsSL https://raw.githubusercontent.com/zji996/META-SCAFFOLD/refs/heads/main/scripts/install.sh \
  | bash -s -- . all
```

The installer copies the complete skill, appends thin AGENTS/CLAUDE references without overwriting existing content, installs the Cursor rule, and creates missing governance templates only when absent.

## v6.8 changes

- Pi user-level package installation and update are the recommended global workflow.
- Cross-agent delegation defaults to foreground Pi print mode with a JSON event stream, serial writes, and primary-agent review.
- Governance status separates implementation, production enablement, default policy, and evidence; proposed goals do not masquerade as active plans.
- Benchmark results stay traceable in dedicated evidence documents, and Pi completion requires the real process to exit rather than only the output channel closing.
- Monorepo, commits, subagents, and handoff prompts are no longer global defaults.
- Small tasks do not perform the full workflow as ceremony.
- Handoffs must be self-contained and may not depend on “see above.”
- Platform-specific Kilo tool names are removed from core governance.
- Multi-service, local-artifact, and multi-instance port patterns are progressive references.
- Runtime content has one source; prompts, dist files, and templates are review copies or thin adapters.

## Main files

| Path | Purpose |
| --- | --- |
| `skills/meta-scaffold/SKILL.md` | Concise runtime core |
| `skills/meta-scaffold/references/` | Progressive details |
| `skills/index.json` | Kilo remote manifest |
| `prompts/META-SCAFFOLD-v6.md` | Human-review contract |
| `scripts/install-agent-skill.sh` | Unified global/Codex/Kilo/Cursor sync |
| `scripts/install.sh` | Project installer |
| `scripts/check.sh` | Repository validation |

## Maintenance

```bash
./scripts/check.sh
make refresh-global
```

Version: `v6.8.4` / `Stable Draft`

## License

MIT
