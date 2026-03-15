#!/bin/bash

CONFIG_DIR="${HOME}/.config/btop"
THEME="${1}"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "${THEME}" in
    abysal-obsidian)
        THEME_FILE="abysal-obsidian.theme"
        ;;
    abysal-marble)
        THEME_FILE="abysal-marble.theme"
        ;;
    *)
        log ERROR "Invalid theme: ${THEME}"
        exit 1
        ;;
esac

sed -i "s|^color_theme = .*|color_theme = \"${CONFIG_DIR}/themes/${THEME_FILE}\"|" "${CONFIG_DIR}/btop.conf"
pkill -SIGUSR1 btop || pkill -USR1 btop

log SUCCESS "Theme applied successfully: ${THEME}"
