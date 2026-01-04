#!/bin/bash

cd ~/.config/rofi

case "$1" in
    gruvbox-material-d)
        ln -sf themes/gruvbox-material-d.rasi colors.rasi
        ;;
    gruvbox-material-l)
        ln -sf themes/gruvbox-material-l.rasi colors.rasi
        ;;
    rose-pine-l)
        ln -sf themes/rose-pine-l.rasi colors.rasi
        ;;
    rose-pine-d)
        ln -sf themes/rose-pine-d.rasi colors.rasi
        ;;
    *)
        echo "Usage: rofi-theme {gruvbox|rose}"
        exit 1
        ;;
esac
