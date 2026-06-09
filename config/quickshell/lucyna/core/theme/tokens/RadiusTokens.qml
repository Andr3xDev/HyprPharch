pragma Singleton

import QtQuick

/*!
    RadiusTokens — Border radius scale.
*/
QtObject {
    readonly property int none: 0
    readonly property int sm:   4
    readonly property int md:   6    // radius
    readonly property int lg:   8    // radiusInner
    readonly property int xl:   12
    readonly property int full: 9999
}
