-- =========================
-- Autocommands
-- =========================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- =========================
-- Highlighting
-- =========================

-- Resaltar al copiar texto
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- =========================
-- Formateo automático
-- =========================

-- Auto-lint al guardar archivo
autocmd("BufWritePost", {
  desc = "Auto lint on save",
  group = augroup("auto-lint", { clear = true }),
  callback = function()
    local lint_status, lint = pcall(require, "lint")
    if lint_status then
      lint.try_lint()
    end
  end,
})

-- =========================
-- Configuración por tipo de archivo
-- =========================

-- Configuración especial para archivos de configuración
autocmd("FileType", {
  desc = "Special settings for config files",
  pattern = { "lua", "vim", "json", "yaml", "toml" },
  group = augroup("config-files", { clear = true }),
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Configuración para archivos de programación
autocmd("FileType", {
  desc = "Programming files settings",
  pattern = { "javascript", "typescript", "python", "html", "css", "scss" },
  group = augroup("programming-files", { clear = true }),
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 80
  end,
})

-- =========================
-- Comportamiento de ventanas
-- =========================

-- Cerrar ciertos tipos de buffer con 'q'
autocmd("FileType", {
  desc = "Close with q",
  pattern = { "help", "startuptime", "qf", "lspinfo", "man", "checkhealth" },
  group = augroup("close-with-q", { clear = true }),
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Redimensionar splits si la ventana de Neovim es redimensionada
autocmd("VimResized", {
  desc = "Resize splits if window got resized",
  group = augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- =========================
-- Restaurar posición del cursor
-- =========================

-- Ir a la última posición conocida cuando se abre un archivo
autocmd("BufReadPost", {
  desc = "Go to last loc when opening a buffer",
  group = augroup("last-loc", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =========================
-- Indicadores visuales para archivos modificados
-- =========================

-- Actualizar indicadores cuando el archivo se modifica
autocmd({ "BufModifiedSet", "BufEnter", "WinEnter" }, {
  desc = "Update visual indicators when file is modified",
  group = augroup("modified-indicators", { clear = true }),
  callback = function()
    -- Actualizar lualine cuando el estado de modificación cambie
    require("lualine").refresh()
  end,
})

-- Notificación cuando se guarda un archivo
autocmd("BufWritePost", {
  desc = "Show save confirmation",
  group = augroup("save-feedback", { clear = true }),
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename ~= "" then
      vim.notify("💾 " .. filename .. " saved!", vim.log.levels.INFO, {
        title = "File Saved",
        timeout = 1000
      })
    end
  end,
})

-- Notificación visual en la command line para archivos modificados
autocmd({ "TextChanged", "TextChangedI" }, {
  desc = "Update status when text changes",
  group = augroup("text-change-status", { clear = true }),
  callback = function()
    if vim.bo.modified then
      -- Solo actualizar lualine, evitamos spam de mensajes
      vim.defer_fn(function()
        require("lualine").refresh()
      end, 100)
    end
  end,
})

-- =========================
-- Auto-cerrar buffers inactivos (optimización de memoria)
-- =========================

-- Tabla para rastrear última actividad de cada buffer
_G.buffer_last_activity = _G.buffer_last_activity or {}

-- Actualizar timestamp cuando se usa un buffer
autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  desc = "Track buffer activity",
  group = augroup("buffer-activity-tracker", { clear = true }),
  callback = function(event)
    _G.buffer_last_activity[event.buf] = vim.loop.now()
  end,
})

-- Revisar y cerrar buffers inactivos cada 5 minutos
autocmd("CursorHold", {
  desc = "Close inactive buffers after 20 minutes",
  group = augroup("auto-close-inactive-buffers", { clear = true }),
  callback = function()
    local current_time = vim.loop.now()
    local timeout = 20 * 60 * 1000 -- 20 minutos en milisegundos

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      -- Solo procesar buffers válidos, cargados y no modificados
      if vim.api.nvim_buf_is_valid(bufnr)
         and vim.api.nvim_buf_is_loaded(bufnr)
         and not vim.bo[bufnr].modified
         and vim.bo[bufnr].buflisted then

        local last_activity = _G.buffer_last_activity[bufnr] or current_time
        local inactive_time = current_time - last_activity

        -- Si el buffer ha estado inactivo por más de 20 minutos
        if inactive_time > timeout then
          -- No cerrar el buffer actual
          if bufnr ~= vim.api.nvim_get_current_buf() then
            -- Verificar que no sea un tipo especial (terminal, help, etc.)
            local buftype = vim.bo[bufnr].buftype
            if buftype ~= "terminal" and buftype ~= "help" and buftype ~= "quickfix" then
              pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
            end
          end
        end
      end
    end
  end,
})