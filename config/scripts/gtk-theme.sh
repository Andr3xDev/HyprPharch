#!/bin/bash

source "${HOME}/.config/scripts/logger.sh"
log INFO "-------------------------------"
log INFO "Applying theme: ${1}"

case "$1" in
    "abysal-obsidian")
        GTK_THEME="Abysal-Obsidian"
        ICON_THEME="Papirus-Dark"
        COLOR_SCHEME="prefer-dark"
        CURSOR="phinger-cursors-light"
        CURSOR_SIZE=25
        ;;
    "abysal-marble")
        GTK_THEME="Abysal-Marble"
        ICON_THEME="Papirus-Light"
        COLOR_SCHEME="prefer-light"
        CURSOR="phinger-cursors-light"
        CURSOR_SIZE=25
        ;;
    *)
        log ERROR "Invalid theme: ${1}"
        exit 1
        ;;
esac

# apply theme
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR"
gsettings set org.gnome.desktop.interface cursor-size "$CURSOR_SIZE"
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"

# GTK 3 config
GTK3_CONF="$HOME/.config/gtk-3.0/settings.ini"
if [ -f "$GTK3_CONF" ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" "$GTK3_CONF"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$ICON_THEME/" "$GTK3_CONF"
    sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$CURSOR/" "$GTK3_CONF"
    if [ "$COLOR_SCHEME" == "prefer-dark" ]; then
        sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/" "$GTK3_CONF"
    else
        sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=0/" "$GTK3_CONF"
    fi
fi

# GTK 2 config
GTK2_CONF="$HOME/.gtkrc-2.0"
if [ -f "$GTK2_CONF" ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=\"$GTK_THEME\"/" "$GTK2_CONF"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$ICON_THEME\"/" "$GTK2_CONF"
    sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$CURSOR\"/" "$GTK2_CONF"
    sed -i "s/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=\"$CURSOR_SIZE\"/" "$GTK2_CONF"
fi

# Hot Reload to XWayland
XSETTINGS_CONF="$HOME/.config/xsettingsd/xsettingsd.conf"
mkdir -p "$(dirname "$XSETTINGS_CONF")"

echo "Net/ThemeName \"$GTK_THEME\"" > "$XSETTINGS_CONF"
echo "Net/IconThemeName \"$ICON_THEME\"" >> "$XSETTINGS_CONF"
echo "Gtk/CursorThemeName \"$CURSOR\"" >> "$XSETTINGS_CONF"
echo "Gtk/CursorThemeSize $CURSOR_SIZE" >> "$XSETTINGS_CONF"
if [ "$COLOR_SCHEME" == "prefer-dark" ]; then
    echo "Gtk/ApplicationPreferDarkTheme 1" >> "$XSETTINGS_CONF"
else
    echo "Gtk/ApplicationPreferDarkTheme 0" >> "$XSETTINGS_CONF"
fi

pkill -HUP xsettingsd || xsettingsd &

# GTK 4 config
rm -rf "$HOME/.config/gtk-4.0"
# (Validación recomendada: Solo enlazar si existe)
if [ -d "/usr/share/themes/$GTK_THEME/gtk-4.0" ]; then
    ln -sf "/usr/share/themes/$GTK_THEME/gtk-4.0" "$HOME/.config/gtk-4.0"
fi

# hyprland cursor
hyprctl setcursor "$CURSOR" "$CURSOR_SIZE"

log SUCCESS "Theme applied successfully: ${1}"
