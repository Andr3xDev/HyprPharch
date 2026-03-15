pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

/**
 * ThemeManager is a singleton object responsible for managing the application's theme.
 * It provides functionality to persist the current theme, retrieve available themes,
 * and compute the current palette based on the selected theme.
 */
QtObject {
    id: themeManager

    // Current theme name, defaults to "abysal-obsidian" until the data file is read
    property string currentTheme: "abysal-obsidian"
    property var theme: currentPalette

    readonly property string _dataDir: "/home/andrex/.config/quickshell/lucyna/data"

    // Read saved theme from data/theme.json on startup
    property FileView _themeFile: FileView {
        path: themeManager._dataDir + "/theme.json"
        onTextChanged: {
            if (!text.trim()) return
            try {
                const data = JSON.parse(text)
                if (data.theme && themeManager.availableThemes.includes(data.theme))
                    themeManager.currentTheme = data.theme
            } catch(e) {}
        }
    }

    // Process to persist theme changes to disk
    property Process _saveProc: Process {
        running: false
    }

    // List of available themes
    readonly property var availableThemes: [
        "abysal-obsidian",
        "abysal-marble"
    ]

    // Computed current palette based on the selected theme
    readonly property QtObject currentPalette: QtObject {
        readonly property color base:       Local.Palettes.palettes[currentTheme].base
        readonly property color surface:    Local.Palettes.palettes[currentTheme].surface
        readonly property color text:       Local.Palettes.palettes[currentTheme].text
        readonly property color muted:      Local.Palettes.palettes[currentTheme].color8
        readonly property color color1:     Local.Palettes.palettes[currentTheme].color1
        readonly property color color2:     Local.Palettes.palettes[currentTheme].color2
        readonly property color color3:     Local.Palettes.palettes[currentTheme].color3
        readonly property color color4:     Local.Palettes.palettes[currentTheme].color4
        readonly property color color5:     Local.Palettes.palettes[currentTheme].color5
        readonly property color color6:     Local.Palettes.palettes[currentTheme].color6
        readonly property color color7:     Local.Palettes.palettes[currentTheme].color7
        readonly property color color8:     Local.Palettes.palettes[currentTheme].color8
        readonly property color color9:     Local.Palettes.palettes[currentTheme].color9
        readonly property color highlight1: Local.Palettes.palettes[currentTheme].highlight1
        readonly property color highlight2: Local.Palettes.palettes[currentTheme].highlight2
        readonly property color highlight3: Local.Palettes.palettes[currentTheme].highlight3

        // Font sizes
        readonly property int baseFontSize: 10
        readonly property int titleFontSize: 13
        readonly property int smallFontSize: 8
        readonly property int iconFontSize: 12

        // Spacing
        readonly property int spacing: 10
        readonly property int barComponentsSpacing: 30
        readonly property int margin: 1
        readonly property int marginItems: 15

        // Border radius
        readonly property int radius: 6
        readonly property int radiusInner: 8

        // Bar opacity
        readonly property real barOpacity: Local.Palettes.palettes[currentTheme].barOpacity || 0.85
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
            _saveProc.command = [
                "python3", "-c",
                "import sys,os; p=sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p,'w').write(sys.argv[2])",
                _dataDir + "/theme.json",
                JSON.stringify({theme: themeName})
            ]
            _saveProc.running = true
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
            "abysal-obsidian": "Abysal Obsidian",
            "abysal-marble": "Abysal Marble"
        }
        return names[themeName] || themeName
    }
}