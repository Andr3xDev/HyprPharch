---------------------------------------------------------------------------------
-- Mason to control all LSP servers
-- Source: https://github.com/williamboman/mason.nvim
--         https://github.com/williamboman/mason-lspconfig.nvim
--         https://github.com/neovim/nvim-lspconfig
---------------------------------------------------------------------------------

return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts ={},
    },
}
