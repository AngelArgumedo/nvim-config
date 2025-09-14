-- =========================
-- Configuración de NvimTree (File Explorer)
-- =========================

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    relativenumber = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        picker = "default",
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
})

-- Keymaps para NvimTree
local keymap = vim.keymap.set
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
keymap("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })