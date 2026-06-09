pragma Singleton

import QtQuick
import Quickshell
import "../builders"
import "../infra"
import "../adapters"
import "../../../core/ipc" as Ipc

/*!
    MonitorService — Singleton + Observer.

    Central state manager for the monitor module.

    Reactive state:
      monitors[]         — current MonitorState[], updated on every refresh

    Ephemeral preview:
      applyEphemeral(name, changes) — applies changes locally + to Hyprland (no file write)

    Commit:
      commit()           — writes monitors.generated.lua + reloads Hyprland
      signal committed(ok, errorMessage) — emitted when commit finishes
*/
QtObject {
    id: root

    // ── Reactive state ────────────────────────────────────
    property var monitors: []

    // ── Signals ───────────────────────────────────────────
    signal committed(bool ok, string errorMessage)

    // ── Config output path ────────────────────────────────
    readonly property string _outputPath:
        Quickshell.env("HOME") + "/.config/hypr/configs/monitors_generated.lua"

    // ── Component instances ───────────────────────────────
    property MonitorAdapter        _adapter:       MonitorAdapter { }
    property MonitorConfigBuilder  _configBuilder: MonitorConfigBuilder { }
    property LuaSerializer         _serializer:    LuaSerializer { }

    property FileWriter _fileWriter: FileWriter {
        onWriteCompleted: function(ok, errorMessage) {
            if (ok)
                Ipc.HyprlandIpc.reload()
            else
                console.warn("MonitorService.commit: write failed —", errorMessage)
            root.committed(ok, errorMessage)
        }
    }

    // ── EventBus listeners ────────────────────────────────
    property Connections _busConnections: Connections {
        target: Ipc.EventBus
        function onMonitorConnected(monitorName)    { root.refresh() }
        function onMonitorDisconnected(monitorName) { root.refresh() }
    }

    // Wait for IdentityService to finish loading from disk before the first
    // refresh(). Without this, parse() runs with an empty registry and
    // register() overwrites saved aliases with model-name defaults.
    property Connections _identityConnections: Connections {
        target: IdentityService
        function onLoaded() { root.refresh() }
    }

    // ── Public API ────────────────────────────────────────

    function refresh() {
        Ipc.HyprlandIpc.getMonitors(function(raw) {
            monitors = _adapter.parse(raw)
        })
    }

    /*!
        Applies a partial change to a monitor both locally and in Hyprland
        (ephemeral — not persisted until commit()).

        changes may contain any subset of:
          mode:      { width, height, refreshRate }
          position:  { x, y }
          scale:     float
          transform: int
          enabled:   bool
    */
    function applyEphemeral(monitorName, changes) {
        const idx = monitors.findIndex(m => m.name === monitorName)
        if (idx < 0) return

        const current = monitors[idx]
        const updated = Object.assign({}, current, {
            activeMode: changes.mode      !== undefined ? changes.mode      : current.activeMode,
            position:   changes.position  !== undefined ? changes.position  : current.position,
            scale:      changes.scale     !== undefined ? changes.scale     : current.scale,
            transform:  changes.transform !== undefined ? changes.transform : current.transform,
            enabled:    changes.enabled   !== undefined ? changes.enabled   : current.enabled,
            cm:         changes.cm        !== undefined ? changes.cm        : current.cm,
        })

        const arr = [...monitors]
        arr[idx]  = updated
        monitors  = arr

        Ipc.HyprlandIpc.setKeyword("monitor", _buildKeyword(updated))
    }

    /*!
        Parses and applies a single profile entry to a monitor (ephemeral).
        Encapsulates the storage format: mode "WxH@R", position "XxY".
        Returns false if the entry format is invalid.
    */
    function applyProfileEntry(monitorName, entry) {
        const mParts = entry.mode.match(/^(\d+)x(\d+)@([\d.]+)/)
        const pParts = entry.position.split("x")
        if (!mParts || pParts.length < 2) return false

        applyEphemeral(monitorName, {
            mode:      { width: parseInt(mParts[1]), height: parseInt(mParts[2]), refreshRate: parseFloat(mParts[3]) },
            position:  { x: parseInt(pParts[0]), y: parseInt(pParts[1]) },
            scale:     entry.scale,
            transform: entry.transform,
            enabled:   entry.enabled,
            cm:        entry.cm || "srgb",
        })
        return true
    }

    // View helpers — single adapter instance, delegates to avoid double instantiation.
    function calcBoundingBox(states)             { return _adapter.calcBoundingBox(states) }
    function toViewModel(state, canvasBounds)    { return _adapter.toViewModel(state, canvasBounds) }

    /*!
        Writes monitors.generated.lua and reloads Hyprland.
        Emits committed(ok, errorMessage) when done.
    */
    function commit() {
        const doc     = _configBuilder.build(monitors)
        const content = _serializer.serialize(doc)
        _fileWriter.write(_outputPath, content)
    }

    // ── Private ───────────────────────────────────────────

    /*!
        Builds the hyprctl keyword value for a monitor.
        Format: name,WxH@R,XxY,scale,transform,N  or  name,disabled
    */
    function _buildKeyword(monitor) {
        if (!monitor.enabled)
            return `${monitor.name},disabled`

        const m   = monitor.activeMode
        const pos = monitor.position
        const t  = (monitor.transform !== null && monitor.transform !== undefined) ? monitor.transform : 0
        const cm = monitor.cm || "srgb"
        return `${monitor.name},${m.width}x${m.height}@${m.refreshRate},${pos.x}x${pos.y},${monitor.scale},transform,${t},cm,${cm}`
    }
}
