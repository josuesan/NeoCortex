# Ship

Run the Ship phase for an initiative — merge, deploy, and rollout.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/impact-matrix.md` for per-repo status.
- Read `initiatives/$ARGUMENTS/links.yaml` for PR URLs.
- Read `initiatives/$ARGUMENTS/rollout.md` for deploy plan.
- Read `initiatives/$ARGUMENTS/qa-checklist.md` — must be complete.
- Read `initiatives/$ARGUMENTS/security-checklist.md` — must be complete.
- Read `config/rollout-defaults.yaml` for rollout configuration.

### 2. Validate readiness

Check that all prerequisites are met:
- All repos are in status `done` or `in-review` (not `in-progress` or `blocked`)
- QA checklist: no unchecked blocker items
- Security checklist: no unchecked critical/high items
- All PRs exist and are in a mergeable state (check with `gh pr view`)

If any check fails, report what's missing and stop. Do NOT proceed with merge.

### 3. Spawn the shipper agent

Spawn the **shipper** agent with the merge/deploy plan:

#### a. Confirm with user
Before doing anything, present:
- The merge order (from rollout.md)
- The deploy order (from rollout.md)
- Any warnings or caveats
- Ask for explicit confirmation: "Proceed with merge? (yes/no)"

**Do NOT merge without user confirmation.**

#### b. Merge in order
For each repo in merge order:
1. Merge the PR (using `gh pr merge`)
2. Verify the merge succeeded
3. Update impact-matrix.md status to `shipped`
4. Update links.yaml
5. If any merge fails, stop and report

#### c. Update rollout
- Update `rollout.md` with actual merge timestamps
- Note the deploy order for the user to follow in their deploy pipeline

### 4. Generate summary

Spawn **digest** to produce a final initiative summary:
- Per-repo: what changed, PR link, merge status
- Any remaining action items (deploys, monitoring, etc.)
- Risks to watch post-deploy
- Mark the initiative phase as `shipped` in overview.md

### 5. Report

Show the user:
- All repos merged successfully (or what failed)
- Deploy order to follow
- Monitoring checklist from rollout.md
- Rollback procedure from rollout.md
- "Initiative shipped. Monitor for rollback triggers."
