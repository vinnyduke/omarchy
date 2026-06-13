#!/usr/bin/env bash
set -euo pipefail

# Support --skip-aur CLI flag AND SKIP_AUR env var
if [[ "${1:-}" == "--skip-aur" || "${SKIP_AUR:-false}" == "true" ]]; then
  echo "Skipping AUR package installation"
  exit 0
fi

if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --noconfirm --needed yay
fi

AUR_LIST="${OMARCHY_INSTALL:-$(dirname "$0")}/aur-packages.txt"

if [[ ! -f "$AUR_LIST" ]]; then
  echo "Error: aur-packages.txt not found at $AUR_LIST"
  exit 1
fi

echo "Installing AUR packages..."
yay -S --needed --noconfirm - < "$AUR_LIST"
echo "AUR packages installed successfully"
