import QtQuick

/*!
    Dark overlay component for dimming background content.
    Commonly used in launchers, modals, and popup windows.
*/
Rectangle {
    id: root
    
    /*!
        Opacity level of the dark overlay (0.0 = transparent, 1.0 = opaque black)
    */
    property real overlayOpacity: 0.5
    
    /*!
        Duration of the fade animation in milliseconds
    */
    property int animationDuration: 130
    
    /*!
        Easing type for the animation
    */
    property int easingType: Easing.OutCubic
    
    /*!
        Emitted when the overlay is clicked
    */
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
