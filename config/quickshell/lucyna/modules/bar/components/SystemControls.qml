import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "../../../core/services" as Services

/*!
    Group of controls to manage PC's components like network or volume
*/
Item {
    id: root
    property bool expanded: false

    implicitWidth: expanded ? controlsRow.implicitWidth : 0
    implicitHeight: parent.height
    visible: expanded || implicitWidth > 0
    clip: true
    
    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacing.xs
        opacity: root.expanded ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: Theme.ThemeManager.motion.duration.standard }
        }
        
        // Network
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            
            Text {
                id: networkIconText
                anchors.centerIn: parent
                text: Services.NetworkService.ethernetEnabled ? "󰈀" :
                      (Services.NetworkService.wifiEnabled ? "󰖩" : "󰖪")
                color: (Services.NetworkService.ethernetEnabled ||
                        Services.NetworkService.wifiEnabled)
                    ? Theme.ThemeManager.colors.accent.primary
                    : Theme.ThemeManager.colors.status.error
                font.pixelSize: Theme.ThemeManager.typography.iconSize
                font.family: Theme.ThemeManager.typography.family.icons

                Behavior on scale {
                    NumberAnimation { duration: Theme.ThemeManager.motion.duration.fast; easing.type: Theme.ThemeManager.motion.easing.standard }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: Services.NetworkService.openNetworkManager()
                onEntered: networkIconText.scale = 1.1
                onExited:  networkIconText.scale = 1.0
            }
        }
        
        // Bluetooth
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            
            Text {
                id: bluetoothIconText
                anchors.centerIn: parent
                text: Services.BluetoothService.enabled ? "󰂯" : "󰂲"
                color: Services.BluetoothService.enabled
                    ? Theme.ThemeManager.colors.accent.primary
                    : Theme.ThemeManager.colors.status.error
                font.pixelSize: Theme.ThemeManager.typography.iconSize
                font.family: Theme.ThemeManager.typography.family.icons

                Behavior on scale {
                    NumberAnimation { duration: Theme.ThemeManager.motion.duration.fast; easing.type: Theme.ThemeManager.motion.easing.standard }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: Services.BluetoothService.openBluetoothManager()
                onEntered: bluetoothIconText.scale = 1.1
                onExited:  bluetoothIconText.scale = 1.0
            }
        }
        
        // Audio
        Item {
            Layout.preferredWidth: audioRow.implicitWidth
            Layout.preferredHeight: 24
            
            RowLayout {
                id: audioRow
                anchors.centerIn: parent
                spacing: Theme.ThemeManager.spacing.xs
                
                Text {
                    id: aIconText
                    text: Services.AudioService.muted ? " 󰖁" :
                          Services.AudioService.volume > 50 ? " 󰕾" : " 󰖀"
                    color: Services.AudioService.muted
                        ? Theme.ThemeManager.colors.status.error
                        : Theme.ThemeManager.colors.accent.primary
                    font.pixelSize: Theme.ThemeManager.typography.iconSize
                    font.family: Theme.ThemeManager.typography.family.icons

                    Behavior on scale {
                        NumberAnimation { duration: Theme.ThemeManager.motion.duration.fast; easing.type: Theme.ThemeManager.motion.easing.standard }
                    }
                }
                
                Text {
                    text: `${Services.AudioService.volume}%`
                    color: Theme.ThemeManager.colors.on.surface
                    font.pixelSize: Theme.ThemeManager.typography.size.sm
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: aIconText.scale = 1.1
                onExited:  aIconText.scale = 1.0
                
                // Scroll set values
                property int wheelAccumulator: 0
                onClicked: Services.AudioService.toggleMute()
                onWheel: wheel => {
                    wheelAccumulator += wheel.angleDelta.y
                    const stepThreshold = 120
                    
                    while (wheelAccumulator >= stepThreshold) {
                        Services.AudioService.changeVolume("1%+")
                        wheelAccumulator -= stepThreshold
                    }
                    while (wheelAccumulator <= -stepThreshold) {
                        Services.AudioService.changeVolume("1%-")
                        wheelAccumulator += stepThreshold
                    }
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