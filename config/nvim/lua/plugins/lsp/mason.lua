---------------------------------------------------------------------------
--- package manager for LSP servers, DAP servers, linters and formatters
---------------------------------------------------------------------------

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
