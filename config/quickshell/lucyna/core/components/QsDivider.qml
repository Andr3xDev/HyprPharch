import QtQuick
import "../theme" as Theme

/*!
    QsDivider — primitive separator component.

    Reads color from ThemeManager tokens. Can be horizontal or vertical.
    No business logic, no service imports.

    Usage:
        QsDivider { }                          // horizontal, full width
        QsDivider { orientation: Qt.Vertical } // vertical, full height
        QsDivider { colorRole: "accent" }      // accent color
*/
Rectangle {
    id: root

    // Qt.Horizontal (default) or Qt.Vertical
    property int orientation: Qt.Horizontal

    // Color role: "default" | "accent" | "muted"
    property string colorRole: "default"

    implicitWidth:  orientation === Qt.Horizontal ? parent.width : 1
    implicitHeight: orientation === Qt.Vertical   ? parent.height : 1

    color: {
        switch (colorRole) {
            case "accent": return Theme.ThemeManager.colors.accent.primary
            case "muted":  return Theme.ThemeManager.colors.on.surfaceMuted
            default:       return Theme.ThemeManager.colors.border
        }
    }
}
