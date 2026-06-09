-- Abysal Obsidian
return {
	-- Base colors
	base    = "rgb(1c1c1c)", -- main_background
	surface = "rgb(262626)", -- secondary_background
	text    = "rgb(d4d4d4)", -- main_text

	-- Palette
	color1 = "rgb(52c9b0)", -- turquoise
	color2 = "rgb(e28e5a)", -- orange
	color3 = "rgb(d1b171)", -- sand
	color4 = "rgb(d47779)", -- soft_red
	color5 = "rgb(6b92e3)", -- steel_blue
	color6 = "rgb(b87bce)", -- lavender_purple
	color7 = "rgb(8c8c8c)", -- light_gray_secondary
	color8 = "rgb(737373)", -- medium_gray_comments
	color9 = "rgb(2e2e2e)", -- dark_gray_borders

	-- Highlight colors
	highlight1 = "rgb(2a2a2a)", -- faint_selection
	highlight2 = "rgb(333333)", -- medium_selection
	highlight3 = "rgb(454545)", -- strong_selection

	-- Wallpaper
	wallpaper = "~/.config/wallpapers/vogabond.jpg",

	-- Border configuration
	border_active   = "rgb(454545)", -- Gray focus          ($highlight3)
	border_inactive = "rgb(2e2e2e)", -- Darker gray borders ($color9)
	border_urgent   = "rgb(d47779)", -- Soft Red            ($color4)

	-- Shadows
	shadow_active   = "rgba(11111b70)",
	shadow_inactive = "rgba(00000000)",

	-- Opacity
	opacity = 0.95,

	-- Hyprlock specifics
	lock_background_brightness = 0.8,
	lock_backsurface  = "rgba(28, 28, 28, 0.95)",
	lock_border_color = "rgba(51, 51, 51, 1)",

	lock_text         = "rgb(d4d4d4)", -- $text
	lock_shadow       = "rgb(1c1c1c)", -- $base

	lock_time_hours   = "rgb(d4d4d4)", -- $text
	lock_time_date    = "rgb(e28e5a)", -- $color2

	lock_input_bg     = "rgb(262626)", -- $surface
	lock_input_border = "rgb(52c9b0)", -- $color1
	lock_input_text   = "rgb(d4d4d4)", -- $text

	lock_actions_border = "rgb(52c9b0)", -- $color1
	lock_actions_text   = "rgb(d4d4d4)", -- $text

	lock_battery_bg     = "rgb(262626)", -- $surface
	lock_battery_border = "rgb(52c9b0)", -- $color1
	lock_battery_text   = "rgb(d4d4d4)", -- $text
}
