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
    config = function()
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local mason_tool_installer = require('mason-tool-installer')

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			pip = {
				upgrade_pip = true,  -- Update pip when managing Python packages
			}
		})

		mason_lspconfig.setup({
			-- LSP servers to install automatically
			ensure_installed = {
				'lua_ls',
				'html',
				'cssls',
				'pylsp',
				'clangd'
			},
		})

		mason_tool_installer.setup({
			-- Non-LSP tools to install automatically
			ensure_installed = {
				'prettier',
				'isort',
			}
		})
	end,
}
