---------------------------------------------------------------------------
--- LSP Config fot each language server, for installation and management
---------------------------------------------------------------------------

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local servers = {
      html = {},
      cssls = {},
      ts_ls = {},
      astro = {},
      jsonls = {},
      pyright = {},
      bashls = {},
      dockerls = {},
      sqls = {},
      yamlls = {},
      taplo = {},
      terraformls = {},
      marksman = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      },
      qmlls = {},
    }
    for server, server_config in pairs(servers) do
      server_config.capabilities = capabilities
      vim.lsp.config(server, server_config)
      vim.lsp.enable(server)
    end
  end,
}
