#!/bin/bash

FILE="$HOME/.config/Code/User/settings.json"
THEME=""

case "$1" in
    gruvbox-material-d) THEME="Gruvbox Material Dark" ;;
    gruvbox-material-l) THEME="Gruvbox Material Light" ;;
    rose-pine-d)        THEME="Rosé Pine" ;;
    rose-pine-l)        THEME="Rosé Pine Dawn" ;;
    *) 
        exit 1 
        ;;
esac

# Usa sed para reemplazar el valor del tema in-place
sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$THEME\"/" "$FILE"
