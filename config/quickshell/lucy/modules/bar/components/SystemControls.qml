import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../theme" as Theme

Item {
    id: systemControls
    
    implicitWidth: visible ? controlsRow.implicitWidth : 0
    implicitHeight: 25
    width: implicitWidth
    height: implicitHeight
    
    clip: true
    
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    
    // Estados
    property bool wifiEnabled: false
    property string wifiSsid: ""
    property bool bluetoothEnabled: false
    property bool audioMuted: false
    property int audioVolume: 0
    property bool micMuted: false
    
    Timer {
        interval: 2000
        running: parent.visible
        repeat: true
        onTriggered: updateStates()
    }
    
    Component.onCompleted: updateStates()
    
    function updateStates() {
        // WiFi status
        var wifiProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "nmcli -t -f DEVICE,STATE device | grep wifi | cut -d':' -f2"]
                stdout: SplitParser {
                    onRead: data => {
                        wifiEnabled = data.trim() === "connected"
                    }
                }
            }
        `, parent, "wifiProcess")
        
        // WiFi SSID
        var ssidProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2"]
                stdout: SplitParser {
                    onRead: data => {
                        wifiSsid = data.trim()
                    }
                }
            }
        `, parent, "ssidProcess")
        
        // Bluetooth status
        var btProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
                stdout: SplitParser {
                    onRead: data => {
                        bluetoothEnabled = data.trim() === "yes"
                    }
                }
            }
        `, parent, "btProcess")
        
        // Audio volume
        var volumeProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "pamixer --get-volume"]
                stdout: SplitParser {
                    onRead: data => {
                        audioVolume = parseInt(data.trim()) || 0
                    }
                }
            }
        `, parent, "volumeProcess")
        
        // Audio mute status
        var muteProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "pamixer --get-mute"]
                stdout: SplitParser {
                    onRead: data => {
                        audioMuted = data.trim() === "true"
                    }
                }
            }
        `, parent, "muteProcess")
        
        // Mic mute status
        var micProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "pamixer --source 0 --get-mute 2>/dev/null || echo false"]
                stdout: SplitParser {
                    onRead: data => {
                        micMuted = data.trim() === "true"
                    }
                }
            }
        `, parent, "micProcess")
    }
    
    function toggleWifi() {
        var cmd = wifiEnabled ? "nmcli radio wifi off" : "nmcli radio wifi on"
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "${cmd}"]
            }
        `, parent, "wifiToggle")
        updateStates()
    }
    
    function toggleBluetooth() {
        var cmd = bluetoothEnabled ? "bluetoothctl power off" : "bluetoothctl power on"
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "${cmd}"]
            }
        `, parent, "btToggle")
        updateStates()
    }
    
    function toggleAudioMute() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["pamixer", "--toggle-mute"]
            }
        `, parent, "audioMuteToggle")
        updateStates()
    }
    
    function toggleMicMute() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "pamixer --source 0 --toggle-mute"]
            }
        `, parent, "micMuteToggle")
        updateStates()
    }
    
    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: 8
        opacity: systemControls.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // WiFi
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: wifiEnabled 
                ? Theme.ThemeManager.currentPalette.color3 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            
            Text {
                anchors.centerIn: parent
                text: wifiEnabled ? "󰖩" : "󰖪"
                color: wifiEnabled 
                    ? Theme.ThemeManager.currentPalette.base 
                    : Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
                font.family: "Symbols Nerd Font"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: toggleWifi()
            }
        }
        
        // Bluetooth
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: bluetoothEnabled 
                ? Theme.ThemeManager.currentPalette.color5 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            
            Text {
                anchors.centerIn: parent
                text: bluetoothEnabled ? "󰂯" : "󰂲"
                color: bluetoothEnabled 
                    ? Theme.ThemeManager.currentPalette.base 
                    : Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
                font.family: "Symbols Nerd Font"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: toggleBluetooth()
            }
        }
        
        // Audio
        Rectangle {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 25
            color: "transparent"
            border.color: Theme.ThemeManager.currentPalette.color1
            border.width: 1
            radius: 4
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 4
                
                Text {
                    text: audioMuted ? "󰖁" : audioVolume > 50 ? "󰕾" : "󰖀"
                    color: audioMuted 
                        ? Theme.ThemeManager.currentPalette.color4 
                        : Theme.ThemeManager.currentPalette.text
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                    font.family: "Symbols Nerd Font"
                }
                
                Text {
                    text: `${audioVolume}%`
                    color: Theme.ThemeManager.currentPalette.text
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize - 1
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: toggleAudioMute()
            }
        }
        
        // Microphone
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: micMuted 
                ? Theme.ThemeManager.currentPalette.color4 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            
            Text {
                anchors.centerIn: parent
                text: micMuted ? "󰍭" : "󰍬"
                color: micMuted 
                    ? Theme.ThemeManager.currentPalette.base 
                    : Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
                font.family: "Symbols Nerd Font"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: toggleMicMute()
            }
        }
    }
}