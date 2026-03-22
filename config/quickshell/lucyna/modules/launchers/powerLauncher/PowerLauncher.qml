import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "./../../../services"
import "../../../theme" as Theme
import "../../../components/overlays"

/*!
    Power launcher overlay that provides system power management options.
    Displays lock, suspend, reboot, and shutdown options with confirmation for destructive actions.
*/
PanelWindow {
    id: root

    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powerLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    // Index of the action that requires confirmation, -1 if none
    property int confirmIndex: -1
    // Index of the currently selected action for keyboard navigation
    property int selectedIndex: 0
    // Uptime string shown in the confirmation text
    property string uptimeText: ""

    onConfirmIndexChanged: {
        if (confirmIndex !== -1) uptimeProcess.running = true
    }

    Process {
        id: uptimeProcess
        command: ["cat", "/proc/uptime"]
        stdout: SplitParser {
            onRead: data => {
                const secs = Math.floor(parseFloat(data.trim().split(" ")[0]))
                const h = Math.floor(secs / 3600)
                const m = Math.floor((secs % 3600) / 60)
                root.uptimeText = h > 0 ? h + "h " + m + "m" : m + "m"
            }
        }
    }

    // IPC handler to toggle the power launcher
    IpcHandler {
        target: "togglePower"
        function handle() { root.toggle() }
    }

    /*!
        Toggle the power launcher visibility
    */
    function toggle() { visible ? close() : open() }

    /*!
        Open the power launcher on the focused screen
    */
    function open() {
        root.screen = ScreenService.focusedScreen()
        root.confirmIndex = -1
        root.selectedIndex = 0
        root.visible = true
    }

    /*!
        Close the power launcher and reset confirmation state
    */
    function close() {
        root.visible = false
        root.confirmIndex = -1
    }

    onVisibleChanged: {
        if (visible) {
            uptimeProcess.running = true
            card.forceActiveFocus()
        }
    }

    // Available power actions with their properties
    readonly property var actions: [
        { label: "Lock",     icon: "󰌾",  destructive: false, action: () => { PowerOptionService.lock();     root.close() } },
        { label: "Suspend",  icon: "󰒲",  destructive: false, action: () => { PowerOptionService.suspend();  root.close() } },
        { label: "Reboot",   icon: "󰜉",  destructive: true,  action: () => { PowerOptionService.reboot();  root.close() } },
        { label: "Shutdown", icon: "󰐥",  destructive: true,  action: () => { PowerOptionService.shutdown(); root.close() } },
    ]

    /*!
        Trigger an action by index. Destructive actions require confirmation.
        @param {int} index - Index of the action to trigger
    */
    function trigger(index) {
        const a = actions[index]
        if (a.destructive && confirmIndex !== index) {
            confirmIndex = index
            return
        }
        confirmIndex = -1
        a.action()
    }

    // Background overlay with darkened effect
    DarkOverlay {
        visible: root.visible
        overlayOpacity: 0.5
        onClicked: root.close()
    }

    // Main card container for power options
    Rectangle {
        id: card

        width:  280
        height: 110
        anchors.centerIn: parent

        color:  Theme.ThemeManager.currentPalette.base
        radius:       Theme.ThemeManager.currentPalette.radiusInner + 6
        border.width: 1
        border.color: Theme.ThemeManager.currentPalette.surface

        opacity: root.visible ? 1.0 : 0.0
        scale:   root.visible ? 1.0 : 0.97

        Behavior on opacity { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }

        focusPolicy: Qt.StrongFocus
        Keys.onEscapePressed: {
            if (root.confirmIndex !== -1) root.confirmIndex = -1
            else root.close()
        }
        Keys.onLeftPressed:  root.selectedIndex = (root.selectedIndex - 1 + root.actions.length) % root.actions.length
        Keys.onRightPressed: root.selectedIndex = (root.selectedIndex + 1) % root.actions.length
        Keys.onReturnPressed: root.trigger(root.selectedIndex)
        Keys.onEnterPressed:  root.trigger(root.selectedIndex)
        Keys.onSpacePressed:  root.trigger(root.selectedIndex)

        MouseArea { anchors.fill: parent }

        Column {
            anchors.centerIn: parent
            spacing: 12

            Row {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter

                // Power action buttons
                Repeater {
                    model: root.actions

                    delegate: Rectangle {
                        readonly property bool isConfirming: root.confirmIndex === index
                        readonly property bool isDestructive: modelData.destructive
                        readonly property bool isSelected: root.selectedIndex === index

                        width:  52
                        height: 52
                        radius: Theme.ThemeManager.currentPalette.radiusInner 

                        color:        isConfirming 
                            ? Qt.rgba(Theme.ThemeManager.currentPalette.color1.r,
                                      Theme.ThemeManager.currentPalette.color1.g,
                                      Theme.ThemeManager.currentPalette.color1.b, 0.2)
                            : Theme.ThemeManager.currentPalette.surface
                        border.width: isSelected ? 2 : 1
                        border.color: isConfirming
                            ? Theme.ThemeManager.currentPalette.color1
                            : isSelected
                                ? Theme.ThemeManager.currentPalette.color1
                                : hoverArea.containsMouse ? Theme.ThemeManager.currentPalette.color1 : Theme.ThemeManager.currentPalette.surface

                        Behavior on border.color { ColorAnimation { duration: 120 } }
                        Behavior on color        { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.icon
                            color: Theme.ThemeManager.currentPalette.text
                            font.pixelSize: 22
                            font.family: "Symbols Nerd Font"
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape:  Qt.PointingHandCursor
                            onClicked:    root.trigger(index)
                            onEntered:    root.selectedIndex = index
                        }
                    }
                }
            }

            // Dynamic text: uptime at rest, confirmation when an action is pending
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.confirmIndex !== -1
                    ? "Press again to " + root.actions[root.confirmIndex].label.toLowerCase()
                    : (root.uptimeText ? "󱑎  Uptime: " + root.uptimeText : " ")
                color: root.confirmIndex !== -1
                    ? Theme.ThemeManager.currentPalette.color1
                    : Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.smallFontSize + 2
                font.letterSpacing: 0.4

                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }
    }
}