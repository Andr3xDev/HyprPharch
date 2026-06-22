---------------------------------------------------------------------------
--- installer to install formatters and linters
---------------------------------------------------------------------------

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    ensure_installed = {
      -- Formatters
      "gofumpt",
      "stylua",
      "prettier",
      "ruff",
      "google-java-format",
      "sql-formatter",
      "shfmt",
      "taplo",
      -- Linters
      "golangci-lint",
      "eslint_d",
      "luacheck",
      "shellcheck",
      "hadolint",
      "yamllint",
      "sqlfluff",
      "tflint",
      "stylelint",
      "htmlhint",
      "jsonlint",
      -- Debug adapters
      "debugpy",
      "codelldb",
      "js-debug-adapter",
    },
    auto_update = false,
    run_on_start = true,
  },
}
