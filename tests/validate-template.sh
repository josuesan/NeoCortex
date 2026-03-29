#!/usr/bin/env bash
set -euo pipefail

# Validate that all expected files exist in the template
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE="$ROOT_DIR/template"

ERRORS=0

pass() { echo "  PASS  $1"; }
fail() { echo "  FAIL  $1"; ERRORS=$((ERRORS + 1)); }

echo "Validating NeoCortex template structure"
echo ""

# Core files
echo "Core files:"
for f in CLAUDE.md .claude/settings.json; do
  [[ -f "$TEMPLATE/$f" ]] && pass "$f" || fail "$f missing"
done

# Agents
echo ""
echo "Agents:"
AGENTS=(conductor scout builder reviewer qa security shipper digest)
for agent in "${AGENTS[@]}"; do
  [[ -f "$TEMPLATE/.claude/agents/$agent.md" ]] && pass "$agent.md" || fail "$agent.md missing"
done

# Skill
echo ""
echo "Skills:"
[[ -f "$TEMPLATE/.claude/skills/cortex/SKILL.md" ]] && pass "cortex/SKILL.md" || fail "cortex/SKILL.md missing"

# Config
echo ""
echo "Config:"
for f in services.yaml conventions.yaml rollout-defaults.yaml; do
  [[ -f "$TEMPLATE/config/$f" ]] && pass "$f" || fail "$f missing"
done

# Initiative template
echo ""
echo "Initiative template:"
for f in overview.md impact-matrix.md links.yaml rollout.md qa-checklist.md security-checklist.md; do
  [[ -f "$TEMPLATE/initiatives/_template/$f" ]] && pass "$f" || fail "$f missing"
done

# Scripts
echo ""
echo "Scripts:"
for f in start-workspace.sh; do
  [[ -f "$TEMPLATE/scripts/$f" ]] && pass "$f" || fail "$f missing"
done

# Commands
echo ""
echo "Commands:"
for f in new-initiative.md validate.md sync.md status.md; do
  [[ -f "$TEMPLATE/.claude/commands/$f" ]] && pass "$f" || fail "$f missing"
done

# Rules
echo ""
echo "Rules:"
[[ -f "$TEMPLATE/.claude/rules/initiative-files.md" ]] && pass "initiative-files.md" || fail "initiative-files.md missing"

echo ""
echo "Result: $ERRORS error(s)"
[[ $ERRORS -eq 0 ]] && echo "ALL PASSED" || echo "FAILED"
exit "$ERRORS"
