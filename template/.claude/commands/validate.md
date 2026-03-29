# Validate Initiative

Validate an initiative's files and state consistency.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

1. Check that `initiatives/$ARGUMENTS/` exists. If not, report and stop.

2. Check that all 6 required files exist and are non-empty:
   - `overview.md`
   - `impact-matrix.md`
   - `links.yaml`
   - `rollout.md`
   - `qa-checklist.md`
   - `security-checklist.md`

3. Read `config/conventions.yaml` to get the list of valid states.

4. Read `impact-matrix.md` and validate that every status value in the Status column is one of the valid states.

5. Read `links.yaml` and check:
   - Has an `initiative:` field matching the slug
   - Has a `services:` field
   - Each service entry has: `repo`, `repo_path`, `branch`, `status`

6. Cross-check: every repo in `impact-matrix.md` should have a corresponding entry in `links.yaml` and vice versa.

7. Report results as PASS/FAIL per check:
   ```
   Validating initiative: <slug>

   Required files:
     PASS  overview.md
     PASS  impact-matrix.md
     ...

   State validation:
     PASS  all states are valid

   Links validation:
     PASS  initiative field matches
     PASS  services field present

   Cross-check:
     PASS  repos consistent between impact-matrix.md and links.yaml

   Result: X error(s), Y warning(s)
   ```
