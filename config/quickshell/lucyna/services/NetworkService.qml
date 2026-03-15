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
    
    // Accumulated lines from parser
    property var _lines: []
    property int _lineCount: 0
    
    // Consolidated network status check (replaces 3 separate processes)
    property Process _networkProcess: Process {
        running: false
        command: ["sh", "-c", `
            # Check wifi status
            nmcli -t -f TYPE,STATE device | grep -q '^wifi:connected' && echo "true" || echo "false"
            # Check ethernet status
            nmcli -t -f TYPE,STATE device | grep -q '^ethernet:connected' && echo "true" || echo "false"
            # Get SSID if wifi is connected
            nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2
        `]
        
        stdout: SplitParser {
            onRead: data => {
                const line = data.trim()
                if (line.length > 0) {
                    root._lines.push(line)
                    root._lineCount++
                }
            }
        }
        
        onExited: (code, status) => {
            // Process accumulated lines when command completes
            if (root._lineCount >= 2) {
                root.wifiEnabled = root._lines[0] === "true"
                root.ethernetEnabled = root._lines[1] === "true"
                root.wifiSsid = root._lines[2] || ""
            }
            // Reset for next run
            root._lines = []
            root._lineCount = 0
        }
    }
    
    // Read info every 2 seconds
    property Timer _pollTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: _networkProcess.running = true
    }
    
    /*!
        Opens the TUI tool to manager the internet connections & devices
        TODO: Move to centralized app execution manager when implemented
    */
    function openNetworkManager() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["ghostty", "-e", "nmtui"]
                onExited: destroy()
            }
        `, root)
    }
}