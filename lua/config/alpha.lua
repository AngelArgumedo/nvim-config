-- =========================
-- Configuración de Alpha (Dashboard con waifu)
-- =========================

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local ascii = require("utils.ascii")

-- Obtener waifu aleatoria
local header = ascii.get_random_waifu()
dashboard.section.header.val = header

-- Opciones del menú principal con iconos profesionales
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find Files", "<cmd>Telescope find_files<CR>"),
  dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("t", "  Find Text", "<cmd>Telescope live_grep<CR>"),
  dashboard.button("n", "  New File", "<cmd>ene<CR>"),
  dashboard.button("p", "  Projects", "<cmd>Telescope git_files<CR>"),
  dashboard.button("s", "󰒲  Lazy Sync", "<cmd>Lazy sync<CR>"),
  dashboard.button("c", "  Configuration", "<cmd>e $MYVIMRC<CR>"),
  dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
}

-- Footer personalizado
local function footer()
  local total_plugins = #vim.tbl_keys(require("lazy").plugins())
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local custom_footer = "✦  想像できれば、プログラムできます。✦"

  return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info .. "\n\n" .. custom_footer
end

dashboard.section.footer.val = footer()

-- Configuración de colores y espaciado profesional
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Espaciado entre secciones
dashboard.config.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

-- Configuración general
dashboard.opts.opts.noautocmd = true
dashboard.opts.opts.margin = 5

-- Configurar alpha
alpha.setup(dashboard.opts)

-- Autocommand para actualizar el footer cuando se carguen plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    dashboard.section.footer.val = footer()
    pcall(vim.cmd.AlphaRedraw)
  end,
})

-- Keymap para volver al dashboard
vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Volver al Dashboard" })