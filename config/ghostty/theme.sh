#!/bin/bash

INPUT_NAME="$1"
CONFIG_FILE="$HOME/.config/ghostty/config"

case "$INPUT_NAME" in
    "rose-pine-d")
        REAL_THEME="Rose Pine" 
        ;;
    "rose-pine-l")
        REAL_THEME="Rose Pine Dawn" 
        ;;
    "gruvbox-material-d")
        REAL_THEME="Gruvbox Material Dark"
        ;;
    "gruvbox-material-l")
        REAL_THEME="Gruvbox Material Light"
        ;;
esac

if grep -q "^theme =" "$CONFIG_FILE"; then
    sed -i "s/^theme = .*/theme = $REAL_THEME/" "$CONFIG_FILE"
    pkill -SIGUSR2 ghostty
else
    echo "theme = $REAL_THEME" >> "$CONFIG_FILE"
fi
