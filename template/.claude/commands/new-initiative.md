# New Initiative

Create a new initiative from the template.

## Arguments

`$ARGUMENTS` is the initiative slug (kebab-case, e.g., `add-checkout-flow`).

## Instructions

1. Validate that `$ARGUMENTS` is provided and is valid kebab-case (`^[a-z0-9]+(-[a-z0-9]+)*$`). If not, explain the format and ask for a valid slug.

2. Check if `initiatives/$ARGUMENTS/` already exists. If it does, report that and stop.

3. Copy `initiatives/_template/` to `initiatives/$ARGUMENTS/`.

4. In all files under `initiatives/$ARGUMENTS/`, replace these placeholders:
   - `<slug>` → the actual slug
   - `<date>` → today's date in YYYY-MM-DD format
   - `<NAME>` → the slug converted to Title Case (hyphens become spaces)

5. Report what was created:
   ```
   Initiative '<slug>' created at initiatives/<slug>/

   Files:
     - overview.md
     - impact-matrix.md
     - links.yaml
     - rollout.md
     - qa-checklist.md
     - security-checklist.md

   Next steps:
     1. Edit initiatives/<slug>/overview.md — define objective, scope, and risks
     2. Run /cortex <slug> to start coordination
   ```
