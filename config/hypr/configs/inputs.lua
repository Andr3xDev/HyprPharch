----------------------------------------------------------------------------------
--          ,--.                         ,--.
--          |  |,--,--,  ,---. ,--.,--.,-'  '-. ,---.
--          |  ||      \| .-. ||  ||  |'-.  .-'(  .-'
--          |  ||  ||  || '-' ''  ''  '  |  |  .-'  `)
--          `--'`--''--'|  |-'  `----'   `--'  `----'
--                      `--'
--             _______
--　　　　　 /  ＞　　フ
--　　　　　| 　_　 _ l      RESUME: Here you manage the configuration of any
--　 　　　／` ミ＿xノ               gesture, mouse, keyboard, etc.
--　　 　 /　　　 　 |
--　　　 /　 ヽ　　 ﾉ
--　 　 │　　|　|　|         AUTHOR:  Andr3xDev
--　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
--　| (￣ヽ＿_ヽ_)__)
--　＼二つ
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
--- General Inputs
----------------------------------------------------------------------------------
hl.config({
	input = {
		follow_mouse  = 1,
		sensitivity   = 0.4,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
		},
	},
})


----------------------------------------------------------------------------------
--- My Devices
----------------------------------------------------------------------------------

-- laptop keyboard
hl.device({
	name      = "at-translated-set-2-keyboard",
	kb_layout = "latam",
})

-- portable mouse
hl.device({
	name          = "2.4g-wireless-mouse",
	sensitivity   = -0.4,
	accel_profile = "flat",
})


----------------------------------------------------------------------------------
--- Mousepad Gestures
----------------------------------------------------------------------------------

-- move horizontal workspaces
hl.gesture({
	fingers   = 3,
	direction = "horizontal",
	action    = "workspace",
	arg       = "unset",
})

-- toggle special workspace
hl.gesture({
	fingers   = 3,
	direction = "vertical",
	action    = "special",
    workspace_name = "magic"
})
