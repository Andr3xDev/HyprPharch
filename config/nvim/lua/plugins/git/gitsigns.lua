---------------------------------------------------------------------------
--- git sigs to show added, changed, and removed lines
---------------------------------------------------------------------------

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]h", gs.next_hunk, { desc = "Next Hunk" })
      map("n", "[h", gs.prev_hunk, { desc = "Prev Hunk" })

      -- Actions
      map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Hunk" })
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Hunk" })
      map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame Line" })
      map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
      map("n", "<leader>gh", gs.diffthis, { desc = "Diff This" })
      map("n", "<leader>gH", function()
        gs.diffthis("~")
      end, { desc = "Diff This ~" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
    end,
  },
}
