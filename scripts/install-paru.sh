#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

# Check if paru already exists
if command_exists paru; then
    print_success "Paru is already installed"
    exit 0
fi

print_banner "Installing Paru"

# Install dependencies
print_message "Checking dependencies..."
sudo pacman -S --needed --noconfirm base-devel git

# Install paru
print_message "Installing paru..."

# Use temp directory from parent script or create one
if [ -z "$HYPRPHARCH_TEMP" ]; then
    TEMP_DIR="$HOME/.cache/paru-install-$$"
    mkdir -p "$TEMP_DIR"
    CLEANUP_TEMP=true
else
    TEMP_DIR="$HYPRPHARCH_TEMP/paru"
    mkdir -p "$TEMP_DIR"
    CLEANUP_TEMP=false
fi

cd "$TEMP_DIR"

print_message "Downloading paru from AUR..."
git clone --depth 1 https://aur.archlinux.org/paru.git
cd paru

print_message "Building paru (this may take a few minutes)..."
makepkg -si --noconfirm

# Cleanup only if we created our own temp dir
if [ "$CLEANUP_TEMP" = true ]; then
    cd "$HOME"
    rm -rf "$TEMP_DIR"
fi

print_success "Paru installed successfully"
