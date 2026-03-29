# Skills

## /cortex

The primary skill for coordinating distributed initiatives.

### Usage

```
/cortex <slug>
```

### What It Does

When invoked with an initiative slug, the skill:

1. **Loads state** — reads all initiative files and config
2. **Determines phase** — assesses where the initiative currently is
3. **Executes the phase** — spawns the appropriate agents
4. **Updates state** — keeps initiative files in sync
5. **Reports status** — shows progress, blockers, and next steps

### Phase Detection

The skill auto-detects the current phase based on initiative state:

| Condition | Detected Phase |
|-----------|---------------|
| overview.md empty or missing | Think |
| impact-matrix.md empty | Plan |
| Some repos `not-started` or `in-progress` | Build |
| All repos `in-review` or beyond | Review |
| Review complete, QA checklist incomplete | QA |
| QA complete, security checklist incomplete | Security |
| All checks pass | Ship |

### Agents Spawned Per Phase

| Phase | Primary Agent | Supporting Agents |
|-------|--------------|-------------------|
| Think | (none — conversation) | — |
| Plan | scout | conductor |
| Build | builder | conductor |
| Review | reviewer | digest |
| QA | qa | — |
| Security | security | — |
| Ship | shipper | digest |

### Example Session

```
> /cortex add-checkout-flow

Loading initiative: add-checkout-flow
Phase detected: Plan

Running scout across 3 repos...
  auth-service: api-change (new /checkout/token endpoint)
  billing-service: logic-change + schema-change (checkout table)
  web-client: ui-change (checkout page)

Impact matrix updated.
Parallel slices: [auth-service, web-client] → then billing-service

Next: ready for Build phase. Run /cortex add-checkout-flow to proceed.
```

### Location

`template/.claude/skills/cortex/SKILL.md`
