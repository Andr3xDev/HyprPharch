return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                rust = { "rustfmt" },
                java = { "google-java-format" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                dockerfile = { "dockerfile_fmt" },
                toml = { "taplo" },
                ["*"] = { "trim_whitespace" },
            },
        })
    end,
}
