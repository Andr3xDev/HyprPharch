#!/bin/bash

THEME_NAME="${1}"
CONFIG_FILE="config.toml"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

if [ -z "${THEME_NAME}" ]; then
    log ERROR "No theme specified"
    exit 1
fi

[[ "${THEME_NAME}" != *.toml ]] && FILE="${THEME_NAME}.toml" || FILE="${THEME_NAME}"
TARGET="$THEME_DIR/$FILE"

ln -sfn "$TARGET" "$CONFIG_FILE"

log SUCCESS "Theme applied successfully: ${THEME}"
