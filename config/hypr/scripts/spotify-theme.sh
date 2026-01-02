#!/bin/bash

THEME="$1"

case "$THEME" in
    "gruvbox-material-d")
        COLOR_SCHEME="gruvbox-material-dark"
        THEME_SPOTIFY="Dribbblish"
        ;;
        
    "gruvbox-material-l")
        COLOR_SCHEME="light"
        THEME_SPOTIFY="Onepunch"
        ;;
        
    "rose-pine-d")
        COLOR_SCHEME="rosepine"
        THEME_SPOTIFY="Dribbblish"
        ;;
        
    "rose-pine-l")
        COLOR_SCHEME="white"
        THEME_SPOTIFY="Dribbblish"
        ;;
        
    *)
        echo "Usage: $0 {gruvbox-material-d|gruvbox-material-l|rose-pine-d|rose-pine-l}"
        exit 1
        ;;
esac

killall spotify 2>/dev/null

spicetify config current_theme "$THEME_SPOTIFY" color_scheme "$COLOR_SCHEME"
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1 inject_theme_js 1
spicetify config sidebar_config 0
spicetify apply
