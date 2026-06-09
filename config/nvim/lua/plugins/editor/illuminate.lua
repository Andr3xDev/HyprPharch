---------------------------------------------------------------------------
--- illuminates other occurrences of the word under the cursor
---------------------------------------------------------------------------

return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    providers = { "lsp", "treesitter", "regex" },
    delay = 200,
    filetypes_denylist = {
      "dirbuf",
      "dirvish",
      "fugitive",
    },
    under_cursor = true,
    large_file_cutoff = 10000,
    min_count_to_highlight = 2,
    case_insensitive_regex = false,
    disable_keymaps = false,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
