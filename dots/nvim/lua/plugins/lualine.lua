---------------------------------------------------------------------------
-- Botton bar config show everytime
-- Source: https://github.com/nvim-lualine/lualine.nvim
-- Config: Andr3xDev
---------------------------------------------------------------------------

return {
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
        return {
            options = {
                icons_enabled = true,
                theme = 'gruvbox-material',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
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
                lualine_b = {'branch', 'diff', 'filename'},
                lualine_c = {
                    { 
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = { error = ' ', warn = ' ', info = ' ' },
                        diagnostics_color = {
                            error = { fg = '#EA6962' },
                            warn = { fg = '#D8A657' },
                            info = { fg = '#A9B665' },
                        },
                    }
                },
                lualine_x = {'encoding'},
                lualine_y = {'filetype'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {'fileformat'},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    end
}
}
