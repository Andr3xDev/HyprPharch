#!/bin/bash
THEME=$1
CONFIG_DIR="$HOME/.config/starship"

case $THEME in
  gruvbox-material-d)
    TARGET="$CONFIG_DIR/gruvbox-material-d/starship.toml"
    ;;
  gruvbox-material-l)
    TARGET="$CONFIG_DIR/gruvbox-material-l/starship.toml"
    ;;
  rose-pine-d)
    TARGET="$CONFIG_DIR/rose-pine-d/starship.toml"
    ;;
  rose-pine-l)
    TARGET="$CONFIG_DIR/rose-pine-l/starship.toml"
    ;;
  *)
    echo "Use: theme [gruvbox-material-d|gruvbox-material-l|rose-pine-d|rose-pine-l]"
    exit 1
    ;;
esac

rm -f "$HOME/.config/starship.toml"

ln -s "$TARGET" "$HOME/.config/starship.toml"
