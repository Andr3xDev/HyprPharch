#!/bin/bash

THEME="$1"

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "${THEME}" in
    "abysal-obsidian")
        COLOR_SCHEME="Gray-Dark2"
        THEME_SPOTIFY="Matte"
        ;;
        
    "abysal-marble")
        COLOR_SCHEME="Porcelain"
        THEME_SPOTIFY="Matte"
        ;;
    *)
        log ERROR "Invalid theme: ${THEME}"
        exit 1
        ;;
esac

killall spotify 2>/dev/null

spicetify backup apply
spicetify config current_theme "${THEME_SPOTIFY}" color_scheme "${COLOR_SCHEME}"
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1 inject_theme_js 1
spicetify config sidebar_config 0
spicetify apply

log SUCCESS "Theme applied successfully: ${THEME}"
