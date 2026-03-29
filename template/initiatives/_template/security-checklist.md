# Security Checklist: <slug>

## Data Exposure

- [ ] No sensitive data logged (PII, tokens, secrets)
- [ ] API responses don't leak internal details
- [ ] Error messages don't expose stack traces or system info
- [ ] Data at rest encryption maintained

## Authentication & Authorization

- [ ] New endpoints require authentication
- [ ] Authorization checks are in place for all operations
- [ ] No privilege escalation paths introduced
- [ ] Token/session handling is correct

## Secrets & Configuration

- [ ] No secrets hardcoded in source
- [ ] Environment variables used for sensitive config
- [ ] Secret rotation is possible without code changes
- [ ] Config changes don't require redeployment of unrelated services

## New Endpoints & Trust Boundaries

- [ ] New endpoints are documented
- [ ] Input validation on all new endpoints
- [ ] Rate limiting considered
- [ ] CORS policy is appropriate
- [ ] No new trust boundary violations

## Dependency Risks

- [ ] No new dependencies with known vulnerabilities
- [ ] Dependency versions are pinned
- [ ] No unnecessary new permissions or scopes

## Notes

<!-- Additional security observations -->
