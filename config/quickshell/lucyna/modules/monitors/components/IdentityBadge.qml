import QtQuick
import "../../../core/components"

/*!
    IdentityBadge — Pure presentation widget.
    Shows monitor alias (large) and physical port name (small, muted).
    No logic, no signals.
*/
Item {
    id: root

    property string alias:    ""
    property string portName: ""

    implicitWidth:  aliasLabel.implicitWidth
    implicitHeight: aliasLabel.implicitHeight + portLabel.implicitHeight + 2

    Column {
        anchors.centerIn: parent
        spacing: 2

        QsText {
            id: aliasLabel
            text:                root.alias
            role:                "title"
            font.bold:           true
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        QsText {
            id: portLabel
            text:                root.portName
            role:                "caption"
            muted:               true
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
