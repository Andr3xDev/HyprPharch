pragma Singleton

import QtQuick

/*!
    SpacingTokens — Named spacing scale.

    All layout distances in the system come from here.
    Components never use numeric literals for spacing.
*/
QtObject {
    readonly property int xs:  4
    readonly property int sm:  8
    readonly property int md:  12
    readonly property int lg:  16
    readonly property int xl:  24
    readonly property int xxl: 32

    // Bar-specific compound spacing (kept for backward compat)
    readonly property int barComponents: 30
}
