import QtQuick
import "../theme" as Theme

/*!
    DarkOverlay — reusable backdrop for launchers, modals, and popups.

    Core primitive: no business logic, no service imports.
*/
Rectangle {
    id: root

    // Opacity level of the dark overlay (0.0 = transparent, 1.0 = opaque black)
    property real overlayOpacity: 0.5

    // Duration of the fade animation in milliseconds
    property int animationDuration: Theme.ThemeManager.motion.duration.fast

    // Easing type for the animation
    property int easingType: Theme.ThemeManager.motion.easing.standard

    // Emitted when the overlay is clicked
    signal clicked()

    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, overlayOpacity)
    opacity: visible ? 1.0 : 0.0

    Behavior on opacity {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
