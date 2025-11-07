import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../theme" as Theme

Item {
    id: systemMetrics
    
    implicitWidth: visible ? metricsRow.implicitWidth : 0
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
    
    property real cpuUsage: 0
    property real ramUsage: 0
    property real gpuUsage: 0
    property real diskUsage: 0  // ⭐ Nueva propiedad
    
    Timer {
        interval: 2000
        running: parent.visible
        repeat: true
        onTriggered: updateMetrics()
    }
    
    Component.onCompleted: updateMetrics()
    
    function updateMetrics() {
        // CPU
        var cpuProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1"]
                stdout: SplitParser {
                    onRead: data => {
                        cpuUsage = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "cpuProcess")
        
        // RAM
        var ramProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}'"]
                stdout: SplitParser {
                    onRead: data => {
                        ramUsage = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "ramProcess")
        
        // GPU (nvidia-smi)
        var gpuProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0"]
                stdout: SplitParser {
                    onRead: data => {
                        gpuUsage = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "gpuProcess")
        
        // ⭐ Disk Usage (partición raíz /)
        var diskProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "df -h / | awk 'NR==2 {print $5}' | sed 's/%//'"]
                stdout: SplitParser {
                    onRead: data => {
                        diskUsage = parseFloat(data.trim()) || 0
                    }
                }
            }
        `, parent, "diskProcess")
    }
    
    RowLayout {
        id: metricsRow
        anchors.centerIn: parent
        spacing: 10
        opacity: systemMetrics.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU
        RowLayout {
            spacing: 4
            Text {
                text: "󰻠"
                color: Theme.ThemeManager.currentPalette.color3
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            Text {
                text: `${Math.round(cpuUsage)}%`
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            }
        }
        
        // RAM
        RowLayout {
            spacing: 4
            Text {
                text: "󰍛"
                color: Theme.ThemeManager.currentPalette.color5
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            Text {
                text: `${Math.round(ramUsage)}%`
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            }
        }
        
        // ⭐ Disk Storage
        RowLayout {
            spacing: 4
            Text {
                text: "󰋊"  // Icono de disco
                color: Theme.ThemeManager.currentPalette.color7
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            Text {
                text: `${Math.round(diskUsage)}%`
                color: diskUsage > 90 
                    ? Theme.ThemeManager.currentPalette.color4  // Rojo si >90%
                    : Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
                font.bold: diskUsage > 90
            }
        }
        
        // GPU
        RowLayout {
            visible: gpuUsage > 0
            spacing: 4
            Text {
                text: "󰢮"
                color: Theme.ThemeManager.currentPalette.color6
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                font.family: "Symbols Nerd Font"
            }
            Text {
                text: `${Math.round(gpuUsage)}%`
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            }
        }
    }
}