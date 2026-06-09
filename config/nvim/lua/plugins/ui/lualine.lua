---------------------------------------------------------------------------
--- Botton bar config show everytime
---------------------------------------------------------------------------

local abyssal = require("palettes.abysal")

-- definition of palette for lualine, using the abyssal theme
local function get_abyssal_theme()
  local p = abyssal.get_palette()

  return {
    normal = {
      a = { bg = p.color1, fg = p.base, gui = "bold" },
      b = { bg = p.surface, fg = p.text },
      c = { bg = p.base, fg = p.text },
      x = { bg = p.base, fg = p.text },
      y = { bg = p.surface, fg = p.text },
      z = { bg = p.color1, fg = p.base, gui = "bold" },
    },
    insert = {
      a = { bg = p.color2, fg = p.base, gui = "bold" },
    },
    visual = {
      a = { bg = p.color4, fg = p.base, gui = "bold" },
    },
    command = {
      a = { bg = p.color3, fg = p.base, gui = "bold" },
    },
    inactive = {
      a = { bg = p.surface, fg = p.base, gui = "bold" },
    },
  }
end

-- helper function to create a separator component for lualine
local function separator(icon, color_fg)
  return {
    function()
      return icon
    end,
    color = { fg = color_fg },
    padding = { left = 0, right = 0 },
  }
end

-- helper function to determine the appropriate icon for the git branch component
local function resolve_branch_icon()
  local result = vim.fn.systemlist("git rev-parse --abbrev-ref @{upstream} 2>/dev/null")[1]
  return (result and result ~= " ") and " " or "󱓊 "
end

-- function to get the git diff information for the current buffer, showing the number of commits ahead and behind the upstream branch
local git_diff_cache = ""

local function update_git_diff_cache()
  local cwd = vim.fn.getcwd()
  local ahead = tonumber(vim.fn.systemlist("git -C " .. cwd .. " rev-list --count @{upstream}..HEAD 2>/dev/null")[1])
    or 0
  local behind = tonumber(vim.fn.systemlist("git -C " .. cwd .. " rev-list --count HEAD..@{upstream} 2>/dev/null")[1])
    or 0
  local parts = {}
  if ahead > 0 then
    table.insert(parts, "󱖗 " .. ahead)
  end
  if behind > 0 then
    table.insert(parts, "󱖙 " .. behind)
  end
  git_diff_cache = table.concat(parts, " ")
end

local function get_git_diff()
  return git_diff_cache
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  callback = update_git_diff_cache,
})

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local p = abyssal.get_palette()

      return {
        options = {
          icons_enabled = true,
          theme = get_abyssal_theme(),
          component_separators = "",
          section_separators = "",
          disabled_filetypes = {
            statusline = { "alpha" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = {
            "mode",
            separator("", p.surface),
          },
          lualine_b = {
            {
              "filename",
              symbols = {
                modified = "󰣕 ",
                readonly = "󰮕 ",
                unnamed = "󰐙 ",
                newfile = "󰐙 ",
              },
            },
            separator("", p.base),
          },
          lualine_c = {
            {
              "branch",
              icon = resolve_branch_icon(),
            },
            {
              get_git_diff,
              color = { fg = p.color2 },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = "󰅚 ", warn = "󱡞 ", info = "󰗖 " },
              diagnostics_color = {
                error = { fg = p.color4 },
                warn = { fg = p.color3 },
                info = { fg = p.color1 },
              },
            },
          },
          lualine_y = {
            separator("", p.base),
            "filetype",
          },
          lualine_z = {
            separator("", p.surface),
            "location",
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "fileformat" },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
}
