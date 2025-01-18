---------------------------------------------------------------------------------
-- Git indicators on the side depending on changes in the file
-- Source: https://github.com/williamboman/mason.nvim
---------------------------------------------------------------------------------

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    keys = {
        { "<Leader>e", "<Cmd>Neotree<CR>", desc = "Flie Explorer" },
        { "<Leader>b", "<Cmd>Neotree buffers<CR>", desc = "Buffer Explorer" },
        { "<Leader>gg", "<Cmd>Neotree git_status<CR>", desc = "Git Explorer" },
        { "<Leader>ee", "<Cmd>Neotree toggle<CR>", desc = "Git Explorer" },
    },
    config = function()
        require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "single",
        enable_git_status = true,
        enable_modified_markers = true,
        enable_diagnostics = false,
        sort_case_insensitive = true,
        source_selector = {
            winbar = true,
            content_layout = "center",
            sources = {
                { source = "filesystem", display_name = " 󰉓  File " },
                { source = "buffers", display_name = " ➜ Buffs " },
                { source = "git_status", display_name = "  Git " },
            },
        },
        default_component_configs = {
            indent = {
                indent_size = 2,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
            },
            modified = {
                symbol = " ",
                highlight = "NeoTreeModified",
            },
            icon = {
                folder_closed     = "",
                folder_open       = "",
                folder_empty      = "",
                folder_empty_open = "",
            },
            git_status = {
                symbols = {
                    added     = "",
                    deleted   = "",
                    modified  = "",
                    renamed   = "",
                    untracked = "",
                    ignored   = "",
                    unstaged  = "",
                    staged    = "",
                    conflict  = "",
                },
            },
        },
        window = {
            position = "left",
            width = 35,
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["<space>"] = "none",
                ["v"] = "open_vsplit",
            },
        },
        filesystem = {
            use_libuv_file_watcher = true,
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    "node_modules",
                },
                never_show = {
                    ".DS_Store",
                    "thumbs.db",
                },
            },
        },
        buffers = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = false,
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                }
            },
        },
        event_handlers = {
        {
        event = "neo_tree_window_after_open",
        handler = function(args)
            if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
            end
        end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
          vim.opt_local.signcolumn = "auto"
          end,
        },
        },
    })
    end,
}
