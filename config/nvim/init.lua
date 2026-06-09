require("config.options")
require("config.keyblinds")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.env.PATH = vim.env.PATH .. ":/usr/lib/qt6/bin"

require("lazy").setup({

  { import = "plugins.code" },
  { import = "plugins.code.lang" },
  { import = "plugins.debug" },
  { import = "plugins.editor" },
  { import = "plugins.git" },
  { import = "plugins.lsp" },
  { import = "plugins.lsp.lenguages" },
  { import = "plugins.others" },
  { import = "plugins.ui" },
})
