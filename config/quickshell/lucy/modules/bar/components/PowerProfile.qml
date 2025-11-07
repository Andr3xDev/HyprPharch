import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../theme" as Theme

/*!
    Battery power profiles
    This allow to select multiple power profiles with a daemon.
    its a toggle menu with 3 options
*/
Item {
    id: powerProfile
    
    width: visible ? profileRow.implicitWidth : 0
    height: 25
    clip: true

    // variable to know selected profile
    property string currentProfile: "balanced"

    // animation to open or close
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    
    
    Timer {
        interval: 3000
        running: parent.visible
        repeat: true
        onTriggered: updateProfile()
    }
    
    Component.onCompleted: updateProfile()
    
    /*!
        Update profile based in the user choise 
    */
    function updateProfile() {
        var profileProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["sh", "-c", "powerprofilesctl get"]
                stdout: SplitParser {
                    onRead: data => {
                        currentProfile = data.trim()
                    }
                }
            }
        `, parent, "profileProcess")
    }
    
    /*!
        Apply user profile selection
    */
    function setProfile(profile) {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: true
                command: ["powerprofilesctl", "set", "${profile}"]
            }
        `, parent, "setProfileProcess")

        currentProfile = profile
    }
    
    /*
        Dysplay menu in bar
    */
    RowLayout {
        id: profileRow
        anchors.centerIn: parent
        spacing: 8
        opacity: powerProfile.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // Performancw
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: currentProfile === "performance" 
                ? Theme.ThemeManager.currentPalette.color4 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            border.color: Theme.ThemeManager.currentPalette.color1
            
            RowLayout {
                anchors.centerIn: parent
                
                Text {
                    text: "󰓅"
                    color: currentProfile === "performance" 
                        ? Theme.ThemeManager.currentPalette.base 
                        : Theme.ThemeManager.currentPalette.color4
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                    font.family: "Symbols Nerd Font"
                }
                
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: setProfile("performance")
            }
        }
        
        // Balanced
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: currentProfile === "balanced" 
                ? Theme.ThemeManager.currentPalette.color3 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            border.color: Theme.ThemeManager.currentPalette.color1
            
            RowLayout {
                anchors.centerIn: parent
                
                Text {
                    text: "󰾅"
                    color: currentProfile === "balanced" 
                        ? Theme.ThemeManager.currentPalette.base 
                        : Theme.ThemeManager.currentPalette.color3
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                    font.family: "Symbols Nerd Font"
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: setProfile("balanced")
            }
        }
        
        // Power Saver button
        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 25
            color: currentProfile === "power-saver" 
                ? Theme.ThemeManager.currentPalette.color5 
                : Theme.ThemeManager.currentPalette.surface
            radius: 4
            border.color: Theme.ThemeManager.currentPalette.color1
            
            RowLayout {
                anchors.centerIn: parent
                
                Text {
                    text: "󰂎"
                    color: currentProfile === "power-saver" 
                        ? Theme.ThemeManager.currentPalette.base 
                        : Theme.ThemeManager.currentPalette.color5
                    font.pixelSize: Theme.ThemeManager.currentPalette.baseFontSize + 1
                    font.family: "Symbols Nerd Font"
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: setProfile("power-saver")
            }
        }
    }
}