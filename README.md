# NeoCortex

A lightweight framework for coordinating distributed multi-repo initiatives using Claude Code.

## The Problem

A single initiative — a new feature, a migration, a compliance change — touches 3, 5, maybe 10 services. Each repo has its own spec, its own branch, its own PR. You end up tracking state across repos in your head, merging in the wrong order, and discovering integration issues after deploy.

**NeoCortex** adds a coordination layer on top of your existing repos and workflows. It doesn't replace anything — it connects everything.

## How It Works

Your repos stay where they are — as siblings in a directory. NeoCortex lives alongside them as the coordinator:

```
~/Projects/                     ← your projects directory
├── neocortex-workspace/        ← NeoCortex coordinator (installed here)
│   ├── config/services.yaml    ← points to sibling repos
│   ├── initiatives/            ← initiative state lives here
│   └── .claude/                ← agents, commands, skills
├── auth-service/               ← your repo (untouched)
├── billing-service/            ← your repo (untouched)
└── web-client/                 ← your repo (untouched)
```

- **Repos are NOT cloned inside NeoCortex.** They stay where they are. `services.yaml` references them with relative paths (`../auth-service`).
- **`start-workspace.sh` connects everything** by launching Claude Code with `--add-dir` for each repo.
- **Claude Code does the work** — 8 subagents handle discovery, implementation, review, QA, security, and shipping.
- **You drive with commands** — `/cortex`, `/new-initiative`, `/status`, `/sync`, etc.

No servers. No dashboards. No daemons. Just Markdown, YAML, and Claude Code.

---

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Your repos cloned as siblings in a directory (e.g., `~/Projects/`)
- `gh` CLI installed (for PR operations)

### Setup

```bash
# 1. Clone NeoCortex
git clone https://github.com/your-org/neocortex.git
cd neocortex

# 2. Install into your workspace
./install.sh ~/Projects/my-platform

# 3. Configure your services
cd ~/Projects/my-platform
```

Edit `config/services.yaml` with your actual repos:

```yaml
services:
  auth-service:
    local_path: ../auth-service
    owner: identity
    role: backend-service
    openspec_path: openspec
    depends_on: []

  billing-service:
    local_path: ../billing-service
    owner: payments
    role: backend-service
    openspec_path: openspec
    depends_on:
      - auth-service
```

### Your First Initiative

```bash
# 4. Launch Claude Code with all your repos
./scripts/start-workspace.sh
```

Then inside Claude Code — just describe what you want to do:

```
/new-initiative add-checkout-flow add credit card and debit checkout support
```

NeoCortex will:
1. Read your repos to understand your platform
2. Identify which services are affected and why
3. Write a proper `overview.md` with objective, scope, and real risks
4. Populate the `impact-matrix.md` with affected repos and dependencies
5. Set up `links.yaml`, checklists, and rollout plan — all with real content, not templates

Then coordinate the work:

```
/cortex add-checkout-flow    # drives the current phase forward
/status add-checkout-flow    # check progress anytime
```

---

## Commands Reference

All commands run inside Claude Code:

| Command | What it does |
|---------|-------------|
| `/new-initiative <slug> <description>` | Analyze repos and create a fully populated initiative |
| `/cortex <slug>` | Coordinate the initiative through its current phase |
| `/status <slug>` | Show initiative summary — per-repo status, checklists, blockers |
| `/validate <slug>` | Check initiative files for consistency and valid states |
| `/sync <slug>` | Verify branches and PRs match what links.yaml says |

### Typical session

```
/new-initiative migrate-auth-v2 replace legacy auth middleware with OAuth2 tokens
# → analyzes repos, writes overview, maps impact, creates checklists

/cortex migrate-auth-v2       # → Plan: scout deepens the analysis
/cortex migrate-auth-v2       # → Build: builder implements per repo
/status migrate-auth-v2       # check progress anytime
/cortex migrate-auth-v2       # → Review/QA/Security (can run in parallel)
/cortex migrate-auth-v2       # → Ship: merge + deploy in order
```

---

## Phases

Every initiative moves through 7 phases:

```
Think → Plan → Build → Review ─┐
                          QA ───┤→ Ship
                      Security ─┘
```

| # | Phase | What happens | Agent |
|---|-------|-------------|-------|
| 1 | **Think** | Define the initiative — objective, scope, risks | `/new-initiative` |
| 2 | **Plan** | Map impact across repos, identify parallel slices | scout |
| 3 | **Build** | Implement changes repo-locally, create branches + PRs | builder |
| 4 | **Review** | Cross-repo integration review, merge/deploy order | reviewer |
| 5 | **QA** | Functional validation, E2E scenarios, test coverage | qa |
| 6 | **Security** | Data exposure, auth, secrets, trust boundaries | security |
| 7 | **Ship** | Merge in order, deploy, monitor, rollback plan | shipper |

