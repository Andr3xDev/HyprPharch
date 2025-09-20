return {
    {
        "mason-org/mason.nvim",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "tailwindcss",
                    "eslint",
                    "jsonls",
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                },
                automatic_installation = true,
            })
        end
    }
}
