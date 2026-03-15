#!/bin/bash

THEME=$1
CONFIG_DIR="$HOME/.config/starship"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

rm -f "$HOME/.config/starship.toml"

ln -s "$CONFIG_DIR/$THEME/starship.toml" "$HOME/.config/starship.toml"

log SUCCESS "Theme applied successfully: ${THEME}"
