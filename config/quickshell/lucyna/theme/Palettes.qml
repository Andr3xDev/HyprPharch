pragma Singleton

import QtQuick

/*!
    Color schemes for all QuickShell applications.
    The advantage is that colors are defined with numbers,
    allowing for relatively simple changes.
*/
QtObject {
    readonly property var palettes: {

        // --- Abysal Palettes ---
        "abysal-obsidian": {
            base:       "#1c1c1c", // main_background
            surface:    "#262626", // secondary_background
            text:       "#d4d4d4", // main_text
            color1:     "#52c9b0", // turquoise
            color2:     "#e28e5a", // orange
            color3:     "#d1b171", // sand
            color4:     "#d47779", // soft_red
            color5:     "#6b92e3", // steel_blue
            color6:     "#b87bce", // lavender_purple
            color7:     "#8c8c8c", // light_gray_secondary
            color8:     "#737373", // medium_gray_comments
            color9:     "#2e2e2e", // dark_gray_borders
            highlight1: "#2a2a2a", // faint_selection
            highlight2: "#333333", // medium_selection
            highlight3: "#454545", // strong_selection
            barOpacity: 0.85       // bar transparency
        },

        "abysal-marble": {
            base:       "#dcdcdc", // main_background
            "surface":    "#cfcfcf", // secondary_background
            "text":       "#2f2f2f", // main_text
            "color1":     "#2c9279", // turquoise
            "color2":     "#b55b25", // orange
            "color3":     "#947635", // sand
            "color4":     "#a8474a", // soft_red
            "color5":     "#365ca8", // steel_blue
            "color6":     "#824699", // lavender_purple
            "color7":     "#555555", // dark_gray_secondary
            "color8":     "#737373", // medium_gray_comments
            "color9":     "#bcbcbc", // light_gray_borders
            "highlight1": "#d4d4d4", // faint_selection
            "highlight2": "#c4c4c4", // medium_selection
            "highlight3": "#b8b8b8", // strong_selection
            "barOpacity": 0.92       // bar transparency
        }
    }
}
