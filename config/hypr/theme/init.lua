--[[
	Theme Selector
	Resolves the active theme by reading the state file.
	Falls back to the default theme if the state file is missing or invalid.

	Extensible pattern: the same state file can later hold monitor
	profiles, layout presets, or any other dynamic configuration.

	Usage:
		local theme = require("theme")
		print(theme.base) --> "rgb(1c1c1c)"
]]

local HOME         = os.getenv("HOME")
local STATE_FILE   = HOME .. "/.config/hypr/theme/state.lua"
local DEFAULT      = "abysal-obsidian"

local theme_name = DEFAULT

-- Safely load the state file: it must return a string (the theme name)
local ok, loader = pcall(loadfile, STATE_FILE)
if ok and loader then
	local ok2, result = pcall(loader)
	if ok2 and type(result) == "string" then
		theme_name = result
	end
end

-- Load and return the selected theme module
return require("theme." .. theme_name)
