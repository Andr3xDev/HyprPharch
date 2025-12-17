#!/bin/bash

CONFIG_DIR="$HOME/.config/btop"
THEME=${1}

if [[ -z "$THEME" ]]; then
  echo "Uso: $0 {gruvbox-dark|gruvbox-light|rose-dark|rose-light}"
  exit 1
fi

case $THEME in
    gruvbox-material-d)
    THEME_FILE="gruvbox-material-d.theme"
    ;;
    gruvbox-material-l)
    THEME_FILE="gruvbox-material-l.theme"
    ;;
    rose-pine-d)
    THEME_FILE="rose-pine-d.theme"
    ;;
    rose-pine-l)
    THEME_FILE="rose-pine-l.theme"
    ;;
  *)
    echo "Theme does not exist: $THEME"
    exit 1
    ;;
esac

sed -i "s|^color_theme = .*|color_theme = \"$CONFIG_DIR/themes/$THEME_FILE\"|" "$CONFIG_DIR/btop.conf"
pkill -SIGUSR1 btop 2>/dev/null || pkill -USR1 btop 2>/dev/null
