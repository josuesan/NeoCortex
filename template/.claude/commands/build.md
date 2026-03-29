# Build

Run the Build phase for an initiative — implement changes in each repo.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/overview.md` for context.
- Read `initiatives/$ARGUMENTS/impact-matrix.md` for per-repo status and dependencies.
- Read `initiatives/$ARGUMENTS/links.yaml` for current state.
- Read `config/services.yaml` for service topology and `openspec_path`.

### 2. Validate readiness

- Check that Plan phase has been completed (impact-matrix.md should have repos with impact types and dependency info filled in).
- If impact-matrix.md looks empty or incomplete, suggest running `/plan $ARGUMENTS` first.

### 3. Spawn the conductor

Spawn the **conductor** agent with the full initiative context. The conductor will:

#### a. Read each affected repo's CLAUDE.md
Before assigning any work, read and note each repo's conventions.

#### b. Determine parallelization
Based on the `depends_on` graph in services.yaml and impact-matrix.md:
- Identify repos with NO unmet dependencies → these can start immediately
- Identify repos that must wait for others to finish
- Group into rounds:
  - Round 1: all repos with no dependencies (parallel)
  - Round 2: repos whose dependencies were in Round 1 (parallel)
  - Round N: and so on...

#### c. Execute rounds
For each round, spawn **builder** agents (one per repo, concurrently where possible):

Each builder receives:
- The repo path and name
- What it needs to do (from impact-matrix.md)
- The repo's CLAUDE.md conventions
- Whether the repo uses OpenSpec
- The initiative overview for context

Each builder will:
1. Read the repo's CLAUDE.md and follow its rules
2. Create an OpenSpec change spec (if the repo uses OpenSpec)
3. Create branch `cortex/<slug>/<repo>`
4. Implement the changes
5. Run the repo's tests
6. Report back: what was done, integration notes, test results

#### d. After each round
- Update `impact-matrix.md` with new statuses
- Update `links.yaml` with branch names and PR URLs (if created)
- Check if the next round's dependencies are now met
- Proceed to next round or report completion

### 4. Report

Show the user:
- Per-repo: what was implemented, branch, test results
- What's done, what's still pending (if any)
- Any blockers encountered
- Integration notes from builders (things other repos need to know)
- Next step: "Build complete. Run `/review $ARGUMENTS` to start integration review."
