import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "components"
import "layout"

/*!
    Bar of the system, shows information, workspaces, power profiles, bateries
*/
PanelWindow {
    id: bar
    anchors {
        left: true
        top: true
        right: true
    }
    implicitHeight: 35
    color: "transparent"

    property var modelData
    screen: modelData
    
    // Left section
    Item {
        id: leftSection
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: leftRow.implicitWidth
        
        RowLayout {
            id: leftRow
            anchors.fill: parent
            spacing: 0
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: leftContent.implicitWidth + (Theme.ThemeManager.currentPalette.margin * 2)
                color: Theme.ThemeManager.currentPalette.base

                RowLayout {
                    id: leftContent
                    anchors {
                        fill: parent
                        leftMargin: Theme.ThemeManager.currentPalette.margin
                        rightMargin: Theme.ThemeManager.currentPalette.margin
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing

                    Item { Layout.preferredWidth: 4 }

                    Clock {}

                    Item { Layout.preferredWidth: 0 }

                    ToggleIndicator {
                        id: controlsToggle
                        icon: "󰒓"
                    }

                    SystemControls {
                        id: systemControls
                        visible: controlsToggle.expanded
                    }

                    Item { Layout.preferredWidth: 4 }

                    ToggleIndicator {
                        id: powerToggle
                        icon: ""
                    }
            
                    PowerProfile {
                        id: powerProfile
                        visible: powerToggle.expanded
                    }

                    Item { Layout.preferredWidth: 4 }
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
        width: centerRow.implicitWidth
        
        RowLayout {
            id: centerRow
            anchors.fill: parent
            spacing: 0
            
            BarConnector {
                mirrored: true
            }
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(100, workspacesRow.implicitWidth + (Theme.ThemeManager.currentPalette.spacing * 4))
                color: Theme.ThemeManager.currentPalette.base
                
                RowLayout {
                    id: workspacesRow
                    anchors.centerIn: parent
                    
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
        }
        width: rightRow.implicitWidth
        
        RowLayout {
            id: rightRow
            anchors.fill: parent
            spacing: 0
            
            BarConnector {
                mirrored: true
            }
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: rightContent.implicitWidth + (Theme.ThemeManager.currentPalette.margin * 2)
                color: Theme.ThemeManager.currentPalette.base

                RowLayout {
                    id: rightContent
                    anchors {
                        fill: parent
                        leftMargin: 0
                        rightMargin: 0
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing

                    Item { Layout.preferredWidth: 4 }

                    SystemTemperatures {
                        id: systemTemperatures
                        visible: tempToggle.expanded
                    }

                    ToggleIndicator {
                        id: tempToggle
                        icon: "󰔏"
                    }
                    
                    Item { Layout.preferredWidth: 4 }

                    SystemMetrics {
                        id: systemMetrics
                        visible: metricsToggle.expanded
                    }

                    ToggleIndicator {
                        id: metricsToggle
                        icon: "󰕮"
                    }
                    
                    Item { Layout.preferredWidth: 4 }

                    Battery {
                        id: batteryWidget
                    }

                    Item { Layout.preferredWidth: 10 }
                }
            }
        }
    }
}