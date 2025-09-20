---------------------------------------------------------------------------------
-- Discord presence plugin to flex you use Nvim :3
-- Source: https://github.com/IogaMaster/neocord
-- Config autor: Andr3xDev
---------------------------------------------------------------------------------

return {
	"IogaMaster/neocord",
	event = "VeryLazy",
	opts = {
		logo = "https://styles.redditmedia.com/t5_30kix/styles/communityIcon_n2hvyn96zwk81.png",
		-- `auto` or url

		logo_tooltip = "Own",
		-- nil or string

		main_image = "language",
		-- `language` or `logo`

		client_id = "1157438221865717891",
		-- Discord application client id (default)

		log_level = nil,
		-- Log messages (`debug`, `info`, `warn`, `error`)

		debounce_timeout = 5,
		-- Seconds to debounce events

		blacklist = {},
		-- List of strings or Lua patterns that disable Rich Presence (current file name, path, or workspace)

		file_assets = {},
		-- Custom file asset definitions by file names and extensions

		show_time = true,
		-- Show the new timer on each triggered event

		global_timer = true,
		-- Timer won't update when any event are triggered

		editing_text = "Cooking code",
		-- String rendered when an editable file is loaded in the buffer (string or function(filename: string): string)

		file_explorer_text = "Browsing files",
		-- String rendered when browsing a file explorer

		git_commit_text = "Committing changes",
		-- String rendered when committing changes in git

		plugin_manager_text = "Managing plugins",
		-- String rendered when managing plugins

		reading_text = "Reading code",
		-- String rendered when a read-only or unmodifiable file is loaded in the buffer

		workspace_text = "Working on projets",
		-- String rendered when in a git repository

		line_number_text = "Line %s out of %s",
		-- String rendered when `enable_line_number` is set to true

		terminal_text = "Using Terminal",
		-- String rendered when in terminal mode.
	},
}
