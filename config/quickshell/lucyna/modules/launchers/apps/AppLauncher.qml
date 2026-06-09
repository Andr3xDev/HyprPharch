import "../../../core/components"
import "../../../core/services" as Services
import "../../../core/theme" as Theme
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import "state"

/*!
    Full-screen app launcher overlay. Shows most-used apps by default
    and filters in real time as the user types.
*/
PanelWindow {
    id: root

    // ── Layout constants ─────────────────────────────────
    readonly property int itemCount: 3
    readonly property int itemHeight: 48
    readonly property int searchH: 44
    readonly property int pad: Theme.ThemeManager.spacing.md
    readonly property int cardW: 380
    readonly property int cardH: searchH + (itemHeight * itemCount) + (pad * 3) + 8

    // ── Public API ───────────────────────────────────────
    function toggle() {
        visible ? close() : open();
    }

    function open() {
        root.screen = Services.ScreenService.focusedScreen();
        AppLauncherState.query = "";
        root.visible = true;
    }

    function close() {
        root.visible = false;
        searchInput.clear();
        AppLauncherState.query = "";
    }

    // ── Visibility ───────────────────────────────────────
    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "appLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    onVisibleChanged: {
        if (visible) {
            searchInput.forceActiveFocus();
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // ── IPC — external keybind (Hyprland) ────────────────
    IpcHandler {
        function handle() {
            root.toggle();
        }

        target: "toggleLauncher"
    }

    // ── Background overlay ───────────────────────────────
    DarkOverlay {
        visible: root.visible
        overlayOpacity: 0.5
        onClicked: root.close()
    }

    // ── Card ─────────────────────────────────────────────
    Rectangle {
        id: card

        width: root.cardW
        height: root.cardH
        anchors.centerIn: parent
        color: Theme.ThemeManager.colors.surface.primary
        radius: Theme.ThemeManager.radius.md
        border.width: 1
        border.color: Theme.ThemeManager.colors.highlight.medium

        MouseArea {
            anchors.fill: parent
        }

        Column {
            spacing: Theme.ThemeManager.spacing.sm

            anchors {
                fill: parent
                margins: root.pad
            }

            // Search field
            TextField {
                id: searchInput

                width: parent.width
                height: root.searchH
                placeholderText: "Only Binary..."
                placeholderTextColor: Theme.ThemeManager.colors.on.surfaceMuted
                color: Theme.ThemeManager.colors.on.surface
                font.pixelSize: Theme.ThemeManager.typography.size.lg
                font.letterSpacing: 0.3
                leftPadding: 34
                rightPadding: root.pad
                topPadding: 10
                bottomPadding: 10
                onTextChanged: AppLauncherState.query = text
                Keys.onEscapePressed: root.close()
                Keys.onDownPressed: appList.incrementCurrentIndex()
                Keys.onUpPressed: appList.decrementCurrentIndex()
                Keys.onReturnPressed: appList.launchCurrent()

                background: Rectangle {
                    color: Theme.ThemeManager.colors.surface.secondary
                    radius: Theme.ThemeManager.radius.lg
                    border.width: 1
                    border.color: searchInput.activeFocus ? Theme.ThemeManager.colors.accent.primary : Theme.ThemeManager.colors.on.surfaceMuted

                    Text {
                        text: " 󰍉 "
                        font.family: Theme.ThemeManager.typography.family.icons
                        font.pixelSize: Theme.ThemeManager.typography.size.xl
                        color: Theme.ThemeManager.colors.accent.primary

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
            }

            // App list
            ListView {
                id: appList

                function launchCurrent() {
                    if (currentItem) {
                        const entry = currentItem.entry;
                        root.close();
                        AppLauncherState.launch(entry);
                    }
                }

                width: parent.width
                height: root.itemHeight * root.itemCount
                clip: true
                model: root.visible ? AppLauncherState.filteredApps : null
                currentIndex: 0
                keyNavigationWraps: true
                highlightRangeMode: ListView.ApplyRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: height
                highlightMoveDuration: 100
                onModelChanged: {
                    currentIndex = 0;
                    positionViewAtBeginning();
                }

                highlight: Rectangle {
                    radius: Theme.ThemeManager.radius.lg
                    color: Theme.ThemeManager.colors.surface.secondary

                    Behavior on y {
                        NumberAnimation {
                            duration: Theme.ThemeManager.motion.duration.fast
                            easing.type: Theme.ThemeManager.motion.easing.standard
                        }
                    }
                }

                delegate: Item {
                    id: delegateRoot

                    readonly property bool isCurrent: appList.currentIndex === index
                    property var entry: modelData

                    width: appList.width
                    height: root.itemHeight

                    Row {
                        spacing: Theme.ThemeManager.spacing.md
                        scale: delegateRoot.isCurrent ? 1.1 : 1
                        transformOrigin: Item.Left

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: root.pad
                        }

                        IconImage {
                            width: 23
                            height: 23
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData.icon)
                        }

                        Text {
                            text: modelData.name
                            color: delegateRoot.isCurrent ? Theme.ThemeManager.colors.on.surface : Theme.ThemeManager.colors.on.surfaceMuted
                            font.pixelSize: Theme.ThemeManager.typography.size.lg
                            font.letterSpacing: 0.2
                            height: root.itemHeight
                            verticalAlignment: Text.AlignVCenter

                            Behavior on color {
                                ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast }
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: Theme.ThemeManager.motion.duration.fast
                                easing.type: Theme.ThemeManager.motion.easing.standard
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: appList.currentIndex = index
                        onClicked: {
                            const app = modelData;
                            root.close();
                            AppLauncherState.launch(app);
                        }
                    }
                }
            }
        }

        // Empty-state quote — visible when no results
        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            width: parent.width - (root.pad * 4)
            spacing: 10
            visible: appList.count === 0

            Text {
                text: "\"We all make choices, but in the end... our choices make us\""
                color: Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize: Theme.ThemeManager.typography.size.md
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Text {
                text: "Andrew Ryan"
                color: Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize: Theme.ThemeManager.typography.size.sm
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                text: "BioShock"
                color: Theme.ThemeManager.colors.on.surfaceMuted
                font.pixelSize: Theme.ThemeManager.typography.size.sm
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
        }
    }
}
