---------------------------------------------------------------------------
--- debug adapter protocol configuration
---------------------------------------------------------------------------

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
    { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
    { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
    { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
    { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
    { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
    { "<leader>dl", "<cmd>DapRunLast<cr>", desc = "Run Last" },
    { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
  },
  config = function()
    local dap = require("dap")

    -- Rust / C / C++ via codelldb
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }
    dap.configurations.rust = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        showDisassembly = "never",
      },
    }
  end,
}
