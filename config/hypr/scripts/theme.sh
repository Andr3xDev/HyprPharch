#!/bin/bash

HYPR_DIR="$HOME/.config/hypr/theme/"
THEME="$1"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "${THEME}" in
    abysal-obsidian)
        # Hyprlock (conf)
        ln -sf abysal-obsidian.conf "$HYPR_DIR/colors.conf"
        # Hyprland (lua)
        echo 'return "abysal-obsidian"' > "$HYPR_DIR/state.lua"
        ;;
    abysal-marble)
        # Hyprlock (conf)
        ln -sf abysal-marble.conf "$HYPR_DIR/colors.conf"
        # Hyprland (lua)
        echo 'return "abysal-marble"' > "$HYPR_DIR/state.lua"
        ;;
    *)
        log ERROR "Invalid theme: ${THEME}"
        exit 1
        ;;
esac

hyprctl reload

log SUCCESS "Theme applied successfully: ${THEME}"
