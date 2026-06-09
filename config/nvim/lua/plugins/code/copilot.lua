---------------------------------------------------------------------------
--- ai to automate code generation and suggestions
---------------------------------------------------------------------------

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      -- TODO validate these keymaps
      keymap = {
        accept = "<M-l>",
        accept_word = "<M-w>",
        accept_line = "<M-e>",
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<M-c>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      help = false,
      gitrebase = false,
    },
  },
}
