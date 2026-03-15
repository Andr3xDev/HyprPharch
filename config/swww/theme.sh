#!/bin/bash

THEME="$1"
WALLPAPER_DIR="$HOME/.config/wallpapers"
MONITORS=$(hyprctl monitors | grep -oP 'Monitor \K[^\s]+')

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${THEME}"

case "${THEME}" in
    "abysal-obsidian")
        for MONITOR in $MONITORS; do
            swww img "$WALLPAPER_DIR/frieren-1.png" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 2 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    "abysal-marble")
        for MONITOR in $MONITORS; do
            swww img "$WALLPAPER_DIR/wall_CR.jpg" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 2 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    *)
        log ERROR "Invalid theme: ${THEME}"
        exit 1
        ;;
esac

log SUCCESS "Theme applied successfully: ${THEME}"
