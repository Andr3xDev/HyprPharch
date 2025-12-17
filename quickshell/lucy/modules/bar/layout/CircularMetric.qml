import QtQuick
import QtQuick.Controls
import "../../../theme" as Theme

/*!
    Visual component to support metrics by using a circle to represent persentages
*/
Item {
    id: circularMetric
    width: size
    height: size
    
    // Base values
    property real value: 0
    property string icon: ""
    property real iconSize: 10
    property real size: 24
    property real lineWidth: 2
    property string tooltip: ""
    readonly property color effectiveColor: value >= 75 
        ? Theme.ThemeManager.currentPalette.color4
        : Theme.ThemeManager.currentPalette.color8
    
    // Cirlce with progress
    Canvas {
        id: canvas
        anchors.fill: parent
        z: 0
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Position
            var centerX = width / 2
            var centerY = height / 2
            var radius = width / 2 - circularMetric.lineWidth
            
            // Background circle
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.lineWidth = circularMetric.lineWidth
            ctx.strokeStyle = circularMetric.effectiveColor
            ctx.globalAlpha = 0.2
            ctx.stroke()
            
            // Progress arc
            if (circularMetric.value > 0) {
                ctx.beginPath()
                var startAngle = -Math.PI / 2
                var endAngle = startAngle + (circularMetric.value / 100) * 2 * Math.PI
                ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                ctx.lineWidth = circularMetric.lineWidth
                ctx.strokeStyle = circularMetric.effectiveColor
                ctx.globalAlpha = 1
                ctx.stroke()
            }
        }
        
        Connections {
            target: circularMetric
            function onValueChanged() { canvas.requestPaint() }
            function onEffectiveColorChanged() { canvas.requestPaint() }
        }
    }
    
    // Icon to show
    Text {
        anchors.centerIn: parent
        text: circularMetric.icon
        color: circularMetric.effectiveColor
        font.pixelSize: circularMetric.iconSize
        font.family: "Symbols Nerd Font"
        z: 1
    }
    
    // Tooltip by mouse hover
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 2
    }
}