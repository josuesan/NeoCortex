# Review

Run the Review phase for an initiative — cross-repo integration review.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/impact-matrix.md` — check all repos are `done` or `in-review`.
- Read `initiatives/$ARGUMENTS/links.yaml` for branches and PRs.
- Read `initiatives/$ARGUMENTS/rollout.md` for the current deploy plan.
- Read `config/services.yaml` for dependencies.

### 2. Validate readiness

- If any repo is still `not-started` or `in-progress`, warn the user and suggest running `/build` first.
- If all repos are already past review, note it.

### 3. Spawn the reviewer agent

Spawn the **reviewer** agent to analyze all changed repos together:

- Validate API contract compatibility between repos (request/response formats match)
- Check that database migrations are safe (backward compatible during rollout)
- Verify merge order — which repos should be merged first based on dependencies
- Verify deploy order — which services should be deployed first
- Check for breaking changes that would cause failures during the deploy gap (when some services are updated and others aren't)
- Validate feature flags are in place where needed for safe rollout
- Check shared types, interfaces, and message formats for consistency

### 4. Update initiative files

- Update `rollout.md` with the reviewer's recommended merge and deploy order
- Update `impact-matrix.md` statuses to `in-review`

### 5. Report

Show the user:
- Review findings organized by severity: blockers, warnings, notes
- Recommended merge order (numbered list)
- Recommended deploy order (numbered list)
- Any backward compatibility concerns
- Next step: "Review complete. Run `/qa $ARGUMENTS` and/or `/security $ARGUMENTS`."

Note: `/qa` and `/security` can be run in parallel after review.
