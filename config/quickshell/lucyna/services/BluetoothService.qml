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
    
    /*!
        Open TUI tool to manage all bt connectons & states
        TODO: Move to centralized app execution manager when implemented
    */
    function openBluetoothManager() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["ghostty", "-e", "bluetui"]
                onExited: destroy()
            }
        `, root)
    }
}