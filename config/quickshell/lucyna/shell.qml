//--------------------------------------------------------------------------------
//                                                                  
//                                                   
//                        ,--.                                           
//                        |  |   ,--.,--. ,---.,--. ,--.,--,--,  ,--,--. 
//                        |  |   |  ||  || .--' \  '  / |      \' ,-.  | 
//                        |  '--.'  ''  '\ `--.  \   '  |  ||  |\ '-'  | 
//                        `-----' `----'  `---'.-'  /   `--''--' `--`--' 
//                                             `---'                     
//              _______
//　　　　　  /  ＞　　フ     
//　　　　　 | 　_　 _ l      RESUME: QuickShell system config, includes bars,
//　 　　　 ／` ミ＿xノ               launchers, widgets & more.
//　　 　  /　　　 　 |
//　　　  /　 ヽ　　 ﾉ
//　  　 │　　|　|　|         AUTHOR:  Andr3xDev
//　 ／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
//　| (￣ヽ＿_ヽ_)__)
//　＼二つ
//--------------------------------------------------------------------------------


import Quickshell
import "modules/bar"
import "modules/launchers/theme"
import "modules/launchers/apps"
import "modules/launchers/power"
import "modules/launchers/clipboard"
import "modules/calendar"
import "modules/indicators/components"
import "modules/monitors"

/*!
    Composition Root — zero logic.
    This file only instantiates modules. All behavior lives inside them.
*/
ShellRoot {

    Variants {
        model: Quickshell.screens.filter(scr => !isExcluded(scr.name))

        Bar {
            property var modelData
            screen: modelData
        }
    }

    // Theme Launcher - Toggle via: qs ipc call themeLauncher.toggle
    ThemeLauncher {
        id: themeLauncher
        externalScriptPath: Quickshell.env("HOME") + "/.config/quickshell/lucyna/scripts/apply-theme.sh"
    }

    // App Launcher - Toggle with hyprctl dispatch
    AppLauncher {
        id: appLauncher
    }

    // Power Launcher - Toggle with hyprctl dispatch, opens on screen under cursor
    PowerLauncher {
        id: powerLauncher
    }

    // Clip Launcher - Toggle via: qs -c lucyna ipc --call toggleClip
    ClipLauncher {
        id: clipLauncher
    }

    // Calendar - Toggle via: click on clock | qs ipc --config lucyna call toggleCalendar handle
    CalendarWindow {
        id: calendarWindow
    }

    // Volume OSD
    Volume {
        id: volumeOsd
    }

    // Monitor Manager - Toggle via: qs ipc call monitorManager.handle
    MonitorManager {
        id: monitorManager
    }

    //Screens excluded from bar rendering.
    function isExcluded(screenName) {
        const excluded = [
            //"HDMI-A-1",
            //"DP-2",
        ];
        return excluded.includes(screenName);
    }

}
