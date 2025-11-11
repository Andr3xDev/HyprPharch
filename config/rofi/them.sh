#!/bin/bash
# ~/.local/bin/rofi-theme

cd ~/.config/rofi

case "$1" in
    gruvbox-material-d)
        ln -sf gruvbox-material-d.rasi colors.rasi
        ;;
    rose-pine-l)
        ln -sf rose-pine-l.rasi colors.rasi
        ;;
    rose-pine-d)
        ln -sf rose-pine-d.rasi colors.rasi
        ;;
    *)
        echo "Usage: rofi-theme {gruvbox|rose}"
        exit 1
        ;;
esac
