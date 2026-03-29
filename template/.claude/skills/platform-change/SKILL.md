---
name: platform-change
description: Coordinate a distributed multi-repo initiative through all phases
arguments:
  - name: slug
    description: Initiative slug (kebab-case identifier)
    required: true
---

# /platform-change

Coordinate a distributed initiative across multiple repositories.

## When invoked with `<slug>`:

### 1. Load Initiative State

- Read `initiatives/<slug>/overview.md` — if it doesn't exist, offer to create the initiative using the template
- Read `initiatives/<slug>/impact-matrix.md` for per-repo status
- Read `initiatives/<slug>/links.yaml` for branches and PRs
- Read `initiatives/<slug>/rollout.md` for deploy plan
- Read `config/services.yaml` for the service topology

### 2. Determine Current Phase

Assess the current phase based on initiative state:

- **Think**: overview.md is empty or just created → help define the initiative
- **Plan**: overview.md is filled but impact-matrix.md is empty → run discovery
- **Build**: impact-matrix has repos but some are `not-started` or `in-progress` → implement
- **Review**: all repos are `in-review` or beyond → run integration review
- **QA**: review is complete → run QA validation
- **Security**: QA is complete → run security review
- **Ship**: all checks pass → coordinate merge/deploy

### 3. Execute Phase

#### Think
- Help the user define the initiative in overview.md
- Clarify scope, non-goals, and risks
- No agents needed — this is a conversation

#### Plan
- Spawn **scout** to analyze affected repos
- Build the impact-matrix.md with repos, impact types, dependencies
- Identify which repos can be worked in parallel
- Propose implementation order
- Update links.yaml with initial service entries

#### Build
- For each repo that is `not-started` or `in-progress`:
  - Check if it has unmet dependencies (another repo must be done first)
  - If parallelizable, spawn **builder** agents concurrently
  - If sequential, spawn them one at a time in dependency order
- After each repo completes, update impact-matrix.md and links.yaml

#### Review
- Spawn **reviewer** to analyze all changed repos
- Review merge order and deploy order
- Flag any backward compatibility issues
- Update rollout.md with recommended deploy order

#### QA
- Spawn **qa** to validate functional correctness
- Complete qa-checklist.md
- Report any gaps in test coverage or missing E2E scenarios

#### Security
- Spawn **security** to analyze security implications
- Complete security-checklist.md
- Report any findings that are blockers

#### Ship
- Spawn **shipper** to coordinate merge and deploy
- Verify all checklists are complete
- Confirm merge order with user
- Update impact-matrix.md as repos are merged and deployed
- Use **digest** to generate final summary

### 4. Report Status

After executing, always:
- Show current phase
- Show per-repo status from impact-matrix.md
- List any blockers
- Suggest next actions
