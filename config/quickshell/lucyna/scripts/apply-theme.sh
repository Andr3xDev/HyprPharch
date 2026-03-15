#!/bin/bash

# Master script to apply theme across all applications
# Usage: ./apply-theme.sh <theme-name>
# Theme names: abysal-obsidian, abysal-marble
THEME="$1"

source "${HOME}/.config/scripts/logger.sh"
log INFO "---------------------------------------------------------------"
log INFO "Applying theme: ${THEME} for all applications"

if [ -z "${THEME}" ]; then
    log ERROR "No theme specified"
    exit 1
fi

# Map quickshell theme names to app-specific names
case "${THEME}" in
    "abysal-obsidian")
        GTK_THEME="abysal-obsidian"
        HYPR_THEME="abysal-obsidian"
        ;;
    "abysal-marble")
        GTK_THEME="abysal-marble"
        HYPR_THEME="abysal-marble"
        ;;
    *)
        log ERROR "Unknown theme: ${THEME}"
        exit 1
        ;;
esac

# ============================================
# Theme Change Commands
# ============================================

# Ghostty
~/.config/ghostty/theme.sh ${THEME}

# Hyprland
~/.config/hypr/scripts/theme.sh ${THEME}

# Yazi
~/.config/yazi/theme.sh ${THEME}

# Fastfetch
~/.config/fastfetch/theme.sh ${THEME}

# Btop
~/.config/btop/theme.sh ${THEME}

# Starship
~/.config/starship/theme.sh ${THEME}

# swww
~/.config/swww/theme.sh ${THEME}

# Kotofetch
~/.config/kotofetch/theme.sh ${THEME}

# spotify
~/.config/scripts/spotify-theme.sh ${THEME}

# VScode theme
~/.config/scripts/vscode-theme.sh ${THEME}

# GTK
~/.config/scripts/gtk-theme.sh ${THEME}

# Firefox tabs
~/.config/startpage/theme.sh ${THEME}

# Dunst
~/.config/dunst/theme.sh ${THEME}

log SUCCESS "All themes applied successfully: ${THEME}"
