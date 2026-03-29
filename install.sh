#!/usr/bin/env bash
set -euo pipefail

# Install NeoCortex template to a destination directory
# Usage: ./install.sh <destination>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

DEST="${1:-}"
if [[ -z "$DEST" ]]; then
  echo "NeoCortex — Distributed Initiative Coordination"
  echo ""
  echo "Usage: $0 <destination-directory>"
  echo "Example: $0 ~/Projects/my-platform"
  exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Error: template directory not found at $TEMPLATE_DIR"
  exit 1
fi

if [[ -d "$DEST" && "$(ls -A "$DEST" 2>/dev/null)" ]]; then
  echo "Warning: $DEST is not empty."
  read -p "Continue? Files may be overwritten. [y/N] " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

mkdir -p "$DEST"
cp -r "$TEMPLATE_DIR"/* "$TEMPLATE_DIR"/.claude "$DEST/"

# Make scripts executable
chmod +x "$DEST"/scripts/*.sh 2>/dev/null || true

echo ""
echo "NeoCortex installed at: $DEST"
echo ""
echo "Next steps:"
echo "  1. cd $DEST"
echo "  2. Edit config/services.yaml — add your repos"
echo "  3. ./scripts/start-workspace.sh — launch Claude Code with all repos"
echo "  4. Inside Claude Code, run /new-initiative <slug>"
echo ""
echo "Documentation: https://github.com/josuesan/NeoCortex"
