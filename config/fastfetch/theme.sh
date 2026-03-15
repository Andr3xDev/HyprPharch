#!/usr/bin/env bash

BASE_DIR="$HOME/.config/fastfetch"
THEMES_DIR="$BASE_DIR/themes"
TARGET="$BASE_DIR/config.jsonc"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

if [[ $# -ne 1 ]]; then
    log ERROR "No theme specified"
    exit 1
fi

SRC="$THEMES_DIR/$1.jsonc"

if [[ ! -f "$SRC" ]]; then
    log ERROR "Theme file not found: ${SRC}"
    exit 1
fi

ln -sfn "$SRC" "$TARGET"

log SUCCESS "Theme applied successfully: ${1}"
