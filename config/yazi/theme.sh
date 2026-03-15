#!/bin/bash

THEME_FILE="$HOME/.config/yazi/theme.toml"
THEME_NAME="${1}"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME_NAME}"

case "${THEME_NAME}" in
    abysal-obsidian)
        cat > "${THEME_FILE}" << 'EOF'
[flavor]
dark = "abysal-obsidian"
EOF
        ;;
    abysal-marble)
        cat > "${THEME_FILE}" << 'EOF'
[flavor]
light = "abysal-marble"
EOF
        ;;
esac

log SUCCESS "Theme applied successfully: ${THEME_NAME}"
