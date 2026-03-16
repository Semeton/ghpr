#!/usr/bin/env bash
# update.sh — Pull latest code and reinstall ghpr.
#
# Usage:
#   ./update.sh
#   UPDATE_BRANCH=main ./update.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRANCH="${UPDATE_BRANCH:-main}"

cd "$SCRIPT_DIR"

echo "→ Fetching updates from origin/$BRANCH ..."
git pull origin "$BRANCH"

echo "→ Reinstalling ghpr ..."
"$SCRIPT_DIR/install.sh"

echo "✅ ghpr update complete."
