return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-file-browser.nvim" },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                theme = "dropdown",
                prompt_prefix = " 🔍 ",
                selection_caret = " ➤ ",
                layout_strategy = "horizontal",
                layout_config = {
                    preview_width = 0.6,
                },
                mappings = {
                    i = {
                        ["<S-j>"] = actions.move_selection_next,
                        ["<S-k>"] = actions.move_selection_previous,
                        ["<S-l>"] = actions.select_default,
                        ["<S-q>"] = actions.close,
                        ["<S-d>"] = actions.delete_buffer,
                        ["<Esc>"] = actions.close,
                    },
                    n = {
                        ["q"] = actions.close,
                    },
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function() return { "--hidden" } end,
                },
                buffers = {
                    previewer = true,
                    prompt_title = "",
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                file_browser = {
                    hijack_netrw = true,
                },
            },
        })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

  end,
}
