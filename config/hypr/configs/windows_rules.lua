----------------------------------------------------------------------------------
--
--             ,------.         ,--.
--             |  .--. ',--.,--.|  | ,---.  ,---.
--             |  '--'.'|  ||  ||  || .-. :(  .-'
--             |  |\  \ '  ''  '|  |\   --..-'  `)
--             `--' '--' `----' `--' `----'`----'
--
--             _______
--　　　　　 /  ＞　　フ
--　　　　　| 　_　 _ l      RESUME: The rules for workspaces, apps, layers,
--　 　　　／` ミ＿xノ               and animations are declared here.
--　　 　 /　　　 　 |
--　　　 /　 ヽ　　 ﾉ
--　 　 │　　|　|　|         AUTHOR:  Andr3xDev
--　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
--　| (￣ヽ＿_ヽ_)__)
--　＼二つ
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
--- General
----------------------------------------------------------------------------------

hl.window_rule({
	name   = "terminal",
	size   = { 750, 450 },
	float  = true,
	center = true,
	match  = {
		class = "com.mitchellh.ghostty",
	},
})

hl.window_rule({
	name   = "pavucontrol",
	size   = { "(monitor_w*0.6)", "(monitor_h*0.6)" },
	float  = true,
	center = true,
	match  = {
		title = "Volume Control",
	},
})

hl.window_rule({
	name   = "spotify",
	size   = { "(monitor_w*0.9)", "(monitor_h*0.8)" },
	float  = true,
	center = true,
	match  = {
		class = "spotify",
	},
})

----- steam -----
hl.window_rule({
	name  = "steam-general",
	tile  = true,
	match = {
		class = "steam",
		title = "Steam",
	},
})
hl.window_rule({
	name  = "steam-popups",
	float = true,
	match = {
		class = "steam",
		title = "^(Friends List|Steam Settings|.*)$",
	},
})
hl.window_rule({
	name  = "steam-settings-size",
	size  = { "(monitor_w*0.65)", "(monitor_h*0.95)" },
	float = true,
	match = {
		class = "steam",
		title = "Steam Settings",
	},
})
hl.window_rule({
	name  = "steam-oferts-size",
	size  = { "(monitor_w*0.3)", "(monitor_h*0.75)" },
	float = true,
	match = {
		class = "steam",
		title = "Special Offers",
	},
})
hl.window_rule({
	name  = "steam-friends-size",
	size  = { "(monitor_w*0.2)", "(monitor_h*0.7)" },
	float = true,
	match = {
		class = "steam",
		title = "Friends List",
	},
})

----- select/open forlder -----
hl.window_rule({
	name   = "file-roller",
	size   = { "(monitor_w*0.5)", "(monitor_h*0.6)" },
	float  = true,
	center = true,
	match  = {
		class = "File-roller",
	},
})
hl.window_rule({
	name   = "file-roller-extract",
	size   = { "(monitor_w*0.5)", "(monitor_h*0.6)" },
	float  = true,
	center = true,
	match  = {
		title = "open",
	},
})

----- VPN -----
hl.window_rule({
	name   = "proton-vpn",
	size   = { 400, 650 },
	center = true,
	float  = true,
	match  = {
		class = "protonvpn-app",
	},
})

----- special workspace -----
hl.workspace_rule({
    workspace        = "special:magic",
    on_created_empty = "[float|center|size:750x450] ghostty -e zsh --no-rcs -c 'kotofetch; exec zsh'",
    gaps_in          = 15,
    gaps_out         = 50,
})


----------------------------------------------------------------------------------
--- animations
----------------------------------------------------------------------------------

----- apps -----
hl.window_rule({
	name      = "firefox-in",
	animation = windowsIn,
	match = {
		class = "firefox",
	},
})

----- layers -----
hl.layer_rule({
	name    = "hyprpicker-no-anim",
	no_anim = true,
	match   = {
		namespace = "hyprpicker",
	},
})
hl.layer_rule({
	name    = "screenshot-no-anim",
	no_anim = true,
	match   = {
		namespace = "selection",
	},
})
