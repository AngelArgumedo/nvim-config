-- =========================
-- Core configuration loader
-- =========================

-- Habilitar loader de Neovim para mejor rendimiento
vim.loader.enable()

-- Cargar configuraciones base
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Establecer colorscheme por defecto (con protección por si no está instalado)
pcall(vim.cmd.colorscheme, "tokyonight")

-- Cargar configuración de colores personalizados
require("config.colors")