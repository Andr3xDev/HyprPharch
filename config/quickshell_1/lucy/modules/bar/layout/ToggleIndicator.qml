import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*!
    Toogle sistem to hide information & show it by clicking the square with an icon
*/
Rectangle {
    id: toggleIndicator
    implicitWidth: label !== ""
    ? contentRow.implicitWidth + (spacing * 2)
    : implicitHeight
    implicitHeight: 25
    // Visuals
    color: expanded
        ? Theme.ThemeManager.currentPalette.color1
        : "transparent"
    radius: 4
    border.color: Theme.ThemeManager.currentPalette.color1
    border.width: 1

    // Values to show
    property string icon: ""
    property string label: ""
    property bool expanded: false

    signal toggled()

    // Animation to open
    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        id: buttonRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: icon
            color: expanded
                ? Theme.ThemeManager.currentPalette.color6
                : Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
            font.family: "Symbols Nerd Font"
            Layout.alignment: Qt.AlignCenter

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        Text {
            visible: label !== ""
            text: label
            color: expanded
                ? Theme.ThemeManager.currentPalette.base
                : Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            Layout.alignment: Qt.AlignCenter

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
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
        onEntered: toggleIndicator.scale = 1.1
        onExited: toggleIndicator.scale = 1.0
    }

    // Animation to open
    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}