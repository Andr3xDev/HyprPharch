import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services

/*!
    Group of controls to manage PC's components like network or volume
*/
Item {
    id: root
    implicitWidth: visible ? controlsRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true
    
    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.currentPalette.spacing - 5
        opacity: root.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
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
                    ? Theme.ThemeManager.currentPalette.color1
                    : Theme.ThemeManager.currentPalette.color4
                font.pixelSize: Theme.ThemeManager.currentPalette.iconFontSize
                font.family: "Symbols Nerd Font"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.NetworkService.openNetworkManager()

                // Hover animation each icon
                hoverEnabled: true
                onEntered: networkIconText.scale = 1.1
                onExited: networkIconText.scale = 1.0
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
                    ? Theme.ThemeManager.currentPalette.color1
                    : Theme.ThemeManager.currentPalette.color4
                font.pixelSize: Theme.ThemeManager.currentPalette.iconFontSize
                font.family: "Symbols Nerd Font"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.BluetoothService.openBluetoothManager()
                
                // Hover animation each icon
                hoverEnabled: true
                onEntered: bluetoothIconText.scale = 1.1
                onExited: bluetoothIconText.scale = 1.0
            }
        }
        
        // Audio
        Item {
            Layout.preferredWidth: audioRow.implicitWidth
            Layout.preferredHeight: 24
            
            RowLayout {
                id: audioRow
                anchors.centerIn: parent
                spacing: 4
                
                Text {
                    id: aIconText
                    text: Services.AudioService.muted ? " 󰖁" : 
                          Services.AudioService.volume > 50 ? " 󰕾" : " 󰖀"
                    color: Services.AudioService.muted
                        ? Theme.ThemeManager.currentPalette.color4
                        : Theme.ThemeManager.currentPalette.color1
                    font.pixelSize: Theme.ThemeManager.currentPalette.iconFontSize
                    font.family: "Symbols Nerd Font"
                }
                
                Text {
                    text: `${Services.AudioService.volume}%`
                    color: Theme.ThemeManager.currentPalette.text
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                // Hover animation each icon
                hoverEnabled: true
                onEntered: aIconText.scale = 1.1
                onExited: aIconText.scale = 1.0
                
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
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}