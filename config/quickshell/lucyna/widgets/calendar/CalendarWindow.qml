import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../theme" as Theme
import "../../services" as Services

/*!
    Floating calendar panel anchored below the bar.

    Toggle via:
      - Bar clock click  (through Services.CalendarState)
      - Keybind Hyprland →  quickshell ipc --config lucyna call toggleCalendar handle
      - ESC              →  closes when open
      - Click outside    →  closes the panel
*/
PanelWindow {
    id: root

    readonly property int _panelW: 290
    readonly property int _panelH: 320

    visible: Services.CalendarState.isVisible

    color: "transparent"
    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.namespace:     "calendar"
    WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusionMode:               ExclusionMode.Ignore

    anchors { top: true; bottom: true; left: true; right: true }

    // ── IPC handler — for external keybinds ─────────────
    IpcHandler {
        target: "toggleCalendar"
        function handle() { Services.CalendarState.toggle() }
    }

    // ── ESC to close ─────────────────────────────────────
    Shortcut {
        sequence: "Escape"
        enabled:  root.visible
        onActivated: Services.CalendarState.isVisible = false
    }

    // ── Click outside to close ───────────────────────────
    MouseArea {
        anchors.fill: parent
        enabled:      root.visible
        z:            0
        onClicked:    Services.CalendarState.isVisible = false
    }

    // ── Panel card ───────────────────────────────────────
    Rectangle {
        id: card

        width:  root._panelW
        height: root._panelH

        anchors.top:              parent.top
        anchors.topMargin:        40
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        // Fade in when the panel opens; exit is instant (window hides immediately)
        opacity: root.visible ? 1.0 : 0.0

        radius:       Theme.ThemeManager.currentPalette.radius
        border.width: 1
        border.color: Qt.rgba(
            Theme.ThemeManager.currentPalette.highlight3.r,
            Theme.ThemeManager.currentPalette.highlight3.g,
            Theme.ThemeManager.currentPalette.highlight3.b,
            0.9)
        color: Qt.rgba(
            Theme.ThemeManager.currentPalette.base.r,
            Theme.ThemeManager.currentPalette.base.g,
            Theme.ThemeManager.currentPalette.base.b,
            0.96)

        MouseArea { anchors.fill: parent }

        CalendarView {
            anchors.fill: parent
        }
    }
}
