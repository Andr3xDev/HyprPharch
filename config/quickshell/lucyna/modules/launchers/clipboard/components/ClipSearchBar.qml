import QtQuick
import "../../../../core/theme" as Theme
import "../state"

/*!
    Search bar for ClipLauncher.
    Binds bidirectionally with ClipState.query.
    Delegates ↑↓↵ to the list reference provided by the parent.
    Ctrl+D deletes the selected entry; Ctrl+Shift+D clears all (with confirmation).
*/
Rectangle {
    id: root

    property var listRef: null

    signal escapePressed()
    signal deleteCurrentRequested()
    signal clearAllConfirmed()

    // ── Clear-all confirmation state ─────────────────────
    property bool _confirmingClear: false

    Timer {
        id: _confirmTimer
        interval: 3000
        onTriggered: root._confirmingClear = false
    }

    function _handleClearAll() {
        if (_confirmingClear) {
            _confirmingClear = false
            _confirmTimer.stop()
            root.clearAllConfirmed()
        } else {
            _confirmingClear = true
            _confirmTimer.restart()
        }
    }

    // ── Appearance ───────────────────────────────────────
    height:       44
    color:        Theme.ThemeManager.colors.surface.secondary
    radius:       Theme.ThemeManager.radius.lg
    border.width: 1
    border.color: searchInput.activeFocus
        ? Theme.ThemeManager.colors.accent.primary
        : Theme.ThemeManager.colors.on.surfaceMuted

    // Search icon
    Text {
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 10 }
        text:           " 󰅍 "
        font.family:    "Symbols Nerd Font"
        font.pixelSize: Theme.ThemeManager.typography.size.xl
        color:          Theme.ThemeManager.colors.accent.primary
    }

    // Search input
    TextInput {
        id: searchInput

        anchors {
            verticalCenter: parent.verticalCenter
            left:  parent.left
            right: parent.right
            leftMargin:  34
            rightMargin: 44
        }

        color:              Theme.ThemeManager.colors.on.surface
        font.pixelSize:     Theme.ThemeManager.typography.size.lg
        font.letterSpacing: 0.3
        selectionColor:     Theme.ThemeManager.colors.accent.primary
        clip:               true
        focus:              true

        onTextChanged: ClipState.query = text

        Keys.onEscapePressed: root.escapePressed()
        Keys.onDownPressed:   { if (root.listRef) root.listRef.incrementCurrentIndex() }
        Keys.onUpPressed:     { if (root.listRef) root.listRef.decrementCurrentIndex() }
        Keys.onReturnPressed: {
            if (root.listRef?.currentItem)
                ClipState.paste(root.listRef.currentItem.clipId)
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_D && (event.modifiers & Qt.ControlModifier)) {
                if (event.modifiers & Qt.ShiftModifier)
                    root._handleClearAll()
                else
                    root.deleteCurrentRequested()
                event.accepted = true
            }
        }
    }

    // Trash button
    Rectangle {
        id: _trashBtn

        width:  28
        height: 28
        anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
        radius: Theme.ThemeManager.radius.lg

        color: (_trashHover.containsMouse || root._confirmingClear)
            ? Qt.rgba(Theme.ThemeManager.colors.accent.secondary.r,
                      Theme.ThemeManager.colors.accent.secondary.g,
                      Theme.ThemeManager.colors.accent.secondary.b, 0.15)
            : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            anchors.centerIn: parent
            text:           root._confirmingClear ? "󰄬" : "󰩺"
            font.family:    "Symbols Nerd Font"
            font.pixelSize: Theme.ThemeManager.typography.size.xl
            color:          Theme.ThemeManager.colors.accent.secondary

            Behavior on color { ColorAnimation { duration: 120 } }
        }

        MouseArea {
            id: _trashHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.PointingHandCursor
            onClicked:    root._handleClearAll()
        }
    }

    function forceSearchFocus() {
        searchInput.forceActiveFocus()
    }
}
