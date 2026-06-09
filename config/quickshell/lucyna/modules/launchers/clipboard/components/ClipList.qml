import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../../../../core/theme" as Theme

/*!
    Virtualised list of clipboard entries.
    Mouse hover and keyboard navigation share a single currentIndex.
*/
ListView {
    id: root

    property var clipState: null

    clip: true
    keyNavigationWraps: true
    highlightMoveDuration: 80
    currentIndex: 0
    model: clipState ? clipState.filtered : null
    onModelChanged: currentIndex = 0

    delegate: Item {
        id: row

        required property int    index
        required property string clipId
        required property string preview
        required property string type
        required property string rawLine

        readonly property bool isCurrent: root.currentIndex === row.index

        width:  root.width
        height: 48

        // ── Selected background ───────────────────────────
        Rectangle {
            anchors.fill: parent
            radius: Theme.ThemeManager.radius.lg
            color:  row.isCurrent ? Theme.ThemeManager.colors.surface.secondary : "transparent"
        }

        // ── Accent bar ────────────────────────────────────
        Rectangle {
            width:  3
            height: parent.height - 12
            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 2 }
            radius:  2
            color:   Theme.ThemeManager.colors.accent.primary
            visible: row.isCurrent
        }

        // ── Content area ──────────────────────────────────
        Item {
            anchors {
                fill:        parent
                leftMargin:  row.isCurrent ? 14 : 10
                rightMargin: row.isCurrent ? 40 : 12
            }

            Behavior on anchors.rightMargin { NumberAnimation { duration: Theme.ThemeManager.motion.duration.fast; easing.type: Theme.ThemeManager.motion.easing.standard } }
            Behavior on anchors.leftMargin  { NumberAnimation { duration: Theme.ThemeManager.motion.duration.fast; easing.type: Theme.ThemeManager.motion.easing.standard } }

            // Text entry
            Text {
                anchors.fill: parent
                visible:           row.type !== "image"
                text:              row.preview
                color:             row.isCurrent
                    ? Theme.ThemeManager.colors.on.surface
                    : Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize:    Theme.ThemeManager.typography.size.md
                elide:             Text.ElideRight
                verticalAlignment: Text.AlignVCenter

                Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }
            }

            // Image entry
            Row {
                id: _imgRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.ThemeManager.spacing.sm
                visible: row.type === "image"

                property bool ready: false

                Component.onCompleted: {
                    if (row.type === "image") _decode()
                }

                function _decode() {
                    if (_imgProc.running) return
                    _imgProc.command = ["sh", "-c",
                        "cliphist decode " + row.clipId + " > /tmp/qs_clip_" + row.clipId]
                    _imgProc.running = true
                }

                Process {
                    id: _imgProc
                    running: false
                    onExited: _imgRow.ready = true
                }

                Image {
                    width: 36; height: 36
                    anchors.verticalCenter: parent.verticalCenter
                    visible:  _imgRow.ready
                    fillMode: Image.PreserveAspectFit
                    source:   _imgRow.ready ? ("file:///tmp/qs_clip_" + row.clipId) : ""
                    cache:    false
                }

                Text {
                    visible:           !_imgRow.ready
                    text:              "󰋩"
                    font.family:       Theme.ThemeManager.typography.family.icons
                    font.pixelSize:    Theme.ThemeManager.typography.bigIconSize
                    color:             Theme.ThemeManager.colors.accent.tertiary
                    verticalAlignment: Text.AlignVCenter
                    height:            48
                }

                Text {
                    text:              "Imagen"
                    color:             row.isCurrent
                        ? Theme.ThemeManager.colors.on.surface
                        : Theme.ThemeManager.colors.on.surfaceMuted
                    font.pixelSize:    Theme.ThemeManager.typography.size.md
                    font.italic:       !_imgRow.ready
                    verticalAlignment: Text.AlignVCenter
                    height:            48
                }
            }
        }

        // ── ✕ delete button ───────────────────────────────
        Rectangle {
            z:       1
            visible: row.isCurrent
            width:   24
            height:  24
            anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
            radius: Theme.ThemeManager.radius.lg
            color:  _xHover.containsMouse
                ? Qt.rgba(Theme.ThemeManager.colors.accent.secondary.r,
                          Theme.ThemeManager.colors.accent.secondary.g,
                          Theme.ThemeManager.colors.accent.secondary.b, 0.15)
                : "transparent"

            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }

            Text {
                anchors.centerIn: parent
                text:           "✕"
                color:          Theme.ThemeManager.colors.accent.secondary
                font.pixelSize: Theme.ThemeManager.typography.size.md
                font.bold:      true
            }

            MouseArea {
                id: _xHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape:  Qt.PointingHandCursor
                onClicked: mouse => {
                    mouse.accepted = true
                    if (root.clipState)
                        root.clipState.deleteEntry(row.rawLine, row.clipId)
                }
            }
        }

        // ── Main interaction ──────────────────────────────
        MouseArea {
            z:            0
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.currentIndex = row.index
            onClicked: {
                if (root.clipState)
                    root.clipState.paste(row.clipId)
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        visible: root.contentHeight > root.height
        contentItem: Rectangle {
            implicitWidth: 4
            radius: 2
            color: Theme.ThemeManager.colors.highlight.strong
        }
    }
}
