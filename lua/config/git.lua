-- =========================
-- Configuración de Git (Diffview)
-- =========================

require('diffview').setup({
  diff_binaries = false,
  enhanced_diff_hl = true,
  git_cmd = { "git" },
  use_icons = true,
  watch_index = true,
  icons = {
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    default = {
      layout = "diff2_horizontal",
      winbar_info = false,
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = "diff2_horizontal",
      winbar_info = false,
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
    win_config = {
      position = "left",
      width = 35,
      win_opts = {}
    },
  },
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
    },
    win_config = {
      position = "bottom",
      height = 16,
      win_opts = {}
    },
  },
  commit_log_panel = {
    win_config = {
      win_opts = {},
    }
  },
  default_args = {
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},
  keymaps = {
    disable_defaults = false,
    view = {
      ["<tab>"]      = "select_next_entry",
      ["<s-tab>"]    = "select_prev_entry",
      ["gf"]         = "goto_file",
      ["<C-w><C-f>"] = "goto_file_split",
      ["<C-w>gf"]    = "goto_file_tab",
      ["<leader>e"]  = "focus_files",
      ["<leader>b"]  = "toggle_files",
    },
    file_panel = {
      ["j"]             = "next_entry",
      ["<down>"]        = "next_entry",
      ["k"]             = "prev_entry",
      ["<up>"]          = "prev_entry",
      ["<cr>"]          = "select_entry",
      ["o"]             = "select_entry",
      ["<2-LeftMouse>"] = "select_entry",
      ["-"]             = "toggle_stage_entry",
      ["S"]             = "stage_all",
      ["U"]             = "unstage_all",
      ["X"]             = "restore_entry",
      ["R"]             = "refresh_files",
      ["L"]             = "open_commit_log",
      ["<c-b>"]         = "scroll_view(-0.25)",
      ["<c-f>"]         = "scroll_view(0.25)",
      ["<tab>"]         = "select_next_entry",
      ["<s-tab>"]       = "select_prev_entry",
      ["gf"]            = "goto_file",
      ["<C-w><C-f>"]    = "goto_file_split",
      ["<C-w>gf"]       = "goto_file_tab",
      ["i"]             = "listing_style",
      ["f"]             = "toggle_flatten_dirs",
      ["<leader>e"]     = "focus_files",
      ["<leader>b"]     = "toggle_files",
    }
  }
})

-- Keymaps para Diffview y Git
local keymap = vim.keymap.set

keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
keymap("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
keymap("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File history" })
keymap("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })

-- Keymaps para merge conflicts
keymap("n", "<leader>gm", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", { desc = "View merge conflicts" })
keymap("n", "<leader>gM", function()
  vim.cmd("DiffviewOpen")
  vim.cmd("DiffviewToggleFiles")
end, { desc = "Resolve merge conflicts" })

-- Keymaps para navegación en conflictos
keymap("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Next conflict/hunk" })

keymap("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous conflict/hunk" })

-- Quick conflict resolution
keymap("n", "<leader>co", "<cmd>diffget //2<cr>", { desc = "Choose ours (left)" })
keymap("n", "<leader>ct", "<cmd>diffget //3<cr>", { desc = "Choose theirs (right)" })
keymap("n", "<leader>cb", "<cmd>diffget //1<cr>", { desc = "Choose base" })