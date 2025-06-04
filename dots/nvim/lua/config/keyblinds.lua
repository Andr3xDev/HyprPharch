-- LEADER --
vim.g.mapleader = " "

-- General Workflow --
vim.keymap.set("n", "<leader>ch", ":Telescope command_history<CR>", { desc = "Command history", noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file (insert)", silent = true })
vim.keymap.set("n", "<C-w>", ":bd<CR>", { desc = "Close buffer", silent = true })

-- Buffers
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.keymap.set('n', '<leader>bl', ':bnext<CR>', { desc = "Next buffer", noremap = true })
vim.keymap.set('n', '<leader>bj', ':bprev<CR>', { desc = "Prev buffer", noremap = true })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "List of buffers", noremap = true, silent = true })

-- Neotree
vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree<CR>", {desc = "Flie Explorer", noremap = true })
vim.keymap.set("n", "<Leader>ee", "<Cmd>Neotree toggle<CR>", {desc = "Close Explorer", noremap = true, silent = true })

-- File Browser
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = "Find files", noremap = true, silent = true})
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "List of buffers", silent = true, noremap = true })

-- Telescope --
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true, silent = true, desc = "Browser files" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true, desc = "Ver diagnósticos LSP" })

-- LSP --
vim.keymap.set("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>", { desc = "LSP docs symbols", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fa", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- GIT --
vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>", { noremap = true, silent = true })

-- Copy to clipboard --
vim.keymap.set("v", "<C-c>", [["+y]])

-- Movement --
vim.keymap.set("n", "<leader>h", "<Cmd>wincmd h<CR>", { desc = "Move cursor to left window", noremap = true })
vim.keymap.set("n", "<leader>j", "<Cmd>wincmd j<CR>", { desc = "Move cursor to bottomw window", noremap = true })
vim.keymap.set("n", "<leader>k", "<Cmd>wincmd k<CR>", { desc = "Move cursor to top window", noremap = true })
vim.keymap.set("n", "<leader>l", "<Cmd>wincmd l<CR>", { desc = "Move cursor to right window", noremap = true })
vim.keymap.set("n", "<leader>=", "<Cmd>vertical resize +5<CR>", { desc = "Resize window +5", noremap = true })
vim.keymap.set("n", "<leader>-", "<Cmd>vertical resize -5<CR>", { desc = "Resize window -5", noremap = true })
