import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services

/*!
    Battery component indicator to presentation data 
*/
RowLayout {
    id: root
    spacing: 4
    
    RowLayout {
        height: parent.height
        spacing: 4
        
        // Battery icon
        Text {
            Layout.alignment: Qt.AlignVCenter
            visible: Services.BatteryService.battery !== null
            text: Services.BatteryService.getBatteryIcon()
            color: Services.BatteryService.isCritical()
                ? Theme.ThemeManager.currentPalette.color4
                : Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
            font.family: "Symbols Nerd Font"
            
            // Animation for critical battery
            SequentialAnimation on opacity {
                running: Services.BatteryService.isCritical()
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 800 }
                NumberAnimation { from: 0.3; to: 1.0; duration: 800 }
            }
        }
        
        // Battery percentage
        Text {
            visible: !Services.BatteryService.shouldHideLevel()
            text: Services.BatteryService.battery 
                ? Math.round(Services.BatteryService.batteryLevel) + "%" 
                : "N/A"
            color: Services.BatteryService.isCritical()
                ? Theme.ThemeManager.currentPalette.color4
                : Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            font.bold: Services.BatteryService.isCritical()
        }
    }
}
