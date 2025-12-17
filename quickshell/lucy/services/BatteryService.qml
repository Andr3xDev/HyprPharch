pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

/*!
    Battery service manages battery state and notifications to it
*/
Singleton {
    id: root
    
    // Public properties
    property var battery: null
    property real batteryLevel: battery ? (battery.percentage * 100) : 0
    property bool isCharging: battery ? (battery.state === 1 || battery.state === 4) : false
    
    // Private properties
    property var _batteryDevice: null
    property int _lastNotifiedLevel: -1
    
    // Notification process
    property Process _notifyProcess: Process {
        running: false
        onExited: running = false
    }
    
    // Monitor battery changes
    property Connections _upowerConnections: Connections {
        target: UPower.devices
        function onValuesChanged() {
            root._updateBattery()
        }
    }
    
    // Monitor battery level for notifications
    onBatteryLevelChanged: {
        _checkBatteryNotification()
    }
    
    // Reset notification threshold when charging
    onIsChargingChanged: {
        if (isCharging) {
            _lastNotifiedLevel = -1
        }
    }
    
    // Initialize on creation
    Component.onCompleted: {
        _updateBattery()
    }
    
    /*!
        Find and update battery device
    */
    function _updateBattery() {
        if (_batteryDevice && _batteryDevice.nativePath) {
            battery = _batteryDevice
            return
        }
        
        const deviceList = UPower.devices.values
        for (let i = 0; i < deviceList.length; i++) {
            const device = deviceList[i]
            if (device.nativePath && device.nativePath.includes("BAT")) {
                _batteryDevice = device
                battery = device
                return
            }
        }
    }
    
    /*!
        Check battery level and trigger notifications
    */
    function _checkBatteryNotification() {
        if (isCharging) return
        
        const level = Math.floor(batteryLevel)
        const thresholds = [20, 15, 10, 5]
        
        for (let i = 0; i < thresholds.length; i++) {
            const threshold = thresholds[i]
            if (level <= threshold && (_lastNotifiedLevel > threshold || _lastNotifiedLevel === -1)) {
                _sendNotification(threshold)
                _lastNotifiedLevel = threshold
                return
            }
        }
    }
    
    /*!
        Send battery notification
    */
    function _sendNotification(level) {
        const urgency = level <= 10 ? "critical" : "normal"
        const icon = level <= 10 ? "battery-empty" : "battery-low"
        const title = level <= 10 ? "⚠️ Critical Battery!" : "🔋 Low Battery"
        const body = `Battery at ${level}%. Connect charger.`
        
        _notifyProcess.command = [
            "notify-send",
            "-u", urgency,
            "-i", icon,
            "-a", "QuickShell Battery",
            title,
            body
        ]
        _notifyProcess.running = true
    }
    
    /*!
        Get battery icon based on level and charging state
    */
    function getBatteryIcon() {
        if (!battery) return "󰂑"
        if (isCharging & batteryLevel > 98) return ""
        if (isCharging) return " "
        if (batteryLevel > 85) return ""
        if (batteryLevel > 65) return ""
        if (batteryLevel > 40) return ""
        if (batteryLevel > 25) return ""
        if (batteryLevel > 10) return ""
        return ""
    }
    
    /*!
        Check if battery is in critical state, for animations & warnings
    */
    function isCritical() {
        return batteryLevel <= 15 && !isCharging
    }
    
    /*!
        Check if battery level should be hidden when is fully charged
    */
    function shouldHideLevel() {
        return isCharging && batteryLevel > 98
    }
}