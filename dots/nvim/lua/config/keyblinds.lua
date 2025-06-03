
-- LEADER --
vim.g.mapleader = " "


-- General Workflow --
vim.keymap.set("n", "<leader>ch", ":Telescope command_history<CR>", { desc = "Command history", noremap = true, silent = true })

-- Buffers
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = "Next buffer", noremap = true })
vim.keymap.set('n', '<leader>bp', ':bprev<CR>', { desc = "Prev buffer", noremap = true })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "List of buffers", noremap = true, silent = true })

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
--
vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>", { noremap = true, silent = true })
