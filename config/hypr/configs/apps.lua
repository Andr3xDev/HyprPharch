----------------------------------------------------------------------------------
--
--            ,---.
--           /  O  \  ,---.  ,---.  ,---.
--          |  .-.  || .-. || .-. |(  .-'
--          |  | |  || '-' '| '-' '.-'  `)
--          `--' `--'|  |-' |  |-' `----'
--                   `--'   `--'
--             _______
--　　　　　 /  ＞　　フ
--　　　　　| 　_　 _ l      RESUME: Here you select the default apps and which
--　 　　　／` ミ＿xノ               ones are started at autostart.
--　　 　 /　　　 　 |
--　　　 /　 ヽ　　 ﾉ
--　 　 │　　|　|　|         AUTHOR:  Andr3xDev
--　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
--　| (￣ヽ＿_ヽ_)__)
--　＼二つ
-----------------------------------------------------------------------------------


---------------------------------------------------------------------------------
--- Autostart
---------------------------------------------------------------------------------
hl.on("hyprland.start", function()
	----- apps -----
	hl.exec_cmd("awww-daemon & dunst & hypridle")

	----- shell -----
	hl.exec_cmd("quickshell --config lucyna &")

	----- services -----
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
	hl.exec_cmd("wl-paste --type text --watch cliphist store &")
	hl.exec_cmd("wl-paste --type image --watch cliphist store &")

	----- ui -----
	hl.exec_cmd("hyprctl setcursor phinger-cursors-light 25 &")
end)


---------------------------------------------------------------------------------
--- Exported commands — consumed by keyblinds and other modules
---------------------------------------------------------------------------------
return {
	-- programs
	terminal       = "ghostty -e zsh --no-rcs -c 'kotofetch; exec zsh'",
	fileManager    = "ghostty --class=yazi -e yazi",
	top            = "ghostty --class=btop -e btop",
	bluethoot      = "ghostty --class=bluetui -e bluetui",
	network        = "ghostty --class=nmtui -e nmtui",
	fetch          = "ghostty --class=fastfetch -e zsh -c 'fastfetch; read '''",

	-- screenshots & pickers
	picker         = "hyprpicker",
    printer_simple = "sh -c \"grim -g '$(slurp -b 00000050)' - | wl-copy && notify-send 'Screenshot' 'Copied to clipboard'\"",
    printer_save   = "sh -c \"grim -g '$(slurp -b 00000050)' ~/media/screenshots/$(date '+%m%d-%Hh-%Mm-%Ss').png && notify-send 'Screenshot' 'Saved in media directory'\"",
    printer_edit   = "sh -c \"grim -g '$(slurp -b 00000050)' -t ppm - | satty --filename -\"",

	-- quickshell elements
	menu           = "quickshell ipc --config lucyna call toggleLauncher handle",
	powermenu      = "quickshell ipc --config lucyna call togglePower handle",
	clipboard      = "quickshell ipc --config lucyna call toggleClip handle",
	calendar       = "quickshell ipc --config lucyna call toggleCalendar handle",
	reload         = "killall quickshell && quickshell --config lucyna",
}
