import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services

/*!
    Clock text to show current time & day of the week.
    Clicking it toggles the floating calendar panel.
*/
Item {
    id: clock
    implicitWidth: clockText.implicitWidth + 16
    Layout.fillHeight: true

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.updateTime()
    }

    function updateTime() {
        var now = new Date()
        var timeStr = Qt.formatDateTime(now, "hh:mm ap")
        var dateStr = Qt.formatDateTime(now, "dd - ddd")
        clockText.text = timeStr + "   |   " + dateStr
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        font.bold:       true
        font.pixelSize:  Theme.ThemeManager.currentPalette.baseFontSize
        color: Services.CalendarState.isVisible
            ? Theme.ThemeManager.currentPalette.color1
            : Theme.ThemeManager.currentPalette.text

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        onClicked:    Services.CalendarState.toggle()
    }
}
