import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "." as Local

/*!
    Monthly calendar grid with header, weekday labels, and day cells.

    Features:
      - Always renders exactly 6 rows × 7 columns (42 cells) for a stable size
      - Days outside the current month are dimmed
      - Today is highlighted with the accent color
      - Sundays and Colombian holidays use the alert color
      - Navigation between months via prev/next/today buttons
      - "Today" highlight refreshes every minute (stays accurate past midnight)
*/
Item {
    id: root

    // ─────────────────────────────────── Navigable state ──
    property int displayMonth: _todayMonth
    property int displayYear:  _todayYear

    // ──────────────────────────────────────── Constants ──
    readonly property int _cellSize:  34
    readonly property int _cellGap:    4
    readonly property int _headerH:   36
    readonly property int _weekdayH:  20
    readonly property int _pad:       12

    // ── Today — refreshed every minute so the highlight stays correct past midnight ──
    property var _today: new Date()
    readonly property int _todayDay:   _today.getDate()
    readonly property int _todayMonth: _today.getMonth() + 1
    readonly property int _todayYear:  _today.getFullYear()

    Timer {
        interval: 60000
        running:  true
        repeat:   true
        onTriggered: root._today = new Date()
    }

    readonly property var _monthNames: [
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
    ]

    readonly property var _weekLabels: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    // ── 42-cell grid descriptor ──────────────────────────
    /*!
        Reactive array of 42 cell descriptors for the current display month.
        Column 0 is always Sunday.
        Recomputes when displayMonth, displayYear, or _today changes.
        Overflow cells use pure arithmetic — no Date objects inside the loop.
    */
    readonly property var cells: {
        const y = displayYear, m = displayMonth
        const firstDow      = new Date(y, m - 1, 1).getDay()
        const daysInMonth   = new Date(y, m, 0).getDate()
        const prevMonthDays = new Date(y, m - 1, 0).getDate()
        const prevM = m === 1  ? 12    : m - 1
        const prevY = m === 1  ? y - 1 : y
        const nextM = m === 12 ? 1     : m + 1
        const nextY = m === 12 ? y + 1 : y

        const result = []
        for (let i = 0; i < 42; i++) {
            const offset = i - firstDow
            let day, cm, cy

            if (offset < 0) {
                day = prevMonthDays + offset + 1;  cm = prevM; cy = prevY
            } else if (offset < daysInMonth) {
                day = offset + 1;                  cm = m;     cy = y
            } else {
                day = offset - daysInMonth + 1;    cm = nextM; cy = nextY
            }

            const cur = offset >= 0 && offset < daysInMonth
            result.push({
                day, month: cm, year: cy,
                isCurrentMonth: cur,
                isToday:  cur && day === _todayDay && cm === _todayMonth && cy === _todayYear,
                isSunday: (i % 7) === 0
            })
        }
        return result
    }

    // ── Reusable navigation button ────────────────────────
    component NavButton: Rectangle {
        id: btn

        property alias label:      lbl.text
        property alias labelColor: lbl.color
        property alias labelSize:  lbl.font.pixelSize

        signal activated()

        implicitWidth:  lbl.implicitWidth + 12
        implicitHeight: 26
        radius: Theme.ThemeManager.currentPalette.radius
        color:  ma.containsMouse
                ? Theme.ThemeManager.currentPalette.highlight2
                : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            id: lbl
            anchors.centerIn: parent
            color:          Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.PointingHandCursor
            onClicked:    btn.activated()
        }
    }

    // ── Layout ────────────────────────────────────────────
    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: root._pad
        spacing: 6

        // ── Header ──────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            implicitHeight:   root._headerH
            spacing: 4

            NavButton {
                implicitWidth: 26
                label:         "‹"
                onActivated:   root._prevMonth()
            }

            Text {
                Layout.fillWidth:    true
                horizontalAlignment: Text.AlignHCenter
                text:           root._monthNames[root.displayMonth - 1] + "  " + root.displayYear
                color:          Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.subtitleFontSize
                font.bold:      true
            }

            NavButton {
                label:      "Today"
                labelColor: Theme.ThemeManager.currentPalette.color1
                labelSize:  Theme.ThemeManager.currentPalette.smallFontSize
                onActivated: root._goToday()
            }

            NavButton {
                implicitWidth: 26
                label:         "›"
                onActivated:   root._nextMonth()
            }
        }

        // ── Weekday labels ──────────────────────────────
        Row {
            Layout.fillWidth: true
            spacing: root._cellGap

            Repeater {
                model: root._weekLabels
                Text {
                    width:               root._cellSize
                    height:              root._weekdayH
                    text:                modelData
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    color:               Theme.ThemeManager.currentPalette.muted
                    font.pixelSize:      Theme.ThemeManager.currentPalette.smallFontSize
                    font.bold:           true
                }
            }
        }

        // ── Day grid ─────────────────────────────────────
        Grid {
            columns:       7
            rowSpacing:    root._cellGap
            columnSpacing: root._cellGap

            Repeater {
                model: root.cells

                Item {
                    width:  root._cellSize
                    height: root._cellSize

                    Rectangle {
                        anchors.centerIn: parent
                        width:  root._cellSize - 4
                        height: root._cellSize - 4
                        radius: (root._cellSize - 4) / 2
                        color:  modelData.isToday
                                ? Qt.rgba(
                                    Theme.ThemeManager.currentPalette.color1.r,
                                    Theme.ThemeManager.currentPalette.color1.g,
                                    Theme.ThemeManager.currentPalette.color1.b,
                                    0.18)
                                : "transparent"
                    }

                    Text {
                        anchors.centerIn: parent
                        text:           modelData.day
                        font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                        font.bold:      modelData.isToday
                        opacity:        modelData.isCurrentMonth ? 1.0 : 0.3
                        color: {
                            if (modelData.isToday)
                                return Theme.ThemeManager.currentPalette.color1
                            if (modelData.isCurrentMonth
                                    && (modelData.isSunday
                                        || Local.HolidayProvider.isHoliday(
                                               modelData.year, modelData.month, modelData.day)))
                                return Theme.ThemeManager.currentPalette.color2
                            return Theme.ThemeManager.currentPalette.text
                        }
                    }
                }
            }
        }
    }

    // ──────────────────────────────────── Navigation ──
    function _prevMonth() {
        if (displayMonth === 1) { displayMonth = 12; displayYear-- }
        else                    { displayMonth--                    }
    }

    function _nextMonth() {
        if (displayMonth === 12) { displayMonth = 1; displayYear++ }
        else                     { displayMonth++                   }
    }

    function _goToday() {
        displayMonth = _todayMonth
        displayYear  = _todayYear
    }
}
