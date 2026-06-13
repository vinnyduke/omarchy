#!/usr/bin/env bash
#===============================================================================
# partition-setup.sh — Partition helper for Omarchy Custom Install
#
# Usage:
#   ./partition-setup.sh                        # Interactive mode
#   ./partition-setup.sh --help                 # Show this help
#   ./partition-setup.sh --disk /dev/sdX        # Specify disk
#   ./partition-setup.sh --disk /dev/sdX --home-fs ext4
#
# This script is a HELPER — run it MANUALLY from the ISO environment
# before the main installer. It does NOT auto-execute.
#
# Creates:
#   - Partition 1: EFI (512MB FAT32)
#   - Partition 2: System (btrfs, rest of disk minus home size)
#   - Partition 3: /home (ext4 or btrfs)
#===============================================================================

set -euo pipefail

# Defaults
DISK=""
HOME_FS="ext4"
HOME_SIZE="50"  # GiB

show_help() {
  sed -n 's/^#//p' "$0" | sed 's/^ //'
  exit 0
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help) show_help ;;
    --disk) DISK="$2"; shift 2 ;;
    --home-fs) HOME_FS="$2"; shift 2 ;;
    *) echo "Error: unknown option $1"; show_help; exit 1 ;;
  esac
done

# Check if running in ISO environment
if mountpoint -q /run/archiso/bootmnt 2>/dev/null; then
  echo "✓ ISO environment detected"
else
  echo "⚠ Not running from ISO — this script is designed for the ISO boot environment."
  echo "  Press Ctrl+C to exit, or continue at your own risk."
  sleep 3
fi

# Detect disk if not specified
if [[ -z "$DISK" ]]; then
  echo ""
  echo "Available disks:"
  lsblk -d -o NAME,SIZE,MODEL | grep -v loop
  echo ""
  echo -n "Enter disk (e.g., /dev/sda): "
  read -r DISK
fi

if [[ ! -b "$DISK" ]]; then
  echo "Error: $DISK is not a block device"
  exit 1
fi

echo ""
echo "=== Partition Plan ==="
echo "Disk:    $DISK"
echo "EFI:     512M FAT32"
echo "System:  rest of disk (minus ${HOME_SIZE}G)"
echo "/home:   ${HOME_SIZE}G ${HOME_FS}"
echo ""
echo -n "Proceed with this partition layout? (y/N): "
read -r confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "Aborted." && exit 0

# Create GPT partition table
echo ""
echo "Creating partitions..."
sgdisk --zap-all "$DISK"
sgdisk --new=1:0:+512M --typecode=1:ef00 "$DISK"
sgdisk --new=2:0:-${HOME_SIZE}G --typecode=2:8300 "$DISK"
sgdisk --new=3:0:0 --typecode=3:8300 "$DISK"

# Format partitions
echo "Formatting partitions..."
mkfs.fat -F32 "${DISK}1"
mkfs.btrfs -f "${DISK}2"
if [[ "$HOME_FS" == "btrfs" ]]; then
  mkfs.btrfs -f "${DISK}3"
else
  mkfs.ext4 -F "${DISK}3"
fi

# Mount partitions
echo "Mounting partitions..."
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home
mount "${DISK}1" /mnt/boot
mount "${DISK}3" /mnt/home

echo ""
echo "✓ Partitions created and mounted:"
echo "  ${DISK}1 → /mnt/boot (EFI)"
echo "  ${DISK}2 → /mnt      (System, btrfs)"
echo "  ${DISK}3 → /mnt/home (${HOME_FS})"
echo ""
echo "The installer can now proceed."
