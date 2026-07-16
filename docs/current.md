# META-SCAFFOLD Current Context

## Current focus

v6.9.0 makes a verified local commit the default completion checkpoint while keeping shared-state publication explicit: complete, scoped changes are committed atomically unless the repository or user opts out; push, remote creation, PRs, and releases still require repository/user authorization.

## Next

1. Measure false-trigger rate, cross-session recovery, and persistent context cost in real Pi/Codex/Kilo/Cursor work.
2. Audit consuming repositories for project-vendored copies and migrate them to user-level packages where version pinning is not required.
3. Measure whether the default local-commit checkpoint reduces dirty-worktree handoff cost without increasing mixed-scope commits; keep repository-specific overrides inline in consuming AGENTS.

## Confirmed

- Runtime source of truth: `skills/meta-scaffold/`; prompts, dist, and templates are thin review or compatibility surfaces.
- Repository structure and push/PR/release policy belong to the consuming repository.
- Unless a consuming repository or user opts out, complete scoped changes that pass proportionate verification receive an atomic local commit; existing/unrelated changes are never folded in merely to clean the worktree.
- The skill also keeps the general rule that explicitly approved plan steps do not require repeated authorization.
- Handoffs are self-contained and generated only for pauses, session changes, agent changes, or explicit requests.
- Codex, Kilo, and Cursor install the same directory; Kilo remote discovery uses `skills/index.json`.
- Pi uses either the user-level git package for skill-only consumption or `~/.agents/skills` for the stable delegation-wrapper path; the two installations must not coexist.
- Hosted CI is not added, restored, or expanded by default; existing CI remains project state, and local verification is reported honestly as local.
- Governance reviews separate implementation/foundation, production enablement, default policy, and validation evidence instead of collapsing them into one status label.
- Benchmark numbers live in dedicated evidence documents when practical; current/roadmap/ADR retain qualitative conclusions and links.
- Pi output-channel completion is not treated as process completion; the primary agent confirms the Pi and timeout processes exited before writing.
- Pi delegation uses foreground `--no-session --mode json -p`; the primary agent consumes lifecycle and tool events, summarizes material progress, and does not treat `--verbose` as a progress channel.
- The Pi wrapper binds an explicit workdir, resolves prompt/event paths against it, and keeps the legacy current-directory form only for compatibility.

## Boundaries

- Keep the Agent Skills runtime small and platform-neutral.
- Installers overwrite only an existing `meta-scaffold` destination and only with explicit force.
- Do not turn line count into the goal; retain rules that materially prevent authorization, verification, dependency, or handoff failures.

## Verification

```bash
./scripts/check.sh
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/meta-scaffold
```
