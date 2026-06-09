---------------------------------------------------------------------------
-- Abyssal Color Palette — Light & Dark themes
---------------------------------------------------------------------------

local M = {}

--- Detect current background (dark/light)
---@return string "dark" | "light"
function M.get_background()
  return vim.o.background == "dark" and "dark" or "light"
end

--- Get the active palette based on current background
---@return table
function M.get_palette()
  return M.get_background() == "dark" and M.dark or M.light
end

---------------------------------------------------------------------------
-- DARK THEME: abysal-obsidian
---------------------------------------------------------------------------
M.dark = {
  base = "#1c1c1c", -- main_background
  surface = "#262626", -- secondary_background
  text = "#d4d4d4", -- main_text
  color1 = "#52c9b0", -- turquoise
  color2 = "#e28e5a", -- orange
  color3 = "#d1b171", -- sand
  color4 = "#d47779", -- soft_red
  color5 = "#6b92e3", -- steel_blue
  color6 = "#b87bce", -- lavender_purple
  color7 = "#8c8c8c", -- light_gray_secondary
  color8 = "#737373", -- medium_gray_comments
  color9 = "#2e2e2e", -- dark_gray_borders
  highlight1 = "#2a2a2a", -- faint_selection
  highlight2 = "#333333", -- medium_selection
  highlight3 = "#454545", -- strong_selection

  grad0 = "#52c9b0",
  grad1 = "#76ba9a",
  grad2 = "#9aab85",
  grad3 = "#be9c6f",
  grad4 = "#d1b171",
}

---------------------------------------------------------------------------
-- LIGHT THEME: abysal-marble
---------------------------------------------------------------------------
M.light = {
  base = "#dcdcdc", -- main_background
  surface = "#cfcfcf", -- secondary_background
  text = "#2f2f2f", -- main_text
  color1 = "#2c9279", -- turquoise
  color2 = "#b55b25", -- orange
  color3 = "#947635", -- sand
  color4 = "#a8474a", -- soft_red
  color5 = "#365ca8", -- steel_blue
  color6 = "#824699", -- lavender_purple
  color7 = "#555555", -- dark_gray_secondary
  color8 = "#737373", -- medium_gray_comments
  color9 = "#bcbcbc", -- light_gray_borders
  highlight1 = "#d4d4d4", -- faint_selection
  highlight2 = "#c4c4c4", -- medium_selection
  highlight3 = "#b8b8b8", -- strong_selection

  grad0 = "#2c9279",
  grad1 = "#4a9880",
  grad2 = "#7a9878",
  grad3 = "#9a9470",
  grad4 = "#9e8a6a",
}

return M
