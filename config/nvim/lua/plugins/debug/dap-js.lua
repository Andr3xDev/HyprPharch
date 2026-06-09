---------------------------------------------------------------------------
--- debugging support for JS and TS using vscode-js-debug
---------------------------------------------------------------------------

return {
  "mxsdev/nvim-dap-vscode-js",
  ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap = require("dap")
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
      adapters = { "pwa-node", "pwa-chrome" },
    })

    local js_config = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[lang] = js_config
    end
  end,
}
