# New Initiative

Create and define a new initiative based on a user description.

## Arguments

`$ARGUMENTS` contains two parts separated by the first space:
- The **slug** (kebab-case identifier, e.g., `add-checkout-flow`)
- The **description** (everything after the slug — what the user wants to achieve, in natural language)

Example: `/new-initiative add-checkout-flow add credit card and debit checkout to the web app, needs auth tokens and payment processing`

If only a slug is provided without a description, ask the user what the initiative should accomplish before proceeding.

## Instructions

### 1. Parse and validate

- Extract the slug (first word) and description (rest of the arguments).
- Validate the slug is kebab-case (`^[a-z0-9]+(-[a-z0-9]+)*$`). If not, suggest a valid slug derived from their input.
- Check if `initiatives/$SLUG/` already exists. If it does, report it and ask if they want to continue with `/cortex` instead.

### 2. Understand the platform

- Read `config/services.yaml` to understand all available services, their roles, owners, dependency graph, and `openspec_path`.
- For each service listed, scan its codebase to understand:
  - What it does (API routes, main modules, domain)
  - Its contracts (API schemas, message formats, shared types)
  - Its current state (recent changes, open branches)
  - **Its CLAUDE.md** — read it to understand repo-specific conventions (commit format, code style, restrictions)
  - **Its OpenSpec status** — check if `openspec/` (or the configured `openspec_path`) exists. If yes, note the format and any existing specs

### 3. Analyze impact

Based on the user's description and your understanding of the repos:

- Identify which services are affected and why
- Classify the impact type per service (api-change, schema-change, logic-change, ui-change, config-change, etc.)
- Determine dependencies between the changes (what must be done before what)
- Identify which repos can be worked in parallel
- Flag potential risks (breaking changes, migrations, new trust boundaries)

### 4. Create the initiative files

Create `initiatives/$SLUG/` with all 6 files, fully populated (not templates):

**overview.md:**
- Write a clear, professional objective based on the user's description
- Define concrete scope (in-scope and out-of-scope) based on what you found in the repos
- Describe the expected outcome
- List real risks based on the codebase analysis (not generic placeholders)
- Use the user's intent but write it properly — structured, specific, actionable

**impact-matrix.md:**
- Fill the table with actual repos, owners (from services.yaml), impact types, and dependency info
- Set all statuses to `not-started`
- Mark parallelizable repos based on the dependency analysis
- Reference the branch names that will be used (cortex/$SLUG/$REPO)

**links.yaml:**
- Populate with all affected services
- Set repo_path from services.yaml
- Set branch names following the cortex/{slug}/{repo} convention
- Set all statuses to `not-started`
- Add notes explaining what each repo needs

**rollout.md:**
- Define the deploy order based on service dependencies
- Note backward compatibility considerations specific to this initiative
- Include relevant monitoring checks

**qa-checklist.md:**
- Write initiative-specific functional checks (not generic ones)
- Define E2E scenarios based on the actual data flow
- Include edge cases relevant to this specific change

**security-checklist.md:**
- Write initiative-specific security checks based on what's actually changing
- Focus on the real risks (new endpoints, data exposure, auth changes)
- Skip sections that don't apply to this initiative

### 5. Present the result

Show the user:
- A summary of what you found and created
- The list of affected repos with impact type
- The proposed implementation order
- Any risks or concerns worth discussing before proceeding
- The next step: `/cortex $SLUG` to start the Plan phase (where scout will do a deeper analysis)

### Important guidelines

- **Don't write placeholder content.** Every field should have real, useful content based on the repos.
- **Don't be generic.** "Validate inputs" is useless. "Validate that checkout session tokens include the billing_account_id claim" is useful.
- **Match the codebase.** Use actual service names, actual endpoint patterns, actual module names from the repos.
- **Be opinionated about scope.** If the user's description is vague, make reasonable scope decisions and flag them — don't leave blanks.
- **Keep it concise.** A good overview is 1 page, not 5. A good checklist has 8-15 items, not 50.
