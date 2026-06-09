import QtQuick
import "../../../core/theme" as Theme

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
        color: Theme.ThemeManager.colors.on.surface
        font.pixelSize: Theme.ThemeManager.typography.size.lg
        font.family: Theme.ThemeManager.typography.family.icons
    }
}
