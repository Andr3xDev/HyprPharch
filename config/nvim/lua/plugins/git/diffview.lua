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
    {
      "<leader>gd",
      function()
        local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
        local result = handle and handle:read("*a") or ""
        if handle then
          handle:close()
        end
        local default_branch = result:match("origin/([%w%-%_%.]+)")
        if not default_branch then
          vim.notify("No se pudo detectar el branch por defecto", vim.log.levels.WARN)
          return
        end
        vim.cmd("DiffviewOpen origin/" .. default_branch)
      end,
      desc = "Diff vs default branch",
    },
    {
      "<leader>gdb",
      function()
        vim.ui.input({ prompt = "Diff vs branch: " }, function(branch)
          if branch and branch ~= "" then
            vim.cmd("DiffviewOpen " .. branch)
          end
        end)
      end,
      desc = "Diff vs branch (prompt)",
    },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diff Close" },
    { "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", desc = "Diff Toggle Files" },
    { "<leader>gM", "<cmd>DiffviewOpen<cr>", desc = "Diff / Merge conflicts" },
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
