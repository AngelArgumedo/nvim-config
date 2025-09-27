-- =========================
-- Configuración de Notify (Notificaciones bonitas)
-- Notificaciones modernas y animadas
-- =========================

local notify = require("notify")

notify.setup({
  -- Configuración de animación
  stages = "fade_in_slide_out", -- fade_in_slide_out/fade/slide/static
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
  -- Configuración visual
  background_colour = "#000000",
  fps = 30,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = ""
  },
  level = 2,
  minimum_width = 50,
  render = "default", -- default/minimal/simple
  top_down = true,
})

-- Establecer notify como el manejador por defecto
vim.notify = notify

-- Keymaps para gestionar notificaciones
local keymap = vim.keymap.set

-- Ver historial de notificaciones
keymap("n", "<leader>un", function()
  notify.dismiss({ silent = true, pending = true })
end, { desc = "🔕 Descartar notificaciones" })

-- Mostrar historial de notificaciones con Telescope (si está disponible)
keymap("n", "<leader>nh", function()
  local telescope_ok, telescope = pcall(require, "telescope")
  if telescope_ok then
    telescope.extensions.notify.notify()
  else
    -- Fallback: mostrar en ventana flotante
    local notifications = notify.history()
    if #notifications == 0 then
      vim.notify("No hay notificaciones en el historial", vim.log.levels.INFO)
      return
    end

    local lines = { "📱 Historial de Notificaciones:", "" }
    for i = #notifications, math.max(1, #notifications - 20), -1 do
      local notif = notifications[i]
      local level_icon = {
        [vim.log.levels.ERROR] = " ",
        [vim.log.levels.WARN] = " ",
        [vim.log.levels.INFO] = " ",
        [vim.log.levels.DEBUG] = " ",
      }
      local icon = level_icon[notif.level] or " "
      local time = os.date("%H:%M:%S", notif.time / 1000)
      table.insert(lines, string.format("%s [%s] %s", icon, time, notif.message))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    local width = 80
    local height = math.min(#lines + 2, 25)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      border = "rounded",
      title = " Historial de Notificaciones ",
      title_pos = "center",
    })

    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
  end
end, { desc = "📱 Ver historial de notificaciones" })

-- Función para notificaciones personalizadas
local function custom_notify(message, level, opts)
  opts = opts or {}
  level = level or vim.log.levels.INFO

  -- Íconos personalizados según el contexto
  local context_icons = {
    git = "󰊢",
    file = "",
    save = "󰆓",
    load = "󰋚",
    config = "",
    plugin = "",
    lsp = "",
    error = "",
    success = "",
    warning = "",
  }

  if opts.icon and context_icons[opts.icon] then
    opts.icon = context_icons[opts.icon]
  end

  notify(message, level, opts)
end

-- Hacer la función disponible globalmente
_G.custom_notify = custom_notify

-- Ejemplo de uso con auto-comandos
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("notify_save", { clear = true }),
  callback = function()
    custom_notify("Archivo guardado: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, {
      title = "Guardado",
      icon = "save",
      timeout = 1000,
    })
  end,
})

-- Notificación de bienvenida
vim.defer_fn(function()
  custom_notify("Notificaciones bonitas activadas", vim.log.levels.INFO, {
    title = "nvim-notify",
    icon = "success",
    timeout = 2000,
  })
end, 1000)

-- Configurar integración con Telescope si está disponible
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  telescope.load_extension("notify")
end

-- Comando para probar notificaciones
vim.api.nvim_create_user_command("TestNotify", function()
  custom_notify("Esta es una notificación de prueba", vim.log.levels.INFO, {
    title = "Test",
    icon = "success"
  })
  vim.defer_fn(function()
    custom_notify("Esta es una advertencia", vim.log.levels.WARN, {
      title = "Warning",
      icon = "warning"
    })
  end, 1000)
  vim.defer_fn(function()
    custom_notify("Esta es un error de ejemplo", vim.log.levels.ERROR, {
      title = "Error",
      icon = "error"
    })
  end, 2000)
end, { desc = "Probar diferentes tipos de notificaciones" })