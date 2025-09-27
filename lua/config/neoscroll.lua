-- =========================
-- Configuración de Neoscroll (Scroll suave)
-- Scroll animado y suave para mejor experiencia visual
-- =========================

local neoscroll = require("neoscroll")

neoscroll.setup({
  -- Configuración de scroll
  mappings = {
    "<C-u>", "<C-d>",
    "<C-b>", "<C-f>",
    "<C-y>", "<C-e>",
    "zt", "zz", "zb",
  },
  hide_cursor = true,          -- Ocultar cursor durante scroll
  stop_eof = true,             -- Parar al final del archivo
  respect_scrolloff = false,   -- Parar scroll en scrolloff
  cursor_scrolls_alone = true, -- Cursor se mueve independientemente
  easing_function = nil,       -- Función de suavizado (nil = linear)
  pre_hook = nil,              -- Función antes de scroll
  post_hook = nil,             -- Función después de scroll
  performance_mode = false,    -- Deshabilitar en archivos grandes
})

-- Configuración de keymaps personalizados con duración específica
local keymap_opts = { silent = true }

-- Mapeos de scroll con tiempo personalizado
local keymaps = {
  -- Scroll básico
  ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
  ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } },

  -- Scroll de página
  ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } },
  ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } },

  -- Scroll línea por línea
  ["<C-y>"] = { "scroll", { "-0.10", "false", "100" } },
  ["<C-e>"] = { "scroll", { "0.10", "false", "100" } },

  -- Posicionamiento
  ["zt"] = { "zt", { "250" } },
  ["zz"] = { "zz", { "250" } },
  ["zb"] = { "zb", { "250" } },
}

-- Aplicar los keymaps
for key, func in pairs(keymaps) do
  vim.keymap.set("n", key, function()
    neoscroll[func[1]](func[2])
  end, keymap_opts)
end

-- Configuración adicional para mouse scroll
if vim.fn.has("mouse") == 1 then
  vim.keymap.set({"n", "v", "x"}, "<ScrollWheelUp>", function()
    neoscroll.scroll(-3, true, 100)
  end, keymap_opts)

  vim.keymap.set({"n", "v", "x"}, "<ScrollWheelDown>", function()
    neoscroll.scroll(3, true, 100)
  end, keymap_opts)
end

-- Función para alternar scroll suave
local smooth_scroll_enabled = true

local function toggle_smooth_scroll()
  if smooth_scroll_enabled then
    -- Deshabilitar scroll suave
    for key in pairs(keymaps) do
      vim.keymap.del("n", key)
    end

    -- Restaurar comportamiento normal
    vim.keymap.set("n", "<C-u>", "<C-u>", keymap_opts)
    vim.keymap.set("n", "<C-d>", "<C-d>", keymap_opts)
    vim.keymap.set("n", "<C-b>", "<C-b>", keymap_opts)
    vim.keymap.set("n", "<C-f>", "<C-f>", keymap_opts)
    vim.keymap.set("n", "<C-y>", "<C-y>", keymap_opts)
    vim.keymap.set("n", "<C-e>", "<C-e>", keymap_opts)
    vim.keymap.set("n", "zt", "zt", keymap_opts)
    vim.keymap.set("n", "zz", "zz", keymap_opts)
    vim.keymap.set("n", "zb", "zb", keymap_opts)

    smooth_scroll_enabled = false
    vim.notify("🐌 Scroll suave deshabilitado", vim.log.levels.INFO, { title = "Neoscroll" })
  else
    -- Re-habilitar scroll suave
    for key, func in pairs(keymaps) do
      vim.keymap.set("n", key, function()
        neoscroll[func[1]](func[2])
      end, keymap_opts)
    end

    smooth_scroll_enabled = true
    vim.notify("🚀 Scroll suave habilitado", vim.log.levels.INFO, { title = "Neoscroll" })
  end
end

-- Keymap para alternar scroll suave
vim.keymap.set("n", "<leader>us", toggle_smooth_scroll, { desc = "🔄 Toggle smooth scroll" })

-- Auto-comando para deshabilitar en archivos muy grandes
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
  group = vim.api.nvim_create_augroup("neoscroll_performance", { clear = true }),
  callback = function()
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 5000 then
      -- Deshabilitar temporalmente en archivos grandes
      if smooth_scroll_enabled then
        vim.notify("📄 Archivo grande detectado - Scroll suave deshabilitado temporalmente",
                  vim.log.levels.INFO, { title = "Neoscroll" })
        toggle_smooth_scroll()
      end
    elseif lines <= 5000 and not smooth_scroll_enabled then
      -- Re-habilitar en archivos pequeños
      toggle_smooth_scroll()
    end
  end,
})

-- Comando para ajustar velocidad de scroll
vim.api.nvim_create_user_command("ScrollSpeed", function(opts)
  local speed = tonumber(opts.args) or 250
  if speed < 50 then speed = 50 end
  if speed > 1000 then speed = 1000 end

  -- Actualizar keymaps con nueva velocidad
  local new_keymaps = {
    ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", tostring(speed) } },
    ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", tostring(speed) } },
    ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", tostring(speed * 2) } },
    ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", tostring(speed * 2) } },
    ["zt"] = { "zt", { tostring(speed) } },
    ["zz"] = { "zz", { tostring(speed) } },
    ["zb"] = { "zb", { tostring(speed) } },
  }

  for key, func in pairs(new_keymaps) do
    vim.keymap.set("n", key, function()
      neoscroll[func[1]](func[2])
    end, keymap_opts)
  end

  vim.notify(string.format("⚡ Velocidad de scroll: %dms", speed), vim.log.levels.INFO, {
    title = "Neoscroll"
  })
end, {
  nargs = 1,
  desc = "Ajustar velocidad de scroll (50-1000ms)"
})

vim.notify("🚀 Neoscroll configurado - Scroll suave activado", vim.log.levels.INFO, {
  title = "Neoscroll",
  timeout = 2000,
})