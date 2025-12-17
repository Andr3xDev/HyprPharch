pragma Singleton
import QtQuick
import "." as Local

QtObject {
    id: themeManager
    
    property string currentTheme: "rose-pine-d"
    property var theme: currentPalette
    
    // Paletas disponibles
    readonly property var availableThemes: [
        "rose-pine-d",
        "rose-pine-l",
        "gruvbox-material-d",
        "gruvbox-material-l"
    ]
    
    // Paleta actual computada
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
    
    function setTheme(themeName) {
        if (availableThemes.includes(themeName)) {
            currentTheme = themeName
            return true
        }
        return false
    }
    
    function getNextTheme() {
        const currentIndex = availableThemes.indexOf(currentTheme)
        const nextIndex = (currentIndex + 1) % availableThemes.length
        return availableThemes[nextIndex]
    }
    
    // Nombres legibles para mostrar en UI
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