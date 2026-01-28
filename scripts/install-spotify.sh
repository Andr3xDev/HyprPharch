#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

print_banner "Installing Spotify & Spicetify"

sudo pacman -S --needed --noconfirm spotify-launcher
paru -S --needed --noconfirm spicetify-cli

# Configure Spicetify permissions
print_message "Setting up Spicetify permissions..."
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# Run Spicetify for the first time
print_message "Running Spicetify initial setup..."
spicetify backup apply

print_success "╔════════════════════════════════════════╗"
print_success "║  Spotify & Spicetify installed!        ║"
print_success "╚════════════════════════════════════════╝"
