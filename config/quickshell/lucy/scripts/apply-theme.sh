#!/bin/bash

# Master script to apply theme across all applications
# Usage: ./apply-theme.sh <theme-name>
# Theme names: rose-pine-d, rose-pine-l, gruvbox-material-d, gruvbox-material-l

THEME="$1"

if [ -z "$THEME" ]; then
    echo "Usage: $0 <theme-name>"
    exit 1
fi

echo "Applying theme: $THEME"

# Map quickshell theme names to your app-specific names if needed
case "$THEME" in
    "rose-pine-d")
        GTK_THEME="rose-pine"
        KITTY_THEME="Rose Pine"
        HYPR_THEME="rose-pine"
        ;;
    "rose-pine-l")
        GTK_THEME="rose-pine-dawn"
        KITTY_THEME="Rose Pine Dawn"
        HYPR_THEME="rose-pine-dawn"
        ;;
    "gruvbox-material-d")
        GTK_THEME="gruvbox-dark"
        KITTY_THEME="Gruvbox Material Dark Medium"
        HYPR_THEME="gruvbox-dark"
        ;;
    "gruvbox-material-l")
        GTK_THEME="gruvbox-light"
        KITTY_THEME="Gruvbox Material Light Medium"
        HYPR_THEME="gruvbox-light"
        ;;
    *)
        echo "Unknown theme: $THEME"
        exit 1
        ;;
esac

# ============================================
# Add your theme change commands below
# ============================================

# Kitty
kitty +kitten themes --reload-in=all "$THEME"

# Hyprland
~/.config/hypr/scripts/theme.sh $THEME

# Rofi
~/.config/rofi/theme.sh $THEME

# Dunst
~/.config/dunst/theme.sh $THEME

# Yazi
~/.config/yazi/theme.sh $THEME

# Fastfetch
~/.config/fastfetch/theme.sh $THEME

# Btop
~/.config/btop/theme.sh $THEME

# Starship
~/.config/starship/theme.sh $THEME

# swww
~/.config/swww/theme.sh $THEME

# Kotofetch
~/.config/kotofetch/theme.sh $THEME

# spotify
~/.config/hypr/scripts/spotify-theme.sh $THEME

# GTK
~/.config/hypr/scripts/gtk-theme.sh $THEME
