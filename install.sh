#!/usr/bin/env bash
# install.sh — Install ghpr as a global command on this machine.
#
# Usage:
#   ./install.sh                        # installs to /usr/local/bin (may need sudo)
#   INSTALL_DIR=~/.local/bin ./install.sh  # installs to a user-local directory
#
# To uninstall:
#   ./uninstall.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/bin/ghpr"
VERSION_FILE="$SCRIPT_DIR/VERSION"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
TARGET="$INSTALL_DIR/ghpr"
RENDERED_SOURCE=""

# ─── Checks ───────────────────────────────────────────────────────────────────

[[ -f "$SOURCE" ]] || {
  echo "❌ Could not find bin/ghpr in $SCRIPT_DIR"
  exit 1
}

[[ -f "$VERSION_FILE" ]] || {
  echo "❌ Could not find VERSION file in $SCRIPT_DIR"
  exit 1
}

VERSION="$(tr -d '[:space:]' < "$VERSION_FILE")"
[[ -n "$VERSION" ]] || {
  echo "❌ VERSION file is empty"
  exit 1
}

INSTALL_STATUS="installed"

render_source() {
  RENDERED_SOURCE="$(mktemp)"
  awk -v v="$VERSION" '{ gsub(/__GHPR_VERSION__/, v); print }' "$SOURCE" > "$RENDERED_SOURCE"
}

cleanup() {
  [[ -n "$RENDERED_SOURCE" && -f "$RENDERED_SOURCE" ]] && rm -f "$RENDERED_SOURCE"
}

trap cleanup EXIT
render_source

CURRENT_VERSION=""
if [[ -x "$TARGET" ]]; then
  CURRENT_VERSION="$("$TARGET" --version 2>/dev/null | awk '{print $2}' || true)"
fi

# ─── Create install dir if it doesn't exist ───────────────────────────────────

if [[ ! -d "$INSTALL_DIR" ]]; then
  echo "→ Creating $INSTALL_DIR ..."
  mkdir -p "$INSTALL_DIR" 2>/dev/null || sudo mkdir -p "$INSTALL_DIR"
fi

# ─── Copy and make executable ─────────────────────────────────────────────────

install_binary() {
  install -m 0755 "$RENDERED_SOURCE" "$TARGET"
}

if [[ -f "$TARGET" ]] && cmp -s "$RENDERED_SOURCE" "$TARGET"; then
  echo "→ $TARGET is already up to date."
  INSTALL_STATUS="up-to-date"
elif install_binary 2>/dev/null; then
  [[ -n "$CURRENT_VERSION" ]] && INSTALL_STATUS="updated"
else
  echo "→ Permission denied — retrying with sudo..."
  sudo install -m 0755 "$RENDERED_SOURCE" "$TARGET"
  [[ -n "$CURRENT_VERSION" ]] && INSTALL_STATUS="updated"
fi

# ─── PATH check ───────────────────────────────────────────────────────────────

echo ""
if [[ "$INSTALL_STATUS" == "up-to-date" ]]; then
  echo "✅ ghpr already up to date: $VERSION"
elif [[ "$INSTALL_STATUS" == "updated" ]]; then
  echo "✅ ghpr updated: $CURRENT_VERSION -> $VERSION"
else
  echo "✅ ghpr installed: $VERSION"
fi
echo "   Location: $TARGET"
echo ""

if ! command -v ghpr &>/dev/null; then
  echo "⚠️  $INSTALL_DIR is not in your PATH."
  echo "   Add the following to your shell startup file (~/.zshrc, ~/.bash_profile, or ~/.profile):"
  echo ""
  echo "     export PATH=\"$INSTALL_DIR:\$PATH\""
  echo ""
  echo "   For fish shell, use:"
  echo ""
  echo "     fish_add_path $INSTALL_DIR"
  echo ""
else
  echo "   Run 'ghpr --help' to get started."
fi
