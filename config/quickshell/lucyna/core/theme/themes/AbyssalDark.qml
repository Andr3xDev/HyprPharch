pragma Singleton

import QtQuick

/*!
    Abyssal Dark (Obsidian) — dark variant of the Abyssal palette family.
*/
QtObject {
    readonly property string id:   "abysal-obsidian"
    readonly property string name: "Abysal Obsidian"

    readonly property color base:       "#1c1c1c"  // main background
    readonly property color surface:    "#262626"  // secondary background
    readonly property color text:       "#d4d4d4"  // main text
    readonly property color color1:     "#52c9b0"  // turquoise
    readonly property color color2:     "#e28e5a"  // orange
    readonly property color color3:     "#d1b171"  // sand
    readonly property color color4:     "#d47779"  // soft red
    readonly property color color5:     "#6b92e3"  // steel blue
    readonly property color color6:     "#b87bce"  // lavender purple
    readonly property color color7:     "#8c8c8c"  // light gray secondary
    readonly property color color8:     "#737373"  // medium gray / comments
    readonly property color color9:     "#2e2e2e"  // dark gray borders
    readonly property color highlight1: "#2a2a2a"  // faint selection
    readonly property color highlight2: "#333333"  // medium selection
    readonly property color highlight3: "#454545"  // strong selection
    readonly property real  barOpacity: 0.85
}
