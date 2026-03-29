# Configuration

All configuration lives in `config/`. These files are the only project-specific content — agents and skills are generic.

## services.yaml

The service registry. Maps every service in your platform.

```yaml
services:
  service-name:
    local_path: ../service-name      # Path relative to workspace root
    owner: team-name                  # Owning team
    role: backend-service             # Service role (see below)
    openspec_path: openspec           # Path to OpenSpec within the repo
    depends_on:                       # Runtime dependencies
      - other-service
```

### Roles

| Role | Description |
|------|-------------|
| `backend-service` | API or backend service |
| `frontend` | Web or mobile frontend |
| `worker` | Background worker or job processor |
| `gateway` | API gateway or BFF |
| `library` | Shared library or package |
| `infrastructure` | Infrastructure config (Terraform, K8s, etc.) |

### Tips

- `local_path` is relative to the workspace root — repos should be siblings
- `depends_on` affects implementation order and deploy order
- `openspec_path` is where builder looks for local specs

## conventions.yaml

Naming rules and valid states.

```yaml
naming:
  initiative_slug: kebab-case
  branch_pattern: "cortex/{initiative}/{repo}"
  change_id_pattern: "{initiative}-{repo}"

states:
  valid:
    - not-started
    - in-progress
    - in-review
    - blocked
    - done
    - shipped
```

### Customizing

- Add custom states if your workflow needs them (e.g., `needs-migration`, `canary`)
- Change branch pattern to match your org's conventions
- Add or remove phases if you don't need all 7

## rollout-defaults.yaml

Default configuration for the Ship phase.

```yaml
rollout:
  phases:
    - staging
    - canary
    - production

  canary:
    minimum_duration: 30m
    traffic_percentage: 10

  production:
    approval_required: true

rollback:
  triggers:
    - error_rate_spike
    - latency_p99_increase
    - failed_health_check
  automatic: false

monitoring:
  required: true
  minimum_observation_period: 15m
```

### Customizing

- Adjust rollout phases to match your deploy pipeline
- Set `automatic: true` for rollback if your platform supports it
- Add org-specific monitoring alerts
