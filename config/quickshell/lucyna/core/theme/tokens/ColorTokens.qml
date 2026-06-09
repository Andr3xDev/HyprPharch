pragma Singleton

import QtQuick

/*!
    ColorTokens — Level 1 (raw palette values) + Level 2 (semantic mapping).

    Components consume semantic names only. Raw color literals live
    exclusively in the theme variant files (AbyssalDark, AbyssalLight).
*/
QtObject {
    id: root

    // Injected by ThemeManager when the active theme changes
    property var _palette: ({})

    // ── Level 2: Semantic surface colors ─────────────────
    readonly property QtObject surface: QtObject {
        readonly property color primary:   root._palette.base     ?? "#1c1c1c"
        readonly property color secondary: root._palette.surface  ?? "#262626"
        readonly property color overlay:   root._palette.highlight1 ?? "#2a2a2a"
    }

    // ── Level 2: Semantic on-surface (text) colors ────────
    readonly property QtObject on: QtObject {
        readonly property color surface:      root._palette.text  ?? "#d4d4d4"
        readonly property color surfaceMuted: root._palette.color8 ?? "#737373"
    }

    // ── Level 2: Accent colors ────────────────────────────
    readonly property QtObject accent: QtObject {
        readonly property color primary:   root._palette.color1 ?? "#52c9b0"
        readonly property color secondary: root._palette.color2 ?? "#e28e5a"
        readonly property color tertiary:  root._palette.color5 ?? "#6b92e3"
    }

    // ── Level 2: Status colors ────────────────────────────
    readonly property QtObject status: QtObject {
        readonly property color error:   root._palette.color4 ?? "#d47779"
        readonly property color warning: root._palette.color3 ?? "#d1b171"
        readonly property color success: root._palette.color1 ?? "#52c9b0"
    }

    // ── Level 2: Highlight / selection states ─────────────
    readonly property QtObject highlight: QtObject {
        readonly property color subtle:   root._palette.highlight1 ?? "#2a2a2a"
        readonly property color medium:   root._palette.highlight2 ?? "#333333"
        readonly property color strong:   root._palette.highlight3 ?? "#454545"
    }

    // ── Level 2: Misc ─────────────────────────────────────
    readonly property color border:     root._palette.color9  ?? "#2e2e2e"
    readonly property real  barOpacity: root._palette.barOpacity ?? 0.85

}
