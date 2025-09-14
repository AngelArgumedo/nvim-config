-- =========================
-- Opciones generales de Neovim
-- =========================

local opt = vim.opt

-- Números de línea
opt.number = true
opt.relativenumber = true

-- Indentación
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Apariencia
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.wrap = false
opt.cursorline = true

-- Comportamiento
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true

-- Persistencia
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Rendimiento
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = true

-- Autocompletado en línea de comandos
opt.wildmode = "longest:full,full"
opt.completeopt = "menu,menuone,noselect"

-- Configuración de listchars para mostrar espacios en blanco
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Configuración de folds
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Título de ventana con indicador de archivos modificados
opt.title = true
opt.titlestring = "Neovim - %t%( %M%)"  -- %M muestra [+] si el archivo está modificado

-- Mostrar estado de modificación en la barra de estado
opt.showmode = false  -- Ya tenemos lualine
opt.showcmd = true