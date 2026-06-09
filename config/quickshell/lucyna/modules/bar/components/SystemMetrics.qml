import QtQuick
import QtQuick.Layouts
import "../../../core/theme" as Theme
import "../../../core/services" as Services
import "../layout"

/*!
    Group of circular indicators showing CPU, GPU, RAM and disk usage.
*/
Item {
    id: root
    property bool expanded: false

    implicitWidth: expanded ? metricsRow.implicitWidth : 0
    implicitHeight: parent.height
    visible: expanded || implicitWidth > 0
    clip: true

    readonly property real metricSize:      20
    readonly property real metricLineWidth: 1.5

    RowLayout {
        id: metricsRow
        anchors.centerIn: parent
        spacing: 2
        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: Theme.ThemeManager.motion.duration.standard }
        }

        CircularMetric {
            value: Services.MetricsService.cpuUsage
            icon: "󰍛"
            size: root.metricSize
            lineWidth: root.metricLineWidth
        }

        CircularMetric {
            value: Services.MetricsService.gpuUsage
            icon: "󰢮"
            size: root.metricSize
            lineWidth: root.metricLineWidth
        }

        CircularMetric {
            value: Services.MetricsService.ramUsage
            icon: "󰍜"
            size: root.metricSize
            lineWidth: root.metricLineWidth
        }

        CircularMetric {
            value: Services.MetricsService.diskUsage
            icon: "󰋊"
            size: root.metricSize
            lineWidth: root.metricLineWidth
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Theme.ThemeManager.motion.duration.standard
            easing.type: Theme.ThemeManager.motion.easing.standard
        }
    }
}
