pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Bluetooth service manages connections & status data, only to show
    TODO: Add connection state detection (enabled vs connected) - UI binding issue prevents showing 3 states
*/
Singleton {
    id: root

    // Public properties
    property bool enabled: false

    // Check if bt is active
    property Process _btProcess: Process {
        running: false
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        stdout: SplitParser {
            onRead: data => {
                root.enabled = data.trim() === "yes"
            }
        }
    }

    // Timer to update data from bt
    property Timer _pollTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: _btProcess.running = true
    }

    // Fire-and-forget process template for one-shot commands
    property Component _fireAndForget: Component {
        Process { onExited: destroy() }
    }

    /*!
        Open TUI tool to manage all bt connections & states
    */
    function openBluetoothManager() {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["ghostty", "-e", "bluetui"]
        })
    }
}
