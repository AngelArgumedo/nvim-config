-- =========================
-- Plugins para mejorar la experiencia de edición
-- =========================

return {
  -- Auto cerrar paréntesis, corchetes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Auto cerrar tags HTML (DESHABILITADO - causaba problemas con texto normal)
  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = "InsertEnter",
  --   config = function()
  --     require("nvim-ts-autotag").setup({
  --       opts = {
  --         enable_close = true,
  --         enable_rename = true,
  --         enable_close_on_slash = true,
  --       },
  --     })
  --   end,
  -- },

  -- Comentarios inteligentes gcc, gbc
  {
    "numToStr/Comment.nvim",
    keys = { "gcc", "gbc", "gc", "gb" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Manipular texto rodeado cs"' ds" ys
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Mejor lista de diagnósticos
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Buscador fuzzy
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim"  -- Para gestión de proyectos recientes
    },
    cmd = "Telescope",
    config = function()
      require("config.telescope")
    end,
  },

  -- Gestión de proyectos recientes (estilo VSCode)
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- Métodos de detección (archivos/carpetas que indican que es un proyecto)
        detection_methods = { "pattern", "lsp" },

        -- Patrones para detectar raíz del proyecto
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml", "go.mod", "composer.json", "requirements.txt", ".gitignore" },

        -- No cambiar automáticamente al directorio del proyecto
        silent_chdir = false,

        -- Mostrar mensajes cuando cambias de proyecto
        show_hidden = false,

        -- Scope de búsqueda
        scope_chdir = 'global',
      })

      -- Integrar con Telescope
      require('telescope').load_extension('projects')
    end,
  },

  -- Resaltado avanzado
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("config.treesitter")
    end,
  },

  -- Sesiones automáticas
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("config.persistence")
    end,
  },

  -- Navegación súper rápida
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("config.flash")
    end,
  },

  -- Find & Replace potente
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    config = function()
      require("config.spectre")
    end,
  },

  -- Testing integrado
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adaptadores para diferentes lenguajes (instalación condicional)
      { "nvim-neotest/neotest-jest", ft = { "javascript", "typescript" } },
      { "nvim-neotest/neotest-python", ft = "python" },
      { "nvim-neotest/neotest-go", ft = "go" },
      { "rouge8/neotest-rust", ft = "rust" },
    },
    config = function()
      require("config.neotest")
    end,
  },

  -- Debugging visual
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require("config.dap")
    end,
  },

  -- Generación automática de documentación
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("config.neogen")
    end,
  },

  -- Renderizado inline de Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim"
    },
    ft = { "markdown" },
  },

  -- Claude Workflows (mantener para workflows automatizados)
  -- NOTA: La integración principal de Claude está en plugins/claude-code.lua
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Cargar solo el sistema de workflows (sin terminal)
      require("config.claude-workflows").setup()
    end,
    event = "VeryLazy",
  },
}