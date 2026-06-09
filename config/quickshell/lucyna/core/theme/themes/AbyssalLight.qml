pragma Singleton

import QtQuick

/*!
    Abyssal Light (Marble) — light variant of the Abyssal palette family.
*/
QtObject {
    readonly property string id:   "abysal-marble"
    readonly property string name: "Abysal Marble"

    readonly property color base:       "#dcdcdc"  // main background
    readonly property color surface:    "#cfcfcf"  // secondary background
    readonly property color text:       "#2f2f2f"  // main text
    readonly property color color1:     "#2c9279"  // turquoise
    readonly property color color2:     "#a04e1e"  // orange
    readonly property color color3:     "#7a6020"  // sand
    readonly property color color4:     "#a8474a"  // soft red
    readonly property color color5:     "#365ca8"  // steel blue
    readonly property color color6:     "#824699"  // lavender purple
    readonly property color color7:     "#555555"  // dark gray secondary
    readonly property color color8:     "#737373"  // medium gray / comments
    readonly property color color9:     "#bcbcbc"  // light gray borders
    readonly property color highlight1: "#d4d4d4"  // faint selection
    readonly property color highlight2: "#c4c4c4"  // medium selection
    readonly property color highlight3: "#b8b8b8"  // strong selection
    readonly property real  barOpacity: 0.92
}
