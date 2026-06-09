-- TODO: fully configure the colorscheme, and add a light/dark toggle

---------------------------------------------------------------------------
--- My own theme with a light and dark variant
---------------------------------------------------------------------------

return {
  "Andr3xDev/abysal.nvim",
  priority = 1000,
  lazy = false,
  cache = false,
  config = function()
    local function get_system_style()
      local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result:find("light") then
          return "marble"
        end
      end
      return "obsidian"
    end
    require("abysal").setup({
      style = get_system_style(),
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = {},
      },
    })
    vim.cmd.colorscheme("abysal")
  end,
}
