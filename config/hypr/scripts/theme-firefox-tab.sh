#!/bin/bash

THEME="$1"
WALLS_DIR="$HOME/.config/wallpapers"
LINK_TARGET="$HOME/.config/startpage/current.jpg"

if [[ "$THEME" == "rose-pine-d" ]]; then
    FILE="frieren-god.jpeg"
elif [[ "$THEME" == "rose-pine-l" ]]; then
    FILE="wall_freiren5.jpg"
elif [[ "$THEME" == "gruvbox-material-d" ]]; then
    FILE="frieren-w.jpg"
elif [[ "$THEME" == "gruvbox-material-l" ]]; then
    FILE="wall_freiren2.jpeg"
else
    FILE="frieren-god.jpeg"
fi

ln -sf "$WALLS_DIR/$FILE" "$LINK_TARGET"
