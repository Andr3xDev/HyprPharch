import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme

Item {
    id: toggleIndicator
    
    implicitWidth: toggleButton.implicitWidth
    implicitHeight: 25
    width: implicitWidth
    height: implicitHeight
    
    property string icon: "󰍛"
    property string label: ""
    property bool expanded: false
    
    signal toggled()
    
    Rectangle {
        id: toggleButton
        anchors.centerIn: parent
        implicitWidth: buttonRow.implicitWidth + 16
        implicitHeight: 25
        color: expanded 
            ? Theme.ThemeManager.currentPalette.color2 
            : "transparent"
        radius: 4
        border.color: Theme.ThemeManager.currentPalette.color1
        border.width: 1
        
        // ⭐ Animación de color
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        
        RowLayout {
            id: buttonRow
            anchors.centerIn: parent
            spacing: 4
            
            Text {
                text: icon
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 2
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                visible: label !== ""
                text: label
                color: Theme.ThemeManager.currentPalette.text
                font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize
            }
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                expanded = !expanded
                toggleIndicator.toggled()
            }
        }
    }
}