pragma Singleton

import QtQuick

/*!
    CalendarState — local visibility state for the calendar module.

    Lives here (modules/calendar/state/) rather than core/services/
    because no other module needs to read calendar visibility — YAGNI.
    If another module ever needs it, it moves to core/ at that point.
*/
QtObject {
    id: root

    property bool isVisible: false

    function toggle() {
        isVisible = !isVisible
    }
}
