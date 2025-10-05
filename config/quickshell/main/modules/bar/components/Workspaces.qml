import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    height: 25
    
    property var workspaceNames: {
        "1": "計",  //calculate :3
        "2": "二",
        "3": "三",
        "4": "四",
        "5": "五",
        "6": "六",
        "7": "七",
        "8": "八",
        "9": "九",
        "10": "零",
        "11": "X"
    }
    
    RowLayout {
        id: workspaceRow
        anchors.fill: parent
        
        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                visible: modelData.id > 0
                width: visible ? 25 : 0
                height: visible ? 25 : 0
                color: "transparent"
                
                Layout.alignment: Qt.AlignVCenter
                
                Text {
                    anchors.centerIn: parent
                    text: workspaceNames[modelData.id.toString()] || modelData.id
                    color: modelData.active ? "#000000" : "#003cff"
                    font.pixelSize: 12
                    font.bold: modelData.active
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + modelData.id)
                }
            }
        }
    }
}