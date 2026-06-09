import QtQuick
import "../theme" as Theme

/*!
    QsIcon — primitive nerd-font icon component.

    Reads size and color from ThemeManager tokens.
    No business logic, no service imports.

    Usage:
        QsIcon { glyph: "󰕾" }
        QsIcon { glyph: "󰕾"; colorRole: "accent" }
*/
Text {
    id: root

    // The nerd-font glyph character to display.
    property string glyph: ""

    // Color role: "default" | "accent" | "accentSecondary" | "muted"
    //             "error"   | "warning" | "success"
    property string colorRole: "default"

    text: glyph
    font.family: Theme.ThemeManager.typography.family.icons
    font.pixelSize: Theme.ThemeManager.typography.iconSize

    color: {
        switch (colorRole) {
            case "accent":          return Theme.ThemeManager.colors.accent.primary
            case "accentSecondary": return Theme.ThemeManager.colors.accent.secondary
            case "muted":           return Theme.ThemeManager.colors.on.surfaceMuted
            case "error":           return Theme.ThemeManager.colors.status.error
            case "warning":         return Theme.ThemeManager.colors.status.warning
            case "success":         return Theme.ThemeManager.colors.status.success
            default:                return Theme.ThemeManager.colors.on.surface
        }
    }
}
