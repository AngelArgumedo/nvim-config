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
        { "<leader>ac", desc = "🤖 Abrir Claude" },
        { "<leader>t1", desc = "Terminal #1" },
        { "<leader>t2", desc = "Terminal #2" },
        { "<leader>t3", desc = "Terminal #3" },
        { "<leader>t4", desc = "Terminal #4" },
        { "<leader>t5", desc = "Terminal #5" },
        { "<leader>tf", desc = "🪟 Terminal flotante" },
        { "<leader>th", desc = "📐 Terminal horizontal" },
        { "<leader>tv", desc = "📏 Terminal vertical" },
        { "<leader>tl", desc = "📋 Listar terminales" },
        { "<leader>tn", desc = "🔢 Nueva terminal" },
        { "<leader>tg", desc = "📊 Git status" },
        { "<leader>td", desc = "🚀 Dev command" },
        { "<leader>tq", desc = "❌ Cerrar todas" },
        { "]c", desc = "Next conflict/hunk" },
        { "[c", desc = "Previous conflict/hunk" },
        { "-", desc = "Abrir Oil" },
      })
    end,
  },

  -- Iconos para devicons (configuración con iconos reales de tecnologías)
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("config.devicons").setup()
    end,
  },

  -- Terminal flotante mejorado
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("config.toggleterm")
    end,
  },

  -- Notificaciones bonitas
  {
    "rcarriga/nvim-notify",
    config = function()
      require("config.notify")
    end,
  },

  -- Scroll suave
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("config.neoscroll")
    end,
  },

  -- Líneas de indentación visual
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm", ""
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)

      -- Configurar highlights
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4261" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#61AFEF" })

      -- Keymaps básicos
      vim.keymap.set("n", "<leader>ui", "<cmd>IBLToggle<cr>", { desc = "🌈 Toggle indent lines" })
      vim.keymap.set("n", "<leader>us", "<cmd>IBLToggleScope<cr>", { desc = "🎯 Toggle scope highlight" })

      -- Función para cambiar estilo de líneas
      local styles = {
        { char = "│", name = "línea continua" },
        { char = "┊", name = "línea punteada" },
        { char = "▏", name = "barra fina" },
      }
      local current_style = 1

      local function cycle_indent_style()
        current_style = current_style % #styles + 1
        local style = styles[current_style]

        require("ibl").update({
          indent = { char = style.char },
          scope = { char = style.char },
        })

        vim.notify("🎨 Estilo: " .. style.name, vim.log.levels.INFO, { title = "Indent Lines" })
      end

      vim.keymap.set("n", "<leader>uc", cycle_indent_style, { desc = "🎨 Cambiar estilo de líneas" })

      vim.notify("🌈 Indent lines configurado", vim.log.levels.INFO, {
        title = "Indent Blankline",
        timeout = 1000,
      })
    end,
  },
}