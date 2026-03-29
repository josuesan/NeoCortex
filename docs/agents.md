# Agents

NeoCortex includes 8 specialized Claude Code subagents. Each is defined in `template/.claude/agents/`.

## conductor

**Role:** Initiative conductor.

**When:** Invoked by `/cortex` to orchestrate the full lifecycle.

**Reads:** overview.md, impact-matrix.md, links.yaml, rollout.md, services.yaml, each repo's CLAUDE.md
**Writes:** impact-matrix.md, links.yaml

**Key behaviors:**
- Never implements code directly — always delegates
- Reads each repo's CLAUDE.md before assigning work to the builder
- Passes repo-specific context (conventions, OpenSpec status) to the builder
- Respects service dependency graph
- Decides what can be parallelized
- Coordinates phase transitions

---

## scout

**Role:** Discovery and analysis.

**When:** Plan phase — analyzing repos to build the impact matrix.

**Reads:** All repos (code, contracts, schemas), services.yaml
**Writes:** Nothing (read-only by default)

**Key behaviors:**
- Inspects API contracts, interfaces, shared types
- Reads each repo's CLAUDE.md and reports conventions to the conductor
- Detects whether each repo uses OpenSpec and what format
- Detects migrations, feature flags, compatibility concerns
- Proposes implementation order
- Does NOT modify any code

---

## builder

**Role:** Single-repo executor. Respects each repo's own rules.

**When:** Build phase — implementing changes in one repository.

**Reads:** repo's CLAUDE.md, repo's .claude/rules/, repo's OpenSpec, impact-matrix.md, initiative overview
**Writes:** OpenSpec change spec (if repo uses OpenSpec), source code, branch creation

**Key behaviors:**
- **Reads the repo's CLAUDE.md FIRST** — the repo's rules govern implementation
- If the repo uses OpenSpec: creates change spec → implements → archives
- If not: implements directly from the initiative overview
- Works on ONE repo at a time
- Follows the repo's conventions (commit format, code style, test commands)
- Reports blockers instead of working around them

---

## reviewer

**Role:** Cross-repo compatibility reviewer.

**When:** Review phase — after all repos have implementations.

**Reads:** All repo branches, impact-matrix.md, rollout.md, services.yaml
**Writes:** Nothing (review output only)

**Key behaviors:**
- Validates API contract compatibility between repos
- Recommends merge and deploy order
- Flags backward compatibility risks
- Considers the "deploy gap" between services

---

## qa

**Role:** Functional validation.

**When:** QA phase — validating correctness across the initiative.

**Reads:** All repos, test suites, impact-matrix.md
**Writes:** qa-checklist.md

**Key behaviors:**
- Runs existing tests (doesn't write new ones unless asked)
- Focuses on cross-service scenarios over unit tests
- Missing E2E test for critical path = blocker
- Notes scenarios requiring manual verification

---

## security

**Role:** Security and configuration review.

**When:** Security phase — reviewing all changes for security risks.

**Reads:** All repo diffs, impact-matrix.md
**Writes:** security-checklist.md

**Key behaviors:**
- Analysis only — does not execute code
- Errs on the side of flagging potential issues
- Hardcoded secrets = always critical
- New endpoints without auth = blocker unless documented as public

---

## shipper

**Role:** Merge and deploy coordination.

**When:** Ship phase — after review, QA, and security are complete.

**Reads:** impact-matrix.md, links.yaml, rollout.md, checklists, rollout-defaults.yaml
**Writes:** rollout.md, impact-matrix.md (status updates)

**Key behaviors:**
- NEVER proceeds if checklists have unchecked blockers
- NEVER merges out of order without explicit approval
- Always confirms with user before merging/deploying
- Updates status in real-time

---

## digest

**Role:** Status summarizer.

**When:** Any time a summary is needed — after Build, before Ship, on demand.

**Reads:** impact-matrix.md, links.yaml, PR details (via gh), checklists
**Writes:** Nothing (produces summary output)

**Key behaviors:**
- One sentence per PR, not a full diff review
- Blockers must have an owner and next action
- Produces binary ship readiness assessment: ready or not
