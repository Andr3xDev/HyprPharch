import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services

/*!
    Power profile selector component to set diferent profiles
*/
Item {
    id: root
    implicitWidth: visible ? profileRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true
    
    // Profile color mapping
    readonly property var profileColors: ({
        "power-saver": Theme.ThemeManager.currentPalette.color9,
        "balanced": Theme.ThemeManager.currentPalette.color5,
        "performance": Theme.ThemeManager.currentPalette.color4
    })
    
    RowLayout {
        id: profileRow
        anchors.centerIn: parent
        spacing: 15
        
        Repeater {
            model: Services.PowerService.profiles
            delegate: Item {
                id: profileButton
                Layout.preferredWidth: buttonContent.implicitWidth
                Layout.preferredHeight: buttonContent.implicitHeight
                
                property bool isActive: modelData.id === Services.PowerService.currentProfile
                property color profileColor: root.profileColors[modelData.id] || Theme.ThemeManager.currentPalette.text
                
                ColumnLayout {
                    id: buttonContent
                    spacing: 1
                    
                    // Icon
                    Text {
                        id: iconText
                        text: modelData.icon
                        color: profileButton.isActive 
                            ? profileButton.profileColor
                            : Theme.ThemeManager.currentPalette.text
                        font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
                        font.family: "Symbols Nerd Font"
                        Layout.alignment: Qt.AlignHCenter
                        
                        Behavior on color {
                            ColorAnimation { 
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    
                    // Underline indicator
                    Rectangle {
                        Layout.preferredWidth: iconText.implicitWidth
                        Layout.preferredHeight: 2
                        Layout.alignment: Qt.AlignHCenter
                        color: profileButton.profileColor
                        radius: 1
                        opacity: profileButton.isActive ? 1 : 0
                        
                        Behavior on opacity {
                            NumberAnimation { 
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.PowerService.setProfile(modelData.id)
                    
                    // Hover animation each icon
                    hoverEnabled: true
                    onEntered: iconText.scale = 1.1
                    onExited: iconText.scale = 1.0
                }
            }
        }
    }
    
    // Animation to toggle
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
}