# Impact Matrix: add-checkout-flow

| Repo | Owner | Impact Type | Status | Parallelizable | Depends On | Branch | PR | OpenSpec Change |
|------|-------|-------------|--------|----------------|------------|--------|----|-----------------|
| auth-service | identity | api-change | done | yes | — | cortex/add-checkout-flow/auth-service | #142 | add-checkout-session |
| billing-service | payments | logic-change, schema-change | in-progress | no | auth-service | cortex/add-checkout-flow/billing-service | — | add-checkout-processing |
| web-client | frontend | ui-change | not-started | no | auth-service, billing-service | — | — | add-checkout-page |
