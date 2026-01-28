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

# Clone spicetify-themes and install Dribbblish and Onepunch themes
print_message "Installing Spicetify themes (Dribbblish and Onepunch)..."
TEMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/spicetify/spicetify-themes.git "$TEMP_DIR/spicetify-themes"

# Get spicetify themes directory
THEMES_DIR="$HOME/.config/spicetify/Themes"
mkdir -p "$THEMES_DIR"

# Copy Dribbblish and Onepunch themes
cp -r "$TEMP_DIR/spicetify-themes/Dribbblish" "$THEMES_DIR/"
cp -r "$TEMP_DIR/spicetify-themes/Onepunch" "$THEMES_DIR/"

# Clean up
rm -rf "$TEMP_DIR"

print_success "╔════════════════════════════════════════╗"
print_success "║  Spotify & Spicetify installed!        ║"
print_success "║  Themes: Dribbblish, Onepunch          ║"
print_success "╚════════════════════════════════════════╝"
