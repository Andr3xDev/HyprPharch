import QtQuick
import "../models/LuaDocument.js" as LuaDocument

/*!
    MonitorConfigBuilder — Builder pattern (pure JS, no side effects).

    Transforms MonitorState[] into a LuaDocument ready for serialization.

    Rules:
      - Disconnected monitors are skipped entirely.
      - Disabled (enabled=false) monitors produce a disabled entry.
      - transform=0 (normal) is stored as null and omitted from output.
      - A catch-all fallback entry is always appended last.
*/
QtObject {
    id: root

    function build(monitors) {
        const doc = LuaDocument.create()

        monitors.forEach(function(monitor) {
            if (!monitor.connected) return

            doc.entries.push({
                output:    monitor.name,
                mode:      monitor.enabled ? _formatMode(monitor.activeMode) : "preferred",
                position:  monitor.enabled ? _formatPosition(monitor.position) : "auto",
                scale:     monitor.scale,
                transform: monitor.transform !== 0 ? monitor.transform : null,
                disabled:  !monitor.enabled
            })
        })

        LuaDocument.addFallback(doc)
        return doc
    }

    function _formatMode(mode) {
        return `${mode.width}x${mode.height}@${mode.refreshRate}`
    }

    function _formatPosition(pos) {
        return `${pos.x}x${pos.y}`
    }
}
