-- =========================
-- Configuración de Treesitter (Syntax Highlighting)
-- =========================

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    -- Core
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",

    -- Frontend / React
    "javascript",
    "jsx",
    "typescript",
    "tsx",
    "html",
    "css",
    "scss",
    "json",
    "yaml",

    -- Backend / Fullstack
    "python",
    "php",
    "go",
    "gomod",
    "gowork",
    "bash",
    "dockerfile",

    -- Utilidades
    "regex",
    "sql",
    "toml",
    "gitignore",
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    use_languagetree = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  indent = {
    enable = true,
    disable = { "yaml" }, -- YAML tiene problemas con el indent automático
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },

  autopairs = {
    enable = true,
  },
})