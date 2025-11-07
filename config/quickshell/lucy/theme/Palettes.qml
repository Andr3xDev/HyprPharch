pragma Singleton
import QtQuick

QtObject {
    readonly property var palettes: {

        // --- Rosé Pine Palettes  ---
        "rose-pine-d": {
            base:    "#191724",
            surface: "#1f1d2e",
            text:    "#e0def4",
            color1:  "#26233a", // overlay
            color2:  "#6e6a86", // muted
            color3:  "#908caa", // subtle
            color4:  "#eb6f92", // love
            color5:  "#f6c177", // gold
            color6:  "#ebbcba", // rose
            color7:  "#31748f", // pine
            color8:  "#9ccfd8", // foam
            color9:  "#c4a7e7", // iris
            color10: "#21202e", // highlightLow
            color11: "#403d52", // highlightMed
            color12: "#524f67"  // highlightHigh
        },

        "rose-pine-l": {
            base:    "#faf4ed",
            surface: "#fffaf3",
            text:    "#575279",
            color1:  "#f2e9e1", // overlay
            color2:  "#9893a5", // muted
            color3:  "#797593", // subtle
            color4:  "#b4637a", // love
            color5:  "#ea9d34", // gold
            color6:  "#d7827e", // rose
            color7:  "#286983", // pine
            color8:  "#56949f", // foam
            color9:  "#907aa9", // iris
            color10: "#f4ede8", // highlightLow
            color11: "#dfdad9", // highlightMed
            color12: "#cecacd"  // highlightHigh
        },

        // --- Gruvbox Material Palettes ---
        "gruvbox-material-d": {
            background: "#282828", // bg0
            surface:    "#32302F", // bg1
            primary:    "#7DAEA3", // blue
            text:       "#D4BE98", // fg0
            textMuted:  "#928374", // grey1
            border:     "#45403D", // bg3
            success:    "#A9B665", // green
            warning:    "#D8A657", // yellow
            error:      "#EA6962"  // red
        },

        "gruvbox-material-l": {
            background: "#FBF1C7", // bg0
            surface:    "#F4E8BE", // bg1
            primary:    "#45707A", // blue
            text:       "#4F3829", // fg1
            textMuted:  "#928374", // grey1
            border:     "#EEE0B7", // bg3
            success:    "#6C782E", // green
            warning:    "#B47109", // yellow
            error:      "#C14A4A"  // red
        }

    }
}