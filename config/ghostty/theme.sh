#!/bin/bash

INPUT_NAME="$1"
CONFIG_FILE="${HOME}/.config/ghostty/config"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

if grep -q "^theme =" "${CONFIG_FILE}"; then
    sed -i "s/^theme = .*/theme = ${INPUT_NAME}/" "${CONFIG_FILE}"
    pkill -SIGUSR2 ghostty
    log SUCCESS "Theme applied successfully: ${INPUT_NAME}"
else
    log ERROR "Theme setting not found in config file"
    exit 1
fi
