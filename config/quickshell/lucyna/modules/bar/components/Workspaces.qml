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
        "11": "ル"
    }
    
    /*!
        Get color based on workspace state (focused, active, or inactive)
        Handles multi-monitor setups where workspaces can be active but not focused
    */
    function getWorkspaceColor(workspace) {
        if (workspace.focused) return Theme.ThemeManager.currentPalette.color1
        if (workspace.active) return Theme.ThemeManager.currentPalette.color2
        return Theme.ThemeManager.currentPalette.color8
    }
    
    /*!
        Get border color (transparent if not active/focused)
    */
    function getBorderColor(workspace) {
        if (workspace.focused) return Theme.ThemeManager.currentPalette.color1
        if (workspace.active) return Theme.ThemeManager.currentPalette.color2
        return "transparent"
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
                    color: getWorkspaceColor(modelData)
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                }
                
                // Bottom border indicator for active/focused workspaces
                Rectangle {
                    id: bottomBorder
                    width: parent.width * 0.8
                    height: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: getBorderColor(modelData)
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