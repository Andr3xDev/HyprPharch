---------------------------------------------------------------------------
--- Markdown Preview with the browser
---------------------------------------------------------------------------

return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = "cd app && npm install",

  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<cr>",
      ft = "markdown",
      desc = "Markdown Preview Toggle",
    },
  },

  init = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_combine_preview = 0
    vim.g.mkdp_combine_preview_auto_refresh = 1
    vim.g.mkdp_browser = ""
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_open_ip = ""
    vim.g.mkdp_port = ""
    vim.g.mkdp_theme = "dark"
    vim.g.mkdp_page_title = "${name}"
    vim.g.mkdp_highlight_css = ""
    vim.g.mkdp_preview_options = {
      sync_scroll_type = "middle",
      hide_yaml_meta = 1,
      disable_sync_scroll = 0,
      disable_filename = 0,
      content_editable = false,
      sequence_diagrams = {},
      flowchart_diagrams = {},
    }
    vim.g.mkdp_filetypes = { "markdown" }
  end,

  config = function()
    vim.cmd([[do FileType]])
  end,
}
