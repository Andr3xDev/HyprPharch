#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

print_banner "Installing Spotify & Spicetify"

sudo pacman -S --needed --noconfirm spotify-launcher
paru -S --needed --noconfirm spicetify-cli

# Launch Spotify to initialize installation
print_message "Launching Spotify to initialize installation..."
spotify-launcher &
SPOTIFY_PID=$!

# Wait for Spotify to initialize (10 seconds)
print_message "Waiting for Spotify to initialize..."
sleep 10

# Close Spotify
print_message "Closing Spotify..."
kill $SPOTIFY_PID 2>/dev/null || killall spotify 2>/dev/null || true
sleep 2

# Configure Spicetify permissions
print_message "Setting up Spicetify permissions..."
spicetify config spotify_path "$HOME/.local/share/spotify-launcher/install/usr/share/spotify"

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

spicetify config inject_css 1 replace_colors 1 overwrite_assets 1 inject_theme_js 1

print_success "╔════════════════════════════════════════╗"
print_success "║  Spotify & Spicetify installed!        ║"
print_success "║  Themes: Dribbblish, Onepunch          ║"
print_success "╚════════════════════════════════════════╝"
