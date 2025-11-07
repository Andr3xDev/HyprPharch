import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*
    Clock text to show current time & day of the week. 
*/
Item {
    id: clock
    
    implicitWidth: clockText.implicitWidth + 16
    height: parent.height
    
    SystemClock {
        id: clockSys
        precision: SystemClock.Minutes
    }
    
    // Get the real time up
    function updateTime() {
        var now = new Date()
        var timeStr = Qt.formatDateTime(now, "h:mm")
        var dateStr = Qt.formatDateTime(now, "dd - ddd")
        clockText.text = timeStr + "   |   " + dateStr
    }
    
    // Timer to show the time
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.updateTime()
    }
    
    Text {
        id: clockText
        anchors.centerIn: parent
        font.bold: true
        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
        color: Theme.ThemeManager.currentPalette.text
    }
    
    Component.onCompleted: updateTime()
}