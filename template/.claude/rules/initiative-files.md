# Initiative File Consistency Rules

When working with initiative files, follow these rules:

## Source of Truth

- `impact-matrix.md` is the central source of truth for per-repo status
- `links.yaml` must always match the actual branch and PR state
- When one file is updated, check if others need updating too

## State Validity

- Only use states defined in `config/conventions.yaml`
- Valid states: `not-started`, `in-progress`, `in-review`, `blocked`, `done`, `shipped`
- Never invent new states

## Sync Requirements

- When a branch is created, update both `impact-matrix.md` and `links.yaml`
- When a PR is opened, update the PR URL in both files
- When status changes, update it in both files
- When moving to a new phase, verify all files reflect current reality

## File Completeness

- Every initiative must have all 6 files: overview.md, impact-matrix.md, links.yaml, rollout.md, qa-checklist.md, security-checklist.md
- Use `/validate <slug>` to check consistency
