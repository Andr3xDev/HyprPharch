---------------------------------------------------------------------------
--- unified interface for formatting code based on file type
---------------------------------------------------------------------------

return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      tsx = { "prettier" },
      astro = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      python = { "ruff_format" },
      lua = { "stylua" },
      rust = { "rustfmt" },
      java = { "google-java-format" },
      sql = { "sql_formatter" },
      bash = { "shfmt" },
      toml = { "taplo" },
      terraform = { "terraform_fmt" },
      qml = { "qmllint" },
      go = { "gofumpt" },
    },

    notify_on_error = true,
    notify_no_formatters = true,
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
