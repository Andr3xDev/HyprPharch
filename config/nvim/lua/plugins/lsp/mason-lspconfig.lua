---------------------------------------------------------------------------
--- config to setup mason-lspconfig with mason.nvim and nvim-lspconfig
---------------------------------------------------------------------------

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "html",
      "cssls",
      "ts_ls",
      "astro",
      "jsonls",
      "pyright",
      "lua_ls",
      "rust_analyzer",
      "bashls",
      "sqls",
      "dockerls",
      "yamlls",
      "taplo",
      "terraformls",
      "marksman",
      "gopls",
    },
    automatic_installation = true,
  },
}
