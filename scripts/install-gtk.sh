#!/bin/bash

set -e

# Use temp directory from parent script or create one
if [ -z "$HYPRPHARCH_TEMP" ]; then
    TMP_DIR=$(mktemp -d)
    trap "rm -rf $TMP_DIR" EXIT
else
    TMP_DIR="$HYPRPHARCH_TEMP/gtk-themes"
    mkdir -p "$TMP_DIR"
fi

mkdir -p "$HOME/.themes" "$HOME/.icons"

echo -e "\033[0;36m→\033[0m Installing GTK themes..."

# Gruvbox GTK
cd "$TMP_DIR"
git clone --depth 1 https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
cd Gruvbox-GTK-Theme/themes
chmod +x install.sh
./install.sh -d "$HOME/.themes" -t default -l --tweaks outline

# Rose Pine GTK
cd "$TMP_DIR"
git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git
cd Rose-Pine-GTK-Theme/themes
chmod +x install.sh
./install.sh -d "$HOME/.themes" -t default -l --tweaks outline

# Papirus Icons
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh

echo -e "\033[0;33m✓\033[0m Themes installed in $HOME/.themes and $HOME/.icons"
