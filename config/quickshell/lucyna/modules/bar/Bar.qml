import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../core/theme" as Theme
import "components"
import "layout"

/*!
    Bar of the system. Shows workspaces, clock, power profiles, metrics and battery.
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
            Theme.ThemeManager.colors.surface.secondary.r,
            Theme.ThemeManager.colors.surface.secondary.g,
            Theme.ThemeManager.colors.surface.secondary.b,
            0.8
        )
        color: Qt.rgba(
            Theme.ThemeManager.colors.surface.primary.r,
            Theme.ThemeManager.colors.surface.primary.g,
            Theme.ThemeManager.colors.surface.primary.b,
            Theme.ThemeManager.colors.barOpacity
        )
        radius: Theme.ThemeManager.radius.md
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
        width: Math.max(100, leftContent.implicitWidth + Theme.ThemeManager.spacing.xxl)

        RowLayout {
            id: leftContent
            anchors.fill: parent
            spacing: Theme.ThemeManager.spacing.sm

            Item { Layout.preferredWidth: 4 }

            ArchLogo {}

            // Subtle separator
            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: parent.height * 0.7
                Layout.alignment: Qt.AlignVCenter
                color: Theme.ThemeManager.colors.on.surfaceMuted
                radius: Theme.ThemeManager.radius.full
            }

            Item { Layout.preferredWidth: 6 }

            Workspaces {
                screen: bar.screen
            }

            Item { Layout.preferredWidth: 10 }
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
        width: clockContent.implicitWidth + Theme.ThemeManager.spacing.xxl

        RowLayout {
            id: clockContent
            anchors.centerIn: parent
            height: parent.height

            Clock {}
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
        width: rightContent.implicitWidth + 2

        RowLayout {
            id: rightContent
            anchors { fill: parent; rightMargin: 1 }
            spacing: Theme.ThemeManager.spacing.sm

            Item { Layout.preferredWidth: 4 }

            PowerProfile {
                id: powerProfile
                expanded: powerToggle.expanded
            }

            ToggleIndicator {
                id: powerToggle
                icon: "󱐋"
            }

            Item { Layout.preferredWidth: 4 }

            SystemControls {
                id: systemControls
                expanded: controlsToggle.expanded
            }

            ToggleIndicator {
                id: controlsToggle
                icon: "󰒓"
            }

            Item { Layout.preferredWidth: 4 }

            SystemTemperatures {
                id: systemTemperatures
                expanded: tempToggle.expanded
            }

            ToggleIndicator {
                id: tempToggle
                icon: "󰔏"
            }

            Item { Layout.preferredWidth: 4 }

            SystemMetrics {
                id: systemMetrics
                expanded: metricsToggle.expanded
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
