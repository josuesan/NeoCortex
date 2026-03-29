# Workflow

End-to-end flow for a distributed initiative.

## Overview

```
Think → Plan → Build → Review ─┐
                         QA ────┤→ Ship
                         Security┘
```

## Phase 1: Think

**Goal:** Understand the problem and define the initiative.

**Who:** You (the human).

**Actions:**
1. Create the initiative: `/new-initiative <slug>`
2. Fill in `overview.md` — objective, scope, non-goals, risks
3. Don't worry about impact or implementation yet

**Output:** A clear overview.md that anyone can read and understand.

## Phase 2: Plan

**Goal:** Map impact across repos and plan the work.

**Key agent:** scout

**Actions:**
1. Run `/cortex <slug>` — it detects the Plan phase
2. scout analyzes all repos for impact
3. Populates `impact-matrix.md` with affected repos, types, dependencies
4. Identifies which repos can be worked in parallel
5. Proposes implementation order
6. Initializes `links.yaml` with service entries

**Output:** A complete impact-matrix.md and links.yaml ready for Build.

## Phase 3: Build

**Goal:** Implement changes in each repo.

**Key agent:** builder

**Actions:**
1. conductor reads impact-matrix.md
2. Identifies parallelizable repos (no unmet dependencies)
3. Spawns builder for each (parallel where safe)
4. Each implementer:
   - Creates branch `cortex/<slug>/<repo>`
   - Implements changes aligned with repo's OpenSpec
   - Runs tests
   - Creates PR
5. impact-matrix.md and links.yaml updated after each repo completes

**Output:** All repos have branches, implementations, and PRs.

## Phase 4: Review

**Goal:** Validate cross-repo compatibility.

**Key agent:** reviewer

**Actions:**
1. reviewer analyzes all changed repos together
2. Validates API contract compatibility
3. Checks merge order and deploy order
4. Flags backward compatibility risks
5. Updates rollout.md with recommended merge/deploy order

**Output:** Review findings, recommended merge order, updated rollout.md.

## Phase 5: QA

**Goal:** Validate functional correctness.

**Key agent:** qa

**Actions:**
1. qa reviews test coverage across repos
2. Validates E2E scenarios
3. Checks edge cases and fallback paths
4. Completes qa-checklist.md

**Output:** Completed qa-checklist.md with pass/fail status.

## Phase 6: Security

**Goal:** Validate security and configuration safety.

**Key agent:** security

**Actions:**
1. security analyzes all changes for security risks
2. Reviews data exposure, auth, secrets, trust boundaries
3. Completes security-checklist.md

**Output:** Completed security-checklist.md with findings.

> **Note:** Review, QA, and Security can run in parallel after Build is complete.

## Phase 7: Ship

**Goal:** Merge, deploy, and validate in production.

**Key agent:** shipper

**Actions:**
1. Verifies all checklists are complete (no unchecked blockers)
2. Confirms merge order with user
3. Merges PRs in order
4. Coordinates deploy per rollout.md
5. Monitors rollback triggers
6. Updates impact-matrix.md to `shipped`
7. digest generates final summary

**Output:** All repos merged and deployed. Initiative complete.

## File Updates Through Phases

| File | Think | Plan | Build | Review | QA | Security | Ship |
|------|-------|------|-------|--------|-----|----------|------|
| overview.md | Create | — | — | — | — | — | — |
| impact-matrix.md | — | Create | Update status | Update review | — | — | Update shipped |
| links.yaml | — | Create | Update branches/PRs | — | — | — | — |
| rollout.md | — | — | — | Update order | — | — | Update timestamps |
| qa-checklist.md | — | — | — | — | Complete | — | Verify |
| security-checklist.md | — | — | — | — | — | Complete | Verify |
