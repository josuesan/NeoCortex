# NeoCortex Coordinator Workspace

This is a NeoCortex coordinator workspace for managing distributed multi-repo initiatives.

## Service Map

See `config/services.yaml` for the registry of all services, their paths, owners, and dependencies.

## Initiatives

Active initiatives live in `initiatives/<slug>/`. Each contains:
- `overview.md` — objective, scope, risks
- `impact-matrix.md` — per-repo status (source of truth)
- `links.yaml` — branches, PRs, change IDs
- `rollout.md` — deploy order and rollback plan
- `qa-checklist.md` — functional validation
- `security-checklist.md` — security review

Create a new initiative: `/new-initiative <slug> <description of what you want to achieve>`

## Commands

### Phase commands (run in order)
- `/new-initiative <slug> <description>` — Think: analyze repos, create initiative with real content
- `/plan <slug>` — Plan: deep analysis via scout, refine impact matrix
- `/build <slug>` — Build: conductor spawns builders per repo (parallelized)
- `/review <slug>` — Review: cross-repo integration review
- `/qa <slug>` — QA: functional validation checklist (can run parallel with /security)
- `/security <slug>` — Security: security review checklist (can run parallel with /qa)
- `/ship <slug>` — Ship: merge PRs in order, coordinate deploy

### Utility commands
- `/status <slug>` — show initiative summary and current phase
- `/validate <slug>` — check initiative file consistency
- `/sync <slug>` — validate branches/PRs match links.yaml

## Agents

Subagents in `.claude/agents/`:
- **conductor** — orchestrates the initiative
- **scout** — discovery and impact analysis (read-only)
- **builder** — implements changes in a single repo
- **reviewer** — cross-repo compatibility review
- **qa** — functional/E2E validation
- **security** — security and config review
- **shipper** — merge/deploy coordination
- **digest** — summarizes PRs and blockers

## Phases

1. **Think** — understand the problem
2. **Plan** — map impact, identify parallel slices
3. **Build** — implement repo-locally
4. **Review** — cross-repo integration review
5. **QA** — functional validation
6. **Security** — security/config review
7. **Ship** — merge, deploy, rollout

## Conventions

- Initiative slugs: `kebab-case`
- Branches: `cortex/<initiative-slug>/<repo-name>`
- Valid states: `not-started`, `in-progress`, `in-review`, `blocked`, `done`, `shipped`
- Always update `impact-matrix.md` and `links.yaml` when repo status changes
