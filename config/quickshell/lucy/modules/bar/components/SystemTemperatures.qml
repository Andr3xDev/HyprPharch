import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../theme" as Theme

Item {
    id: systemTemperatures
    
    implicitWidth: visible ? tempsRow.implicitWidth : 0
    implicitHeight: 25
    width: implicitWidth
    height: implicitHeight
    
    clip: true
    
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    
    property real cpuTemp: 0
    property real gpuTemp: 0
    
    Timer {
        interval: 3000  // Actualizar cada 3 segundos
        running: parent.visible
        repeat: true
        onTriggered: updateTemperatures()
    }
    
    Component.onCompleted: updateTemperatures()
    
    function updateTemperatures() {
        // CPU Temperature (usando sensors)
        var cpuProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "sensors | grep -i 'Package id 0\\|Tctl\\|temp1' | head -n1 | awk '{print $3}' | sed 's/+//;s/°C//' | cut -d'.' -f1"]
                stdout: SplitParser {
                    onRead: data => {
                        cpuTemp = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "cpuTempProcess")
        
        // GPU Temperature (nvidia-smi)
        var gpuProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0"]
                stdout: SplitParser {
                    onRead: data => {
                        gpuTemp = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "gpuTempProcess")
    }
    
    function getTempColor(temp) {
        if (temp >= 80) return Theme.ThemeManager.currentPalette.color4  // Rojo
        if (temp >= 70) return Theme.ThemeManager.currentPalette.color7  // Naranja/Amarillo
        return Theme.ThemeManager.currentPalette.text  // Normal
    }
    
    RowLayout {
        id: tempsRow
        anchors.centerIn: parent
        spacing: 10
        opacity: systemTemperatures.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU Temperature
        RowLayout {
            visible: cpuTemp > 0
            spacing: 4
            
            Text {
                text: "󰔏"  // Icono temperatura CPU
                color: getTempColor(cpuTemp)
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                text: `${Math.round(cpuTemp)}°`
                color: getTempColor(cpuTemp)
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                font.bold: cpuTemp >= 80
            }
        }
        
        // GPU Temperature
        RowLayout {
            visible: gpuTemp > 0
            spacing: 4
            
            Text {
                text: "󰾲"  // Icono temperatura GPU
                color: getTempColor(gpuTemp)
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                text: `${Math.round(gpuTemp)}°`
                color: getTempColor(gpuTemp)
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                font.bold: gpuTemp >= 80
            }
        }
    }
}