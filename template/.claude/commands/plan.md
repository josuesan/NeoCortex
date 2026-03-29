# Plan

Run the Plan phase for an initiative — deep analysis of affected repos.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/overview.md` — if it doesn't exist, tell the user to run `/new-initiative` first.
- Read `initiatives/$ARGUMENTS/impact-matrix.md` for the current repo list.
- Read `initiatives/$ARGUMENTS/links.yaml` for current state.
- Read `config/services.yaml` for the service topology and `openspec_path` per repo.

### 2. Deep discovery via scout

Spawn the **scout** agent with this task:

For each repo listed in impact-matrix.md (and any others that might be affected):

- Read the repo's `CLAUDE.md` and `.claude/rules/` — report conventions
- Check if the repo uses OpenSpec (look at `openspec_path` from services.yaml)
- Inspect API contracts, interfaces, shared types between affected repos
- Check database schemas for required migrations
- Check for feature flags or backward compatibility concerns
- Look for existing branches or PRs related to this initiative
- Verify the dependency analysis from `/new-initiative` is correct

### 3. Refine initiative files

Based on scout's findings, update:

- **impact-matrix.md** — correct impact types, dependencies, parallelization flags
- **links.yaml** — update service entries if new repos were discovered or some were removed
- **rollout.md** — refine deploy order based on deeper dependency analysis

### 4. Report

Show the user:
- Per-repo summary: what was found, conventions, OpenSpec status
- Dependency graph: what depends on what
- Parallelization plan: what can run concurrently in Build
- Implementation order: sequential chain
- Any new risks or concerns discovered
- Confirmation: "Ready for Build. Run `/build $ARGUMENTS` to start implementation."
