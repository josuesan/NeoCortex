# Initiative Status

Render a summary of an initiative's current state.

## Arguments

`$ARGUMENTS` is the initiative slug.

## Instructions

1. Read `initiatives/$ARGUMENTS/overview.md` and extract: initiative name, owner, current phase.

2. Read `initiatives/$ARGUMENTS/impact-matrix.md` and build a per-repo status summary.

3. Read `initiatives/$ARGUMENTS/links.yaml` for branch/PR info.

4. Read `initiatives/$ARGUMENTS/qa-checklist.md` and count checked vs total items.

5. Read `initiatives/$ARGUMENTS/security-checklist.md` and count checked vs total items.

6. Present the summary in this format:

   ```
   ══════════════════════════════════════
     NeoCortex Initiative: <slug>
   ══════════════════════════════════════

   Phase: <current phase>
   Owner: <owner>

   Per-Repo Status:
     <repo-name>          <status>    <PR link or "no PR">
     <repo-name>          <status>    <PR link or "no PR">

   Progress: X/Y repos done

   Checklists:
     QA:       X/Y completed
     Security: X/Y completed

   Blockers:
     - <any repos with status "blocked" and their notes>
     (or "None")

   Next Actions:
     - <suggest what to do next based on current phase>
   ══════════════════════════════════════
   ```
