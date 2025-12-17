import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../../theme" as Theme

/*!
    A dynamic widget for displaying and switching between Hyprland workspaces.
    This component renders a horizontal row of workspace indicators
    based on the Hyprland workspaces.
*/
Item {
    implicitWidth: workspaceRow.implicitWidth
    implicitHeight: parent
    width: implicitWidth
    height: implicitHeight
    
    // Map as JavaScript object that defines custom display names for workspaces
    property var workspaceNames: {
        "1": "イ",
        "2": "ロ",
        "3": "ハ",
        "4": "ニ",
        "5": "ホ",
        "6": "ヘ",
        "7": "ト",
        "8": "チ",
        "9": "リ",
        "10": "ヌ",
        "11": "イ"
    }
    
    // Show workspaces
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        
        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                // Hide special workspaces
                visible: modelData.id > 0

                // Collapse non visible items
                width: visible ? 25 : 0
                height: visible ? 25 : 0
                
                color: "transparent"
                Layout.alignment: Qt.AlignVCenter
                
                // Workspaces colors & names implementation
                Text {
                    anchors.centerIn: parent
                    text: workspaceNames[modelData.id.toString()] || modelData.id
                    
                    // Color to each type of workspace (active & focus - active & noFocus - inactive)
                    // This is for multiple monitors
                    color: {
                        if (modelData.focused) {
                            return Theme.ThemeManager.currentPalette.color8 // focus
                        } else if (modelData.active) {
                            return Theme.ThemeManager.currentPalette.color6 // no-focus
                        } else {
                            return Theme.ThemeManager.currentPalette.color2
                        }
                    }
                    
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                    
                }
                
                // Button border to active & focus workspace
                Rectangle {
                    id: bottomBorder
                    width: parent.width * 0.8
                    height: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    
                    // Color to each type of workspace (active & focus - active & noFocus - inactive)
                    // This is for multiple monitors
                    color: {
                        if (modelData.focused) {
                            return Theme.ThemeManager.currentPalette.color8 // focus
                        } else if (modelData.active) {
                            return Theme.ThemeManager.currentPalette.color6 // no-focus
                        } else {
                            return "transparent"
                        }
                    }
                }
            
                // Clickable
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + modelData.id)
                }
            }
        }
    }
}