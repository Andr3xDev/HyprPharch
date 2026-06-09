---------------------------------------------------------------------------
--- text on the debug session
---------------------------------------------------------------------------

return {
  "theHamsta/nvim-dap-virtual-text",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  opts = {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    display_callback = function(variable, options)
      if options.virt_text_pos == "inline" then
        return " = " .. variable.value
      else
        return variable.name .. " = " .. variable.value
      end
    end,
    virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
  },
}
