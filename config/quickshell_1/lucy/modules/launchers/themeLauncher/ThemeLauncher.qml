import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*!
    Theme selector popup - minimal launcher to switch between color themes
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
    
    anchors {
        bottom: true
    }
    
    // Use mask for proper popup shape
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
        color: Theme.ThemeManager.currentPalette.surface
        radius: 0
        border.color: Theme.ThemeManager.currentPalette.color1
        border.width: 1
        
        implicitHeight: contentColumn.implicitHeight + 32
        
        // Handle Escape key to close
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
                    color: Theme.ThemeManager.currentPalette.color9
                    font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize + 2
                    font.family: "Symbols Nerd Font"
                }

                Text {
                    text: "Themes"
                    color: Theme.ThemeManager.currentPalette.text
                    font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                // Close button
                Rectangle {
                    width: 20
                    height: 20
                    radius: 2
                    color: closeMouseArea.containsMouse 
                        ? Theme.ThemeManager.currentPalette.color1 
                        : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        color: Theme.ThemeManager.currentPalette.color2
                        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
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
                color: Theme.ThemeManager.currentPalette.color1
            }

            // Theme list
            ThemeList {
                id: themeList
                Layout.fillWidth: true
                
                onThemeSelected: function(themeId) {
                    Theme.ThemeManager.setTheme(themeId)
                    
                    // Execute external script if configured
                    if (externalScriptPath !== "") {
                        scriptProcess.command = [externalScriptPath, themeId]
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

    // Public functions
    function toggle() {
        visible = !visible
    }

    function open() {
        visible = true
    }

    function close() {
        visible = false
    }
}