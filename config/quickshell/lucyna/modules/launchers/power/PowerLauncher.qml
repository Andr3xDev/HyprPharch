import "../../../core/components"
import "../../../core/services" as Services
import "../../../core/theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

/*!
    Power management overlay with lock, suspend, reboot, and shutdown actions.
    Destructive actions require a second confirmation press.
*/
PanelWindow {
    id: root

    // ── State ────────────────────────────────────────────
    property int    confirmIndex:  -1   // -1 = none pending
    property int    selectedIndex: 0
    property string uptimeText:    ""

    readonly property var actions: [{
        "label": "Lock",
        "icon": "󰌾",
        "destructive": false,
        "action": () => { Services.PowerOptionService.lock();    root.close() }
    }, {
        "label": "Suspend",
        "icon": "󰒲",
        "destructive": false,
        "action": () => { Services.PowerOptionService.suspend(); root.close() }
    }, {
        "label": "Reboot",
        "icon": "󰜉",
        "destructive": true,
        "action": () => { Services.PowerOptionService.reboot();  root.close() }
    }, {
        "label": "Shutdown",
        "icon": "󰐥",
        "destructive": true,
        "action": () => { Services.PowerOptionService.shutdown(); root.close() }
    }]

    // ── Public API ───────────────────────────────────────
    function toggle() {
        visible ? close() : open();
    }

    function open() {
        root.screen = Services.ScreenService.focusedScreen();
        confirmIndex  = -1;
        selectedIndex = 0;
        root.visible  = true;
    }

    function close() {
        root.visible  = false;
        confirmIndex  = -1;
    }

    function trigger(index) {
        const a = actions[index];
        if (a.destructive && confirmIndex !== index) {
            confirmIndex = index;
            return;
        }
        confirmIndex = -1;
        a.action();
    }

    // ── Visibility ───────────────────────────────────────
    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powerLauncher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    onConfirmIndexChanged: {
        if (confirmIndex !== -1)
            uptimeProcess.running = true
    }
    onVisibleChanged: {
        if (visible) {
            uptimeProcess.running = true;
            card.forceActiveFocus();
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // ── Uptime reader ────────────────────────────────────
    Process {
        id: uptimeProcess
        command: ["cat", "/proc/uptime"]
        stdout: SplitParser {
            onRead: (data) => {
                const secs = Math.floor(parseFloat(data.trim().split(" ")[0]));
                const h = Math.floor(secs / 3600);
                const m = Math.floor((secs % 3600) / 60);
                root.uptimeText = h > 0 ? h + "h " + m + "m" : m + "m";
            }
        }
    }

    // ── IPC — external keybind (Hyprland) ────────────────
    IpcHandler {
        function handle() { root.toggle(); }
        target: "togglePower"
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

        width: 280
        height: 110
        anchors.centerIn: parent
        color: Theme.ThemeManager.colors.surface.primary
        radius: Theme.ThemeManager.radius.xl
        border.width: 1
        border.color: Theme.ThemeManager.colors.surface.secondary
        opacity: root.visible ? 1 : 0
        scale: root.visible ? 1 : 0.97
        focusPolicy: Qt.StrongFocus
        Keys.onEscapePressed: root.confirmIndex !== -1 ? root.confirmIndex = -1 : root.close()
        Keys.onLeftPressed: root.selectedIndex = (root.selectedIndex - 1 + root.actions.length) % root.actions.length
        Keys.onRightPressed: root.selectedIndex = (root.selectedIndex + 1) % root.actions.length
        Keys.onReturnPressed: root.trigger(root.selectedIndex)
        Keys.onEnterPressed: root.trigger(root.selectedIndex)
        Keys.onSpacePressed: root.trigger(root.selectedIndex)

        MouseArea { anchors.fill: parent }

        Column {
            anchors.centerIn: parent
            spacing: Theme.ThemeManager.spacing.md

            // Action buttons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.ThemeManager.spacing.md

                Repeater {
                    model: root.actions

                    delegate: Rectangle {
                        readonly property bool isConfirming: root.confirmIndex === index
                        readonly property bool isSelected: root.selectedIndex === index
                        readonly property bool isHighlighted: isConfirming || isSelected || hoverArea.containsMouse

                        width: 52
                        height: 52
                        radius: Theme.ThemeManager.radius.lg
                        color: isConfirming
                            ? Qt.rgba(Theme.ThemeManager.colors.accent.primary.r,
                                      Theme.ThemeManager.colors.accent.primary.g,
                                      Theme.ThemeManager.colors.accent.primary.b, 0.2)
                            : Theme.ThemeManager.colors.surface.secondary
                        border.width: isSelected ? 2 : 1
                        border.color: isHighlighted
                            ? Theme.ThemeManager.colors.accent.primary
                            : Theme.ThemeManager.colors.surface.secondary

                        Text {
                            anchors.centerIn: parent
                            text: modelData.icon
                            color: Theme.ThemeManager.colors.on.surface
                            font.pixelSize: Theme.ThemeManager.typography.iconSize
                            font.family: "Symbols Nerd Font"
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: root.selectedIndex = index
                            onClicked: root.trigger(index)
                        }

                        Behavior on color       { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    }
                }
            }

            // Uptime label / confirmation prompt
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.confirmIndex !== -1
                    ? "Press again to " + root.actions[root.confirmIndex].label.toLowerCase()
                    : (root.uptimeText ? "󱑎  Uptime: " + root.uptimeText : " ")
                color: root.confirmIndex !== -1
                    ? Theme.ThemeManager.colors.accent.primary
                    : Theme.ThemeManager.colors.on.surface
                font.pixelSize: Theme.ThemeManager.typography.size.sm
                font.letterSpacing: 0.4

                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }

        Behavior on opacity { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
    }
}
