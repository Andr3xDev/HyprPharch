pragma Singleton
import QtQuick

/*!
    Color schemes for all QuickShell applications.
    The advantage is that colors are defined with numbers,
    allowing for relatively simple changes.
*/
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
            color12: "#2A2837"  // Other
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
            base:    "#282828", // background
            surface: "#32302F", // surface
            text:    "#D4BE98", // text
            color1:  "#45403D", // border
            color2:  "#928374", // textMuted
            color3:  "#928374", // textMuted
            color4:  "#EA6962", // error
            color5:  "#D8A657", // warning
            color6:  "#A9B665", // error
            color7:  "#7DAEA3", // primary
            color9:  "#A9B665", // success
            color8:  "#7DAEA3", // primary
            color10: "#32302F", // surface
            color11: "#45403D", // border
            color12: "#45403D"  // border
        },

        "gruvbox-material-l": {
            base:    "#FBF1C7", // background
            surface: "#F4E8BE", // surface
            text:    "#4F3829", // text
            color1:  "#E5D5AD", // border
            color2:  "#928374", // textMuted
            color3:  "#928374", // textMuted
            color4:  "#C14A4A", // error
            color5:  "#C35E0A", // warning
            color6:  "#6C782E", // corresponde a tu green del dark
            color7:  "#45707A", // primary
            color9:  "#4C7A5D", // success
            color8:  "#45707A", // primary
            color10: "#F4E8BE", // surface
            color11: "#E5D5AD", // border
            color12: "#A89984", // border
        }

    }
}
