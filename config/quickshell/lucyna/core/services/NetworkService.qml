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

        // Lines accumulate per-run inside the Process to avoid cross-run pollution
        property var _lines: []

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim()
                if (line.length > 0)
                    _networkProcess._lines.push(line)
            }
        }

        onExited: {
            const lines = _networkProcess._lines
            if (lines.length >= 2) {
                root.wifiEnabled    = lines[0] === "true"
                root.ethernetEnabled = lines[1] === "true"
                root.wifiSsid       = lines[2] || ""
            }
            _networkProcess._lines = []
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

    // Fire-and-forget process template for one-shot commands
    property Component _fireAndForget: Component {
        Process { onExited: destroy() }
    }

    /*!
        Opens the TUI tool to manage the internet connections & devices
    */
    function openNetworkManager() {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["ghostty", "-e", "nmtui"]
        })
    }
}
