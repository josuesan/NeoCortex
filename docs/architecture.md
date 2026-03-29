# Architecture

## Design Model

NeoCortex follows an **initiative-first, repo-second** approach to distributed development.

### The Problem

In a microservices architecture, a single business change often spans multiple repositories. Each repo has its own lifecycle, spec, and PR — but the *initiative* is the real unit of work. Without coordination, you're managing a spreadsheet in your head.

### The Solution

```
┌─────────────────────────────────────────────┐
│           NeoCortex Workspace               │
│                                             │
│  initiatives/     config/     .claude/      │
│  ├── add-flow/    ├── services.yaml         │
│  │   ├── overview │   ├── conventions.yaml  │
│  │   ├── impact   │   └── rollout.yaml      │
│  │   ├── links    ├── agents/               │
│  │   ├── rollout  └── skills/               │
│  │   ├── qa                                 │
│  │   └── security                           │
│                                             │
│  Coordinates ──────────────────────────┐    │
│                                        │    │
└────────────────────────────────────────┼────┘
         │              │                │
         ▼              ▼                ▼
   ┌──────────┐  ┌──────────┐    ┌──────────┐
   │ auth-svc │  │billing-svc│   │web-client │
   │          │  │           │   │           │
   │ openspec/│  │ openspec/ │   │ openspec/ │
   │ (local)  │  │ (local)   │   │ (local)   │
   └──────────┘  └───────────┘   └──────────┘
```

### Three Layers

| Layer | Owns | Tool |
|-------|------|------|
| **Repo-local** | What changes in this service | OpenSpec |
| **Workspace** | How changes coordinate across services | NeoCortex |
| **Runtime** | Claude Code agents, skills, multi-repo sessions | Claude Code native |

## Phases

Every initiative moves through 7 sequential phases:

1. **Think** — Understand the problem. Human-driven.
2. **Plan** — Map impact, dependencies, parallel slices. Agent: scout.
3. **Build** — Implement changes repo-locally. Agent: builder (parallelizable).
4. **Review** — Cross-repo integration review. Agent: reviewer.
5. **QA** — Functional/E2E validation. Agent: qa.
6. **Security** — Security and config review. Agent: security.
7. **Ship** — Merge, deploy, rollout. Agent: shipper.

Review, QA, and Security can run in parallel after Build. Ship is always last.

## Agents

| Agent | Role | Modifies Code? |
|-------|------|----------------|
| conductor | Orchestrates the initiative | No |
| scout | Discovery and analysis | No |
| builder | Implements in one repo | Yes |
| reviewer | Cross-repo review | No |
| qa | Functional checks | No (updates checklist) |
| security | Security review | No (updates checklist) |
| shipper | Merge/deploy coordination | No (merges PRs) |
| digest | Summarizes state | No |

## Configuration

All project-specific configuration lives in `config/`:

- `services.yaml` — service registry with paths, owners, dependencies
- `conventions.yaml` — naming rules, valid states, documentation policy
- `rollout-defaults.yaml` — deploy phases, rollback triggers, monitoring requirements

This keeps agent prompts generic and reusable across projects.

## What NeoCortex Does NOT Do

- Replace OpenSpec (repo-local specs stay in repos)
- Run services or tests (delegates to Claude Code / shell)
- Manage infrastructure (no servers, queues, or databases)
- Auto-merge or auto-deploy without explicit confirmation
