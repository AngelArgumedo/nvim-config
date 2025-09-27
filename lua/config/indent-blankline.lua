-- =========================
-- Configuración de Indent Blankline (Líneas de indentación)
-- Líneas visuales para mejor lectura de código indentado
-- =========================

local ibl = require("ibl")

-- Configuración simple y estable
ibl.setup({
  -- Configuración de indentación
  indent = {
    char = "│",
    tab_char = "│",
    highlight = "IblIndent",
    smart_indent_cap = true,
    priority = 1,
  },

  -- Configuración de scope simplificada
  scope = {
    enabled = true,
    char = "│",
    show_start = true,
    show_end = false, -- Reducir complejidad
    show_exact_scope = true,
    injected_languages = false, -- Deshabilitar para evitar errores
    highlight = "IblScope",
    priority = 1024,
  },

  -- Configuración de whitespace
  whitespace = {
    highlight = "IblIndent",
    remove_blankline_trail = true,
  },

  -- Excluir tipos de archivo
  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
      "neotest-output",
      "neotest-summary",
      "neotest-output-panel",
      "",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
})

-- Configurar highlights después del setup
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4261" })
vim.api.nvim_set_hl(0, "IblScope", { fg = "#61AFEF" })

-- Keymaps para controlar indent lines
local keymap = vim.keymap.set

-- Toggle indent lines
keymap("n", "<leader>ui", function()
  vim.cmd("IBLToggle")
end, { desc = "🌈 Toggle indent lines" })

-- Toggle scope highlight
keymap("n", "<leader>us", function()
  vim.cmd("IBLToggleScope")
end, { desc = "🎯 Toggle scope highlight" })

-- Función para cambiar el estilo de líneas
local current_style = 1
local styles = {
  { char = "│", name = "línea continua" },
  { char = "┊", name = "línea punteada" },
  { char = "┆", name = "línea fina" },
  { char = "▏", name = "barra fina" },
  { char = "▎", name = "barra gruesa" },
}

local function cycle_indent_style()
  current_style = current_style % #styles + 1
  local style = styles[current_style]

  ibl.update({
    indent = { char = style.char },
    scope = { char = style.char },
  })

  vim.notify("🎨 Estilo de indentación: " .. style.name, vim.log.levels.INFO, {
    title = "Indent Lines"
  })
end

keymap("n", "<leader>uc", cycle_indent_style, { desc = "🎨 Cambiar estilo de líneas" })

-- Auto-comandos para mejor experiencia
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("indent_blankline_config", { clear = true }),
  callback = function()
    local filetype = vim.bo.filetype

    -- Configuraciones específicas por tipo de archivo
    if filetype == "python" then
      -- En Python, mostrar más claramente los niveles de indentación
      ibl.update({
        scope = {
          show_start = true,
          show_end = true,
        }
      })
    elseif filetype == "yaml" or filetype == "yml" then
      -- En YAML, las líneas de indentación son críticas
      ibl.update({
        indent = { char = "┊" },
        scope = { char = "│" },
      })
    end
  end,
})

-- Comando para configurar colores personalizados
vim.api.nvim_create_user_command("IndentColors", function(opts)
  local theme = opts.args or "default"

  if theme == "pastel" then
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#444B6A" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#BB9AF7" })
  elseif theme == "bright" then
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#565F89" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#7AA2F7" })
  elseif theme == "minimal" then
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2D3149" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#7C3AED" })
  else
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4261" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#61AFEF" })
  end

  vim.notify("🎨 Tema de colores: " .. theme, vim.log.levels.INFO, {
    title = "Indent Lines"
  })
end, {
  nargs = "?",
  complete = function()
    return { "default", "pastel", "bright", "minimal" }
  end,
  desc = "Cambiar tema de colores de indent lines"
})

-- Configuración simplificada sin hooks complejos para evitar errores

vim.notify("🌈 Indent lines configurado - Líneas de indentación activadas", vim.log.levels.INFO, {
  title = "Indent Blankline",
  timeout = 2000,
})