---------------------------------------------------------------------------
--- Notifications system
---------------------------------------------------------------------------

return {
  "rcarriga/nvim-notify",
  opts = {
    stages   = "slide",
    render   = "compact",
    timeout  = 3000,
    max_width = 65,
    level    = vim.log.levels.INFO,
    icons = {
      ERROR = " ",
      WARN  = " ",
      INFO  = " ",
      DEBUG = " ",
      TRACE = "✎ ",
    },
  },
}
