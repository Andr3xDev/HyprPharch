import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*!
    List of available themes with preview colors
*/
Item {
    id: root
    implicitHeight: themeColumn.implicitHeight

    signal themeSelected(string themeId)

    // Color previews for each theme (base + 2 accent colors)
    readonly property var themePreviewColors: ({
        "rose-pine-d": ["#191724", "#eb6f92", "#c4a7e7"],
        "rose-pine-l": ["#faf4ed", "#b4637a", "#907aa9"],
        "gruvbox-material-d": ["#282828", "#EA6962", "#7DAEA3"],
        "gruvbox-material-l": ["#FBF1C7", "#C14A4A", "#45707A"]
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
                
                property bool isActive: modelData === Theme.ThemeManager.currentTheme
                property bool isHovered: itemMouseArea.containsMouse

                color: isActive 
                    ? Theme.ThemeManager.currentPalette.color1
                    : (isHovered ? Theme.ThemeManager.currentPalette.color10 : "transparent")
                radius: 4
                border.color: isActive 
                    ? Theme.ThemeManager.currentPalette.color9 
                    : "transparent"
                border.width: isActive ? 1 : 0

                Behavior on color {
                    ColorAnimation { 
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 12
                        rightMargin: 12
                    }
                    spacing: 10

                    // Active indicator
                    Rectangle {
                        Layout.preferredWidth: 3
                        Layout.preferredHeight: 18
                        radius: 1
                        color: Theme.ThemeManager.currentPalette.color9
                        opacity: themeItem.isActive ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { 
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    // Theme name
                    Text {
                        Layout.fillWidth: true
                        text: Theme.ThemeManager.getThemeDisplayName(modelData)
                        color: themeItem.isActive 
                            ? Theme.ThemeManager.currentPalette.text
                            : Theme.ThemeManager.currentPalette.color3
                        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                        font.bold: themeItem.isActive
                        elide: Text.ElideRight

                        Behavior on color {
                            ColorAnimation { 
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
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

                                // Subtle scale on hover
                                scale: themeItem.isHovered ? 1.1 : 1.0

                                Behavior on scale {
                                    NumberAnimation { 
                                        duration: 150
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        }
                    }

                    // Check icon for active theme
                    Text {
                        text: "󰄬"
                        color: Theme.ThemeManager.currentPalette.color8
                        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
                        font.family: "Symbols Nerd Font"
                        opacity: themeItem.isActive ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { 
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        if (!themeItem.isActive) {
                            root.themeSelected(modelData)
                        }
                    }
                }
            }
        }
    }
}