import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

/*!
    A visual connector for the bar, which draws a triangle on a Canvas to join modules.
*/
Canvas {
    Layout.fillHeight: true
    Layout.preferredWidth: 20

    // Get the direction of the triangle
    // false = (0,0), (0,height), (width,0) -> turns to right
    // true  = (0,0), (width,height), (width,0) -> turns to left
    property bool mirrored: false

    // Draw the triangle
    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.fillStyle = Theme.ThemeManager.currentPalette.base
        
        ctx.beginPath()
        if (mirrored) {
            ctx.moveTo(0, 0)
            ctx.lineTo(width, height)
            ctx.lineTo(width, 0)
        } else {
            ctx.moveTo(0, 0)
            ctx.lineTo(0, height)
            ctx.lineTo(width, 0)
        }
        ctx.closePath()
        ctx.fill()
        
        // Draw border on diagonal
        ctx.strokeStyle = Theme.ThemeManager.currentPalette.color12
        ctx.lineWidth = 3
        ctx.beginPath()
        if (mirrored) {
            ctx.moveTo(0, -3)
            ctx.lineTo(width, height)
        } else {
            ctx.moveTo(0, height)
            ctx.lineTo(width, -3)
        }
        ctx.stroke()
        
    }
    
    Component.onCompleted: requestPaint()
    
    // Repaint when theme changes
    Connections {
        target: Theme.ThemeManager
        function onCurrentThemeChanged() {
            requestPaint()
        }
    }
}