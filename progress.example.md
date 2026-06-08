# AI Brain Progress

## Current State

- Brain path: `<BrainPath>`
- GitHub repository: `https://github.com/<your-user>/<your-ai-brain-repo>`
- Codex skills link: `$HOME\.agents\skills`
- Antigravity Editor skills link: `$HOME\.gemini\config\skills`
- Antigravity CLI skills link: `$HOME\.gemini\antigravity-cli\skills`

## Done

- [ ] Clone this repository on the first computer.
- [ ] Run `Setup-BrainOnWindows.ps1`.
- [ ] Confirm Codex and Antigravity can see shared skills.
- [ ] Install optional sync check scheduled task.

## Decisions

- Shared behavior goes in global rules.
- Repeatable workflows go in `skills/`.
- Long-form policies and background knowledge go in `references/`.
- Scripts should be safe by default and avoid overwriting local work.

## Verification

- [ ] PowerShell scripts parse successfully.
- [ ] `Sync-MyAiBrain.ps1 -Mode Check` works.
- [ ] Skills links point to `<BrainPath>\skills`.

## TODO

- [ ] Customize `skills/` and `references/` for your own workflow.
- [ ] Commit and push your first personalized version.

## Git Checkpoint

- Commit:
- Push:
