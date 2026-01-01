#!/usr/bin/env bash

BASE_DIR="$HOME/.config/fastfetch"
THEMES_DIR="$BASE_DIR/themes"
TARGET="$BASE_DIR/config.jsonc"

OPTS=("gruvbox-material-d" "gruvbox-material-l" "rose-pine-d" "rose-pine-l")

if [[ -z "$1" ]]; then
    echo "Options: ${OPTS[*]}"
    exit 1
fi

VALID=0
for item in "${OPTS[@]}"; do
    [[ "$item" == "$1" ]] && VALID=1 && break
done

if [[ $VALID -eq 0 ]]; then
    echo "Options: ${OPTS[*]}"
    exit 1
fi

SRC="$THEMES_DIR/$1.jsonc"

if [[ -f "$SRC" ]]; then
    ln -sf "$SRC" "$TARGET"
else
    echo "Critical: File $SRC does not exist."
    exit 1
fi
