import QtQuick
import "../theme" as Theme

/*!
    QsSurface — primitive container component.

    Reads color and radius from ThemeManager tokens.
    No business logic, no service imports.

    Usage:
        QsSurface { }
        QsSurface { level: "secondary"; radiusKey: "lg" }
*/
Rectangle {
    id: root

    // Surface level: "primary" | "secondary" | "overlay"
    property string level: "primary"

    // Radius key: "none" | "sm" | "md" | "lg" | "xl" | "full"
    property string radiusKey: "md"

    color: {
        switch (level) {
            case "secondary": return Theme.ThemeManager.colors.surface.secondary
            case "overlay":   return Theme.ThemeManager.colors.surface.overlay
            default:          return Theme.ThemeManager.colors.surface.primary
        }
    }

    radius: {
        switch (radiusKey) {
            case "none": return Theme.ThemeManager.radius.none
            case "sm":   return Theme.ThemeManager.radius.sm
            case "lg":   return Theme.ThemeManager.radius.lg
            case "xl":   return Theme.ThemeManager.radius.xl
            case "full": return Theme.ThemeManager.radius.full
            default:     return Theme.ThemeManager.radius.md
        }
    }
}
