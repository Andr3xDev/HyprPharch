---------------------------------------------------------------------------
-- Botton bar config show everytime
-- Source: https://github.com/nvim-lualine/lualine.nvim
-- Config: Andr3xDev
---------------------------------------------------------------------------

local gruvbox_material_custom = {
    normal = {
        a = { bg = '#b0b846', fg = '#1b1b1b', gui = 'bold' },
        b = { bg = '#282828', fg = '#e2cca9' },
        c = { bg = '#282828', fg = '#e2cca9' },
        x = { bg = '#282828', fg = '#e2cca9' },
        y = { bg = '#282828', fg = '#e2cca9' },
        z = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
    },
    insert = {
        a = { bg = '#e9b143', fg = '#1b1b1b', gui = 'bold' },
        z = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
    },
    visual = {
        a = { bg = '#f2594b', fg = '#1b1b1b', gui = 'bold' },
        z = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
    },
    command = {
        a = { bg = '#f28534', fg = '#1b1b1b', gui = 'bold' },
        z = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
    },
    inactive = {
        a = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
        z = { bg = '#282828', fg = '#e2cca9', gui = 'bold' },
    }
}

return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = function()
			return {
				options = {
					icons_enabled = true,
					theme = gruvbox_material_custom,
                    component_separators = '',
					section_separators = '',
					disabled_filetypes = {
						statusline = {'alpha', 'neo-tree'},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					}
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {
                        'filename'
                    },
					lualine_c = {
                        {
                            function()
                                return '▊'
                            end,
                            color = { fg = '#80aa9e'},
                            padding = { left = 0, right = 0 },
                        },
                        'branch', 'diff'},
					lualine_x = {
						{
                            'diagnostics',
							sources = { 'nvim_diagnostic' },
							symbols = {error = ' ', warn = ' ', info = ' '},
							diagnostics_color = {
								error = {fg = '#EA6962'},
								warn = {fg = '#D8A657'},
								info = {fg = '#A9B665'},
							},
						}
                    },
					lualine_y = {
                        {
                            function()
                                return '▊'
                            end,
                            color = { fg = '#80aa9e'},
                            padding = { left = 0, right = 0 },
                        },
                        'filetype'
                    },
					lualine_z = {
                        {
                            function()
                                return '▊'
                            end,
                            color = { fg = '#b0b846'},
                            padding = { left = 0, right = 0 },
                        },
                        'location'}
				},
				inactive_sections = {
					lualine_a = {'filename'},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {'fileformat'},
                },
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end
	}
}
