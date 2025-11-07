import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    id: themeLauncher
    
    property bool isVisible: false
    
    // Icono/botón en la barra
    Rectangle {
        id: launcherButton
        implicitWidth: 30
        implicitHeight: parent.height
        color: themeLauncher.isVisible ? ThemeManager.theme.componentActive : ThemeManager.theme.componentBackground
        radius: 4
        
        Text {
            anchors.centerIn: parent
            text: "🎨"
            font.pixelSize: ThemeManager.theme.baseFontSize + 2
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            
            onEntered: if (!themeLauncher.isVisible) parent.color = ThemeManager.theme.componentHover
            onExited: if (!themeLauncher.isVisible) parent.color = ThemeManager.theme.componentBackground
            
            onClicked: themeLauncher.isVisible = !themeLauncher.isVisible
        }
    }
    
    // Popup window
    PopupWindow {
        id: popup
        visible: themeLauncher.isVisible
        
        anchor {
            window: bar
            rect.x: bar.width - 150
            rect.y: bar.height + 5
        }
        
        width: 140
        height: ThemeManager.availableThemes.length * 35 + 10
        color: "transparent"
        
        Rectangle {
            anchors.fill: parent
            color: ThemeManager.theme.barBackground
            border.color: ThemeManager.theme.barBorder
            border.width: 2
            radius: 6
            
            Column {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5
                
                Repeater {
                    model: ThemeManager.availableThemes
                    
                    Rectangle {
                        width: parent.width
                        height: 30
                        color: modelData === ThemeManager.currentTheme ? 
                               ThemeManager.theme.componentActive : 
                               "transparent"
                        radius: 4
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            
                            Text {
                                text: modelData
                                color: ThemeManager.theme.textPrimary
                                font.pixelSize: ThemeManager.theme.baseFontSize
                                font.bold: modelData === ThemeManager.currentTheme
                                Layout.fillWidth: true
                            }
                            
                            Text {
                                text: modelData === ThemeManager.currentTheme ? "✓" : ""
                                color: ThemeManager.theme.textPrimary
                                font.pixelSize: ThemeManager.theme.baseFontSize
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            
                            onEntered: {
                                if (modelData !== ThemeManager.currentTheme) {
                                    parent.color = ThemeManager.theme.componentHover
                                }
                            }
                            onExited: {
                                if (modelData !== ThemeManager.currentTheme) {
                                    parent.color = "transparent"
                                }
                            }
                            
                            onClicked: {
                                ThemeManager.setTheme(modelData)
                                themeLauncher.isVisible = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Cerrar al hacer clic fuera (opcional)
    MouseArea {
        enabled: themeLauncher.isVisible
        anchors.fill: Quickshell.screens[0]
        propagateComposedEvents: false
        
        onClicked: themeLauncher.isVisible = false
    }
}