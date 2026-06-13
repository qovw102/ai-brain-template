<!-- my-ai-brain-global-policy:start -->
# Global Checkpoint Policy

When the user asks to create, update, review, or synchronize reusable skills, references, scripts, or shared agent knowledge, use the shared `brain-maintenance` Skill from `{{BRAIN_PATH}}\skills\brain-maintenance\SKILL.md`.

At the beginning of a new agent session, or before work that depends on shared skills/references, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "{{BRAIN_PATH}}\scripts\Sync-MyAiBrain.ps1" -Mode Pull
```

The sync script automatically pulls only when the worktree is clean and a fast-forward update is safe. If it reports local changes or diverged history, stop and explain what must be committed or resolved first.

For every user-requested action that changes files or project state:

1. Use the shared `auto-logging` Skill from `{{BRAIN_PATH}}\skills\auto-logging\SKILL.md`.
2. Update or create the project root `progress.md`.
3. Maintain a Markdown TODO checklist with completed and pending work.
4. Record verification results, decisions, blockers, and next steps.
5. Inspect Git status and diff, stage only related files, commit, and push automatically when a remote tracking branch exists.
6. Report the commit SHA and push result.

Do not create empty commits for read-only questions or actions with no project changes. Never commit secrets, tokens, authentication files, or unrelated user changes. Never force-push unless explicitly requested.
<!-- my-ai-brain-global-policy:end -->
