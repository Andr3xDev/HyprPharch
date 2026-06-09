---------------------------------------------------------------------------
--- general config for todo, warning, error, etc comments in code
---------------------------------------------------------------------------

local palette = require("palettes.abysal").get_palette()

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo Comments" },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next Todo",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Prev Todo",
    },
  },
  opts = {
    colors = {
      error = { "DiagnosticError", "ErrorMsg", palette.color4 },
      warning = { "DiagnosticWarn", "WarningMsg", palette.color3 },
      info = { "DiagnosticInfo", palette.color1 },
      hint = { "DiagnosticHint", palette.color2 },
      default = { "Identifier", palette.color1 },
      test = { "Identifier", palette.color5 },
      todo = { palette.color1 },
      hack = { palette.color2 },
      note = { palette.color2 },
      perf = { palette.color5 },
    },

    signs = true,
    sign_priority = 8,

    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "BROKEN" } },
      TODO = { icon = " ", color = "todo", alt = { "TO-DO" } },
      HACK = { icon = " ", color = "hack", alt = { "WORKAROUND", "TEMP", "TEMPORARY" } },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "DEPRECATED", "OBSOLETE" } },
      NOTE = { icon = " ", color = "note", alt = { "INFO", "DESC", "DOCS", "CONTEXT", "QUESTION" } },
      PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      SAFETY = { icon = "󰒃 ", color = "error", alt = { "SEC", "SECURITY", "VULN", "CVE" } },
      REVIEW = { icon = " ", color = "warning", alt = { "REVISIT", "CHECKME", "FOLLOWUP" } },
    },

    gui_style = {
      fg = "NONE",
      bg = "NONE",
    },

    merge_keywords = true,
    highlight = {
      multiline = true,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "fg",
      after = "",
      pattern = [[.*<(KEYWORDS)\s*:?]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },

    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):?]],
    },
  },
}
