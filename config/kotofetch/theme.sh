#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

THEME_NAME="${1:-}"
THEME_DIR="themes"
CONFIG_FILE="config.toml"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME_NAME}"

if [ -z "$THEME_NAME" ]; then
    log ERROR "No theme specified"
    exit 1
fi

[[ "$THEME_NAME" != *.toml ]] && FILE="${THEME_NAME}.toml" || FILE="$THEME_NAME"
TARGET="$THEME_DIR/$FILE"

rm -f "$CONFIG_FILE"

ln -sf "$TARGET" "$CONFIG_FILE"

log SUCCESS "Theme applied successfully: ${THEME_NAME}"

