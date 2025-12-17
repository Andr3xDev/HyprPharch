pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Bluetooth service manages connections & status data, only to show
*/
Singleton {
    id: root
    
    // Public properties
    property bool enabled: false
    
    // Check if bt is active & number of connections
    property Process _btProcess: Process {
        running: false
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        stdout: SplitParser {
            onRead: data => root.enabled = data.trim() === "yes"
        }
    }
    
    // Timer to update data from bt
    property Timer _pollTimer: Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: _btProcess.running = true
    }
    
    /*!
        Open TUI tool to manage all bt connectons & states
    */
    function openBluetoothManager() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["kitty", "-e", "bluetui"]
                onExited: destroy()
            }
        `, root)
    }
}