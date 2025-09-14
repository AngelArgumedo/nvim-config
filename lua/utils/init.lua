-- =========================
-- Utilidades generales
-- =========================

local M = {}

-- Función para verificar si un plugin está disponible
function M.has_plugin(plugin)
  return pcall(require, plugin)
end

-- Función para crear keymaps de manera más fácil
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Función para crear autocmds de manera más fácil
function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

-- Función para crear augroups de manera más fácil
function M.augroup(name, opts)
  return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

-- Función para notificar al usuario
function M.notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, { title = "Neovim Config" })
end

-- Función para verificar si estamos en Windows
function M.is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

-- Función para verificar si estamos en WSL
function M.is_wsl()
  return vim.fn.has("wsl") == 1
end

return M