import QtQuick
import QtQuick.Layouts
import "../../../../core/theme" as Theme

/*!
    List of available themes with preview color dots.
*/
Item {
    id: root
    implicitHeight: themeColumn.implicitHeight

    signal themeSelected(string themeId)

    // Color previews per theme — keys match availableThemes ids
    readonly property var themePreviewColors: ({
        "abysal-obsidian": ["#1c1c1c", "#52c9b0", "#e28e5a"],
        "abysal-marble":   ["#dcdcdc", "#2c9279", "#a04e1e"]
    })

    ColumnLayout {
        id: themeColumn
        anchors.fill: parent
        spacing: 6

        Repeater {
            model: Theme.ThemeManager.availableThemes

            delegate: Rectangle {
                id: themeItem
                Layout.fillWidth: true
                Layout.preferredHeight: 44

                property bool isActive:  modelData === Theme.ThemeManager.currentTheme
                property bool isHovered: itemMouseArea.containsMouse

                color: isActive
                    ? Theme.ThemeManager.colors.accent.primary
                    : (isHovered ? Theme.ThemeManager.colors.highlight.medium : "transparent")
                radius: 4
                border.color: isActive
                    ? Theme.ThemeManager.colors.border
                    : "transparent"
                border.width: isActive ? 1 : 0

                Behavior on color {
                    ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 12
                        rightMargin: 12
                    }
                    spacing: 10

                    // Active indicator bar
                    Rectangle {
                        Layout.preferredWidth: 3
                        Layout.preferredHeight: 18
                        radius: 1
                        color: Theme.ThemeManager.colors.border
                        opacity: themeItem.isActive ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                    }

                    // Theme name
                    Text {
                        Layout.fillWidth: true
                        text: Theme.ThemeManager.getThemeDisplayName(modelData)
                        color: themeItem.isActive
                            ? Theme.ThemeManager.colors.on.surface
                            : Theme.ThemeManager.colors.status.warning
                        font.pixelSize: Theme.ThemeManager.typography.size.sm
                        font.bold: themeItem.isActive
                        elide: Text.ElideRight

                        Behavior on color {
                            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                    }

                    // Color preview dots
                    Row {
                        spacing: 3

                        Repeater {
                            model: root.themePreviewColors[modelData] || []

                            delegate: Rectangle {
                                width: 12
                                height: 12
                                radius: 2
                                color: modelData
                                border.color: Qt.darker(modelData, 1.2)
                                border.width: 1
                                scale: themeItem.isHovered ? 1.1 : 1.0

                                Behavior on scale {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                                }
                            }
                        }
                    }

                    // Check icon for active theme
                    Text {
                        text: "󰄬"
                        color: Theme.ThemeManager.colors.on.surfaceMuted
                        font.pixelSize: Theme.ThemeManager.typography.iconSize
                        font.family: "Symbols Nerd Font"
                        opacity: themeItem.isActive ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                    }
                }

                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (!themeItem.isActive)
                            root.themeSelected(modelData)
                    }
                }
            }
        }
    }
}
