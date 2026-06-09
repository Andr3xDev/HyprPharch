---------------------------------------------------------------------------
--- view git diffs in a single tabpage with support for many features
---------------------------------------------------------------------------

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
  },
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen origin/main<cr>", desc = "Diff vs main" },
    { "<leader>gdO", "<cmd>DiffviewOpen origin/master<cr>", desc = "Diff vs master" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diff Close" },
    { "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", desc = "Diff Toggle Files" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
      },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
    hooks = {
      view_opened = function()
        vim.diagnostic.enable(false)
      end,
      view_closed = function()
        vim.diagnostic.enable(true)
      end,
    },
  },
}
