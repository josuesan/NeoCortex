#!/usr/bin/env bash
set -euo pipefail

# Check that all expected documentation files exist and are non-empty
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

ERRORS=0

pass() { echo "  PASS  $1"; }
fail() { echo "  FAIL  $1"; ERRORS=$((ERRORS + 1)); }

echo "Linting documentation"
echo ""

# Check required docs
DOCS=(architecture.md workflow.md conventions.md agents.md skills.md config.md migration-guide.md)
echo "Required docs:"
for doc in "${DOCS[@]}"; do
  if [[ -f "$ROOT_DIR/docs/$doc" ]]; then
    if [[ -s "$ROOT_DIR/docs/$doc" ]]; then
      pass "docs/$doc"
    else
      fail "docs/$doc is empty"
    fi
  else
    fail "docs/$doc missing"
  fi
done

echo ""

# Check README
echo "Root files:"
[[ -f "$ROOT_DIR/README.md" && -s "$ROOT_DIR/README.md" ]] && pass "README.md" || fail "README.md missing or empty"

echo ""

# Basic broken link check (internal markdown links)
echo "Internal link check:"
BROKEN=0
while IFS= read -r file; do
  while IFS= read -r link; do
    # Extract path from markdown link [text](path)
    path=$(echo "$link" | sed 's/.*](//' | sed 's/).*//' | sed 's/#.*//')
    if [[ -n "$path" && ! "$path" =~ ^http ]]; then
      # Resolve relative to the file's directory
      dir=$(dirname "$file")
      if [[ ! -f "$dir/$path" ]]; then
        fail "Broken link in $(basename "$file"): $path"
        BROKEN=$((BROKEN + 1))
      fi
    fi
  done < <(grep -oE '\[[^]]+\]\([^)]+\)' "$file" 2>/dev/null || true)
done < <(find "$ROOT_DIR/docs" "$ROOT_DIR/README.md" -name '*.md' 2>/dev/null)

[[ $BROKEN -eq 0 ]] && pass "No broken internal links found"

echo ""
echo "Result: $ERRORS error(s)"
[[ $ERRORS -eq 0 ]] && echo "ALL PASSED" || echo "FAILED"
exit "$ERRORS"
