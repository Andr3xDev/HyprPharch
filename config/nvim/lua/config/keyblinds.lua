---------------------------------------------------------------------------
-- Keybindings to each plugin or flow
---------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- save / close
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file (insert)", silent = true })
vim.keymap.set("n", "<C-q>", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- splits / windows
vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Window left", noremap = true })
vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Window down", noremap = true })
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Window up", noremap = true })
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Window right", noremap = true })
vim.keymap.set("n", "<leader>=", "<Cmd>vertical resize +5<CR>", { desc = "Resize +5", noremap = true })
vim.keymap.set("n", "<leader>-", "<Cmd>vertical resize -5<CR>", { desc = "Resize -5", noremap = true })

-- buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":bnext<CR>", { desc = "Next buffer", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bh", ":bprev<CR>", { desc = "Prev buffer", noremap = true, silent = true })

-- harpoon
vim.keymap.set("n", "<leader>aa", function()
  require("harpoon"):list():add()
end, { desc = "Add file" })
vim.keymap.set("n", "<leader>ad", function()
  require("harpoon"):list():remove()
end, { desc = "Add file" })
vim.keymap.set("n", "<leader>ah", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Toggle menu" })
vim.keymap.set("n", "<leader>a1", function()
  require("harpoon"):list():select(1)
end, { desc = "File 1" })
vim.keymap.set("n", "<leader>a2", function()
  require("harpoon"):list():select(2)
end, { desc = "File 2" })
vim.keymap.set("n", "<leader>a3", function()
  require("harpoon"):list():select(3)
end, { desc = "File 3" })
vim.keymap.set("n", "<leader>a4", function()
  require("harpoon"):list():select(4)
end, { desc = "File 4" })

-- file / find
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {
  desc = "Find files",
  noremap = true,
  silent = true,
})
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", {
  desc = "Live grep",
  noremap = true,
  silent = true,
})
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", {
  desc = "Recent files",
  noremap = true,
  silent = true,
})
vim.keymap.set("n", "<leader>fc", ":Telescope commands<CR>", {
  desc = "Commands",
  noremap = true,
  silent = true,
})
vim.keymap.set(
  "n",
  "<leader>fH",
  ":Telescope command_history<CR>",
  { desc = "Command history", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", {
  desc = "Help tags",
  noremap = true,
  silent = true,
})
vim.keymap.set("n", "<leader>fy", "<cmd>Yazi<CR>", { desc = "Yazi", noremap = true, silent = true })

-- code / LSP
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
vim.keymap.set(
  "n",
  "<leader>fd",
  "<cmd>Telescope diagnostics<CR>",
  { desc = "Diagnostics", noremap = true, silent = true }
)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })

-- git
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gt", ":Telescope git_status<CR>", { desc = "Git status", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gC", ":Telescope git_commits<CR>", { desc = "Git commits", noremap = true, silent = true })
-- trouble / diagnostics
vim.keymap.set(
  "n",
  "<leader>xx",
  "<cmd>Trouble diagnostics toggle<CR>",
  { desc = "Diagnostics", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xb",
  "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "Buffer diagnostics", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Trouble symbols toggle focus=false<CR>",
  { desc = "Symbols", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>cl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
  { desc = "LSP panel", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xL",
  "<cmd>Trouble loclist toggle<CR>",
  { desc = "Location list", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xQ",
  "<cmd>Trouble qflist toggle<CR>",
  { desc = "Quickfix list", noremap = true, silent = true }
)

-- debug
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Step out" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle UI" })
vim.keymap.set("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "REPL" })

-- search / replace
vim.keymap.set("n", "<leader>sR", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & Replace" })
vim.keymap.set("n", "<leader>sr", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & Replace (current file)" })
vim.keymap.set("v", "<leader>sr", function()
  require("grug-far").with_visual_selection()
end, { desc = "Search & Replace (visual)" })
