# QA Checklist: <slug>

## Functional Checks

- [ ] Core happy path works end-to-end
- [ ] Error states are handled correctly
- [ ] Input validation works as expected
- [ ] Response formats match contracts

## E2E Scenarios

- [ ] <!-- Scenario 1: describe the flow -->
- [ ] <!-- Scenario 2: describe the flow -->

## Edge Cases

- [ ] Empty/null inputs handled
- [ ] Concurrent requests handled
- [ ] Large payloads handled
- [ ] Timeout scenarios handled

## Feature Flags / Fallbacks

- [ ] Feature flag toggles work correctly (if applicable)
- [ ] Fallback paths work when flag is off
- [ ] No degradation for existing users

## Cross-Service Validation

- [ ] Contracts between services match
- [ ] Data flows correctly through the full pipeline
- [ ] No orphaned or inconsistent state between services

## Notes

<!-- Additional QA observations -->
