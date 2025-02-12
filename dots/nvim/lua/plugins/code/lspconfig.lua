---------------------------------------------------------------------------------
-- Mason to control all LSP servers
-- Source: https://github.com/williamboman/mason.nvim
--         https://github.com/williamboman/mason-lspconfig.nvim
--         https://github.com/neovim/nvim-lspconfig
---------------------------------------------------------------------------------

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "jdtls",      -- Java
                    "cssls",      -- CSS
                    "tsserver",   -- JavaScript/TypeScript
                    "pyright",    -- Python
                    "sqlls",      -- SQL
                    "html",       -- HTML
                    "marksman",   -- Markdown
                    "lua_ls",     -- Lua
                    "bashls"      -- Bash
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    local clients = vim.lsp.get_active_clients()
                    for _, client in pairs(clients) do
                        if not vim.lsp.buf_is_attached(0, client.id) then
                            vim.lsp.stop_client(client.id)
                        end
                    end
                end,
            })

            local on_attach = function(_, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
            }

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = servers[server_name] and servers[server_name].settings or nil,
                    })
                end,
            })
        end,
    },
}

