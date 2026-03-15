import QtQuick
import "../../../theme" as Theme

/*!
    Arch Linux logo icon
*/
Item {
    id: root
    implicitWidth: logoText.implicitWidth
    implicitHeight: parent.height
    
    Text {
        id: logoText
        anchors.centerIn: parent
        text: " 󰣇 "
        color: Theme.ThemeManager.currentPalette.text
        font.pixelSize: Theme.ThemeManager.currentPalette.titleFontSize
        font.family: "Symbols Nerd Font"
    }
}
