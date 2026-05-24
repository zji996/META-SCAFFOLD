# META-SCAFFOLD Current Context

## Current goal

Publish META-SCAFFOLD v5 as a reusable public skill repository that Codex can install first as a global skill, with per-project imports as secondary options.

## Confirmed direction

- Repository name: `META-SCAFFOLD`.
- Main reusable entry: `skills/meta-scaffold/SKILL.md`.
- Codex/OpenAI UI metadata entry: `skills/meta-scaffold/agents/openai.yaml`.
- Full contract source: `prompts/META-SCAFFOLD-v5.md`.
- Root README must explain convenient import methods.
- Public GitHub target assumed by install commands: `zji996/META-SCAFFOLD`.
- Preferred Codex install command uses the preinstalled skill installer:
  `python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py --repo zji996/META-SCAFFOLD --path skills/meta-scaffold`.
- Local pre-publish Codex install entry: `./scripts/install-codex-skill.sh`.

## Boundaries

- Keep the repository lightweight.
- Do not add package managers or build tools unless needed.
- Do not make templates look like mandatory architecture.
- Keep installation safe: append or create, avoid overwriting existing project files.

## Verification

```bash
./scripts/check.sh
```

## Next starting point

- Push the generated repository to GitHub as public.
- After publishing, run the Codex GitHub skill installer and README curl commands from a temporary target to verify imports.
