# Sync Links

Validate that branches and PRs in links.yaml match actual git/GitHub state.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

1. Read `initiatives/$ARGUMENTS/links.yaml`.

2. For each service entry:

   a. **Check repo path exists**: verify the `repo_path` directory exists.

   b. **Check branch exists**: run `git -C <repo_path> rev-parse --verify <branch>` to confirm the branch exists locally. Also check remote with `git -C <repo_path> ls-remote --heads origin <branch>`.

   c. **Check PR status**: if `pr_url` is set (not null), run `gh pr view <pr_url> --json state,mergeable,reviewDecision` to get the actual PR state.

   d. **Check status consistency**: compare the `status` in links.yaml against reality:
      - If status is `not-started` but branch exists → warning
      - If status is `done` or `shipped` but PR is still open → warning
      - If status is `in-review` but no PR exists → warning

3. Report findings per service:
   ```
   Syncing links for initiative: <slug>

     auth-service:
       OK    repo path exists
       OK    branch cortex/<slug>/auth-service exists
       OK    PR #142 is MERGED
       OK    status 'done' is consistent

     billing-service:
       OK    repo path exists
       MISS  branch cortex/<slug>/billing-service not found locally
       WARN  status is 'in-progress' but no branch exists

   Summary: X issues found
   ```
