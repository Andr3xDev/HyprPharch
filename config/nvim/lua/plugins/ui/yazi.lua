---------------------------------------------------------------------------
--- file explorer with focus on fast navigation and previewing
---------------------------------------------------------------------------

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",

  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,

  opts = {
    open_for_directories = true,
    open_multiple_tabs = false,
    change_neovim_cwd_on_close = false,

    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,

    highlight_groups = {
      hovered_buffer = nil,
      hovered_buffer_in_same_directory = nil,
    },

    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
      open_file_in_tab = false,
      open_and_pick_window = false,
    },
  },

  keys = {
    { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi" },
    { "<leader>fw", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
    { "<leader>f.", "<cmd>Yazi toggle<cr>", desc = "Yazi (resume)" },
  },
}
