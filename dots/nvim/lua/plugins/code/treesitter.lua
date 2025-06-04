
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = {
        -- Frontend
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "astro",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
        "java",
        "python",
        "sql",
        "bash",
        "lua",
        "dockerfile",
        "yaml",
        "toml",
      },

      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

