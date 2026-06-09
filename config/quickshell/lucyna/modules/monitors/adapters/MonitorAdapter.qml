import QtQuick
import "../services"
import "../models/MonitorState.js" as MonitorState

/*!
    MonitorAdapter — Adapter pattern.

    Transforms raw hyprctl JSON → MonitorState[] → ViewModel.
    The UI and services never see raw IPC shapes.

    ⚠ Side effect: auto-registers new monitor identities via IdentityService.
    This is intentional — MonitorAdapter is the only layer allowed to import
    IdentityService within the adapters/ tier.
*/
QtObject {
    id: root

    // ── Public API ────────────────────────────────────────

    /*!
        Parses the raw array from HyprlandIpc.getMonitors() into MonitorState[].
        Auto-registers identities for monitors not yet in IdentityService.

        NOTE: serial may be empty (monitors without EDID serial). In that case
        the monitor name ("eDP-1") is used as the identity key — identity
        becomes port-bound rather than monitor-bound for that display.
    */
    function parse(rawArray) {
        return rawArray.map(function(raw) {
            const serial   = _deriveSerial(raw)
            const make     = raw.make  || ""
            const model    = raw.model || ""
            const identity = IdentityService.resolveOrRegister(serial, make, model)

            return MonitorState.create(
                raw.name,
                serial,
                identity,
                { width: raw.width, height: raw.height, refreshRate: raw.refreshRate },
                { x: raw.x, y: raw.y },
                raw.scale,
                raw.transform,
                !raw.disabled,
                _parseModes(raw.availableModes || []),
                true,
                raw.cm || "srgb"
            )
        })
    }

    /*!
        Converts a MonitorState into a flat ViewModel for canvas rendering.

        canvasBounds must be:
        {
          layout:      { x, y, width, height }  — result of calcBoundingBox(), Hyprland logical px
          canvasWidth:  number                   — MonitorCanvas pixel width
          canvasHeight: number                   — MonitorCanvas pixel height
        }
    */
    function toViewModel(state, canvasBounds) {
        const PADDING = 16
        const availW  = canvasBounds.canvasWidth  - PADDING * 2
        const availH  = canvasBounds.canvasHeight - PADDING * 2
        const layout  = canvasBounds.layout

        const fitScale = Math.min(availW / layout.width, availH / layout.height)
        const scaledW  = layout.width  * fitScale
        const scaledH  = layout.height * fitScale
        const offsetX  = PADDING + (availW - scaledW) / 2
        const offsetY  = PADDING + (availH - scaledH) / 2

        // Hyprland logical size: physical px divided by scale factor
        const logW = state.activeMode.width  / state.scale
        const logH = state.activeMode.height / state.scale

        return {
            name:       state.name,
            alias:      state.identity ? state.identity.alias : state.name,
            portName:   state.name,
            modeLabel:  _formatModeLabel(state.activeMode),
            canvasRect: {
                x:      offsetX + (state.position.x - layout.x) * fitScale,
                y:      offsetY + (state.position.y - layout.y) * fitScale,
                width:  logW * fitScale,
                height: logH * fitScale
            },
            enabled:   state.enabled,
            connected: state.connected,
            transform: state.transform,
            scale:     state.scale
        }
    }

    /*!
        Computes the bounding rectangle of all monitor positions in
        Hyprland logical pixel space. x/y can be negative.
        Returns a safe fallback (1920×1080) when the list is empty.
    */
    function calcBoundingBox(states) {
        if (!states || states.length === 0)
            return { x: 0, y: 0, width: 1920, height: 1080 }

        let minX = Infinity, minY = Infinity
        let maxX = -Infinity, maxY = -Infinity

        for (const s of states) {
            const logW = s.activeMode.width  / s.scale
            const logH = s.activeMode.height / s.scale
            minX = Math.min(minX, s.position.x)
            minY = Math.min(minY, s.position.y)
            maxX = Math.max(maxX, s.position.x + logW)
            maxY = Math.max(maxY, s.position.y + logH)
        }

        return { x: minX, y: minY, width: maxX - minX, height: maxY - minY }
    }

    // ── Private ───────────────────────────────────────────

    /*!
        Derives a stable monitor key from raw IPC data using the same
        priority chain as GNOME/KDE display tools:
          1. serial       — monitor-bound, port-independent (best)
          2. make|model   — panel-bound, works for eDP and serialless monitors
          3. name         — port-bound fallback (last resort)
    */
    function _deriveSerial(raw) {
        if (raw.serial)            return raw.serial
        if (raw.make && raw.model) return `${raw.make}|${raw.model}`
        return raw.name
    }

    // Parses "1920x1080@144.00Hz" → { width, height, refreshRate }.
    // Skips malformed entries silently.
    function _parseModes(rawModes) {
        return rawModes.reduce(function(acc, str) {
            const m = str.match(/^(\d+)x(\d+)@([\d.]+)Hz$/)
            if (m) acc.push({
                width:       parseInt(m[1]),
                height:      parseInt(m[2]),
                refreshRate: parseFloat(m[3])
            })
            return acc
        }, [])
    }

    // Uses Unicode × and rounds refresh rate to nearest integer for display.
    function _formatModeLabel(mode) {
        return `${mode.width}×${mode.height} @ ${Math.round(mode.refreshRate)} Hz`
    }
}
