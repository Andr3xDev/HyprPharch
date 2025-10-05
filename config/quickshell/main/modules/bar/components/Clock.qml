import Quickshell
import QtQuick

Rectangle {
    id: clock
    width: clockText.width

    SystemClock {
        id: clockSys
        precision: SystemClock.Minutes
    }

    Text {
        id: clockText
        font.bold: true
        font.pixelSize: 11
        color: "#000000"
        anchors.centerIn: parent
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var now = new Date()
                var timeStr = Qt.formatDateTime(now, "hh : mm")
                var dateStr = Qt.formatDateTime(now, "d / M")
                clockText.text = timeStr + "  |  " + dateStr
            }
        }

        Component.onCompleted: {
            var now = new Date()
            var timeStr = Qt.formatDateTime(now, "hh : mm")
            var dateStr = Qt.formatDateTime(now, "d / M")
            text = timeStr + "  |  " + dateStr
        }
    }
}