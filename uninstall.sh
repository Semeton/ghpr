#!/usr/bin/env bash
# uninstall.sh — Remove ghpr from this machine.
#
# Usage:
#   ./uninstall.sh
#   INSTALL_DIR=~/.local/bin ./uninstall.sh
#   ./uninstall.sh --yes

set -euo pipefail

YES=false

usage() {
  cat <<'EOF'
uninstall.sh — Remove ghpr from this machine.

Usage:
  ./uninstall.sh
  INSTALL_DIR=~/.local/bin ./uninstall.sh
  ./uninstall.sh --yes

Options:
  -y, --yes      Remove without confirmation
  -h, --help     Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes)
      YES=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

INSTALL_DIR="${INSTALL_DIR:-}"
TARGET=""

if [[ -n "$INSTALL_DIR" ]]; then
  TARGET="$INSTALL_DIR/ghpr"
elif command -v ghpr &>/dev/null; then
  TARGET="$(command -v ghpr)"
else
  TARGET="/usr/local/bin/ghpr"
fi

if [[ ! -e "$TARGET" ]]; then
  echo "ℹ ghpr is not installed at: $TARGET"
  exit 0
fi

if [[ "$YES" != true ]]; then
  read -r -p "Remove ghpr at '$TARGET'? [y/N] " REPLY
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo "ℹ Uninstall cancelled."
    exit 0
  fi
fi

if rm -f "$TARGET" 2>/dev/null; then
  :
else
  echo "→ Permission denied — retrying with sudo..."
  sudo rm -f "$TARGET"
fi

echo "✅ ghpr removed from $TARGET"
