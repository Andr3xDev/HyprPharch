pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    Metrics service get all data from the main components in a PC, like cpu or gpu
*/
Singleton {
    id: root

    // Public properties
    property real cpuUsage: 0
    property real ramUsage: 0
    property real ramUsedGB: 0
    property real ramTotalGB: 0
    property real gpuUsage: 0
    property real diskUsage: 0
    property real diskUsedGB: 0
    property real diskTotalGB: 0
    
    // Get cpu usage
    property Process _cpuProcess: Process {
        running: false
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1"]
        
        stdout: SplitParser {
            onRead: data => {
                const usage = parseFloat(data.trim())
                if (!isNaN(usage)) root.cpuUsage = usage
            }
        }
    }
    
    // Get ram usage
    property Process _ramProcess: Process {
        running: false
        command: ["sh", "-c", "free -g | grep Mem | awk '{printf \"%.1f %.1f %.1f\", $3, $2, ($3/$2) * 100.0}'"]
        
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ")
                if (parts.length === 3) {
                    root.ramUsedGB = parseFloat(parts[0])
                    root.ramTotalGB = parseFloat(parts[1])
                    root.ramUsage = parseFloat(parts[2])
                }
            }
        }
    }
    
    // Get gpu usage
    property Process _gpuProcess: Process {
        running: false
        command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0"]
        
        stdout: SplitParser {
            onRead: data => {
                const usage = parseFloat(data.trim())
                if (!isNaN(usage)) root.gpuUsage = usage
            }
        }
    }
    
    // Get main disk usage, where root directory is
    property Process _diskProcess: Process {
        running: false
        command: ["sh", "-c", "df -BG / | awk 'NR==2 {gsub(\"G\", \"\", $3); gsub(\"G\", \"\", $2); gsub(\"%\", \"\", $5); printf \"%s %s %s\", $3, $2, $5}'"]
        
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ")
                if (parts.length === 3) {
                    root.diskUsedGB = parseFloat(parts[0])
                    root.diskTotalGB = parseFloat(parts[1])
                    root.diskUsage = parseFloat(parts[2])
                }
            }
        }
    }
    
    // timer to update data almost in real time
    property Timer _pollTimer: Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _cpuProcess.running = true
            _ramProcess.running = true
            _gpuProcess.running = true
            _diskProcess.running = true
        }
    }
}