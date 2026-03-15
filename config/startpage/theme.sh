#!/bin/bash

THEME="$1"
WALLS_DIR="$HOME/.config/wallpapers"
DEST="$HOME/.config/startpage/current_wallpaper.png"
FILE=""

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

if [[ "${THEME}" == "abysal-obsidian" ]]; then
    FILE="frieren-1.png"

elif [[ "${THEME}" == "abysal-marble" ]]; then
    FILE="wall_CR.jpg"
fi

cp "${WALLS_DIR}/${FILE}" "${DEST}"

log SUCCESS "Theme applied successfully: ${THEME}"
