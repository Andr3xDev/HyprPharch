import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import "../../../theme" as Theme

/**

*/
Item {
    implicitWidth: batteryRow.implicitWidth
    implicitHeight: 25
    width: implicitWidth
    height: implicitHeight
    
    property var battery: null
    property real batteryLevel: battery ? (battery.percentage * 100) : 0
    property bool isCharging: battery ? (battery.state === 1 || battery.state === 4) : false
    
    // ⭐ Guardar el último nivel notificado
    property int lastNotifiedLevel: -1
    
    Component.onCompleted: {
        updateBattery()
    }
    
    Connections {
        target: UPower.devices
        function onValuesChanged() {
            updateBattery()
        }
    }
    
    // ⭐ Monitorear cambios en battery level
    onBatteryLevelChanged: {
        checkBatteryNotification()
    }
    
    // ⭐ Resetear cuando se conecta el cargador
    onIsChargingChanged: {
        if (isCharging) {
            lastNotifiedLevel = -1
            console.log("Charging started, reset notifications")
        }
    }
    
    function updateBattery() {
        var deviceList = UPower.devices.values
        for (var i = 0; i < deviceList.length; i++) {
            var device = deviceList[i]
            if (device.nativePath && device.nativePath.includes("BAT")) {
                battery = device
                return
            }
        }
    }
    
    function checkBatteryNotification() {
        if (isCharging) return
        
        var level = Math.floor(batteryLevel)
        var thresholds = [20, 15, 10, 5]  // ⭐ De mayor a menor
        
        for (var i = 0; i < thresholds.length; i++) {
            var threshold = thresholds[i]
            // ⭐ Solo notificar si cruzamos este umbral y no lo habíamos notificado
            if (level === threshold && lastNotifiedLevel !== threshold) {
                sendNotification(threshold)
                lastNotifiedLevel = threshold
                return  // ⭐ Salir después de notificar
            }
        }
    }
    
    function sendNotification(level) {
        var urgency = level <= 10 ? "critical" : "normal"
        var icon = level <= 10 ? "battery-empty" : "battery-low"
        var title = level <= 10 ? "⚠️ Batería Crítica!" : "🔋 Batería Baja"
        var body = `Batería al ${level}%. Conecta el cargador.`
        
        var processComponent = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["notify-send", "-u", "${urgency}", "-i", "${icon}", "-a", "QuickShell Battery", "${title}", "${body}"]
            }
        `, parent, "notifyProcess")
        
        console.log(`Notification sent: Battery at ${level}%`)
    }
    
    RowLayout {
        id: batteryRow
        anchors.centerIn: parent
        spacing: 4
        
        // Icono de batería
        Text {
            visible: battery !== null
            text: {
                if (!battery) return ""
                if (isCharging) return "󰂄"
                if (batteryLevel > 90) return "󰁹"
                if (batteryLevel > 70) return "󰂀"
                if (batteryLevel > 50) return "󰁿"
                if (batteryLevel > 30) return "󰁽"
                if (batteryLevel > 10) return "󰁼"
                return "󰁺"
            }
            color: {
                if (batteryLevel <= 20 && !isCharging) return Theme.ThemeManager.currentPalette.color4
                if (isCharging) return Theme.ThemeManager.currentPalette.color3
                return Theme.ThemeManager.currentPalette.text
            }
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
            font.family: "Symbols Nerd Font"
            
            SequentialAnimation on opacity {
                running: batteryLevel <= 20 && !isCharging
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 800 }
                NumberAnimation { from: 0.3; to: 1.0; duration: 800 }
            }
        }
        
        // Porcentaje
        Text {
            text: battery ? `${Math.round(batteryLevel)}%` : "N/A"
            color: batteryLevel <= 20 && !isCharging
                ? Theme.ThemeManager.currentPalette.color4 
                : Theme.ThemeManager.currentPalette.text
            font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            font.bold: batteryLevel <= 20 && !isCharging
        }
    }
}