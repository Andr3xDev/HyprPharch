#!/bin/bash

FILE="$HOME/.config/Code/User/settings.json"
THEME=""

case "$1" in
    abysal-obsidian) THEME="Abysal Obsidian" ;;
    abysal-marble) THEME="Abysal Marble" ;;
    *) 
        exit 1 
        ;;
esac

# Usa sed para reemplazar el valor del tema in-place
sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$THEME\"/" "$FILE"
