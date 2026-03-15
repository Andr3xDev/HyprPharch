import "../../../services" as Services
import "../../../theme" as Theme
import "../../../components/overlays"
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import "services"

/*!
    Full-screen app launcher overlay, displays the most used apps by default
    and filters in real time as the user types.
*/
PanelWindow {
    id: root

    // Layout constants
    readonly property int itemCount: 3
    readonly property int itemHeight: 48
    readonly property int searchH: 44
    readonly property int pad: 12
    readonly property int cardW: 380
    readonly property int cardH: searchH + (itemHeight * itemCount) + (pad * 3) + 8

    // Open on focused screen, close clearing the query
    function toggle() {
        visible ? close() : open();
    }

    function open() {
        root.screen = Services.ScreenService.focusedScreen();
        AppService.query = "";
        root.visible = true;
    }

    function close() {
        root.visible = false;
        searchInput.clear();
        AppService.query = "";
    }

    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "appLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    onVisibleChanged: {
        if (visible)
            searchInput.forceActiveFocus();

    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // IPC interface for external control (hyprland keybind)
    IpcHandler {
        function handle() {
            root.toggle();
        }

        target: "toggleLauncher"
    }

    // Dark overlay background
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

        MouseArea {
            anchors.fill: parent
        }

        Column {
            spacing: 8

            anchors {
                fill: parent
                margins: root.pad
            }

            TextField {
                id: searchInput

                width: parent.width
                height: root.searchH
                placeholderText: "Only Binary..."
                placeholderTextColor: Theme.ThemeManager.currentPalette.muted
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
                font.letterSpacing: 0.3
                leftPadding: 34
                rightPadding: 12
                topPadding: 10
                bottomPadding: 10
                onTextChanged: AppService.query = text

                Keys.onEscapePressed: root.close()
                Keys.onDownPressed: appList.incrementCurrentIndex()
                Keys.onUpPressed: appList.decrementCurrentIndex()
                Keys.onReturnPressed: appList.launchCurrent()

                background: Rectangle {
                    color: Theme.ThemeManager.currentPalette.surface
                    radius: Theme.ThemeManager.currentPalette.radiusInner
                    border.width: 1
                    border.color: searchInput.activeFocus ? Theme.ThemeManager.currentPalette.color1 : Theme.ThemeManager.currentPalette.muted

                    Text {
                        text: " 󰍉 "
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize + 4
                        color: Theme.ThemeManager.currentPalette.color1

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }

                    }

                }

            }

            ListView {
                id: appList

                function launchCurrent() {
                    if (currentItem) {
                        const entry = currentItem.entry;
                        root.close();
                        AppService.launch(entry);
                    }
                }

                width: parent.width
                height: root.itemHeight * root.itemCount
                clip: true
                model: root.visible ? AppService.filteredApps : null
                currentIndex: 0
                keyNavigationWraps: true
                highlightRangeMode: ListView.ApplyRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: height
                highlightMoveDuration: 100
                onModelChanged: currentIndex = 0

                highlight: Rectangle {
                    radius: Theme.ThemeManager.currentPalette.radiusInner
                    color: Theme.ThemeManager.currentPalette.surface

                    Behavior on y {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                delegate: Item {
                    id: delegateRoot

                    property var entry: modelData

                    width: appList.width
                    height: root.itemHeight

                    Row {
                        spacing: 12
                        scale: appList.currentIndex === index ? 1.1 : 1
                        transformOrigin: Item.Left

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 12
                        }

                        IconImage {
                            width: 23
                            height: 23
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData.icon)
                        }

                        Text {
                            text: modelData.name
                            color: appList.currentIndex === index ? Theme.ThemeManager.currentPalette.text : Theme.ThemeManager.currentPalette.color8
                            font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
                            font.letterSpacing: 0.2
                            height: root.itemHeight
                            verticalAlignment: Text.AlignVCenter

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }

                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
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
                            AppService.launch(app);
                        }
                    }

                }

            }

        }

        // Quote message centered in the card - only visible when no results
        Column {
            spacing: 6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            width: parent.width - (root.pad * 4)
            visible: appList.count === 0

            Text {
                text: "\"We all make choices, but in the end... our choices make us\""
                color: Theme.ThemeManager.currentPalette.muted
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Text {
                text: "Andrew Ryan"
                color: Theme.ThemeManager.currentPalette.color8
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize - 1
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                text: "BioShock"
                color: Theme.ThemeManager.currentPalette.color8
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize - 2
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
        }

    }

}
