#!/bin/bash

HYPR_DIR="$HOME/.config/hypr/theme/"

case "$1" in
    gruvbox-material-d)
        ln -sf gruvbox-material-d.conf "$HYPR_DIR/colors.conf"
        THEME="Gruvbox"
        ;;
    gruvbox-material-l)
        ln -sf gruvbox-material-l.conf "$HYPR_DIR/colors.conf"
        THEME="Gruvbox"
        ;;
    rose-pine-d)
        ln -sf rose-pine-d.conf "$HYPR_DIR/colors.conf"
        THEME="Rose Pine"
        ;;
    rose-pine-l)
        ln -sf rose-pine-l.conf "$HYPR_DIR/colors.conf"
        THEME="Rose Pine Dawn"
        ;;
    *)
        echo "Usage: hypr-theme {gruvbox|rose|dawn}"
        exit 1
        ;;
esac

hyprctl reload
