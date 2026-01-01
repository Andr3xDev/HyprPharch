pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Audio service manages volume state from the default system device to output sound
*/
Singleton {
    id: root
    
    // Public properties
    property bool muted: false
    property int volume: 0
    
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
    
    // Updates the values all the time to show the actions over the volumen component
    property Timer _pollTimer: Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _volumeProcess.running = true
            _muteProcess.running = true
        }
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
        _scheduleRefresh()
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
        _scheduleRefresh()
    }
    
    /*!
        Allow to update all data from volume to show real time modifications
    */
    function _scheduleRefresh() {
        Qt.createQmlObject(`
            import QtQuick
            Timer {
                interval: 10
                running: true
                repeat: false
                onTriggered: {
                    root._volumeProcess.running = true
                    root._muteProcess.running = true
                    destroy()
                }
            }
        `, root)
    }
}