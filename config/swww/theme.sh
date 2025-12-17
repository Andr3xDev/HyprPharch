#!/bin/bash

THEME="$1"
WALLPAPER_DIR="$HOME/.config/wallpapers"
MONITORS=$(hyprctl monitors | grep -oP 'Monitor \K[^\s]+')

case "$THEME" in
    "gruvbox-material-d")
        for MONITOR in $MONITORS; do

            swww img "$WALLPAPER_DIR/wall-neon-n.jpg" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 1 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    "gruvbox-material-l")
        for MONITOR in $MONITORS; do
            swww img "$WALLPAPER_DIR/wall_freiren2.jpeg" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 1 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    "rose-pine-d")
        for MONITOR in $MONITORS; do
            swww img "$WALLPAPER_DIR/wall_frieren-tree.jpg" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 1 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    "rose-pine-l")
        for MONITOR in $MONITORS; do
            swww img "$WALLPAPER_DIR/wall_freiren5.jpg" \
                --transition-type fade \
                --transition-fps 60 \
                --transition-duration 1 \
                --outputs "$MONITOR" &
        done
        wait
        ;;
        
    *)
        echo "Usage: $0 {gruvbox-material-d|gruvbox-material-l|rose-pine-d|rose-pine-l}"
        exit 1
        ;;
esac

echo "Wallpaper changed to: $THEME on all monitors"
