#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

REAL_USER=$(get_real_user)
USER_HOME=$(get_user_home)
CONFIG_SRC="$SCRIPT_DIR/../config"

check_root

print_banner "Installing Dotfiles"

# Copy all config files
print_message "Copying configuration files..."

# Create backup if config exists
if [ -d "$USER_HOME/.config" ]; then
    BACKUP_DIR="$USER_HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
    print_warning "Backing up existing config to $BACKUP_DIR"
    sudo -u "$REAL_USER" cp -r "$USER_HOME/.config" "$BACKUP_DIR"
fi

# Create .config directory
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"

# Copy each config directory
for config in btop dunst fastfetch gtk-3.0 gtk-4.0 hypr kitty kotofetch nvim nwg-look quickshell rofi starship swww xsettingsd yazi; do
    if [ -d "$CONFIG_SRC/$config" ]; then
        print_message "Installing $config config..."
        sudo -u "$REAL_USER" cp -r "$CONFIG_SRC/$config" "$USER_HOME/.config/"
    fi
done

# Copy starship.toml to home
if [ -f "$CONFIG_SRC/starship.toml" ]; then
    sudo -u "$REAL_USER" cp "$CONFIG_SRC/starship.toml" "$USER_HOME/.config/starship.toml"
fi

# Copy wallpapers
if [ -d "$CONFIG_SRC/wallpapers" ]; then
    print_message "Installing wallpapers..."
    sudo -u "$REAL_USER" mkdir -p "$USER_HOME/Pictures/wallpapers"
    sudo -u "$REAL_USER" cp -r "$CONFIG_SRC/wallpapers/"* "$USER_HOME/Pictures/wallpapers/" 2>/dev/null || true
fi

# Set ownership
chown -R "$REAL_USER:$REAL_USER" "$USER_HOME/.config"
[ -d "$USER_HOME/Pictures/wallpapers" ] && chown -R "$REAL_USER:$REAL_USER" "$USER_HOME/Pictures/wallpapers"

print_success "Dotfiles installed successfully"
