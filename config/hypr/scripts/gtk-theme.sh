#!/bin/bash

case "$1" in
    "gruvbox-material-d")
        GTK_THEME="Gruvbox-Dark"
        ICON_THEME="Papirus-Dark"
        COLOR_SCHEME="prefer-dark"
        ;;
    "gruvbox-material-l")
        GTK_THEME="Gruvbox-Light"
        ICON_THEME="Papirus-Light"
        COLOR_SCHEME="prefer-light"
        ;;
    "rose-pine-d")
        GTK_THEME="Rosepine-Dark"
        ICON_THEME="Papirus-Dark"
        COLOR_SCHEME="prefer-dark"
        ;;
    "rose-pine-l")
        GTK_THEME="Rosepine-Light"
        ICON_THEME="Papirus-Light"
        COLOR_SCHEME="prefer-light"
        ;;
    *)
        echo "Use: $0 {gruvbox-material-d | gruvbox-material-l | rose-pine-d | rose-pine-l}"
        exit 1
        ;;
esac

# apply theme
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"

# modify settings.ini from GTK-3.0
GTK3_CONF="$HOME/.config/gtk-3.0/settings.ini"
if [ -f "$GTK3_CONF" ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" "$GTK3_CONF"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$ICON_THEME/" "$GTK3_CONF"
    if [ "$COLOR_SCHEME" == "prefer-dark" ]; then
        sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/" "$GTK3_CONF"
    else
        sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=0/" "$GTK3_CONF"
    fi
fi

# modify .gtkrc-2.0
GTK2_CONF="$HOME/.gtkrc-2.0"
if [ -f "$GTK2_CONF" ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=\"$GTK_THEME\"/" "$GTK2_CONF"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$ICON_THEME\"/" "$GTK2_CONF"
fi

# Hot Reload to XWayland
XSETTINGS_CONF="$HOME/.config/xsettingsd/xsettingsd.conf"
mkdir -p "$(dirname "$XSETTINGS_CONF")"

echo "Net/ThemeName \"$GTK_THEME\"" > "$XSETTINGS_CONF"
echo "Net/IconThemeName \"$ICON_THEME\"" >> "$XSETTINGS_CONF"
if [ "$COLOR_SCHEME" == "prefer-dark" ]; then
    echo "Gtk/ApplicationPreferDarkTheme 1" >> "$XSETTINGS_CONF"
else
    echo "Gtk/ApplicationPreferDarkTheme 0" >> "$XSETTINGS_CONF"
fi

pkill -HUP xsettingsd || xsettingsd &

rm -rf "$HOME/.config/gtk-4.0"
ln -sf "/usr/share/themes/$GTK_THEME/gtk-4.0" "$HOME/.config/gtk-4.0"
