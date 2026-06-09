---------------------------------------------------------------------------
--- Session management, allowing save and restore sessions
---------------------------------------------------------------------------

return {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },

keys = {
    {
      "<leader>qs",
      function()
        local name = vim.fn.input("Session name: ")
        if name ~= "" then
        vim.cmd("AutoSession save " .. name)
        end
      end,
      desc = "Save Session",
    },
    { "<leader>qr", "<cmd>AutoSession toggle<cr>", desc = "Restore Session" },
    { "<leader>qd", "<cmd>AutoSession delete<cr>", desc = "Delete Session" },
    { "<leader>qf", "<cmd>AutoSession search<cr>", desc = "Search Sessions" },
    { "<leader>qr", "<cmd>AutoSession restore<cr>", desc = "Restore Session" },
    { "<leader>qd", "<cmd>AutoSession delete<cr>", desc = "Delete Session" },
    { "<leader>qf", "<cmd>AutoSession search<cr>", desc = "Search Sessions" },
    { "<leader>qa", "<cmd>AutoSession toggle<cr>", desc = "Toggle Autosave" },
    { "<leader>qp", "<cmd>AutoSession purgeOrphaned<cr>", desc = "Purge Orphaned Sessions" },
  },
  lazy = false,
  opts = {
    auto_save = true,
    auto_restore = false,
    auto_create = false,
    continue_restore_on_error = true,
    lazy_support = true,
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    session_lens = {
      picker = "telescope",
      load_on_setup = true,
      previewer = false,
      mappings = {
        delete_session = { "i", "<C-D>" },
        alternate_session = { "i", "<C-S>" },
        copy_session = { "i", "<C-Y>" },
      },
    },
  },
}
