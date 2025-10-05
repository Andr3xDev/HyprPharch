pragma Singleton
import QtQuick

QtObject {
    readonly property var palettes: {

        // --- Rosé Pine Palettes  ---
        "rose-pine-d": {
            background: "#191724", // Base
            surface:    "#1f1d2e", // Surface
            primary:    "#c4a7e7", // Iris
            text:       "#e0def4", // Text
            textMuted:  "#6e6a86", // Muted
            border:     "#403d52", // Highlight Med
            success:    "#31748f", // Pine
            warning:    "#f6c177", // Gold
            error:      "#eb6f92"  // Love
        },

        "rose-pine-l": {
            background: "#faf4ed", // Base
            surface:    "#fffaf3", // Surface
            primary:    "#907aa9", // Iris
            text:       "#575279", // Text
            textMuted:  "#9893a5", // Muted
            border:     "#dfdad9", // Highlight Med
            success:    "#286983", // Pine
            warning:    "#ea9d34", // Gold
            error:      "#b4637a"  // Love
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