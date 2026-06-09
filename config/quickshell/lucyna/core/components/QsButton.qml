import QtQuick
import "../theme" as Theme

/*!
    QsButton — polivalent button for module UIs.

    Not for bar widgets (those have active/toggle state and their own components).

    Variants
    --------
    "ghost"   transparent bg, highlight on hover, on.surface text  (default)
    "filled"  accent.primary bg, accent.secondary on hover, surface.primary text
    "outline" transparent bg + border, highlight on hover, on.surface text
    "danger"  status.error bg, status.error+dim on hover, surface.primary text

    Any variant color can be overridden per-instance:
        QsButton {
            variant:    "filled"
            bgColor:    Theme.ThemeManager.colors.status.warning
            labelColor: Theme.ThemeManager.colors.surface.primary
            onClicked:  doSomething()
        }
*/
Rectangle {
    id: root

    // ── Variant properties ────────────────────────────────

    // Content
    property string label: ""
    property string glyph: ""

    // Variant
    property string variant: "ghost"

    // Color overrides
    property color bgColor:    _variantBg
    property color hoverColor: _variantHover
    property color labelColor: _variantLabel

    // Border
    property int   borderWidth: variant === "outline" ? 1 : 0
    property color borderColor: _variantBorder

    signal clicked()

    // Internal variant
    readonly property color _variantBg: {
        switch (variant) {
            case "filled":  return Theme.ThemeManager.colors.accent.primary
            case "danger":  return Theme.ThemeManager.colors.status.error
            default:        return "transparent"
        }
    }

    readonly property color _variantHover: {
        switch (variant) {
            case "filled":  return Theme.ThemeManager.colors.accent.secondary
            case "danger":  return Qt.darker(Theme.ThemeManager.colors.status.error, 1.2)
            default:        return Theme.ThemeManager.colors.highlight.medium
        }
    }

    readonly property color _variantLabel: {
        switch (variant) {
            case "filled":  return Theme.ThemeManager.colors.surface.primary
            case "danger":  return Theme.ThemeManager.colors.surface.primary
            default:        return Theme.ThemeManager.colors.on.surface
        }
    }

    readonly property color _variantBorder: {
        switch (variant) {
            case "outline": return Theme.ThemeManager.colors.highlight.medium
            default:        return "transparent"
        }
    }


    // ── Geometry ──────────────────────────────────────────
    implicitWidth:  _row.implicitWidth  + Theme.ThemeManager.spacing.md * 2
    implicitHeight: _row.implicitHeight + Theme.ThemeManager.spacing.sm * 2


    // ── Visuals ───────────────────────────────────────────
    color:        _area.containsMouse ? root.hoverColor : root.bgColor
    radius:       Theme.ThemeManager.radius.sm
    border.width: root.borderWidth
    border.color: root.borderColor

    Behavior on color { ColorAnimation { duration: Theme.ThemeManager.motion.duration.fast } }

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacing.xs

        Text {
            visible:        root.glyph !== ""
            text:           root.glyph
            color:          root.labelColor
            font.family:    Theme.ThemeManager.typography.family.icons
            font.pixelSize: Theme.ThemeManager.typography.iconSize
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible:        root.label !== ""
            text:           root.label
            color:          root.labelColor
            font.pixelSize: Theme.ThemeManager.typography.size.sm
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: _area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        onClicked:    root.clicked()
    }
}
