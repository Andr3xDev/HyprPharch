#!/bin/bash

FILE="$HOME/.config/Code/User/settings.json"
THEME=""

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "$1" in
    abysal-obsidian) THEME="Abysal Obsidian" ;;
    abysal-marble) THEME="Abysal Marble" ;;
    *) 
        exit 1 
        ;;
esac

sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$THEME\"/" "$FILE"

log SUCCESS "Theme applied successfully: ${THEME}"
