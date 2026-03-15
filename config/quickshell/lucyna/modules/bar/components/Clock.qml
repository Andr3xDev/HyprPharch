import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*!
    Clock text to show current time & day of the week. 
*/
Item {
    id: clock
    implicitWidth: clockText.implicitWidth + 16
    height: parent.height
    
    // Timer to update clock every minute
    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.updateTime()
    }

    /*!
        Get the real time up
    */
    function updateTime() {
        var now = new Date()
        var timeStr = Qt.formatDateTime(now, "hh:mm ap")
        var dateStr = Qt.formatDateTime(now, "dd - ddd")
        clockText.text = timeStr + "   |   " + dateStr
    }
    
    // Text to show time
    Text {
        id: clockText
        anchors.centerIn: parent
        font.bold: true
        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
        color: Theme.ThemeManager.currentPalette.text
    }
}
