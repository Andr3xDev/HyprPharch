import "../../../core/components"
import "../../../core/theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "components"
import "state"

/*!
    Full-screen clipboard launcher overlay. Filters entries in real time,
    supports paste on click/Enter, and delete via ✕ button or Ctrl+D.
    Ctrl+Shift+D clears all history (requires confirmation).
*/
PanelWindow {
    id: root

    // Layout constants
    readonly property int cardW:   460
    readonly property int rowH:    48
    readonly property int searchH: 44
    readonly property int pad:     12
    readonly property int maxRows: 8
    readonly property int minRows: 3
    readonly property int listH:   Math.max(rowH * minRows, Math.min((ClipState.filtered?.count ?? 0) * rowH, rowH * maxRows))
    readonly property int cardH:   pad + searchH + pad + listH + pad

    // Public API
    function toggle() { visible ? close() : open() }

    function open() {
        ClipState.refresh()
        root.visible = true
    }

    function close() {
        ClipState.cleanup()
        root.visible = false
    }

    // Visibility
    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "clipLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    onVisibleChanged: {
        if (visible) searchInput.forceSearchFocus()
    }

    anchors { top: true; bottom: true; left: true; right: true }

    // IPC — external keybind
    IpcHandler {
        function handle() { root.toggle() }
        target: "toggleClip"
    }

    // Background overlay
    DarkOverlay {
        visible: root.visible
        overlayOpacity: 0.5
        onClicked: root.close()
    }

    // Card
    Rectangle {
        id: card

        width:  root.cardW
        height: root.cardH
        anchors.centerIn: parent
        color:        Theme.ThemeManager.colors.surface.primary
        radius:       Theme.ThemeManager.radius.md
        border.width: 1
        border.color: Theme.ThemeManager.colors.highlight.medium

        MouseArea { anchors.fill: parent }

        // Empty-state quote
        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            width:   parent.width - (root.pad * 4)
            spacing: 6
            visible: clipList.count === 0

            Text {
                text:                "\"I'm no hero. Never was, never will be\""
                color:               Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize:      Theme.ThemeManager.typography.size.md
                font.italic:         true
                horizontalAlignment: Text.AlignHCenter
                width:               parent.width
                wrapMode:            Text.WordWrap
            }
            Text {
                text:                "Solid Snake"
                color:               Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize:      Theme.ThemeManager.typography.size.sm
                horizontalAlignment: Text.AlignHCenter
                width:               parent.width
            }
            Text {
                text:                "Metal Gear Solid 4"
                color:               Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize:      Theme.ThemeManager.typography.size.sm
                font.italic:         true
                horizontalAlignment: Text.AlignHCenter
                width:               parent.width
            }
        }

        Column {
            spacing: root.pad
            anchors { fill: parent; margins: root.pad }

            ClipSearchBar {
                id: searchInput
                width:    parent.width
                listRef:  clipList
                onEscapePressed:          root.close()
                onDeleteCurrentRequested: {
                    const item = clipList.currentItem
                    if (item) ClipState.deleteEntry(item.rawLine, item.clipId)
                }
                onClearAllConfirmed: ClipState.clearAll()
            }

            ClipList {
                id: clipList
                width:     parent.width
                height:    root.listH
                clipState: ClipState
            }
        }
    }

    Connections {
        target: ClipState
        function onPasteCompleted() { root.close() }
    }
}
