# Changelog

## [0.1.0] — 2025-03-28

### Added

- Initial framework structure
- 8 subagent definitions (conductor, scout, builder, reviewer, qa, security, shipper, digest)
- `/platform-change` skill for initiative coordination
- Initiative template files (overview, impact-matrix, links, rollout, QA checklist, security checklist)
- Configuration system (services.yaml, conventions.yaml, rollout-defaults.yaml)
- Claude Code commands (`/new-initiative`, `/validate`, `/sync`, `/status`)
- Shell script (`start-workspace.sh`) for launching multi-repo sessions
- Full documentation (architecture, workflow, conventions, agents, skills, config, migration guide)
- Example initiatives (ecommerce-checkout, policy-renewal-flow)
- Install script for bootstrapping new workspaces
