import QtQuick
import "../../../core/theme" as Theme

/*!
    BarButton — interactive button for the bar.

    Supports active/toggle state with animated transitions.
    Intended for bar widgets only — for module UIs use QsButton instead.
*/
Rectangle {
    id: root

    property string glyph:  ""
    property string label:  ""
    property bool   active: false

    signal clicked()

    implicitWidth:  _row.implicitWidth  + Theme.ThemeManager.spacing.md * 2
    implicitHeight: _row.implicitHeight + Theme.ThemeManager.spacing.sm * 2

    radius: Theme.ThemeManager.radius.sm

    color: {
        if (active)              return Theme.ThemeManager.colors.accent.primary
        if (_area.containsMouse) return Theme.ThemeManager.colors.highlight.medium
        return "transparent"
    }

    Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacing.xs

        Text {
            visible:        root.glyph !== ""
            text:           root.glyph
            color:          root.active
                                ? Theme.ThemeManager.colors.surface.primary
                                : Theme.ThemeManager.colors.on.surface
            font.family:    Theme.ThemeManager.typography.family.icons
            font.pixelSize: Theme.ThemeManager.typography.iconSize
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }
        }

        Text {
            visible:        root.label !== ""
            text:           root.label
            color:          root.active
                                ? Theme.ThemeManager.colors.surface.primary
                                : Theme.ThemeManager.colors.on.surface
            font.pixelSize: Theme.ThemeManager.typography.size.sm
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }
        }
    }

    MouseArea {
        id: _area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        onClicked:    root.clicked()
    }
}
