#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

REAL_USER=$(get_real_user)
USER_HOME=$(get_user_home)

# Check if paru already exists
if command_exists paru; then
    print_success "Paru is already installed"
    exit 0
fi

print_banner "Installing Paru"

# Install dependencies
print_message "Checking dependencies..."
pacman -S --needed --noconfirm base-devel git

# Install paru
print_message "Installing paru..."
TEMP_DIR="/tmp/paru-install"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

sudo -u "$REAL_USER" git clone https://aur.archlinux.org/paru.git
cd paru
sudo -u "$REAL_USER" makepkg -si --noconfirm

# Cleanup
cd /
rm -rf "$TEMP_DIR"

print_success "Paru installed successfully"
