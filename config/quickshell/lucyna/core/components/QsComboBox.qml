import QtQuick
import QtQuick.Controls
import "../theme" as Theme

/*!
    QsComboBox — Themed drop-down selector.

    Drop-in replacement for ComboBox with shell visual style.

    Properties:
      model           any     — list model (array, ListModel, etc.)
      currentIndex    int     — selected index
      maxPopupHeight  int     — max height of the dropdown list (default 200)

    Signal:
      activated(int index)   — user selected an item (mirrors ComboBox.activated)
*/
ComboBox {
    id: root

    property int maxPopupHeight: 200

    implicitHeight: 32

    background: Rectangle {
        color:        Theme.ThemeManager.colors.surface.secondary
        radius:       Theme.ThemeManager.radius.lg
        border.width: 1
        border.color: root.activeFocus
                          ? Theme.ThemeManager.colors.accent.primary
                          : Theme.ThemeManager.colors.on.surfaceMuted
    }

    contentItem: Text {
        leftPadding:       8
        text:              root.displayText
        color:             Theme.ThemeManager.colors.on.surface
        font.pixelSize:    Theme.ThemeManager.typography.size.md
        verticalAlignment: Text.AlignVCenter
        elide:             Text.ElideRight
    }

    delegate: ItemDelegate {
        width:       root.width
        highlighted: root.highlightedIndex === index

        contentItem: Text {
            leftPadding:       8
            text:              modelData
            color:             highlighted
                                   ? Theme.ThemeManager.colors.accent.primary
                                   : Theme.ThemeManager.colors.on.surface
            font.pixelSize:    Theme.ThemeManager.typography.size.md
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color:  highlighted
                        ? Theme.ThemeManager.colors.highlight.medium
                        : "transparent"
            radius: Theme.ThemeManager.radius.md
        }
    }

    popup: Popup {
        y:       root.height + 2
        width:   root.width
        padding: 0

        background: Rectangle {
            color:        Theme.ThemeManager.colors.surface.secondary
            radius:       Theme.ThemeManager.radius.lg
            border.width: 1
            border.color: Theme.ThemeManager.colors.highlight.medium
        }

        contentItem: Rectangle {
            color:  "transparent"
            radius: Theme.ThemeManager.radius.lg
            clip:   true

            implicitHeight: Math.min(_list.contentHeight + Theme.ThemeManager.spacing.sm * 2,
                                     root.maxPopupHeight)

            ListView {
                id: _list
                anchors {
                    fill:         parent
                    topMargin:    Theme.ThemeManager.spacing.xs
                    bottomMargin: Theme.ThemeManager.spacing.xs
                    leftMargin:   Theme.ThemeManager.spacing.xs
                    rightMargin:  Theme.ThemeManager.spacing.xs
                }
                clip:         true
                model:        root.delegateModel
                currentIndex: root.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }
}
