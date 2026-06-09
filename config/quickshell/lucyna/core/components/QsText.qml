import QtQuick
import "../theme" as Theme

/*!
    QsText — primitive text component.

    Always reads typography and color from ThemeManager semantic tokens.
    No business logic, no service imports.

    Usage:
        QsText { text: "Hello"; role: "title"; muted: true }
*/
Text {
    id: root

    // Visual role: "body" | "subtitle" | "title" | "caption" | "icon"
    property string role: "body"

    // When true, uses the muted (secondary) text color.
    property bool muted: false

    color: muted
        ? Theme.ThemeManager.colors.on.surfaceMuted
        : Theme.ThemeManager.colors.on.surface

    font.pixelSize: {
        switch (role) {
            case "caption":  return Theme.ThemeManager.typography.size.xs
            case "body":     return Theme.ThemeManager.typography.size.sm
            case "subtitle": return Theme.ThemeManager.typography.size.md
            case "title":    return Theme.ThemeManager.typography.size.lg
            default:         return Theme.ThemeManager.typography.size.sm
        }
    }
}
