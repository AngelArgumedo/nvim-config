-- =========================
-- Configuración de LSP (Language Server Protocol)
-- =========================

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configuración de servidores LSP
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT"
        },
        diagnostics = {
          globals = {"vim"},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  pyright = {},
  ts_ls = {},
  html = {},
  cssls = {},
  emmet_ls = {
    filetypes = { "html", "css", "scss", "javascript", "typescript", "jsx", "tsx" },
  },
  tailwindcss = {},
  -- PHP Language Server
  phpactor = {
    filetypes = { "php" },
    root_dir = function(pattern)
      return require('lspconfig.util').root_pattern('composer.json', '.git')(pattern)
    end,
  },
  -- Go Language Server
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
}

-- Función que se ejecuta cuando se adjunta un LSP
local on_attach = function(client, bufnr)
  -- Keymaps específicos de LSP
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)

  -- Formatear con LSP si está disponible
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end

  -- Resaltado de referencias automático
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Configurar cada servidor
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
  }, config))
end

-- Configuración de diagnósticos
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Cambiar iconos de diagnósticos
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end