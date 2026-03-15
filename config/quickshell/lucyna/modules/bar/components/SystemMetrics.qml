import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services
import "../layout"

Item {
    id: root
    implicitWidth: visible ? metricsRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true
    
    RowLayout {
        id: metricsRow
        anchors.centerIn: parent
        spacing: 2
        opacity: root.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU
        CircularMetric {
            value: Services.MetricsService.cpuUsage
            icon: "󰍛"
            size: 20
            lineWidth: 1.5
        }
        
        // GPU
        CircularMetric {
            value: Services.MetricsService.gpuUsage
            icon: "󰢮"
            size: 20
            lineWidth: 1.5
        }

        // RAM
        CircularMetric {
            value: Services.MetricsService.ramUsage
            icon: "󰍜"
            size: 20
            lineWidth: 1.5
        }
        
        // Disk Storage
        CircularMetric {
            value: Services.MetricsService.diskUsage
            icon: "󰋊"
            size: 20
            lineWidth: 1.5
        }
    }

    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
}
