import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "../../../core/services" as Services

/*!
    Battery indicator showing icon and charge percentage.
*/
RowLayout {
    id: root
    spacing: Theme.ThemeManager.spacing.xs

    // Battery icon
    Text {
        Layout.alignment: Qt.AlignVCenter
        visible: Services.BatteryService.battery !== null
        text: Services.BatteryService.getBatteryIcon()
        color: Services.BatteryService.isCritical()
            ? Theme.ThemeManager.colors.status.error
            : Theme.ThemeManager.colors.on.surface
        font.pixelSize: Theme.ThemeManager.typography.iconSize
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
            ? Theme.ThemeManager.colors.status.error
            : Theme.ThemeManager.colors.on.surface
        font.pixelSize: Theme.ThemeManager.typography.size.sm
        font.bold: Services.BatteryService.isCritical()
    }
}
