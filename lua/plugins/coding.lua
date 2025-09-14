-- =========================
-- Plugins para programación y desarrollo
-- =========================

return {
  -- LSP (Language Server Protocol)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "html",
          "cssls",
          "emmet_ls",
          "tailwindcss",
          "phpactor",
          "gopls",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Autocompletado
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "jcdickinson/codeium.nvim", -- Codeium source para cmp
    },
    config = function()
      require("config.cmp")
    end,
  },

  -- Snippets
  {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "flake8" },
      }

      -- Auto-lint al guardar
      local autocmd = vim.api.nvim_create_autocmd
      autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          python = { "black" },
          lua = { "stylua" },
          php = { "prettier" },
          go = { "gofmt", "goimports" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Keymap para formatear (usamos <leader>fm para evitar conflicto con find files)
      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format file" })
    end,
  },

  -- AI Autocompletado gratuito con Codeium
  {
    "Exafunction/codeium.nvim",
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat = false, -- Solo autocompletado, no chat (ya tienes Claude)
      })
    end
  },
}