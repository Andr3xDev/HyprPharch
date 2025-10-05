import Quickshell
import QtQuick
import QtQuick.Layouts
import "./components";

PanelWindow {
    id: bar
    anchors {
        left: true
        top: true
        right: true
    }
    margins {
        left: 100
        right: 100
        bottom: 1
        top: 5
    }

    implicitHeight: 33
    color: "transparent"
    property int baseFontSize: 11
    
    Rectangle {
        anchors.fill: parent
        color: "#c16868"
        border.color: "#ffd4fe"
        border.width: 2
        width: parent.width
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 1
            
            // Left section
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                
                Clock { 
                    Layout.preferredWidth: 110
                    Layout.maximumWidth: 110
                }
                Divider { dividerColor: "#585b70" }
                Workspaces {}
            }
            
            // Spacer
            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: 20
            }
            
            // Right section
            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: parent.width * 0.5

                Battery{}
            }
        }
    }
}