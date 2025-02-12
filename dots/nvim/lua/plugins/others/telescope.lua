return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Para mejor rendimiento
    { "nvim-telescope/telescope-file-browser.nvim" }, -- Navegador de archivos
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
        path_display = { "truncate" }, -- Muestra rutas truncadas
        mappings = {
          i = { -- Modo inserción
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
          n = { -- Modo normal
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown", -- Cambiar el tema (dropdown, cursor, etc.)
        },
        live_grep = {
          additional_args = function() return { "--hidden" } end, -- Buscar en archivos ocultos
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- Habilita la búsqueda difusa
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          theme = "ivy",
          hijack_netrw = true, -- Reemplaza netrw con Telescope
        },
      },
    })

    -- Carga extensiones
    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    -- Keymaps para atajos rápidos
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
    map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
    map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
    map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", opts)
  end,
}

