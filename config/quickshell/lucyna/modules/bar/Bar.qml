import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "components"
import "layout"

/*!
    Bar of the system, shows information, workspaces, power profiles, bateries
    
    TODO: Refactor section components for better maintainability
          - Create reusable BarSection.qml component
          - Extract common patterns from leftSection/centerSection/rightSection
          - Move magic numbers (spacing, margins) to named properties
          - Reduce code duplication in section layout logic
          - This will make the bar more maintainable and easier to customize
*/
PanelWindow {
    id: bar
    anchors {
        left: true
        top: true
        right: true
    }
    margins { top: 4; left: 6; right: 6 }
    implicitHeight: 32
    color: "transparent"


    property var modelData
    screen: modelData
    
    Rectangle {
        anchors.fill: parent
        border.color: Qt.rgba(
            Theme.ThemeManager.currentPalette.surface.r,
            Theme.ThemeManager.currentPalette.surface.g,
            Theme.ThemeManager.currentPalette.surface.b,
            0.8
        )
        color: Qt.rgba(
            Theme.ThemeManager.currentPalette.base.r,
            Theme.ThemeManager.currentPalette.base.g,
            Theme.ThemeManager.currentPalette.base.b,
            Theme.ThemeManager.currentPalette.barOpacity
        )
        radius: Theme.ThemeManager.currentPalette.radius
        border.width: 2
    }
    
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
                Layout.preferredWidth: Math.max(100, leftContent.implicitWidth + (Theme.ThemeManager.currentPalette.spacing * 4))
                color: "transparent"
                
                RowLayout {
                    id: leftContent
                    anchors {
                        fill: parent
                        leftMargin: 0
                        rightMargin: 0
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing

                    Item { Layout.preferredWidth: 4 }

                    ArchLogo {}

                    // Subtle separator
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: parent.height * 0.7
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.ThemeManager.currentPalette.muted
                        radius: 10
                    }

                    Item { Layout.preferredWidth: 6 }

                    Workspaces {}

                    Item { Layout.preferredWidth: 10 }
                }
            }
        }
    }
    
    // Center section - Clock
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
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: clockRow.implicitWidth + (Theme.ThemeManager.currentPalette.spacing * 4)
                color: "transparent"

                RowLayout {
                    id: clockRow
                    anchors.centerIn: parent
                    height: parent.height

                    Clock {}
                }
            }
        }
    }
    
    // Right section - Metrics, Controls and Battery
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
            
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: rightContent.implicitWidth + (Theme.ThemeManager.currentPalette.margin * 2)
                color: "transparent"

                RowLayout {
                    id: rightContent
                    anchors {
                        fill: parent
                        leftMargin: 0
                        rightMargin: Theme.ThemeManager.currentPalette.margin
                    }
                    spacing: Theme.ThemeManager.currentPalette.spacing

                    Item { Layout.preferredWidth: 4 }

                    PowerProfile {
                        id: powerProfile
                        visible: powerToggle.expanded
                    }
            
                    ToggleIndicator {
                        id: powerToggle
                        icon: "󱐋"
                    }

                    Item { Layout.preferredWidth: 4 }

                    SystemControls {
                        id: systemControls
                        visible: controlsToggle.expanded
                    }

                    ToggleIndicator {
                        id: controlsToggle
                        icon: "󰒓"
                    }
                    
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
