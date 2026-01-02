#!/bin/bash

THEME_NAME=$1
THEME_PATH="$HOME/.config/dunst/themes/$THEME_NAME.conf"
CONFIG_PATH="$HOME/.config/dunst/dunstrc"

# Validar que el tema existe
if [ ! -f "$THEME_PATH" ]; then
    exit 1
fi

# Crear el symlink (f fuerza el reemplazo)
ln -sf "$THEME_PATH" "$CONFIG_PATH"

# Reiniciar el servicio
killall dunst

# Prueba
notify-send "Dunst Theme" "Cambiado a $THEME_NAME"
