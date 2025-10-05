import Quickshell
import QtQuick

Rectangle {
    id: battery
    width: batteryText.width

    Text {
        id: clockText
        font.bold: true
        font.pixelSize: 11
        color: "#000000"
        anchors.centerIn: parent
        
        Component.onCompleted: {
            var now = new Date()
            var timeStr = Qt.formatDateTime(now, "hh : mm")
            var dateStr = Qt.formatDateTime(now, "d / M")
            text = timeStr + "  |  " + dateStr
        }
    }
}