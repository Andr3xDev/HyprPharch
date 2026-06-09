pragma Singleton

import QtQuick

/*!
    MotionTokens — Animation durations and easing curves.

    All Behavior / NumberAnimation / ColorAnimation durations
    come from here to keep motion consistent across the system.
*/
QtObject {
    // ── Durations (ms) ────────────────────────────────────
    readonly property QtObject duration: QtObject {
        readonly property int fast:     100
        readonly property int standard: 200
        readonly property int slow:     350
    }

    // ── Easing types ──────────────────────────────────────
    readonly property QtObject easing: QtObject {
        readonly property int standard:    Easing.OutCubic
        readonly property int decelerate:  Easing.OutQuart
        readonly property int accelerate:  Easing.InCubic
    }
}
