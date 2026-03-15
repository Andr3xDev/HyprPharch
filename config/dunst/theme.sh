#!/bin/bash

THEME_NAME=$1
THEME_PATH="$HOME/.config/dunst/themes/${THEME_NAME}.conf"
CONFIG_PATH="$HOME/.config/dunst/dunstrc"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME_NAME}"

if [ ! -f "${THEME_PATH}" ]; then
    log ERROR "Theme file not found: ${THEME_PATH}"
    exit 1
fi

ln -sf "${THEME_PATH}" "${CONFIG_PATH}"

killall dunst

notify-send "Theme" "changed to ${THEME_NAME}"

log SUCCESS "Theme applied successfully: ${THEME_NAME}"
