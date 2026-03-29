# Initiative: Policy Renewal Flow

| Field | Value |
|-------|-------|
| Slug | `policy-renewal-flow` |
| Created | 2025-03-01 |
| Owner | insurance-ops |
| Phase | review |

## Objective

Implement automated policy renewal for car insurance. When a policy approaches expiration, the system generates a renewal quote, presents it to the customer, and processes the renewal if accepted.

## Scope

### In Scope

- Renewal quote generation in quoter service
- Renewal offer creation in offer-builder
- Renewal order processing in order-orchestrator
- Renewal notification emails

### Out of Scope

- Premium recalculation based on claims history (separate initiative)
- Multi-policy bundle renewals
- Broker-initiated renewals

## Expected Outcome

Policies expiring within 30 days automatically get renewal quotes. Customers receive email with renewal offer. Accepted renewals are processed without manual intervention.

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Quote pricing mismatch with original | High | Validate against original quote parameters |
| Order-orchestrator renewal path untested | Medium | Add integration tests for renewal flow |
| Email delivery timing for 30-day window | Low | Configurable window, start with 30 days |

## Related Initiatives

- `cicl-assistance-communications` (parallel, different insurance subtype)
