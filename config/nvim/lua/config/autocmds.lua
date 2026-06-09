---------------------------------------------------------------------------
-- Autocommands to control the behavior of the system with events
---------------------------------------------------------------------------

-- When closing a buffer, check if there are any other buffers open. If not, open the alpha dashboard
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      local bufs = vim.tbl_filter(function(b)
        return vim.bo[b].buflisted and vim.fn.bufname(b) ~= ""
      end, vim.api.nvim_list_bufs())

      if #bufs == 0 and vim.fn.exists(":Alpha") == 2 then
        vim.cmd("Alpha")
      end
    end)
  end,
})
