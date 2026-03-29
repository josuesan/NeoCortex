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
- **You drive with explicit phase commands** — `/new-initiative`, `/plan`, `/build`, `/review`, `/qa`, `/security`, `/ship`

No servers. No dashboards. No daemons. Just Markdown, YAML, and Claude Code.

---

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Your repos cloned as siblings in a directory (e.g., `~/Projects/`)
- `gh` CLI installed (for PR operations)
- (Recommended) [RTK](https://github.com/rtk-ai/rtk) installed — reduces token consumption by 60-90% on shell commands

### Token Optimization with RTK

NeoCortex agents make heavy use of git, test runners, and file operations. RTK compresses these outputs before they hit the context window:

```bash
# Install RTK
brew install rtk

# Enable globally for Claude Code (creates a PreToolUse hook)
rtk init -g
```

This is optional but strongly recommended — especially for `/build` (test output) and `/ship` (git/gh operations).

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

Then drive each phase explicitly:

```
/plan add-checkout-flow      # deep analysis of affected repos
/build add-checkout-flow     # implement in each repo (parallelized)
/review add-checkout-flow    # cross-repo integration review
/qa add-checkout-flow        # functional validation
/security add-checkout-flow  # security review
/ship add-checkout-flow      # merge + deploy in order
/status add-checkout-flow    # check progress anytime
```

---

## Commands Reference

All commands run inside Claude Code:

### Phase commands

| Command | Phase | What it does |
|---------|-------|-------------|
| `/new-initiative <slug> <desc>` | Think | Analyze repos, create initiative with real content |
| `/plan <slug>` | Plan | Deep repo analysis via scout, refine impact matrix |
| `/build <slug>` | Build | Conductor parallelizes builders across repos |
| `/review <slug>` | Review | Cross-repo integration review |
| `/qa <slug>` | QA | Functional validation checklist |
| `/security <slug>` | Security | Security review checklist |
| `/ship <slug>` | Ship | Merge PRs in order, coordinate deploy |

### Utility commands

| Command | What it does |
|---------|-------------|
| `/status <slug>` | Show initiative summary — phase, per-repo status, blockers |
| `/validate <slug>` | Check initiative files for consistency and valid states |
| `/sync <slug>` | Verify branches and PRs match what links.yaml says |

### Typical session

```
/new-initiative migrate-auth-v2 replace legacy auth middleware with OAuth2 tokens
# → analyzes repos, writes overview, maps impact, creates checklists

/plan migrate-auth-v2         # scout does deep analysis
/build migrate-auth-v2        # conductor parallelizes builders per repo
/status migrate-auth-v2       # check progress

/review migrate-auth-v2       # cross-repo compatibility review
/qa migrate-auth-v2           # ← these two can run
/security migrate-auth-v2     # ← in parallel

/ship migrate-auth-v2         # merge + deploy in order
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
| # | Phase | Command | Agent |
|---|-------|---------|-------|
| 1 | **Think** | `/new-initiative` | (main session) |
| 2 | **Plan** | `/plan` | scout |
| 3 | **Build** | `/build` | conductor → builder(s) |
| 4 | **Review** | `/review` | reviewer |
| 5 | **QA** | `/qa` | qa |
| 6 | **Security** | `/security` | security |
| 7 | **Ship** | `/ship` | shipper + digest |

Review, QA, and Security can run in parallel. Ship is always last.

---

## Agents

8 subagents in `.claude/agents/`, each with a focused role:

| Agent | Role | Model | Touches code? |
|-------|------|-------|:---:|
| **conductor** | Orchestrates the initiative, coordinates all agents | sonnet | No |
| **scout** | Analyzes repos — contracts, deps, migrations, impact | sonnet | No |
| **builder** | Implements changes in a single repo | opus | Yes |
| **reviewer** | Reviews cross-repo compatibility and merge order | sonnet | No |
| **qa** | Validates functional correctness, completes QA checklist | sonnet | No |
| **security** | Reviews security risks, completes security checklist | sonnet | No |
| **shipper** | Coordinates merge and deploy sequence | haiku | No |
| **digest** | Summarizes PRs, blockers, risks, and readiness | haiku | No |

Only **builder** uses Opus (writes code). Analysis agents use Sonnet. Mechanical agents use Haiku.

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
    └── commands/
        ├── new-initiative.md            # /new-initiative (Think)
        ├── plan.md                      # /plan
        ├── build.md                     # /build
        ├── review.md                    # /review
        ├── qa.md                        # /qa
        ├── security.md                  # /security
        ├── ship.md                      # /ship
        ├── status.md                    # /status
        ├── validate.md                  # /validate
        └── sync.md                      # /sync
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
| [Commands](docs/commands.md) | All phase and utility commands |
| [Config](docs/config.md) | services.yaml, conventions.yaml, rollout-defaults.yaml |
| [Migration Guide](docs/migration-guide.md) | Adopting NeoCortex in existing teams |

---

## License

MIT — see [LICENSE](LICENSE).
