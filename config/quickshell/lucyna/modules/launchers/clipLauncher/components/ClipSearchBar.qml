import QtQuick
import "../../../../theme" as Theme
import "../services"

/*!
    Search bar for ClipLauncher.
    Binds bidirectionally with ClipService.query.
    Delegates ↑↓↵ to the list reference provided by the parent.
*/
Rectangle {
    id: root

    property var listRef: null

    signal escapePressed()

    height: 44
    color: Theme.ThemeManager.currentPalette.surface
    radius: Theme.ThemeManager.currentPalette.radiusInner
    border.width: 1
    border.color: searchInput.activeFocus
        ? Theme.ThemeManager.currentPalette.color1
        : Theme.ThemeManager.currentPalette.muted

    // Search icon
    Text {
        text: " 󰅍 "
        font.family: "Symbols Nerd Font"
        font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize + 4
        color: Theme.ThemeManager.currentPalette.color1
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
    }

    TextInput {
        id: searchInput

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 34
            rightMargin: 12
        }

        color: Theme.ThemeManager.currentPalette.text
        font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
        font.letterSpacing: 0.3
        selectionColor: Theme.ThemeManager.currentPalette.color1
        clip: true
        focus: true

        onTextChanged: ClipService.query = text

        Keys.onEscapePressed: root.escapePressed()
        Keys.onDownPressed:   { if (root.listRef) root.listRef.incrementCurrentIndex() }
        Keys.onUpPressed:     { if (root.listRef) root.listRef.decrementCurrentIndex() }
        Keys.onReturnPressed: {
            if (root.listRef && root.listRef.currentItem)
                ClipService.paste(root.listRef.currentItem.clipId)
        }
    }

    function forceSearchFocus() {
        searchInput.forceActiveFocus()
    }
}
