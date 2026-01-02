#!/bin/bash

THEME_NAME=$1
THEME_PATH="$HOME/.config/dunst/themes/$THEME_NAME.conf"
CONFIG_PATH="$HOME/.config/dunst/dunstrc"

if [ ! -f "$THEME_PATH" ]; then
    exit 1
fi

ln -sf "$THEME_PATH" "$CONFIG_PATH"

killall dunst

notify-send "Theme" "changed to $THEME_NAME"
