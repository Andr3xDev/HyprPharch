import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "components"

/*!
    Theme selector popup — toggle between available color themes.
    Toggle via: quickshell ipc call themeLauncher.toggle
*/
PanelWindow {
    id: themeLauncher

    // IPC interface for external control (hyprland keybind)
    IpcHandler {
        target: "themeLauncher"
        function toggle() {
            themeLauncher.visible = !themeLauncher.visible
        }
    }

    // Floating overlay window
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "themeLauncher"
    exclusionMode: ExclusionMode.Ignore

    anchors { bottom: true }

    mask: Region { item: background }

    implicitWidth: 280
    implicitHeight: visible ? background.implicitHeight + 50 : 0
    visible: false
    color: "transparent"

    // Script path for external theme changes (hyprland, etc)
    property string externalScriptPath: ""

    Rectangle {
        id: background
        width: 280
        height: contentColumn.implicitHeight + 32
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        color: Theme.ThemeManager.colors.surface.secondary
        radius: 0
        border.color: Theme.ThemeManager.colors.accent.primary
        border.width: 1

        implicitHeight: contentColumn.implicitHeight + 32

        focus: true
        Keys.onEscapePressed: themeLauncher.visible = false

        ColumnLayout {
            id: contentColumn
            anchors {
                fill: parent
                margins: 16
            }
            spacing: 12

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "󰔎"
                    color: Theme.ThemeManager.colors.border
                    font.pixelSize: Theme.ThemeManager.typography.size.xl
                    font.family: "Symbols Nerd Font"
                }

                Text {
                    text: "Themes"
                    color: Theme.ThemeManager.colors.on.surface
                    font.pixelSize: Theme.ThemeManager.typography.size.lg
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                // Close button
                Rectangle {
                    width: 20
                    height: 20
                    radius: 2
                    color: closeMouseArea.containsMouse
                        ? Theme.ThemeManager.colors.accent.primary
                        : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        color: Theme.ThemeManager.colors.accent.secondary
                        font.pixelSize: Theme.ThemeManager.typography.size.sm
                        font.family: "Symbols Nerd Font"
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: themeLauncher.visible = false
                    }
                }
            }

            // Separator
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.ThemeManager.colors.accent.primary
            }

            // Theme list
            ThemeList {
                id: themeList
                Layout.fillWidth: true

                onThemeSelected: function(themeId) {
                    Theme.ThemeManager.setTheme(themeId)

                    if (externalScriptPath !== "") {
                        scriptProcess.command = ["bash", externalScriptPath, themeId]
                        scriptProcess.running = true
                    }

                    themeLauncher.visible = false
                }
            }
        }
    }

    // Process for external script execution
    Process {
        id: scriptProcess
        running: false
    }

    function toggle() { visible = !visible }
    function open()   { visible = true }
    function close()  { visible = false }
}
