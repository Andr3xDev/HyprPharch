pragma Singleton

import QtQuick

/*!
    TypographyTokens — Font families, sizes, and weights.

    Components reference these tokens; they never hard-code
    pixel sizes or font family strings.
*/
QtObject {
    // ── Families ──────────────────────────────────────────
    readonly property QtObject family: QtObject {
        readonly property string sans:  "Sans Serif"
        readonly property string mono:  "Monospace"
        readonly property string icons: "Symbols Nerd Font"
    }

    // ── Sizes (px) ────────────────────────────────────────
    readonly property QtObject size: QtObject {
        readonly property int xs: 8   // smallFontSize
        readonly property int sm: 10  // baseFontSize
        readonly property int md: 11  // subtitleFontSize
        readonly property int lg: 13  // titleFontSize
        readonly property int xl: 16
    }

    // ── Icon sizes ────────────────────────────────────────
    readonly property int iconSize: 12  // iconFontSize

    // ── Weights ───────────────────────────────────────────
    readonly property QtObject weight: QtObject {
        readonly property int regular: Font.Normal
        readonly property int medium:  Font.Medium
        readonly property int bold:    Font.Bold
    }
}
