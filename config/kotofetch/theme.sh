#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

THEME_NAME="${1:-}"
THEME_DIR="themes"
CONFIG_FILE="config.toml"

if [ -z "$THEME_NAME" ]; then
    echo "Uso: ./theme.sh <nombre_tema>"
    exit 1
fi

[[ "$THEME_NAME" != *.toml ]] && FILE="${THEME_NAME}.toml" || FILE="$THEME_NAME"
TARGET="$THEME_DIR/$FILE"

rm -f "$CONFIG_FILE"

ln -sf "$TARGET" "$CONFIG_FILE"
