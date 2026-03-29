# Conventions

## Initiative Slugs

- Format: `kebab-case`
- Examples: `add-checkout-flow`, `migrate-auth-v2`, `fix-billing-sync`
- Must match `^[a-z0-9]+(-[a-z0-9]+)*$`

## Branch Naming

- Pattern: `cortex/<initiative-slug>/<repo-name>`
- Examples:
  - `cortex/add-checkout-flow/auth-service`
  - `cortex/add-checkout-flow/web-client`

## Change IDs

- Pattern: `<initiative-slug>-<repo-name>`
- Used to link NeoCortex tracking to OpenSpec changes in each repo

## Valid States

| State | Meaning |
|-------|---------|
| `not-started` | Repo identified but no work begun |
| `in-progress` | Implementation underway |
| `in-review` | PR open, awaiting review |
| `blocked` | Waiting on a dependency or external factor |
| `done` | Implementation complete, PR approved |
| `shipped` | Merged and deployed to production |

## State Transitions

```
not-started → in-progress → in-review → done → shipped
                    ↓            ↓
                  blocked      blocked
```

Any state can transition to `blocked`. Blocked items should always have a note explaining what they're waiting on.

## Impact Types

Use these in impact-matrix.md:

| Type | Meaning |
|------|---------|
| `api-change` | New/modified API endpoints or contracts |
| `schema-change` | Database migration or schema modification |
| `config-change` | Environment variables, feature flags, settings |
| `logic-change` | Business logic modification |
| `ui-change` | Frontend/UI modification |
| `dependency-update` | Shared library or package update |
| `new-service` | Entirely new service or component |

## Documentation Updates

- Update initiative files as part of each phase transition
- impact-matrix.md and links.yaml must always be in sync
- Use `/validate <slug>` to check consistency
