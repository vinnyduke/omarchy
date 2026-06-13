#!/usr/bin/env bash
set -euo pipefail

# Install nano syntax highlighting files from fork defaults
NANO_SRC="${OMARCHY_PATH:-$HOME/.local/share/omarchy}/default/nano"
NANO_DST="$HOME/.nano"

if [[ ! -d "$NANO_SRC" ]]; then
  echo "Warning: nano syntax files not found at $NANO_SRC — skipping"
  exit 0
fi

mkdir -p "$NANO_DST"
cp "$NANO_SRC"/*.nanorc "$NANO_DST"/
echo "Nano syntax files installed to $NANO_DST"

# Ensure EDITOR=nano is set in shell profile
if ! grep -q 'export EDITOR=nano' "$HOME/.bashrc" 2>/dev/null; then
  echo '' >> "$HOME/.bashrc"
  echo '# Set default editor' >> "$HOME/.bashrc"
  echo 'export EDITOR=nano' >> "$HOME/.bashrc"
fi
echo "EDITOR=nano configured"
