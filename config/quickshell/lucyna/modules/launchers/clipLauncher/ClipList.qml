import QtQuick
import QtQuick.Controls
import "components"
import "../../../theme" as Theme

/*!
    Virtualised list of clipboard entries.
    Exposes `clipService` so ClipItem delegates can call paste().
*/
ListView {
    id: root

    // Exposed so ClipItem can reach it via ListView.view.clipService
    property var clipService: null

    clip: true
    cacheBuffer: 96
    reuseItems: true
    keyNavigationEnabled: true
    keyNavigationWraps: true
    currentIndex: 0
    model: clipService ? clipService.filtered : null
    onModelChanged: currentIndex = 0

    delegate: ClipItem {
        required property var modelData
        clipId:  modelData.clipId
        preview: modelData.preview
        type:    modelData.type
        width:   root.width
    }

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        visible: root.contentHeight > root.height
        contentItem: Rectangle {
            implicitWidth: 4
            radius: 2
            color: Theme.ThemeManager.currentPalette.highlight3
        }
    }
}
