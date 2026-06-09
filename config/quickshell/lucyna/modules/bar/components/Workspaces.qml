import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../../core/theme" as Theme

/*!
    A dynamic widget for displaying and switching between Hyprland workspaces.
    This component renders a horizontal row of workspace indicators
    based on the Hyprland workspaces.
*/
Item {
    implicitWidth: workspaceRow.implicitWidth
    implicitHeight: parent.height
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

    // multi-monitor values to render property
    property var screen: null
    property string monitorName: screen ? screen.name : ""
    property int numWorkspaces: 10

    /*!
        Normalized local ID from real hyprsplit ID
     */
    function localId(workspaceId) {
        return ((workspaceId - 1) % numWorkspaces) + 1;
    }

    /*!
        Returns the accent color for a workspace state (focused > active),
        or fallback when inactive. Used for both text and border coloring.
    */
    function workspaceColor(workspace, fallback) {
        if (workspace.focused) return Theme.ThemeManager.colors.accent.primary;
        if (workspace.active)  return Theme.ThemeManager.colors.accent.secondary;
        return fallback;
    }

    // Show workspaces
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent

        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                // Hide special workspaces
                visible: modelData.id > 0 && modelData.monitor !== null && modelData.monitor.name === monitorName

                // Collapse non visible items
                width: visible ? 25 : 0
                height: visible ? 25 : 0

                color: "transparent"
                Layout.alignment: Qt.AlignVCenter

                // Workspaces colors & names implementation
                Text {
                    anchors.centerIn: parent
                    text: workspaceNames[localId(modelData.id).toString()] || localId(modelData.id)
                    color: workspaceColor(modelData, Theme.ThemeManager.colors.on.surfaceMuted)
                    font.pixelSize: Theme.ThemeManager.typography.size.sm
                }

                // Bottom border indicator for active/focused workspaces
                Rectangle {
                    id: bottomBorder
                    width: parent.width * 0.8
                    height: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: workspaceColor(modelData, "transparent")
                }

                // Clickable
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
