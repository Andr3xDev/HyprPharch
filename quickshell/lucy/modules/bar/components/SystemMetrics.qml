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
        spacing: 0
        opacity: root.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU
        CircularMetric {
            value: Services.MetricsService.cpuUsage
            icon: "󰍛"
            iconSize: 12
        }
        
        // GPU
        CircularMetric {
            value: Services.MetricsService.gpuUsage
            icon: "󰢮"
            iconSize: 12
        }

        // RAM
        CircularMetric {
            value: Services.MetricsService.ramUsage
            icon: ""
            iconSize: 9
        }
        
        // Disk Storage
        CircularMetric {
            value: Services.MetricsService.diskUsage
            icon: "󰋊"
            iconSize: 11
        }
    }

    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
}