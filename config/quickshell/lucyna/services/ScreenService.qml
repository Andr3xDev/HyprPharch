pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

/*!
    Utility functions related to screens and monitors
*/
Singleton {

    /*!
        Get the screen matching the focused Hyprland monitor by name
    */
    function focusedScreen() {
        const name = Hyprland.focusedMonitor?.name ?? ""
        return Quickshell.screens.find(s => s.name === name) ?? Quickshell.screens[0]
    }
}
