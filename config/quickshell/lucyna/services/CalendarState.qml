pragma Singleton

import QtQuick

/*!
    Shared visibility state for the calendar panel.
    Uses QtObject (same pattern as ThemeManager) to guarantee
    a single instance across all import contexts.
*/
QtObject {
    id: root

    property bool isVisible: false

    function toggle() {
        isVisible = !isVisible
    }
}
