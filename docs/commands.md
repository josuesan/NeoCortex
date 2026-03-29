# Commands

NeoCortex uses explicit phase commands — you always know what you're running and what to expect.

## Phase Commands

Run these in order. Each command runs one phase and reports results before you decide to continue.

### `/new-initiative <slug> <description>`

**Phase:** Think

Creates a new initiative by analyzing your repos and writing all 6 initiative files with real content.

- Reads `services.yaml` and scans each repo
- Reads each repo's CLAUDE.md and OpenSpec status
- Identifies affected services and dependencies
- Writes overview.md, impact-matrix.md, links.yaml, rollout.md, qa-checklist.md, security-checklist.md

### `/plan <slug>`

**Phase:** Plan

Deep analysis of affected repos via the **scout** agent.

- Validates and refines the impact matrix from `/new-initiative`
- Checks contracts, schemas, and integration points between repos
- Reports each repo's CLAUDE.md conventions and OpenSpec status
- Produces the parallelization plan and implementation order

### `/build <slug>`

**Phase:** Build

Implementation via **conductor** → **builder** agents. This is where parallelization happens.

- Conductor reads the dependency graph and groups repos into rounds
- Repos with no dependencies start in parallel (Round 1)
- Each builder reads the repo's CLAUDE.md, creates OpenSpec change (if applicable), implements, and runs tests
- When a round finishes, the next round's dependencies are met
- Updates impact-matrix.md and links.yaml after each repo completes

### `/review <slug>`

**Phase:** Review

Cross-repo integration review via the **reviewer** agent.

- Validates API contract compatibility between repos
- Recommends merge and deploy order
- Flags backward compatibility risks
- Updates rollout.md with recommended order

### `/qa <slug>`

**Phase:** QA (can run in parallel with `/security`)

Functional validation via the **qa** agent.

- Reviews test coverage across affected repos
- Validates E2E scenarios and edge cases
- Completes qa-checklist.md with pass/fail per item

### `/security <slug>`

**Phase:** Security (can run in parallel with `/qa`)

Security review via the **security** agent.

- Reviews data exposure, auth, secrets, trust boundaries
- Checks new endpoints and dependencies
- Completes security-checklist.md with findings by severity

### `/ship <slug>`

**Phase:** Ship

Merge and deploy coordination via **shipper** + **digest** agents.

- Validates all checklists are complete (blocks if not)
- Confirms merge order with user before proceeding
- Merges PRs in dependency order
- Generates final initiative summary via digest

## Utility Commands

### `/status <slug>`

Shows the current state of an initiative: phase, per-repo status, checklist completion, blockers, next actions.

### `/validate <slug>`

Checks initiative files for consistency: required files exist, states are valid, impact-matrix and links.yaml are in sync.

### `/sync <slug>`

Verifies that branches and PRs in links.yaml actually exist and match their recorded status.

## Typical Flow

```
/new-initiative my-change description of what to build
/plan my-change
/build my-change
/review my-change
/qa my-change            ← can run in parallel
/security my-change      ← with this one
/ship my-change
```

Use `/status my-change` at any point to check where you are.
