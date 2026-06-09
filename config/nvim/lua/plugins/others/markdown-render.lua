---------------------------------------------------------------------------
--- Renders markdown in-buffer with virtual text and concealment
---------------------------------------------------------------------------

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    max_file_size = 10,
    debounce = 70,
    preset = "none",
    render_modes = { "n", "c", "t" },
    anti_conceal = {
      enabled = true,
      disabled_modes = false,
      above = 0,
      below = 0,
      ignore = {
        code_background = true,
        indent = true,
        sign = true,
        virtual_lines = true,
      },
    },

    win_options = {
      conceallevel = { default = vim.o.conceallevel, rendered = 3 },
      concealcursor = { default = vim.o.concealcursor, rendered = "" },
    },

    heading = {
      enabled = true,
      render_modes = false,
      atx = true,
      setext = true,
      sign = true,
      signs = { "󰫎 " },
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      position = "overlay",
      width = "full",
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = false,
      border_virtual = false,
      border_prefix = false,
      above = "▄",
      below = "▀",
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },

    code = {
      enabled = true,
      render_modes = false,
      sign = true,
      conceal_delimiters = true,
      language = true,
      language_icon = true,
      language_name = true,
      language_info = true,
      language_pad = 0,
      disable = {},
      disable_background = { "diff" },
      background_inset = 1,
      width = "full",
      left_margin = 1,
      left_pad = 2,
      right_pad = 1,
      min_width = 10,
      border = "hide",
      language_border = "█",
      language_left = "",
      language_right = "",
      above = "▄",
      below = "▀",
      inline = true,
      inline_left = "",
      inline_right = "",
      inline_pad = 0,
      style = "full",
      priority = 140,
      highlight = "RenderMarkdownCode",
      highlight_info = "RenderMarkdownCodeInfo",
      highlight_language = nil,
      highlight_border = "RenderMarkdownCodeBorder",
      highlight_fallback = "RenderMarkdownCodeFallback",
      highlight_inline = "RenderMarkdownCodeInline",
      highlight_inline_left = nil,
      highlight_inline_right = nil,
    },

    pipe_table = {
      enabled = true,
      render_modes = false,
      preset = "double",
      cell = "padded",
      padding = 1,
      min_width = 0,
      border = {
        "┌",
        "┬",
        "┐",
        "├",
        "┼",
        "┤",
        "└",
        "┴",
        "┘",
        "│",
        "─",
      },
      border_enabled = true,
      border_virtual = false,
      alignment_indicator = "━",
      style = "full",
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      filler = "RenderMarkdownTableFill",
    },

    checkbox = {
      enabled = true,
      render_modes = false,
      bullet = false,
      left_pad = 0,
      right_pad = 1,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },

      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
        scope_highlight = "@markup.strikethrough",
      },
      custom = {
        todo = {
          raw = "[-]",
          rendered = "󰥔 ",
          highlight = "RenderMarkdownTodo",
          scope_highlight = nil,
        },
      },
    },

    callout = {
      note = {
        raw = "[!NOTE]",
        rendered = "󰋽 Note",
        highlight = "RenderMarkdownInfo",
        category = "github",
      },
      tip = {
        raw = "[!TIP]",
        rendered = "󰌶 Tip",
        highlight = "RenderMarkdownSuccess",
        category = "github",
      },
      important = {
        raw = "[!IMPORTANT]",
        rendered = "󰅾 Important",
        highlight = "RenderMarkdownHint",
        category = "github",
      },
      warning = {
        raw = "[!WARNING]",
        rendered = "󰀪 Warning",
        highlight = "RenderMarkdownWarn",
        category = "github",
      },
      caution = {
        raw = "[!CAUTION]",
        rendered = "󰳦 Caution",
        highlight = "RenderMarkdownError",
        category = "github",
      },
      info = {
        raw = "[!INFO]",
        rendered = "󰋽 Info",
        highlight = "RenderMarkdownInfo",
        category = "obsidian",
      },
      todo = {
        raw = "[!TODO]",
        rendered = "󰗡 Todo",
        highlight = "RenderMarkdownInfo",
        category = "obsidian",
      },
      danger = {
        raw = "[!DANGER]",
        rendered = "󱐌 Danger",
        highlight = "RenderMarkdownError",
        category = "obsidian",
      },
      bug = {
        raw = "[!BUG]",
        rendered = "󰨰 Bug",
        highlight = "RenderMarkdownError",
        category = "obsidian",
      },
      example = {
        raw = "[!EXAMPLE]",
        rendered = "󰉹 Example",
        highlight = "RenderMarkdownHint",
        category = "obsidian",
      },
      quote = {
        raw = "[!QUOTE]",
        rendered = "󱆨 Quote",
        highlight = "RenderMarkdownQuote",
        category = "obsidian",
      },
    },

    bullet = {
      enabled = true,
      render_modes = false,
      icons = { "●", "○", "◆", "◇" },
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      highlight = "RenderMarkdownBullet",
    },

    dash = {
      enabled = true,
      render_modes = false,
      icon = "─",
      width = "full",
      left_margin = 0,
      highlight = "RenderMarkdownDash",
    },

    link = {
      enabled = true,
      render_modes = false,
      footnote = {
        superscript = true,
        prefix = "",
        suffix = "",
      },
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌹 ",
      highlight = "RenderMarkdownLink",
      wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
      custom = {},
    },

    sign = {
      enabled = true,
      highlight = "RenderMarkdownSign",
    },

    indent = {
      enabled = false,
      render_modes = false,
      per_level = 2,
      skip_level = 1,
      skip_heading = false,
      icon = "▎",
      highlight = "RenderMarkdownIndent",
    },

    overrides = {
      buftype = {
        nofile = {
          render_modes = true,
          padding = { highlight = "NormalFloat" },
          sign = { enabled = false },
          code = { left_pad = 0, right_pad = 0 },
        },
      },
      filetype = {},
    },

    injections = {
      gitcommit = {
        enabled = true,
        query = [[
          ((message) @injection.content
              (#set! injection.combined)
              (#set! injection.include-children)
              (#set! injection.language "markdown"))
        ]],
      },
    },

    on = {
      attach = function() end,
      initial = function() end,
      render = function() end,
      clear = function() end,
    },
  },

  config = function(_, opts)
    require("render-markdown").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(event)
        vim.keymap.set("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>", {
          desc = "Toggle Markdown Render",
          buffer = event.buf,
        })
      end,
    })
  end,
}