Review, QA, and Security can run in parallel. Ship is always last.

---

## Agents

8 subagents in `.claude/agents/`, each with a focused role:

| Agent | Role | Touches code? |
|-------|------|:---:|
| **conductor** | Orchestrates the initiative, coordinates all agents | No |
| **scout** | Analyzes repos — contracts, deps, migrations, impact | No |
| **builder** | Implements changes in a single repo | Yes |
| **reviewer** | Reviews cross-repo compatibility and merge order | No |
| **qa** | Validates functional correctness, completes QA checklist | No |
| **security** | Reviews security risks, completes security checklist | No |
| **shipper** | Coordinates merge and deploy sequence | No |
| **digest** | Summarizes PRs, blockers, risks, and readiness | No |

---

## Initiative Files

Each initiative lives in `initiatives/<slug>/` with 6 files:

| File | Purpose | Updated in |
|------|---------|-----------|
| `overview.md` | Objective, scope, risks | Think |
| `impact-matrix.md` | Per-repo status table (source of truth) | Plan → Ship |
| `links.yaml` | Branches, PRs, change IDs per service | Plan → Build |
| `rollout.md` | Deploy order, compatibility, rollback plan | Review → Ship |
| `qa-checklist.md` | Functional validation checklist | QA |
| `security-checklist.md` | Security review checklist | Security |

---

## Project Structure

```
your-workspace/
├── CLAUDE.md                            # Workspace instructions for Claude
├── config/
│   ├── services.yaml                    # Your service map (edit this)
│   ├── conventions.yaml                 # Naming, states, branch patterns
│   └── rollout-defaults.yaml            # Deploy/rollback defaults
├── initiatives/
│   ├── _template/                       # Initiative file templates
│   └── <slug>/                          # Your active initiatives
├── scripts/
│   └── start-workspace.sh              # Launch Claude Code with --add-dir
└── .claude/
    ├── settings.json                    # Permission defaults
    ├── rules/
    │   └── initiative-files.md          # File consistency rules
    ├── agents/
    │   ├── conductor.md                 # Orchestrator
    │   ├── scout.md                     # Discovery
    │   ├── builder.md                   # Implementation
    │   ├── reviewer.md                  # Integration review
    │   ├── qa.md                        # QA validation
    │   ├── security.md                  # Security review
    │   ├── shipper.md                   # Ship coordination
    │   └── digest.md                    # Status synthesis
    ├── commands/
    │   ├── new-initiative.md            # /new-initiative
    │   ├── validate.md                  # /validate
    │   ├── sync.md                      # /sync
    │   └── status.md                    # /status
    └── skills/
        └── cortex/
            └── SKILL.md                 # /cortex
```

---

## Relationship with OpenSpec

NeoCortex does **not** replace OpenSpec. They work at different levels:

| Level | Tool | Handles |
|-------|------|---------|
| **Repo** | OpenSpec | Proposal, design, tasks, spec deltas for one service |
| **Workspace** | NeoCortex | Impact matrix, dependencies, rollout, review, QA, security, ship |

You can use NeoCortex without OpenSpec — it just means your repos won't have local specs for the builder agent to reference.

---

## Configuration

All project-specific config lives in `config/`:

- **`services.yaml`** — your service registry (paths, owners, roles, dependencies)
- **`conventions.yaml`** — naming rules, valid states, branch patterns
- **`rollout-defaults.yaml`** — deploy phases, rollback triggers, monitoring

See [docs/config.md](docs/config.md) for full schema and examples.

---

## Documentation

| Doc | Description |
|-----|-------------|
| [Architecture](docs/architecture.md) | System model and design principles |
| [Workflow](docs/workflow.md) | End-to-end flow through all 7 phases |
| [Conventions](docs/conventions.md) | Naming, states, branches, impact types |
| [Agents](docs/agents.md) | All 8 agents — role, inputs, outputs, guidelines |
| [Skills](docs/skills.md) | The `/cortex` skill in detail |
| [Config](docs/config.md) | services.yaml, conventions.yaml, rollout-defaults.yaml |
| [Migration Guide](docs/migration-guide.md) | Adopting NeoCortex in existing teams |

---

## License

MIT — see [LICENSE](LICENSE).
