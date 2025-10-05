import QtQuick
import Qt.labs.settings 1.0
import Quickshell
import "./ThemeColors"

QtObject {
    id: root
    
    // Persistence config
    Settings {
        id: settings
        property string currentTheme: "catppuccin"
        property bool systemIntegration: true
    }
    
    property string currentTheme: settings.currentTheme
    property var colors: palettes[currentTheme] || palettes.catppuccin
    signal themeChanged(string themeName)
    
    // API 
    function setTheme(themeName) {
        if (!palettes[themeName]) {
            console.warn(`Theme '${themeName}' not found`)
            return false
        }
        
        settings.currentTheme = themeName
        
        // Ejecutar script del sistema si está habilitado
        if (settings.systemIntegration) {
            applySystemTheme(themeName)
        }
        
        themeChanged(themeName)
        return true
    }
    
    function getAvailableThemes() {
        return Object.keys(palettes)
    }
    
    function enableSystemIntegration(enable) {
        settings.systemIntegration = enable
    }
    
    function applySystemTheme(themeName) {
        // Ejecutar el script bash
        var scriptPath = StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/theme-switcher.sh"
        
        Process.exec("bash", [scriptPath, themeName])
        console.log(`Applied system theme: ${themeName}`)
    }
    
    Component.onCompleted: {
        console.log(`ThemeManager initialized with theme: ${currentTheme}`)
        themeChanged(currentTheme)
    }
}