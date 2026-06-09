---------------------------------------------------------------------------
--- autocpompletion to the code editor, powered by the blink engine.
---------------------------------------------------------------------------

return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
    "rafamadriz/friendly-snippets",
  },

  build = function()
    require("blink.cmp").build():wait(60000)
  end,

  opts = {
    keymap = {
      preset = "default",
      ["<CR>"]    = { "accept", "fallback" },
      ["<Tab>"]   = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    completion = {
      documentation = {
        auto_show       = false,
        auto_show_delay_ms = 500,
      },
    },
    signature = {
      enabled = true,
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "lua" },
  },
}
