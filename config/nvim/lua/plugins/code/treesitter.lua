---------------------------------------------------------------------------
--- code highlighting and indentation
---------------------------------------------------------------------------

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
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
        "rust",
        "terraform",
      },
      indent = { enable = true },
      auto_install = true,
    })
  end,
}
