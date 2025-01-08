-----------------------------------------------------------
-- Colorscheme to all nvim color
-- Source: https://github.com/sainnhe/gruvbox-material
-- Config autor: sainnhe
-----------------------------------------------------------

return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.cmd.colorscheme 'gruvbox-material'
    end,
}
