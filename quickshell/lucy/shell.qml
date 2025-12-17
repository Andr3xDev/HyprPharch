//--------------------------------------------------------------------------------
//                                                                  
//    ,--.                                                    ,---. 
//    |  |   ,--.,--. ,---.,--. ,--.     ,---. ,---. ,--,--, /  .-' 
//    |  |   |  ||  || .--' \  '  /     | .--'| .-. ||      \|  `-, 
//    |  '--.'  ''  '\ `--.  \   '      \ `--.' '-' '|  ||  ||  .-' 
//    `-----' `----'  `---'.-'  /        `---' `---' `--''--'`--'   
//                         `---'                                    
//           _______
//　　　　　 /  ＞　　フ     
//　　　　　| 　_　 _ l      RESUME: QuickShell system config, includes bars,
//　 　　　／` ミ＿xノ               launchers, widgets & more.
//　　 　 /　　　 　 |
//　　　 /　 ヽ　　 ﾉ
//　 　 │　　|　|　|         AUTHOR:  Andr3xDev
//　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
//　| (￣ヽ＿_ヽ_)__)
//　＼二つ
//--------------------------------------------------------------------------------



import Quickshell
import "modules/bar"
import Quickshell.Wayland
import "modules/launchers/themeLauncher"

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
        externalScriptPath: "/home/andrex/.config/quickshell/lucy/scripts/apply-theme.sh"
    }
    
    /*!
        Create multiple Bars to each monitor & exclude the creation in tarjet monitor
    */
    function isExcluded(screenName) {
        const excluded = [
            "HDMI-A-1",
            // "DP-2",
        ];
        return excluded.includes(screenName);
    }

}