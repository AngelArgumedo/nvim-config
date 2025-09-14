-- =========================
-- Configuración de Telescope (Fuzzy Finder)
-- =========================

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "truncate" },
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.npm/",
      "vendor/",
      "%.DS_Store",
      "%.pyc",
      "__pycache__/",
    },
    mappings = {
      i = {
        ["<C-n>"] = "move_selection_next",
        ["<C-p>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-c>"] = "close",
        ["<Down>"] = "move_selection_next",
        ["<Up>"] = "move_selection_previous",
        ["<CR>"] = "select_default",
        ["<C-x>"] = "select_horizontal",
        ["<C-v>"] = "select_vertical",
        ["<C-t>"] = "select_tab",
        ["<C-u>"] = "preview_scrolling_up",
        ["<C-d>"] = "preview_scrolling_down",
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = false,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
        n = {
          ["dd"] = "delete_buffer",
        }
      }
    },
    colorscheme = {
      enable_preview = true,
    },
  },
  extensions = {},
})

-- Keymaps para Telescope
local keymap = vim.keymap.set

-- Keymaps principales
keymap("n", "<leader>f", builtin.find_files, { desc = "Buscar archivos" })
keymap("n", "<leader>r", builtin.oldfiles, { desc = "Archivos recientes" })

-- Keymaps con prefijo 'f' para Find
keymap("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buscar buffers" })
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ayuda" })
keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Archivos recientes" })
keymap("n", "<leader>fc", builtin.colorscheme, { desc = "Cambiar tema" })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "Ver keymaps" })
keymap("n", "<leader>fs", builtin.grep_string, { desc = "Buscar palabra bajo cursor" })

-- Búsquedas específicas de LSP
keymap("n", "<leader>lr", builtin.lsp_references, { desc = "LSP References" })
keymap("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP Definitions" })
keymap("n", "<leader>lt", builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
keymap("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP Implementations" })

-- Git con Telescope
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })