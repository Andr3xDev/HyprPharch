-- Abysal Marble
return {
	-- Base colors
	base    = "rgb(dcdcdc)", -- main_background
	surface = "rgb(cfcfcf)", -- secondary_background
	text    = "rgb(2f2f2f)", -- main_text

	-- Palette
	color1 = "rgb(2c9279)", -- turquoise
	color2 = "rgb(a04e1e)", -- orange
	color3 = "rgb(7a6020)", -- sand
	color4 = "rgb(a8474a)", -- soft_red
	color5 = "rgb(365ca8)", -- steel_blue
	color6 = "rgb(824699)", -- lavender_purple
	color7 = "rgb(555555)", -- dark_gray_secondary
	color8 = "rgb(737373)", -- medium_gray_comments
	color9 = "rgb(bcbcbc)", -- light_gray_borders

	-- Highlight colors
	highlight1 = "rgb(d4d4d4)", -- faint_selection
	highlight2 = "rgb(c4c4c4)", -- medium_selection
	highlight3 = "rgb(b8b8b8)", -- strong_selection

	-- Wallpaper
	wallpaper = "~/.config/wallpapers/vogabond.png",

	-- Border configuration
	border_active   = "rgb(b8b8b8)", -- Muted gray focus   ($highlight3)
	border_inactive = "rgb(bcbcbc)", -- Soft light gray    ($color9)
	border_urgent   = "rgb(a8474a)", -- Deep Red            ($color4)

	-- Shadows
	shadow_active   = "rgba(00000050)",
	shadow_inactive = "rgba(00000000)",

	-- Opacity
	opacity = 0.92,

	-- Hyprlock specifics
	lock_background_brightness = 0.9,
	lock_backsurface  = "rgba(220, 220, 220, 0.9)",
	lock_border_color = "rgba(196, 196, 196, 1)",

	lock_text         = "rgb(2f2f2f)", -- $text
	lock_shadow       = "rgb(dcdcdc)", -- $base

	lock_time_hours   = "rgb(2f2f2f)", -- $text
	lock_time_date    = "rgb(2c9279)", -- $color1

	lock_input_bg     = "rgb(cfcfcf)", -- $surface
	lock_input_border = "rgb(2c9279)", -- $color1
	lock_input_text   = "rgb(2f2f2f)", -- $text

	lock_actions_border = "rgb(2c9279)", -- $color1
	lock_actions_text   = "rgb(2f2f2f)", -- $text

	lock_battery_bg     = "rgb(cfcfcf)", -- $surface
	lock_battery_border = "rgb(2c9279)", -- $color1
	lock_battery_text   = "rgb(2f2f2f)", -- $text
}
