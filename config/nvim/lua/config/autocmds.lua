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

-- When entering a buffer, check if it's an empty buffer (no name, not modified, and not a special buffer). If it is, and there are other buffers open, delete it to avoid clutter.
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  once = true,
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      -- nvim_list_bufs() ya solo devuelve listed, pero por si acaso
      if vim.api.nvim_buf_get_name(buf) == ""
        and vim.api.nvim_buf_get_option(buf, "buftype") == ""
        and vim.api.nvim_buf_get_option(buf, "buflisted")
        and not vim.api.nvim_buf_get_option(buf, "modified")
        and buf ~= vim.api.nvim_get_current_buf()
      then
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end,
})
