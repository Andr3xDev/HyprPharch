-- TODO: nfigurate this fully with all posible keybindings and groups

---------------------------------------------------------------------------
--- dynamic menu to show keybindings in a popup
---------------------------------------------------------------------------

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>a", group = "harpoon" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code/lsp" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>o", group = "octo" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>u", group = "ui" },
        { "<leader>q", group = "session" },
        { "<leader>s", group = "surround" },
      },
      -- Surround
      {
        { "ys", desc = "Add surround", mode = "n" },
        { "yss", desc = "Add surround (line)", mode = "n" },
        { "yS", desc = "Add surround (multiline)", mode = "n" },
        { "ds", desc = "Delete surround", mode = "n" },
        { "cs", desc = "Change surround", mode = "n" },
        { "cS", desc = "Change surround (line)", mode = "n" },
        { "S", desc = "Add surround", mode = "v" },
        { "gS", desc = "Add surround (indent)", mode = "v" },
      },
      -- Harpoon
      {
        { "<leader>aa", desc = "Add file", mode = "n" },
        { "<leader>al", desc = "List files", mode = "n" },
        { "<leader>1", desc = "Harpoon 1", mode = "n" },
        { "<leader>2", desc = "Harpoon 2", mode = "n" },
        { "<leader>3", desc = "Harpoon 3", mode = "n" },
        { "<leader>4", desc = "Harpoon 4", mode = "n" },
      },
      -- Diagnostics / Trouble
      {
        { "<leader>xx", desc = "Diagnostics", mode = "n" },
        { "<leader>xX", desc = "Buffer diagnostics", mode = "n" },
        { "<leader>xs", desc = "Symbols", mode = "n" },
        { "<leader>xl", desc = "LSP references", mode = "n" },
        { "<leader>xL", desc = "Location list", mode = "n" },
        { "<leader>xQ", desc = "Quickfix list", mode = "n" },
      },
      -- Debug
      {
        { "<leader>db", desc = "Toggle Breakpoint", mode = "n" },
        { "<leader>dc", desc = "Continue", mode = "n" },
        { "<leader>di", desc = "Step Into", mode = "n" },
        { "<leader>do", desc = "Step Over", mode = "n" },
        { "<leader>dO", desc = "Step Out", mode = "n" },
        { "<leader>dr", desc = "Toggle REPL", mode = "n" },
        { "<leader>dl", desc = "Run Last", mode = "n" },
        { "<leader>dt", desc = "Terminate", mode = "n" },
        { "<leader>du", desc = "Toggle DAP UI", mode = "n" },
        { "<leader>de", desc = "Eval Expression", mode = { "n", "v" } },
      },
      -- Git
      {
        { "<leader>gd", group = "diffview", mode = "n" },
        { "<leader>gdo", desc = "Diff vs main", mode = "n" },
        { "<leader>gdO", desc = "Diff vs master", mode = "n" },
        { "<leader>gdc", desc = "Diff Close", mode = "n" },
        { "<leader>gdf", desc = "Diff Toggle Files", mode = "n" },
        { "<leader>gs", desc = "Stage Hunk", mode = { "n", "v" } },
        { "<leader>gr", desc = "Reset Hunk", mode = { "n", "v" } },
        { "<leader>gS", desc = "Stage Buffer", mode = "n" },
        { "<leader>gR", desc = "Reset Buffer", mode = "n" },
        { "<leader>gp", desc = "Preview Hunk", mode = "n" },
        { "<leader>gb", desc = "Blame Line", mode = "n" },
        { "<leader>gh", desc = "Diff This", mode = "n" },
        { "<leader>gH", desc = "Diff This ~", mode = "n" },
        { "<leader>gB", desc = "Toggle Line Blame", mode = "n" },
        { "<leader>gg", desc = "LazyGit", mode = "n" },
      },
      -- Octo
      {
        { "<leader>op", group = "pull requests", mode = "n" },
        { "<leader>oi", group = "issues", mode = "n" },
        { "<leader>oc", group = "comments", mode = "n" },
        { "<leader>or", group = "reactions", mode = "n" },
        { "<leader>ol", group = "labels", mode = "n" },
        { "<leader>oa", group = "assignees", mode = "n" },
      },
      -- Telescope / file
      {
        { "<leader>ff", desc = "Find Files", mode = "n" },
        { "<leader>fg", desc = "Live Grep", mode = "n" },
        { "<leader>fb", desc = "Buffers", mode = "n" },
        { "<leader>fh", desc = "Help Tags", mode = "n" },
        { "<leader>fr", desc = "Recent Files", mode = "n" },
        { "<leader>fc", desc = "Commands", mode = "n" },
        { "<leader>fd", desc = "Diagnostics", mode = "n" },
        { "<leader>fs", desc = "Document Symbols", mode = "n" },
      },
      -- Code / LSP
      {
        { "<leader>cf", desc = "Format Buffer", mode = { "n", "v" } },
      },
    },
  },
  keys = {
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
}
