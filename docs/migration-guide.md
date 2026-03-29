# Migration Guide

How to adopt NeoCortex in your team.

## Starting Point: Already Using Claude Code

You already have `.claude/` in your repos. NeoCortex adds a coordinator workspace on top.

**Steps:**
1. Create a new directory for your coordinator workspace
2. Run `./install.sh /path/to/workspace`
3. Edit `config/services.yaml` to list your repos
4. Start using `/platform-change` for cross-repo work

**What changes:** You now start multi-repo work from the coordinator, not from individual repos.
**What stays the same:** Everything inside each repo. Their `.claude/`, their agents, their workflows.

## Starting Point: Already Using OpenSpec

Each repo has `openspec/` with proposals, designs, and tasks.

**Steps:**
1. Same as above — create coordinator workspace
2. Set `openspec_path: openspec` for each service in services.yaml
3. When builder enters a repo, it reads the OpenSpec for context

**What changes:** Cross-repo coordination now lives in the coordinator. Individual repo specs stay in each repo.
**What stays the same:** OpenSpec workflow per repo. Proposals, designs, tasks — all still local.

## Starting Point: Using Both

This is the ideal starting point. You already have the pieces.

**Steps:**
1. Create coordinator workspace
2. Configure services.yaml
3. Start your next initiative with `/platform-change`

## Step-by-Step First Initiative

```bash
# 1. Install
./install.sh ~/Projects/my-conductor

# 2. Configure
cd ~/Projects/my-conductor
# Edit config/services.yaml with your actual repos

# 3. Start Claude Code
./scripts/start-workspace.sh

# 4. Inside Claude Code, create and coordinate
/new-initiative my-first-initiative
# Edit initiatives/my-first-initiative/overview.md
/platform-change my-first-initiative
```

## What Changes in Daily Workflow

| Before | After |
|--------|-------|
| Open each repo separately | Start from coordinator with all repos |
| Track cross-repo state mentally | impact-matrix.md tracks it |
| Manually check branch/PR status | `/sync` command |
| Ad-hoc merge order | rollout.md defines it |
| No cross-repo QA/security checklist | Explicit checklists per initiative |

## What Stays the Same

- Each repo's internal workflow (git, tests, CI/CD)
- OpenSpec for repo-local specs
- Per-repo Claude Code settings and agents
- Your deploy pipeline
- Your monitoring and alerting

## Tips for Adoption

- Start with one initiative to learn the workflow
- Don't try to retrofit past work — use NeoCortex for new initiatives going forward
- Keep services.yaml updated as repos are added or removed
- Review and clean up completed initiatives periodically
