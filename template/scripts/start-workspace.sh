#!/usr/bin/env bash
set -euo pipefail

# Start a Claude Code session with all configured services as --add-dir
# Usage: ./scripts/start-workspace.sh [initiative-slug]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="$ROOT_DIR/config/services.yaml"

if [[ ! -f "$CONFIG" ]]; then
  echo "Error: config/services.yaml not found at $CONFIG"
  exit 1
fi

# Parse service paths from services.yaml
# Uses grep/sed to avoid requiring yq (install yq for better YAML parsing)
DIRS=()
while IFS= read -r path; do
  # Resolve relative paths from the workspace root
  resolved="$(cd "$ROOT_DIR" && cd "$path" 2>/dev/null && pwd)" || {
    echo "Warning: path $path does not exist, skipping"
    continue
  }
  DIRS+=("$resolved")
done < <(grep 'local_path:' "$CONFIG" | sed 's/.*local_path:\s*//' | sed 's/#.*//' | xargs)

if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: no valid service paths found in $CONFIG"
  exit 1
fi

# Build the claude command
CMD="claude"
for dir in "${DIRS[@]}"; do
  CMD+=" --add-dir $dir"
done

# If an initiative slug is provided, set it as the initial prompt
SLUG="${1:-}"
if [[ -n "$SLUG" ]]; then
  CMD+=" --prompt '/platform-change $SLUG'"
fi

echo "Starting NeoCortex workspace with ${#DIRS[@]} services:"
for dir in "${DIRS[@]}"; do
  echo "  - $dir"
done
echo ""
echo "Command: $CMD"
echo ""

# Execute
eval "$CMD"
