---------------------------------------------------------------------------
--- code structure outline for LSP and Treesitter
---------------------------------------------------------------------------

return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
  keys = {
    { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbols outline (Aerial)" },
    { "[[",         "<cmd>AerialPrev<cr>",   desc = "Prev symbol" },
    { "]]",         "<cmd>AerialNext<cr>",   desc = "Next symbol" },
  },
  opts = {
    backends = { "treesitter", "lsp", "markdown", "man" },
    attach_mode = "global",
    show_guides = true,
    layout = {
      resize_to_content = false,
      win_opts = {
        signcolumn = "yes",
        statuscolumn = " ",
      },
    },
    guides = {
      mid_item  = "├╴",
      last_item = "└╴",
      nested_top = "│ ",
      whitespace = "  ",
    },
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    highlight_on_hover = true,
    highlight_on_jump = 300,
    autojump = true,
  },
}
