-- =========================
-- Keymaps globales
-- =========================

local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================
-- Archivos y navegación
-- =========================

-- Guardar y salir
keymap("n", "<leader>w", ":w<CR>", { desc = "Guardar" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Cerrar" })
keymap("n", "<leader>Q", ":q!<CR>", { desc = "Forzar cerrar sin guardar" })

-- Quitar highlight de búsqueda
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Quitar highlight" })

-- Explorador de archivos
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle explorador" })
keymap("n", "-", "<cmd>Oil<cr>", { desc = "Abrir Oil" })

-- =========================
-- Manejo de ventanas
-- =========================

-- Dividir ventanas
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Dividir vertical" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Dividir horizontal" })

-- Navegar entre ventanas
keymap("n", "<C-h>", "<C-w>h", { desc = "Ir izquierda" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Ir derecha" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Ir abajo" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Ir arriba" })

-- Redimensionar ventanas
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Aumentar altura" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Reducir altura" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Reducir ancho" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Aumentar ancho" })

-- =========================
-- Manejo de buffers
-- =========================

-- Navegar buffers
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Buffer siguiente" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer anterior" })
keymap("n", "<leader>c", ":bd<CR>", { desc = "Cerrar buffer" })

-- =========================
-- Edición avanzada
-- =========================

-- Mover líneas seleccionadas
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba" })

-- Mantener cursor centrado al hacer scroll
keymap("n", "<C-d>", "<C-d>zz", { desc = "Medio scroll abajo centrado" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Medio scroll arriba centrado" })

-- Mantener búsquedas centradas
keymap("n", "n", "nzzzv", { desc = "Siguiente resultado centrado" })
keymap("n", "N", "Nzzzv", { desc = "Resultado anterior centrado" })

-- Mejor experiencia de pegado
keymap("x", "<leader>p", '"_dP', { desc = "Pegar sin perder registro" })

-- =========================
-- Terminal
-- =========================

-- Salir de modo terminal
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Salir de terminal a normal" })

-- Navegación en terminal
keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Terminal: ir izquierda" })
keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Terminal: ir abajo" })
keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Terminal: ir arriba" })
keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Terminal: ir derecha" })

-- =========================
-- Diagnósticos y navegación LSP
-- =========================

keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Ver error" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Error anterior" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Error siguiente" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Lista de diagnósticos" })

-- Navegación de código (equivalente a Ctrl+Click en VSCode)
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Ir a definición" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Ir a declaración" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Ver referencias" })
keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Ir a implementación" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Documentación hover" })
keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Ayuda de signatura" })

-- =========================
-- Manejo de archivos modificados
-- =========================

-- Ver archivos modificados
keymap("n", "<leader>m", function()
  local modified_buffers = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "modified") then
      local filename = vim.api.nvim_buf_get_name(bufnr)
      if filename ~= "" then
        table.insert(modified_buffers, vim.fn.fnamemodify(filename, ":t"))
      end
    end
  end

  if #modified_buffers == 0 then
    vim.notify("✅ No unsaved files", vim.log.levels.INFO, { title = "File Status" })
  else
    vim.notify("📝 Unsaved files:\n• " .. table.concat(modified_buffers, "\n• "),
              vim.log.levels.WARN, { title = "Unsaved Files" })
  end
end, { desc = "Show unsaved files" })

-- Guardar todos los archivos modificados
keymap("n", "<leader>W", "<cmd>wall<CR>", { desc = "Save all modified files" })

-- =========================
-- Font and Icon Testing
-- =========================

-- Cargar utilidades de prueba de fuentes
require("config.font-test")