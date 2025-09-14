-- =========================
-- Configuración de nvim-cmp (Autocompletado)
-- =========================

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'codeium' }, -- AI autocompletado con máxima prioridad
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Iconos para diferentes fuentes
      local icons = {
        codeium = "🤖",
        nvim_lsp = "🔧",
        vsnip = "✂️",
        buffer = "📝",
        path = "📁",
        cmdline = "⌘",
      }

      local source_names = {
        codeium = "[AI]",
        nvim_lsp = "[LSP]",
        vsnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        cmdline = "[CMD]",
      }

      -- Agregar icono
      vim_item.kind = (icons[entry.source.name] or "") .. " " .. vim_item.kind

      -- Agregar fuente
      vim_item.menu = source_names[entry.source.name] or "[" .. entry.source.name .. "]"

      return vim_item
    end
  },
  experimental = {
    ghost_text = true,
  },
})

-- Configuración para '/' (búsqueda)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Configuración para ':' (comandos)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})