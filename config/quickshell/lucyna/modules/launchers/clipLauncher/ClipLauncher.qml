import "../../../theme" as Theme
import "../../../components/overlays"
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "services"
import "components"

PanelWindow {
    id: root

    readonly property int cardW:   460
    readonly property int rowH:    48
    readonly property int searchH: 44
    readonly property int pad:     12
    readonly property int maxRows: 8
    readonly property int minRows: 3

    readonly property int listH: Math.max(rowH * minRows,
                                          Math.min(ClipService.filtered.count * rowH,
                                                   rowH * maxRows))
    readonly property int cardH: pad + searchH + pad + listH + pad

    function toggle() { visible ? close() : open() }

    function open() {
        ClipService.refresh()
        root.visible = true
    }

    function close() {
        ClipService.cleanup()
        root.visible = false
    }

    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "clipLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    anchors { top: true; bottom: true; left: true; right: true }

    IpcHandler {
        target: "toggleClip"
        function handle() { root.toggle() }
    }

    onVisibleChanged: {
        if (visible)
            searchInput.forceSearchFocus()
    }

    DarkOverlay {
        visible: root.visible
        overlayOpacity: 0.5
        onClicked: root.close()
    }

    Rectangle {
        id: card
        width: root.cardW
        height: root.cardH
        anchors.centerIn: parent
        color: Theme.ThemeManager.currentPalette.base
        radius: Theme.ThemeManager.currentPalette.radius
        border.width: 1
        border.color: Theme.ThemeManager.currentPalette.highlight2

        MouseArea { anchors.fill: parent }

        Column {
            spacing: 6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            width: parent.width - (root.pad * 4)
            visible: clipList.count === 0

            Text {
                text: "\"I'm no hero. Never was, never will be\""
                color: Theme.ThemeManager.currentPalette.muted
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Text {
                text: "Solid Snake"
                color: Theme.ThemeManager.currentPalette.color8
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize - 1
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                text: "Metal Gear Solid 4"
                color: Theme.ThemeManager.currentPalette.color8
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize - 2
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
        }

        Column {
            spacing: root.pad
            anchors {
                fill: parent
                margins: root.pad
            }

            ClipSearchBar {
                id: searchInput
                width: parent.width
                listRef: clipList
                onEscapePressed: root.close()
            }

            ClipList {
                id: clipList
                width: parent.width
                height: root.listH
                clipService: ClipService
            }
        }
    }

    Connections {
        target: ClipService
        function onPasteCompleted() { root.close() }
    }
}
