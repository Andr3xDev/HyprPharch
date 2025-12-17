#!/bin/bash

set -e

TMP_DIR=$(mktemp -d)
THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"

trap "rm -rf $TMP_DIR" EXIT

mkdir -p "$THEMES_DIR" "$ICONS_DIR"

echo -e "\033[0;36m→\033[0m Installing GTK themes..."

# Gruvbox GTK
cd "$TMP_DIR"
git clone --depth 1 https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
cd Gruvbox-GTK-Theme/themes
chmod +x install.sh
./install.sh -d "$THEMES_DIR" -t default -l --tweaks outline

# Rose Pine GTK
cd "$TMP_DIR"
git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git
cd Rose-Pine-GTK-Theme/themes
chmod +x install.sh
./install.sh -d "$THEMES_DIR" -t default -l --tweaks outline

# Papirus Icons
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$ICONS_DIR" sh

echo -e "\033[0;33m✓\033[0m Themes installed in $THEMES_DIR and $ICONS_DIR"
