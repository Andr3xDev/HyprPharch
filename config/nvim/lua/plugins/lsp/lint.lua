---------------------------------------------------------------------------
--- config to manage linters for various filetypes
---------------------------------------------------------------------------

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      astro = { "eslint_d" },
      python = { "ruff" },
      lua = { "luacheck" },
      bash = { "shellcheck" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      terraform = { "tflint" },
      hcl = { "tflint" },
      sql = { "sqlfluff" },
      css = { "stylelint" },
      scss = { "stylelint" },
      html = { "htmlhint" },
      json = { "jsonlint" },
      jsonc = { "jsonlint" },
    },

    linters = {
      sqlfluff = {
        args = { "lint", "--dialect", "ansi", "--format", "json" },
      },
      luacheck = {
        args = {
          "--globals",
          "vim",
          "--no-unused-args",
          "--formatter",
          "plain",
          "--codes",
          "--ranges",
          "-",
        },
      },
    },
  },

  config = function(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    if opts.linters then
      for name, config in pairs(opts.linters) do
        if lint.linters[name] then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], config)
        end
      end
    end

    local group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = group,
      callback = function()
        if vim.bo.buftype ~= "" then
          return
        end
        lint.try_lint()
      end,
    })
  end,
}
