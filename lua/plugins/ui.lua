-- =========================
-- Plugins de UI y apariencia
-- =========================

return {
  -- Tema principal
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in four styles: storm, night, day, moon
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true, bold = true },
          functions = { bold = true },
          variables = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "vista_kind", "terminal", "packer" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = true,
        -- Custom colors and highlights
        on_colors = function(colors)
          colors.hint = colors.orange
          colors.error = "#ff7a93"
          colors.warning = "#ffb86c"
          colors.info = "#7aa2f7"
        end,
        on_highlights = function(highlights, colors)
          highlights.Keyword = {
            fg = colors.magenta,
            italic = true,
            bold = true
          }
          highlights.Function = {
            fg = colors.blue,
            bold = true
          }
          highlights.String = {
            fg = colors.green,
          }
          highlights.Number = {
            fg = colors.orange,
          }
          highlights.Constant = {
            fg = colors.purple,
          }
          highlights.Type = {
            fg = colors.cyan,
            bold = true
          }
          highlights.Statement = {
            fg = colors.magenta,
            bold = true
          }
          highlights.Special = {
            fg = colors.yellow,
          }
          highlights.Identifier = {
            fg = colors.fg,
          }
          highlights.Comment = {
            fg = colors.comment,
            italic = true
          }
          -- LSP semantic highlights
          highlights["@keyword"] = { fg = colors.purple, italic = true, bold = true }
          highlights["@function"] = { fg = colors.blue, bold = true }
          highlights["@variable"] = { fg = colors.fg }
          highlights["@parameter"] = { fg = colors.orange }
          highlights["@property"] = { fg = colors.green1 }
          highlights["@type"] = { fg = colors.cyan, bold = true }
        end,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Dashboard con waifu
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.alpha")
    end,
  },

  -- Barra de estado
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine")
    end,
  },

  -- Explorador de archivos
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  -- Explorador de archivos alternativo: oil.nvim
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.oil")
    end,
  },

  -- Atajos interactivos
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "helix",
        delay = 300,
        plugins = {
          marks = false,
          registers = false,
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        win = {
          border = "rounded",
        },
      })

      -- Registrar grupos de atajos
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Split" },
        { "<leader>t", group = "Terminal" },
        { "<leader>c", group = "Conflict Resolution" },
        { "<leader>l", group = "LSP" },
        { "<leader>h", group = "Git Hunks" },
        { "<leader>w", desc = "Save file" },
        { "<leader>W", desc = "Save all files" },
        { "<leader>q", desc = "Quit" },
        { "<leader>h", desc = "No highlight" },
        { "<leader>r", desc = "Recent files" },
        { "<leader>m", desc = "Show unsaved files" },
        { "<leader>fm", desc = "Format file" },
        { "<leader>ac", desc = "Abrir Claude flotante" },
        { "]c", desc = "Next conflict/hunk" },
        { "[c", desc = "Previous conflict/hunk" },
        { "-", desc = "Abrir Oil" },
      })
    end,
  },

  -- Iconos para devicons
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
      },
      color_icons = true,
      default = true,
      strict = true,
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = "#f1502f",
          name = "Gitignore"
        }
      },
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#81e043",
          name = "Log"
        }
      },
    }
  },

  -- Terminal flotante
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
        },
        open_mapping = [[<C-\>]],
      })

      -- Terminal dedicado para Claude (singleton)
      local claude_terminal = require("toggleterm.terminal").Terminal:new({
        cmd = "claude",
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- Keymap personalizado para Claude - reutiliza la misma terminal
      vim.keymap.set("n", "<leader>ac", function()
        claude_terminal:toggle()
      end, { desc = "Abrir Claude en flotante" })

      -- Keymaps adicionales para terminal
      local keymap = vim.keymap.set
      keymap("n", "<leader>tt", ":split | terminal<CR>i", { desc = "Terminal abajo" })
      keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal flotante" })
      keymap("n", "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", { desc = "Terminal horizontal" })
      keymap("n", "<leader>tv", "<cmd>ToggleTerm size=50 direction=vertical<cr>", { desc = "Terminal vertical" })
    end,
  },
}