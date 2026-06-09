---------------------------------------------------------------------------
--- Shows a color preview for hex and rgb color codes in the buffer
---------------------------------------------------------------------------

return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = false,
      RRGGBBAA = false,
      AARRGGBB = false,
      rgb_fn = false,
      hsl_fn = false,
      css = false,
      css_fn = false,
      mode = "background",
      tailwind = false,
      sass = { enable = false },
      virtualtext = "■",
      always_update = false,
    },
    buftypes = {},
  },
}
