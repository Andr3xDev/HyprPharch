#!/bin/bash

THEME="$1"
WALLS_DIR="$HOME/.config/wallpapers"
DEST="$HOME/.config/startpage/current_wallpaper.jpg"
FILE=""

if [[ "$THEME" == "rose-pine-d" ]]; then
    FILE="frieren-god.jpeg"

elif [[ "$THEME" == "rose-pine-l" ]]; then
    FILE="wall_freiren5.jpg"

elif [[ "$THEME" == "gruvbox-material-d" ]]; then
    FILE="frieren-w.jpg"

elif [[ "$THEME" == "gruvbox-material-l" ]]; then
    FILE="wall_freiren2.jpeg"
fi

cp "$WALLS_DIR/$FILE" "$DEST"
