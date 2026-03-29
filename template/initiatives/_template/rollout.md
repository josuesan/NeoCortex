# Rollout Plan: <slug>

## Deploy Order

Deploy services in this order:

1. <!-- first service — typically the one with no dependents -->
2. <!-- dependent services -->
3. <!-- frontend/consumer services last -->

## Backward Compatibility

- [ ] All API changes are backward compatible during rollout
- [ ] Database migrations are safe to run before code deploy
- [ ] Feature flags are in place for gradual rollout (if applicable)

## Monitoring

- [ ] Error rate alerts configured
- [ ] Latency P99 alerts configured
- [ ] Health check endpoints verified
- [ ] Dashboard links added below

| Service | Dashboard | Alert Channel |
|---------|-----------|---------------|
| | | |

## Rollback Triggers

- Error rate exceeds baseline by >5%
- P99 latency increases by >50%
- Health check failures on any service

## Rollback Procedure

1. Revert deployment in reverse order (last deployed → first deployed)
2. Verify health checks pass
3. Verify error rates return to baseline
4. Notify team in relevant channel
