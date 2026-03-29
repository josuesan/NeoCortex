# Impact Matrix: policy-renewal-flow

| Repo | Owner | Impact Type | Status | Parallelizable | Depends On | Branch | PR | OpenSpec Change |
|------|-------|-------------|--------|----------------|------------|--------|----|-----------------|
| quoter | pricing | logic-change, api-change | done | yes | — | cortex/policy-renewal-flow/quoter | #87 | add-renewal-quote |
| offer-builder | pricing | logic-change | done | no | quoter | cortex/policy-renewal-flow/offer-builder | #45 | add-renewal-offer |
| order-orchestrator | ops | logic-change, config-change | in-review | no | offer-builder | cortex/policy-renewal-flow/order-orchestrator | #203 | add-renewal-processing |
