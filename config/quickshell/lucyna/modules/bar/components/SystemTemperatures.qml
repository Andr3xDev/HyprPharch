import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "../../../core/services" as Services

/*!
    Group of indicators to know the status of the temp in PC's components
*/
Item {
    id: root
    implicitWidth: visible ? tempsRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true

    /*!
        Return color to indicate warning levels
    */
    function getTempColor(temp) {
        if (temp >= 80) return Theme.ThemeManager.colors.status.error    // critical
        if (temp >= 70) return Theme.ThemeManager.colors.status.warning  // warning
        return Theme.ThemeManager.colors.accent.primary                  // normal
    }
    
    RowLayout {
        id: tempsRow
        anchors.centerIn: parent
        spacing: 10
        opacity: root.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU Temperature
        RowLayout {
            visible: Services.TemperatureService.cpuTemp > 0
            spacing: Theme.ThemeManager.spacing.xs
            
            Text {
                text: "󰍛"
                color: root.getTempColor(Services.TemperatureService.cpuTemp)
                font.pixelSize: Theme.ThemeManager.typography.iconSize
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                text: `${Math.round(Services.TemperatureService.cpuTemp)}°`
                color: Theme.ThemeManager.colors.on.surface
                font.pixelSize: Theme.ThemeManager.typography.size.sm
            }
        }
        
        // GPU Temperature
        RowLayout {
            visible: Services.TemperatureService.hasGPU
            spacing: Theme.ThemeManager.spacing.xs
            
            Text {
                text: "󰾲"
                color: root.getTempColor(Services.TemperatureService.gpuTemp)
                font.pixelSize: Theme.ThemeManager.typography.iconSize
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                text: `${Math.round(Services.TemperatureService.gpuTemp)}°`
                color: Theme.ThemeManager.colors.on.surface
                font.pixelSize: Theme.ThemeManager.typography.size.sm
            }
        }
    }

    // Animation to toggle
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
}