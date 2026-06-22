---------------------------------------------------------------------------
--- management of GitHub issues and PRs
---------------------------------------------------------------------------

return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Octo",
  keys = {
    -- PRs: open
    { "<leader>opl", "<cmd>Octo pr list<cr>", desc = "PR List" },
    { "<leader>opv", "<cmd>Octo pr browser<cr>", desc = "PR Open in Browser" },

    -- PRs: inspect
    { "<leader>opd", "<cmd>Octo pr diff<cr>", desc = "PR Show Diff" },
    { "<leader>opf", "<cmd>Octo pr changes<cr>", desc = "PR Changed Files" },
    { "<leader>opC", "<cmd>Octo pr commits<cr>", desc = "PR List Commits" },
    { "<leader>opo", "<cmd>Octo pr checkout<cr>", desc = "PR Checkout" },

    -- review: start, submit, approve, request changes
    { "<leader>opr", "<cmd>Octo review start<cr>", desc = "PR Review Start" },
    { "<leader>opR", "<cmd>Octo review resume<cr>", desc = "PR Review Resume (pending)" },
    { "<leader>opX", "<cmd>Octo review discard<cr>", desc = "PR Review Discard (pending)" },
    { "<leader>ops", "<cmd>Octo review submit<cr>", desc = "PR Review Submit" },
    { "<leader>opa", "<cmd>Octo review approve<cr>", desc = "PR Approve" },
    { "<leader>opx", "<cmd>Octo review request_changes<cr>", desc = "PR Request Changes" },

    -- comments
    { "<leader>ocr", "<cmd>Octo comment add<cr>", desc = "Comment Add", mode = { "n", "v" } },
    { "<leader>oce", "<cmd>Octo comment delete<cr>", desc = "Comment Delete" },
  },
  opts = {
    use_local_fs = false,
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    picker = "telescope",
    picker_config = {
      use_emojis = true,
    },
    comment_icon = "▎",
    outdated_icon = "󰅒 ",
    resolved_icon = " ",
    reaction_viewer_hint_icon = " ",
    user_icon = " ",
    timeline_marker = " ",
    timeline_indent = 2,
    right_bubble_delimiter = "",
    left_bubble_delimiter = "",
    snippet_context_lines = 4,
    timeout = 5000,
    ui = {
      use_signcolumn = true,
    },
    pull_requests = {
      order_by = { field = "CREATED_AT", direction = "DESC" },
      always_select_remote_on_delete = false,
    },
    file_panel = {
      size = 10,
      use_icons = true,
    },
    mappings = {
      review_thread = {
        goto_issue = { lhs = "<leader>ogi", desc = "Go to issue" },
        add_comment = { lhs = "<leader>ocr", desc = "Add comment" },
        delete_comment = { lhs = "<leader>oce", desc = "Delete comment" },
        next_comment = { lhs = "]c", desc = "Next comment" },
        prev_comment = { lhs = "[c", desc = "Prev comment" },
        select_next_entry = { lhs = "]q", desc = "Next changed file" },
        select_prev_entry = { lhs = "[q", desc = "Prev changed file" },
        select_first_entry = { lhs = "[Q", desc = "First changed file" },
        select_last_entry = { lhs = "]Q", desc = "Last changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
      },
      submit_win = {
        approve_review = { lhs = "<C-a>", desc = "Approve" },
        comment_review = { lhs = "<C-c>", desc = "Comment" },
        request_changes = { lhs = "<C-x>", desc = "Request changes" },
        close_review_tab = { lhs = "<C-q>", desc = "Close" },
      },
      file_panel = {
        next_entry = { lhs = "j", desc = "Next file" },
        prev_entry = { lhs = "k", desc = "Prev file" },
        select_entry = { lhs = "<cr>", desc = "Open file" },
        refresh_files = { lhs = "R", desc = "Refresh" },
        select_next_entry = { lhs = "]q", desc = "Next changed file" },
        select_prev_entry = { lhs = "[q", desc = "Prev changed file" },
        select_first_entry = { lhs = "[Q", desc = "First changed file" },
        select_last_entry = { lhs = "]Q", desc = "Last changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
        toggle_viewed = { lhs = "<leader>tv", desc = "Toggle viewed" },
        goto_file = { lhs = "gf", desc = "Go to file" },
      },
    },
  },
}
