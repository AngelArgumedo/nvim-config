-- =========================
-- Configuración de Flash (Navegación súper rápida)
-- Salta a cualquier lugar en pantalla al instante
-- =========================

local flash = require("flash")

flash.setup({
  -- Configuración principal
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    -- Búsqueda multi-ventana
    multi_window = true,
    -- Mostrar resultados mientras escribes
    forward = true,
    wrap = true,
    -- Modo de búsqueda
    mode = "exact", -- exact/search/fuzzy
    -- Búsqueda incremental
    incremental = false,
  },
  jump = {
    -- Saltar automáticamente cuando solo hay una opción
    jumplist = true,
    pos = "start", -- start/end/range
    -- Limpiar resaltado después de saltar
    autojump = false,
    inclusive = nil,
    offset = nil,
  },
  label = {
    -- Mostrar labels antes del match
    before = true,
    after = true,
    -- Estilo de labels
    style = "overlay", -- overlay/inline/eol
    -- Usar mayúsculas
    uppercase = true,
    -- Distancia mínima entre labels
    distance = true,
    min_pattern_length = 0,
    -- Rainbow mode
    rainbow = {
      enabled = false,
      shade = 5,
    },
    -- Formato de labels
    format = function(opts)
      return { { opts.match.label, opts.hl_group } }
    end,
  },
  highlight = {
    -- Duración del resaltado
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  -- Acciones personalizadas
  action = nil,
  pattern = "",
  -- Continuar después de la primera selección
  continue = false,
  -- Configuración de modos específicos
  modes = {
    -- Modo de carácter único
    char = {
      enabled = true,
      config = function(opts)
        -- Saltar automáticamente después de primera entrada
        opts.autohide = true
        opts.jump_labels = true
        opts.multi_line = true
        return opts
      end,
      -- Teclas de salto rápido
      keys = { "f", "F", "t", "T", ";", "," },
      -- Carácter especial para labels
      char_actions = function(motion)
        return {
          [";"] = "next", -- repetir hacia adelante
          [","] = "prev", -- repetir hacia atrás
          -- Integración con nvim-surround
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
        }
      end,
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    -- Modo de línea
    line = {
      enabled = true,
      any_line = true,
      search = { mode = "search", max_length = 0 },
      highlight = { backdrop = false, matches = false },
      jump = { pos = "start", inclusive = false },
    },
    -- Modo de búsqueda
    search = {
      enabled = true,
      highlight = { backdrop = false },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        forward = true,
        multi_window = true,
        wrap = true,
        incremental = false,
      },
    },
    -- Modo de treesitter
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "start" },
      search = { incremental = false },
      label = { before = true, after = true, style = "inline" },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    -- Modo de diagnostico
    treesitter_search = {
      jump = { pos = "start" },
      search = { multi_window = true, wrap = true, incremental = false },
      remote_op = { restore = true },
      label = { before = false, after = true, style = "inline" },
    },
    -- Modo remoto
    remote = {
      remote_op = { restore = true, motion = true },
    },
  },
  -- Prompt para búsquedas
  prompt = {
    enabled = true,
    prefix = { { "⚡", "FlashPromptIcon" } },
    win_config = {
      relative = "editor",
      width = 1, -- auto tamaño
      height = 1,
      row = -1, -- bottom
      col = 0,
      zindex = 1000,
    },
  },
})

-- Keymaps para Flash
local keymap = vim.keymap.set

-- Salto básico (reemplaza hop/lightspeed)
keymap({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "⚡ Flash jump" })

-- Salto a líneas
keymap({ "n", "x", "o" }, "S", function()
  flash.jump({ search = { mode = "search", max_length = 0 } })
end, { desc = "⚡ Flash líneas" })

-- Treesitter flash (saltar por nodos de sintaxis)
keymap({ "n", "x", "o" }, "r", function()
  flash.treesitter()
end, { desc = "⚡ Flash Treesitter" })

-- Búsqueda remota con operadores
keymap("o", "R", function()
  flash.treesitter_search()
end, { desc = "⚡ Flash Treesitter Search" })

-- Toggle de Flash en búsqueda
keymap({ "c" }, "<c-s>", function()
  flash.toggle()
end, { desc = "⚡ Toggle Flash Search" })

-- Integración con Telescope
keymap("n", "<leader>fs", function()
  require("flash").jump({
    pattern = vim.fn.expand("<cword>"),
  })
end, { desc = "⚡ Flash palabra actual" })

-- Salto en ventana actual únicamente
keymap({ "n", "x", "o" }, "<leader>sw", function()
  flash.jump({
    search = { multi_window = false }
  })
end, { desc = "⚡ Flash ventana actual" })

-- Configurar colores personalizados
vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff966c", fg = "#1b1d2b", bold = true })
vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = "#ff007c" })

vim.notify("⚡ Flash configurado - Navegación súper rápida activada", vim.log.levels.INFO, {
  title = "Flash",
  timeout = 2000,
})