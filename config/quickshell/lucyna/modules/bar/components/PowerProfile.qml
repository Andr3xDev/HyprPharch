import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "../../../core/services" as Services

/*!
    Power profile selector component to set different profiles
*/
Item {
    id: root
    property bool expanded: false

    implicitWidth: expanded ? profileRow.implicitWidth : 0
    implicitHeight: parent.height
    visible: expanded || implicitWidth > 0
    clip: true
    
    // Profile color mapping
    readonly property var profileColors: ({
        "power-saver": Theme.ThemeManager.colors.accent.tertiary,
        "balanced": Theme.ThemeManager.colors.status.warning,
        "performance": Theme.ThemeManager.colors.status.error
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
                property color profileColor: root.profileColors[modelData.id] || Theme.ThemeManager.colors.on.surface
                
                ColumnLayout {
                    id: buttonContent
                    spacing: 1
                    
                    // Icon
                    Text {
                        id: iconText
                        text: modelData.icon
                        color: profileButton.isActive
                            ? profileButton.profileColor
                            : Theme.ThemeManager.colors.on.surface
                        font.pixelSize: Theme.ThemeManager.typography.iconSize
                        font.family: Theme.ThemeManager.typography.family.icons
                        Layout.alignment: Qt.AlignHCenter
                        
                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.ThemeManager.motion.duration.standard
                                easing.type: Theme.ThemeManager.motion.easing.standard
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
                                duration: Theme.ThemeManager.motion.duration.standard
                                easing.type: Theme.ThemeManager.motion.easing.standard
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
            duration: Theme.ThemeManager.motion.duration.standard
            easing.type: Theme.ThemeManager.motion.easing.standard
        }
    }
}