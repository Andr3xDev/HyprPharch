pragma Singleton
import QtQuick
import Qt.labs.settings
import "." as Local

/**
 * ThemeManager is a singleton object responsible for managing the application's theme.
 * It provides functionality to persist the current theme, retrieve available themes,
 * and compute the current palette based on the selected theme.
 */
QtObject {
    id: themeManager

    // Current theme name, defaults to "rose-pine-d" if no saved theme is found
    property string currentTheme: settings.savedTheme || "rose-pine-d"
    property var theme: currentPalette

    // Theme persistence settings
    property Settings settings: Settings {
        category: "appearance"
        // Saved theme name, defaults to "rose-pine-d"
        property string savedTheme: "rose-pine-d"
    }

    // List of available themes
    readonly property var availableThemes: [
        "rose-pine-d",
        "rose-pine-l",
        "gruvbox-material-d",
        "gruvbox-material-l"
    ]

    // Computed current palette based on the selected theme
    readonly property QtObject currentPalette: QtObject {
        readonly property color base:    Local.Palettes.palettes[currentTheme].base
        readonly property color surface: Local.Palettes.palettes[currentTheme].surface
        readonly property color text:    Local.Palettes.palettes[currentTheme].text
        readonly property color color1:  Local.Palettes.palettes[currentTheme].color1
        readonly property color color2:  Local.Palettes.palettes[currentTheme].color2
        readonly property color color3:  Local.Palettes.palettes[currentTheme].color3
        readonly property color color4:  Local.Palettes.palettes[currentTheme].color4
        readonly property color color5:  Local.Palettes.palettes[currentTheme].color5
        readonly property color color6:  Local.Palettes.palettes[currentTheme].color6
        readonly property color color7:  Local.Palettes.palettes[currentTheme].color7
        readonly property color color8:  Local.Palettes.palettes[currentTheme].color8
        readonly property color color9:  Local.Palettes.palettes[currentTheme].color9
        readonly property color color10: Local.Palettes.palettes[currentTheme].color10
        readonly property color color11: Local.Palettes.palettes[currentTheme].color11
        readonly property color color12: Local.Palettes.palettes[currentTheme].color12

        // Font sizes
        readonly property int baseFontSize: 11
        readonly property int titleFontSize: 13
        readonly property int smallFontSize: 9

        // Spacing
        readonly property int spacing: 10
        readonly property int barComponentsSpacing: 30
        readonly property int margin: 1
        readonly property int marginItems: 15
    }

    /**
     * Sets the current theme to the specified theme name.
     * If the theme name is valid, it updates the current theme and persists it.
     * @param {string} themeName - The name of the theme to set.
     * @returns {boolean} - True if the theme was successfully set, false otherwise.
     */
    function setTheme(themeName) {
        if (availableThemes.includes(themeName)) {
            currentTheme = themeName
            settings.savedTheme = themeName
            return true
        }
        return false
    }

    /**
     * Retrieves the next theme in the list of available themes.
     * Cycles back to the first theme if the current theme is the last in the list.
     * @returns {string} - The name of the next theme.
     */
    function getNextTheme() {
        const currentIndex = availableThemes.indexOf(currentTheme)
        const nextIndex = (currentIndex + 1) % availableThemes.length
        return availableThemes[nextIndex]
    }

    /**
     * Retrieves a user-friendly display name for the specified theme.
     * @param {string} themeName - The name of the theme.
     * @returns {string} - The display name of the theme.
     */
    function getThemeDisplayName(themeName) {
        const names = {
            "rose-pine-d": "Rosé Pine Dark",
            "rose-pine-l": "Rosé Pine Light",
            "gruvbox-material-d": "Gruvbox Dark",
            "gruvbox-material-l": "Gruvbox Light"
        }
        return names[themeName] || themeName
    }
}