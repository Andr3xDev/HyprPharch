-----------------------------------------------------------
-- Colorscheme to all nvim color
-- Source: https://github.com/sainnhe/gruvbox-material
-- Source custom: https://github.com/Andr3xDev/gruvbox-material-personal
-- Config autor: sainnhe
-----------------------------------------------------------

return {
	'Andr3xDev/gruvbox-material-personal',
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_enable_italic = true
		vim.cmd.colorscheme 'gruvbox-material'
	end,
}
