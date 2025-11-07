import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "components"
import "layout"

PanelWindow {
    id: bar
    anchors {
        left: true
        top: true
        right: true
    }
    margins {
        left: -1
        right: -1
        bottom: -1
        top: -1
    }
    implicitHeight: 35
    color: "transparent"
    
    // Left section
    Item {
        id: leftSection
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: Theme.ThemeManager.currentPalette.margin
        }
        width: leftRow.width + 20
        
        RowLayout {
            id: leftRow
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                topMargin: Theme.ThemeManager.currentPalette.margin
                bottomMargin: Theme.ThemeManager.currentPalette.margin
            }
            spacing: 0
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: leftContent.width + Theme.ThemeManager.currentPalette.margin * 2
                color: Theme.ThemeManager.currentPalette.base
                border.width: 0
                radius: 0
                
                // Ocultar borde derecho
                Rectangle {
                    anchors.right: parent.right
                    width: 2
                    height: parent.height
                    color: Theme.ThemeManager.currentPalette.base
                }
                
                RowLayout {
                    id: leftContent
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.ThemeManager.currentPalette.margin
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing
                    
                    Clock {}
                    
                    ToggleIndicator {
                        id: controlsToggle
                        icon: "󰒓"
                    }
                    
                    SystemControls {
                        id: systemControls
                        visible: controlsToggle.expanded
                    }
                    
                    ToggleIndicator {
                        id: powerToggle
                        icon: "󰾆"
                    }
            
                    PowerProfile {
                        id: powerProfile
                        visible: powerToggle.expanded
                    }
                }
            }
            
            BarConnector {}
        }
    }
    
    // Center section
    Item {
        id: centerSection
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom
        }
        width: centerRow.width
        
        RowLayout {
            id: centerRow
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
                topMargin: Theme.ThemeManager.currentPalette.margin
                bottomMargin: Theme.ThemeManager.currentPalette.margin
            }
            spacing: 0
            
            BarConnector {
                mirrored: true
            }
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(150, workspacesRow.implicitWidth + (Theme.ThemeManager.currentPalette.spacing * 4))
                color: Theme.ThemeManager.currentPalette.base
                border.width: 0
                
                // Ocultar bordes en las juntas
                Rectangle {
                    anchors.left: parent.left
                    width: 2
                    height: parent.height
                    color: Theme.ThemeManager.currentPalette.base
                }
                Rectangle {
                    anchors.right: parent.right
                    width: 2
                    height: parent.height
                    color: Theme.ThemeManager.currentPalette.base
                }
                
                RowLayout {
                    id: workspacesRow
                    anchors.centerIn: parent
                    spacing: Theme.ThemeManager.currentPalette.spacing
                    
                    Workspaces {}
                }
            }
            BarConnector {} 
        }
    }
    
    // Right section
    Item {
        id: rightSection
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: Theme.ThemeManager.currentPalette.margin
        }
        width: rightRow.width
        
        RowLayout {
            id: rightRow
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                topMargin: Theme.ThemeManager.currentPalette.margin
                bottomMargin: Theme.ThemeManager.currentPalette.margin
            }
            spacing: 0
            
            BarConnector {
                mirrored: true
            }
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: rightContent.width + Theme.ThemeManager.currentPalette.margin * 2
                color: Theme.ThemeManager.currentPalette.base
                border.width: 0
                
                // Ocultar borde izquierdo
                Rectangle {
                    anchors.left: parent.left
                    width: 2
                    height: parent.height
                    color: Theme.ThemeManager.currentPalette.base
                }
                
                RowLayout {
                    id: rightContent
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: Theme.ThemeManager.currentPalette.margin
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing
                    
                    SystemTemperatures {
                        id: systemTemperatures
                        visible: tempToggle.expanded
                    }
                    
                    ToggleIndicator {
                        id: tempToggle
                        icon: "󰔏"
                    }
                    
                    SystemMetrics {
                        id: systemMetrics
                        visible: metricsToggle.expanded
                    }
                    
                    ToggleIndicator {
                        id: metricsToggle
                        icon: "󰍛"
                    }
                    
                    Battery {
                        id: batteryWidget
                    }
                }
            }
        }
    }
}