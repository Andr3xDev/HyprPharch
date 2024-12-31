return {
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
        options = {theme = require'lualine.themes.gruvbox-material'}
        return opts
    end
}
}
