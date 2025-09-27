-- =========================
-- Configuración de Persistence (Sesiones Automáticas)
-- Guarda y restaura automáticamente tu workspace
-- =========================

local persistence = require("persistence")

persistence.setup({
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directorio para sesiones
  options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
  pre_save = nil, -- función antes de guardar
  save_empty = false, -- no guardar si no hay buffers
})

-- Keymaps para sesiones
local keymap = vim.keymap.set

-- Restaurar sesión del directorio actual
keymap("n", "<leader>qs", function()
  persistence.load()
end, { desc = "🔄 Restaurar sesión actual" })

-- Restaurar última sesión
keymap("n", "<leader>ql", function()
  persistence.load({ last = true })
end, { desc = "🕐 Restaurar última sesión" })

-- Dejar de grabar sesión para este directorio
keymap("n", "<leader>qd", function()
  persistence.stop()
end, { desc = "🛑 Dejar de grabar sesión" })

-- Comando personalizado para limpiar sesiones viejas
vim.api.nvim_create_user_command("SessionClean", function()
  local sessions_dir = vim.fn.stdpath("state") .. "/sessions/"
  local sessions = vim.fn.glob(sessions_dir .. "*", false, true)

  if #sessions == 0 then
    vim.notify("No hay sesiones guardadas", vim.log.levels.INFO, { title = "Sessions" })
    return
  end

  local old_sessions = {}
  local now = os.time()
  local week_ago = now - (7 * 24 * 60 * 60) -- 7 días

  for _, session in ipairs(sessions) do
    local stat = vim.loop.fs_stat(session)
    if stat and stat.mtime.sec < week_ago then
      table.insert(old_sessions, session)
    end
  end

  if #old_sessions == 0 then
    vim.notify("No hay sesiones viejas para limpiar", vim.log.levels.INFO, { title = "Sessions" })
    return
  end

  for _, session in ipairs(old_sessions) do
    vim.fn.delete(session)
  end

  vim.notify(
    string.format("🧹 %d sesiones viejas eliminadas", #old_sessions),
    vim.log.levels.INFO,
    { title = "Sessions" }
  )
end, { desc = "Limpiar sesiones viejas (>7 días)" })

-- Auto-comandos
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
  callback = function()
    -- Solo auto-restaurar si se abrió sin argumentos
    if vim.fn.argc() == 0 and not vim.g.started_by_firenvim then
      -- Pequeño delay para que termine de cargar todo
      vim.defer_fn(function()
        if vim.fn.filereadable(vim.fn.stdpath("state") .. "/sessions/" .. vim.fn.getcwd():gsub("/", "%%")) == 1 then
          vim.notify("🔄 Sesión restaurada automáticamente", vim.log.levels.INFO, {
            title = "Persistence",
            timeout = 2000
          })
        end
      end, 100)
    end
  end,
})

vim.notify("💾 Persistence configurado - Sesiones automáticas activadas", vim.log.levels.INFO, {
  title = "Persistence",
  timeout = 2000,
})