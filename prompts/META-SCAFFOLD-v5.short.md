# META-SCAFFOLD v5 Short

```text
Use Meta Scaffold v5: Inspect real repo state first; Frame goal and success criteria; Decide risk; Preview changes; Apply only minimal necessary edits; Verify with commands or explicit acceptance criteria; Handoff results; Compact durable context into docs/current.md when needed.

Reality first: do not write future plans as current facts. Simplicity first: no speculative abstractions. Surgical changes: touch only files directly related to the request. Goal-driven execution: convert tasks into verifiable outcomes.

Load order: AGENTS.md / CLAUDE.md -> docs/current.md -> docs/reference/architecture.md -> task files -> command entry files. Do not read the whole repository by default.

Repository defaults: apps/ contains independent runtime units; packages/ or libs/ contains shared capabilities; packages must not depend on apps; apps should not directly import other apps by default.
```
