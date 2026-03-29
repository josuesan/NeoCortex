# QA

Run the QA phase for an initiative — functional validation.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/overview.md` for context.
- Read `initiatives/$ARGUMENTS/impact-matrix.md` for affected repos.
- Read `initiatives/$ARGUMENTS/qa-checklist.md` for the current checklist.

### 2. Spawn the qa agent

Spawn the **qa** agent to validate functional correctness across the initiative:

- Review test coverage for new and changed code in each affected repo
- Run existing test suites where possible
- Validate end-to-end scenarios across services (does the full data flow work?)
- Check edge cases: empty inputs, concurrent requests, timeouts, error handling
- Verify feature flags and fallback paths work correctly
- Validate cross-service data flows and contract compliance

### 3. Complete the checklist

Update `initiatives/$ARGUMENTS/qa-checklist.md`:
- Check items that pass `[x]`
- Leave unchecked items that fail or can't be verified `[ ]`
- Add notes explaining any failures or gaps
- Add any new checks that were discovered during validation

### 4. Report

Show the user:
- Checklist completion: X/Y items passing
- Any failures or gaps (with details)
- Scenarios that need manual verification
- Pass/fail recommendation
- If passing: "QA complete. Run `/security $ARGUMENTS` if not done, then `/ship $ARGUMENTS`."

Note: `/qa` and `/security` can be run in parallel.
