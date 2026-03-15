#!/bin/bash

HYPR_DIR="$HOME/.config/hypr/theme/"
THEME="$1"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "${THEME}" in
    abysal-obsidian)
        ln -sf abysal-obsidian.conf "$HYPR_DIR/colors.conf"
        THEME="Gruvbox"
        ;;
    abysal-marble)
        ln -sf abysal-marble.conf "$HYPR_DIR/colors.conf"
        THEME="Gruvbox"
        ;;
    *)
        log ERROR "Invalid theme: ${THEME}"
        exit 1
        ;;
esac

hyprctl reload

log SUCCESS "Theme applied successfully: ${THEME}"
