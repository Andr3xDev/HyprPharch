import QtQuick
import Quickshell.Io
import "../../../../theme" as Theme

/*!
    Delegate for ClipList.
    - Text entries: shows the preview string.
    - Image entries: decodes via cliphist to a temp file and renders a thumbnail.
*/
Item {
    id: root

    required property string clipId
    required property string preview
    required property string type

    readonly property bool isSelected: ListView.isCurrentItem

    height: 48

    // Selected background tint
    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.currentPalette.radiusInner
        color: root.isSelected
            ? Theme.ThemeManager.currentPalette.surface
            : "transparent"
    }

    // Accent bar on the left edge when selected
    Rectangle {
        width: 3
        height: parent.height - 12
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 2
        }
        radius: 2
        color: Theme.ThemeManager.currentPalette.color1
        visible: root.isSelected
    }

    Loader {
        anchors {
            fill: parent
            leftMargin: root.isSelected ? 14 : 10
            rightMargin: 12
        }
        sourceComponent: root.type === "image" ? _imageLayout : _textLayout
    }

    // --- Text layout ---
    Component {
        id: _textLayout

        Text {
            text: root.preview
            color: root.isSelected
                ? Theme.ThemeManager.currentPalette.text
                : Theme.ThemeManager.currentPalette.color8
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            height: 48

            Behavior on color {
                ColorAnimation { duration: 100 }
            }
        }
    }

    // --- Image layout: decodes to temp file, then shows thumbnail ---
    Component {
        id: _imageLayout

        Item {
            id: _img

            property bool _ready: false

            Component.onCompleted: _decode()

            // Re-decode if this delegate is reused for a different entry
            Connections {
                target: root
                function onClipIdChanged() {
                    _img._ready = false
                    _decode()
                }
            }

            function _decode() {
                if (_proc.running) return
                _proc.command = [
                    "sh", "-c",
                    "cliphist decode " + root.clipId + " > /tmp/qs_clip_" + root.clipId
                ]
                _proc.running = true
            }

            Process {
                id: _proc
                running: false
                onExited: _img._ready = true
            }

            Row {
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter

                // Thumbnail (shown when decoded)
                Image {
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter
                    visible: _img._ready
                    fillMode: Image.PreserveAspectFit
                    source: _img._ready ? ("file:///tmp/qs_clip_" + root.clipId) : ""
                    cache: false
                }

                // Loading icon (shown while decoding)
                Text {
                    text: "󰋩"
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 18
                    color: Theme.ThemeManager.currentPalette.color5
                    verticalAlignment: Text.AlignVCenter
                    height: 48
                    visible: !_img._ready
                }

                Text {
                    text: "Imagen"
                    color: root.isSelected
                        ? Theme.ThemeManager.currentPalette.text
                        : Theme.ThemeManager.currentPalette.color8
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                    font.italic: !_img._ready
                    verticalAlignment: Text.AlignVCenter
                    height: 48
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (root.ListView.view)
                root.ListView.view.currentIndex = index
        }
        onClicked: {
            if (root.ListView.view && root.ListView.view.clipService)
                root.ListView.view.clipService.paste(root.clipId)
        }
    }
}
