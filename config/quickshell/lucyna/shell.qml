//--------------------------------------------------------------------------------
//                                                                  
//                                                   
//                        ,--.                                           
//                        |  |   ,--.,--. ,---.,--. ,--.,--,--,  ,--,--. 
//                        |  |   |  ||  || .--' \  '  / |      \' ,-.  | 
//                        |  '--.'  ''  '\ `--.  \   '  |  ||  |\ '-'  | 
//                        `-----' `----'  `---'.-'  /   `--''--' `--`--' 
//                                             `---'                     
//            _______
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
import Quickshell.Wayland
import "modules/bar"
import "modules/launchers/themeLauncher"
import "modules/launchers/appsLauncher"
import "modules/launchers/powerLauncher"

/*!
    Root of the configuration, this is where components,
    launchers, and widgets are declared
*/
ShellRoot {

    Variants {
        model: Quickshell.screens.filter(scr => !isExcluded(scr.name))
        
        Bar {
            property var modelData
            screen: modelData
        }
    }

    // Theme Launcher - Toggle with hyprctl dispatch
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
    
    /*!
        Create multiple Bars to each monitor & exclude the creation in tarjet monitor
    */
    function isExcluded(screenName) {
        const excluded = [
            //"HDMI-A-1",
            //"DP-2",
        ];
        return excluded.includes(screenName);
    }

}
