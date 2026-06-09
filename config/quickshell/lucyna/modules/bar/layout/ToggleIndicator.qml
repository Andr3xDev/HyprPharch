import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme

/*!
    Toogle sistem to hide information & show it by clicking the square with an icon
*/
Rectangle {
    id: toggleIndicator
    implicitWidth: label !== ""
        ? buttonRow.implicitWidth + (hPad * 2)
        : implicitHeight
    implicitHeight: 20
    readonly property real hPad: Theme.ThemeManager.spacing.xs
    // Visuals
    color: expanded
        ? Theme.ThemeManager.colors.highlight.strong
        : "transparent"
    radius: Theme.ThemeManager.radius.sm
    border.color: Theme.ThemeManager.colors.highlight.strong
    border.width: 1

    // Values to show
    property string icon: ""
    property string label: ""
    property bool expanded: false

    signal toggled()

    // Animation to open
    Behavior on color {
        ColorAnimation {
            duration: Theme.ThemeManager.motion.duration.standard
            easing.type: Theme.ThemeManager.motion.easing.standard
        }
    }

    RowLayout {
        id: buttonRow
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacing.xs

        Text {
            text: icon
            color: expanded
                ? Theme.ThemeManager.colors.accent.secondary
                : Theme.ThemeManager.colors.on.surface
            font.pixelSize: Theme.ThemeManager.typography.iconSize
            font.family: Theme.ThemeManager.typography.family.icons
            Layout.alignment: Qt.AlignCenter

            Behavior on color {
                ColorAnimation {
                    duration: Theme.ThemeManager.motion.duration.standard
                    easing.type: Theme.ThemeManager.motion.easing.standard
                }
            }
        }

        Text {
            visible: label !== ""
            text: label
            color: expanded
                ? Theme.ThemeManager.colors.surface.primary
                : Theme.ThemeManager.colors.on.surface
            font.pixelSize: Theme.ThemeManager.typography.size.sm
            Layout.alignment: Qt.AlignCenter

            Behavior on color {
                ColorAnimation {
                    duration: Theme.ThemeManager.motion.duration.standard
                    easing.type: Theme.ThemeManager.motion.easing.standard
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            expanded = !expanded
            toggleIndicator.toggled()
        }

        hoverEnabled: true
        onEntered: toggleIndicator.scale = 1.2
        onExited: toggleIndicator.scale = 1.0
    }

    // Animation to scale on hover
    Behavior on scale {
        NumberAnimation {
            duration: Theme.ThemeManager.motion.duration.fast
            easing.type: Theme.ThemeManager.motion.easing.standard
        }
    }
}