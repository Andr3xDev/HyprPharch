pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Network service manages all internet connections, devices & status of the net
*/
Singleton {
    id: root
    
    // Public properties
    property bool wifiEnabled: false
    property bool ethernetEnabled: false
    property string wifiSsid: ""
    
    // Wifi connection validation
    property Process _wifiProcess: Process {
        running: false
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep -q '^wifi:connected' && echo true || echo false"]
        stdout: SplitParser {
            onRead: data => root.wifiEnabled = data.trim() === "true"
        }
    }
    
    // Ethernet connection validation
    property Process _ethernetProcess: Process {
        running: false
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep -q '^ethernet:connected' && echo true || echo false"]
        stdout: SplitParser {
            onRead: data => root.ethernetEnabled = data.trim() === "true"
        }
    }
    
    // Actual network connected name
    property Process _ssidProcess: Process {
        running: false
        command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2"]
        stdout: SplitParser {
            onRead: data => root.wifiSsid = data.trim()
        }
    }
    
    // Read info all the time
    property Timer _pollTimer: Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _wifiProcess.running = true
            _ethernetProcess.running = true
            _ssidProcess.running = true
        }
    }
    
    /*!
        Opens the TUI tool to managger the internet connections & devces
    */
    function openNetworkManager() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["kitty", "-e", "nmtui"]
                onExited: destroy()
            }
        `, root)
    }
}