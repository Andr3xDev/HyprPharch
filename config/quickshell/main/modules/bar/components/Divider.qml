import QtQuick
import QtQuick.Layouts

Item {
    property alias dividerColor: divider.color
    
    Layout.preferredWidth: 2
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter
    
    Rectangle {
        id: divider
        width: 4
        height: parent.height -4
        color: "#000000"
        anchors.centerIn: parent
    }
}