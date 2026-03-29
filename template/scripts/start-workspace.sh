#!/usr/bin/env bash
set -euo pipefail

# Start a Claude Code session with all configured services as --add-dir
#
# Usage: ./scripts/start-workspace.sh [initiative-slug]
#
# This script:
#   1. Reads config/services.yaml to find your repos
#   2. Launches Claude Code FROM this workspace directory
#   3. Adds each repo via --add-dir so Claude can access them all
#
# Claude's working directory will be THIS workspace (the coordinator).
# Your repos are accessed via --add-dir — they are NOT copied or moved.
#
# Example:
#   ./scripts/start-workspace.sh                      # start session
#   ./scripts/start-workspace.sh                        # start session

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="$ROOT_DIR/config/services.yaml"

if [[ ! -f "$CONFIG" ]]; then
  echo "Error: config/services.yaml not found"
  echo ""
  echo "Make sure you're running this from an installed NeoCortex workspace."
  echo "If you haven't installed yet, run: ./install.sh <destination>"
  exit 1
fi

# Parse service paths from services.yaml
DIRS=()
NAMES=()
while IFS= read -r path; do
  resolved="$(cd "$ROOT_DIR" && cd "$path" 2>/dev/null && pwd)" || {
    echo "  Warning: $path does not exist, skipping"
    continue
  }
  DIRS+=("$resolved")
  NAMES+=("$(basename "$resolved")")
done < <(grep 'local_path:' "$CONFIG" | sed 's/.*local_path:[[:space:]]*//' | sed 's/[[:space:]]*#.*//' | sed 's/[[:space:]]*$//')

if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: no valid service paths found in $CONFIG"
  echo "Check that your repos exist at the paths listed in config/services.yaml"
  exit 1
fi

# Build the claude command — launch from the workspace root
CMD="claude"
for dir in "${DIRS[@]}"; do
  CMD+=" --add-dir \"$dir\""
done

# If an initiative slug is provided, set it as the initial prompt
SLUG="${1:-}"
if [[ -n "$SLUG" ]]; then
  CMD+=" --prompt '/status $SLUG'"
fi

echo "╔══════════════════════════════════════════╗"
echo "║         NeoCortex Workspace              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Working directory: $ROOT_DIR"
echo ""
echo "Connected repos (${#DIRS[@]}):"
for name in "${NAMES[@]}"; do
  echo "  - $name"
done
echo ""
if [[ -n "$SLUG" ]]; then
  echo "Initiative: $SLUG"
  echo ""
fi
echo "Launching Claude Code..."
echo ""

# Execute from the workspace root
cd "$ROOT_DIR"
eval "$CMD"
