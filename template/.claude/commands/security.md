# Security

Run the Security phase for an initiative — security and configuration review.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

### 1. Load initiative state

- Read `initiatives/$ARGUMENTS/overview.md` for context.
- Read `initiatives/$ARGUMENTS/impact-matrix.md` for affected repos.
- Read `initiatives/$ARGUMENTS/security-checklist.md` for the current checklist.

### 2. Spawn the security agent

Spawn the **security** agent to review all changes for security risks:

- Check for sensitive data in logs (PII, tokens, secrets)
- Check API responses don't leak internal details or stack traces
- Verify authentication on all new/changed endpoints
- Verify authorization checks are in place
- Check for hardcoded secrets in source code (including test files)
- Review new trust boundaries and API surface changes
- Check input validation and sanitization on new endpoints
- Review CORS, rate limiting, and HTTP security headers
- Check new dependencies for known vulnerabilities
- Review environment variable and configuration changes

### 3. Complete the checklist

Update `initiatives/$ARGUMENTS/security-checklist.md`:
- Check items that pass `[x]`
- Leave unchecked items that fail or need attention `[ ]`
- Add notes with severity (critical, high, medium, low) for findings
- Add recommended remediations for any issues found

### 4. Report

Show the user:
- Checklist completion: X/Y items passing
- Findings organized by severity
- Recommended remediations
- Pass/fail recommendation
- If passing: "Security complete. Run `/ship $ARGUMENTS` when ready."

Note: `/qa` and `/security` can be run in parallel.
