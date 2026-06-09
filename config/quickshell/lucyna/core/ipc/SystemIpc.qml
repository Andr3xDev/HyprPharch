pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    SystemIpc — Facade for all non-Hyprland system commands.

    Services in core/services/ delegate here instead of spawning
    Process objects directly. Centralises all shell-command execution
    for audio, bluetooth, network, and other OS-level operations.
*/
Singleton {
    id: root

    property Component _fireAndForget: Component {
        Process { onExited: destroy() }
    }

    // ── Audio ─────────────────────────────────────────────

    function toggleMute() {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        })
    }

    function setVolume(step) {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", step]
        })
    }

    // ── Bluetooth ─────────────────────────────────────────

    function openBluetoothManager() {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["ghostty", "-e", "bluetui"]
        })
    }

    // ── Network ───────────────────────────────────────────

    function openNetworkManager() {
        _fireAndForget.createObject(root, {
            running: true,
            command: ["ghostty", "-e", "nmtui"]
        })
    }

    // ── Power ─────────────────────────────────────────────

    function suspend()  { _fireAndForget.createObject(root, { running: true, command: ["systemctl", "suspend"] }) }
    function shutdown() { _fireAndForget.createObject(root, { running: true, command: ["systemctl", "poweroff"] }) }
    function reboot()   { _fireAndForget.createObject(root, { running: true, command: ["systemctl", "reboot"] }) }
    function lock()     { _fireAndForget.createObject(root, { running: true, command: ["hyprlock"] }) }
}
