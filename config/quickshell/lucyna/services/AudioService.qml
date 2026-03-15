pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Audio service manages volume state from the default system device to output sound
    
    Uses hybrid polling: slow 1000ms in rest, fast 100ms burst for 3s during user interaction
    
    TODO: Refactor to eliminate Qt.createQmlObject() usage
          - Replace dynamic object creation with Component-based approach
          - This will improve memory management and code maintainability
          - Consider using defined Process components instead of creating them dynamically
*/
Singleton {
    id: root
    
    // Public properties
    property bool muted: false
    property int volume: 0
    
    // Hybrid polling state
    property bool _fastPolling: false
    property int _slowInterval: 1000
    property int _fastInterval: 100
    property int _fastDuration: 3000  // 3 seconds of fast polling after user interaction
    
    // Get actual value from the default device
    property Process _volumeProcess: Process {
        running: false
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"]
        stdout: SplitParser {
            onRead: data => {
                const vol = parseInt(data.trim())
                if (!isNaN(vol)) root.volume = vol
            }
        }
    }
    
    // Get mute status from the default device
    property Process _muteProcess: Process {
        running: false
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false"]
        stdout: SplitParser {
            onRead: data => root.muted = data.trim() === "true"
        }
    }
    
    // Updates the values with dynamic interval based on activity
    property Timer _pollTimer: Timer {
        interval: root._slowInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _volumeProcess.running = true
            _muteProcess.running = true
        }
    }
    
    // Timer to return to slow polling after user interaction
    property Timer _fastPollTimer: Timer {
        interval: root._fastDuration
        running: false
        repeat: false
        onTriggered: {
            root._fastPolling = false
            _pollTimer.interval = root._slowInterval
        }
    }
    
    /*!
        Enable fast polling temporarily after user interaction
    */
    function _enableFastPolling() {
        if (!root._fastPolling) {
            root._fastPolling = true
            _pollTimer.interval = root._fastInterval
        }
        _fastPollTimer.restart()
    }
    
    /*!
        Allow mute default device from a component
    */
    function toggleMute() {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                onExited: destroy()
            }
        `, root)
        _enableFastPolling()
    }
    
    /*!
        Allow change volume level from 0 to 150 or the default value of the device
    */
    function changeVolume(step) {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "${step}"]
                onExited: destroy()
            }
        `, root)
        _enableFastPolling()
    }
}