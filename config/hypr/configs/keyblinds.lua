----------------------------------------------------------------------------------
--
--    ,--. ,--.                ,--.   ,--.,--.           ,--.
--    |  .'   / ,---. ,--. ,--.|  |-. |  |`--',--,--,  ,-|  | ,---.
--    |  .   ' | .-. : \  '  / | .-. '|  |,--.|      \' .-. |(  .-'
--    |  |\   \\   --.  \   '  | `-' ||  ||  ||  ||  |\ `-' |.-'  `)
--    `--' '--' `----'.-'  /    `---' `--'`--'`--''--' `---' `----'
--                    `---'
--             _______
--　　　　　 /  ＞　　フ
--　　　　　| 　_　 _ l      RESUME: Keyblinds to control special ws, media,
--　 　　　／` ミ＿xノ               movement, widgets and apps
--　　 　 /　　　 　 |
--　　　 /　 ヽ　　 ﾉ
--　 　 │　　|　|　|         AUTHOR:  Andr3xDev
--　／￣|　　 |　|　|        URL: https://github.com/Andr3xDev/HyprPharch
--　| (￣ヽ＿_ヽ_)__)
--　＼二つ
-----------------------------------------------------------------------------------


local apps = require("configs.apps")
local mainmod = "SUPER"


---------------------------------------------------------------------------------
--- Basics
---------------------------------------------------------------------------------

hl.bind(mainmod .. " + RETURN",         hl.dsp.exec_cmd(apps.terminal))
hl.bind(mainmod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("[float off] " .. apps.terminal))
hl.bind(mainmod .. " + Q",              hl.dsp.window.close())
hl.bind(mainmod .. " + SHIFT + Q",      hl.dsp.window.kill())
hl.bind(mainmod .. " + SHIFT + F",      hl.dsp.window.fullscreen())

----- reload secction -----
hl.bind(mainmod .. " + R",         hl.dsp.exec_cmd(apps.reload))
hl.bind(mainmod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

----- unbind default floating toggle -----
hl.unbind("CTRL_L + RETURN")


---------------------------------------------------------------------------------
--- Apps
---------------------------------------------------------------------------------

hl.bind(mainmod .. " + A", hl.dsp.submap("apps"))

hl.define_submap("apps", function()
	hl.bind("E", function()
		hl.dispatch(hl.dsp.exec_cmd("[float; center on; size monitor_w*0.5 monitor_h*0.5] " .. apps.fileManager))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("I", function()
		hl.dispatch(hl.dsp.exec_cmd("[float; center on; size monitor_w*0.8 monitor_h*0.8] " .. apps.top))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("F", function()
		hl.dispatch(hl.dsp.exec_cmd("[float; center on; size 700 400] " .. apps.fetch))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("B", function()
		hl.dispatch(hl.dsp.exec_cmd("[float; center on; size 800 500] " .. apps.bluethoot))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("N", function()
		hl.dispatch(hl.dsp.exec_cmd("[float; center on; size 700 550] " .. apps.network))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("M", function()
		hl.dispatch(hl.dsp.exec_cmd("quickshell ipc --config lucyna call monitorManager handle"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("C", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.clipboard))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("G", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.calendar))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
end)

----- quickshell -----
hl.bind(mainmod .. " + SPACE",     hl.dsp.exec_cmd(apps.menu))
hl.bind(mainmod .. " + BACKSPACE", hl.dsp.exec_cmd(apps.powermenu))

-- DEPRECATED
hl.bind("SUPER + Y", hl.dsp.exec_cmd("quickshell ipc --config lucyna call themeLauncher toggle"))


---------------------------------------------------------------------------------
--- Screenshots & Pickers
---------------------------------------------------------------------------------

hl.bind(mainmod .. " + T", hl.dsp.submap("screenshots"))

hl.define_submap("screenshots", function()
	hl.bind("T", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.printer_simple))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("S", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.printer_save))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("E", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.printer_edit))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("P", function()
		hl.dispatch(hl.dsp.exec_cmd(apps.picker))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("space",  hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
end)


---------------------------------------------------------------------------------
--- Special Buttons
---------------------------------------------------------------------------------

hl.bind("xf86poweroff", hl.dsp.exec_cmd(apps.powermenu))

----- Brightness -----
-- !!! Change device to yours !!!
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d intel_backlight set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d intel_backlight set 10%-"), { repeating = true })

----- Media buttons -----
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +2%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -2%"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))


---------------------------------------------------------------------------------
-- Windows Settings
---------------------------------------------------------------------------------

hl.bind(mainmod .. " + V", hl.dsp.window.float({ action = "toggle" }))


---------------------------------------------------------------------------------
-- Workspaces
---------------------------------------------------------------------------------

----- Resize submap -----
hl.bind(mainmod .. " + CTRL + V", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	hl.bind("H",      hl.dsp.window.resize({ x = -35, y = 0, relative = true }), { repeating = true })
	hl.bind("L",      hl.dsp.window.resize({ x = 35, y = 0, relative = true }),  { repeating = true })
	hl.bind("K",      hl.dsp.window.resize({ x = 0, y = -35, relative = true }), { repeating = true })
	hl.bind("J",      hl.dsp.window.resize({ x = 0, y = 35, relative = true }),  { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
	hl.bind("space",  hl.dsp.submap("reset"))
end)

----- Special workspace (scratchpad) -----
hl.bind(mainmod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainmod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

----- Window focus -----
hl.bind(mainmod .. " + H",   hl.dsp.focus({ direction = "left" }))
hl.bind(mainmod .. " + L",   hl.dsp.focus({ direction = "right" }))
hl.bind(mainmod .. " + K",   hl.dsp.focus({ direction = "up" }))
hl.bind(mainmod .. " + J",   hl.dsp.focus({ direction = "down" }))
hl.bind(mainmod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

----- Move windows -----
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

----- Move / resize windows with mouse -----
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })


---------------------------------------------------------------------------------
--- hyprsplit library
---------------------------------------------------------------------------------

local hs = require("lib.hyprsplit")

hs.config({ num_workspaces = 10 })
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainmod .. " + " .. key,         hs.dsp.focus({ workspace = i }))
    hl.bind(mainmod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = true }))
end

hl.bind("SUPER + " .. "g", hs.dsp.grab_rogue_windows())

----- swap workspaces -----
hl.bind(mainmod .. " + CTRL + L", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind(mainmod .. " + CTRL + H", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "-1" }))


---------------------------------------------------------------------------------
--- hyprswap: full deck swap
---------------------------------------------------------------------------------

local hw = require("lib.hyprswap")

hl.bind(mainmod .. " + CTRL + SHIFT + L", hw.dsp.swap({ monitor1 = "current", monitor2 = "+1" }))
hl.bind(mainmod .. " + CTRL + SHIFT + H", hw.dsp.swap({ monitor1 = "current", monitor2 = "-1" }))
