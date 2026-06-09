----------------------------------------------------------------------------------
--
--               ,------.,--.  ,--.,--.   ,--.
--               |  .---'|  ,'.|  | \  `.'  /
--               |  `--, |  |' '  |  \     /
--           .--.|  `---.|  | `   |   \   /
--           '--'`------'`--'  `--'    `-'
--
--             _______
--　　　　　 /  ＞　　フ
--　　　　　| 　_　 _ l      RESUME: ENV variables to set general global configs
--　 　　　／` ミ＿xノ
--　　 　 /　　　 　 |
--　　　 /　 ヽ　　 ﾉ
--　 　 │　　|　|　|         AUTHOR:  Andr3xDev
--　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
--　| (￣ヽ＿_ヽ_)__)
--　＼二つ
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
--- General & Styling
----------------------------------------------------------------------------------
hl.env("XCURSOR_SIZE",    "24")
hl.env("XCURSOR_THEME",   "phinger-cursors-light")
hl.env("HYPRCURSOR_SIZE", "24")


----------------------------------------------------------------------------------
--- Toolkit Backend
----------------------------------------------------------------------------------
hl.env("GDK_BACKEND",         "wayland,x11,*")
hl.env("QT_QPA_PLATFORM",     "wayland;xcb")
hl.env("SDL_VIDEODRIVER",     "wayland")
hl.env("CLUTTER_BACKEND",     "wayland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")


----------------------------------------------------------------------------------
--- Scaling Fixes
----------------------------------------------------------------------------------
hl.env("GDK_SCALE",                    "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",  "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")


----------------------------------------------------------------------------------
--- NVIDIA / Optimus
----------------------------------------------------------------------------------
hl.env("NVD_BACKEND",               "direct")
hl.env("LIBVA_DRIVER_NAME",         "iHD")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
