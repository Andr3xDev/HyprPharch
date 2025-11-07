#!/bin/bash
sleep 1

# Move each workspace to designed monitor
hyprctl --batch "\
    dispatch moveworkspacetomonitor 1 DP-2;\
    dispatch moveworkspacetomonitor 2 DP-2;\
    dispatch moveworkspacetomonitor 3 DP-2;\
    dispatch moveworkspacetomonitor 4 DP-2;\
    dispatch moveworkspacetomonitor 5 HDMI-A-1;\
    dispatch moveworkspacetomonitor 6 eDP-2;\
    dispatch moveworkspacetomonitor 7 eDP-2;\
    dispatch moveworkspacetomonitor 8 eDP-2;\
    dispatch moveworkspacetomonitor 9 eDP-2;\
    dispatch moveworkspacetomonitor 10 HDMI-A-1"
