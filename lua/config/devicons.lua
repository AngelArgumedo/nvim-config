-- =========================
-- Configuración de iconos de tecnologías
-- Con iconos reales de Nerd Font
-- =========================

local M = {}

-- Configurar iconos de tecnologías
function M.setup()
  local devicons = require("nvim-web-devicons")

  devicons.setup({
    -- Configuración de iconos reales de tecnologías
    override = {
      -- JavaScript con el logo oficial de JS
      js = {
        icon = "",
        color = "#f1e05a",
        cterm_color = "185",
        name = "Js"
      },
      -- TypeScript con el logo oficial de TS
      ts = {
        icon = "",
        color = "#3178c6",
        cterm_color = "67",
        name = "Ts"
      },
      -- React JSX y TSX con el logo oficial de React
      jsx = {
        icon = "",
        color = "#61dafb",
        cterm_color = "45",
        name = "Jsx"
      },
      tsx = {
        icon = "",
        color = "#61dafb",
        cterm_color = "45",
        name = "Tsx"
      },
      -- HTML con el logo oficial de HTML5
      html = {
        icon = "",
        color = "#e34c26",
        cterm_color = "196",
        name = "Html"
      },
      -- CSS con el logo oficial de CSS3
      css = {
        icon = "",
        color = "#1572B6",
        cterm_color = "26",
        name = "Css"
      },
      -- SCSS con el logo oficial de Sass
      scss = {
        icon = "",
        color = "#c6538c",
        cterm_color = "169",
        name = "Scss"
      },
      sass = {
        icon = "",
        color = "#c6538c",
        cterm_color = "169",
        name = "Sass"
      },
      -- JSON
      json = {
        icon = "",
        color = "#cbcb41",
        cterm_color = "185",
        name = "Json"
      },
      -- Python con el logo oficial
      py = {
        icon = "",
        color = "#3572A5",
        cterm_color = "61",
        name = "Py"
      },
      -- Lua con el logo oficial
      lua = {
        icon = "",
        color = "#000080",
        cterm_color = "74",
        name = "Lua"
      },
      -- Vim
      vim = {
        icon = "",
        color = "#019833",
        cterm_color = "28",
        name = "Vim"
      },
      -- Go con el logo oficial
      go = {
        icon = "",
        color = "#00ADD8",
        cterm_color = "38",
        name = "Go"
      },
      -- PHP con el logo oficial
      php = {
        icon = "",
        color = "#4F5D95",
        cterm_color = "62",
        name = "Php"
      },
      -- Java con el logo oficial
      java = {
        icon = "",
        color = "#ED8B00",
        cterm_color = "208",
        name = "Java"
      },
      -- C
      c = {
        icon = "",
        color = "#555555",
        cterm_color = "59",
        name = "C"
      },
      -- C++
      cpp = {
        icon = "",
        color = "#f34b7d",
        cterm_color = "204",
        name = "Cpp"
      },
      -- Rust con el logo oficial
      rs = {
        icon = "",
        color = "#dea584",
        cterm_color = "216",
        name = "Rs"
      },
      -- Vue con el logo oficial
      vue = {
        icon = "",
        color = "#4FC08D",
        cterm_color = "42",
        name = "Vue"
      },
      -- Svelte con el logo oficial
      svelte = {
        icon = "",
        color = "#ff3e00",
        cterm_color = "196",
        name = "Svelte"
      },
      -- Angular (para archivos component.ts)
      ["component.ts"] = {
        icon = "",
        color = "#DD0031",
        cterm_color = "160",
        name = "AngularComponent"
      },
      -- Node.js con el logo oficial
      ["package.json"] = {
        icon = "",
        color = "#e8274b",
        cterm_color = "197",
        name = "PackageJson"
      },
      ["package-lock.json"] = {
        icon = "",
        color = "#7a2048",
        cterm_color = "88",
        name = "PackageLockJson"
      },
      -- Yarn con el logo oficial
      ["yarn.lock"] = {
        icon = "",
        color = "#368fb9",
        cterm_color = "67",
        name = "YarnLock"
      },
      -- Git con el logo oficial
      [".gitignore"] = {
        icon = "",
        color = "#f1502f",
        cterm_color = "196",
        name = "Gitignore"
      },
      [".gitmodules"] = {
        icon = "",
        color = "#f1502f",
        cterm_color = "196",
        name = "GitModules"
      },
      -- Docker con el logo oficial
      ["Dockerfile"] = {
        icon = "",
        color = "#458ee6",
        cterm_color = "68",
        name = "Dockerfile"
      },
      ["docker-compose.yml"] = {
        icon = "",
        color = "#458ee6",
        cterm_color = "68",
        name = "DockerCompose"
      },
      ["docker-compose.yaml"] = {
        icon = "",
        color = "#458ee6",
        cterm_color = "68",
        name = "DockerCompose"
      },
      -- Environment files
      [".env"] = {
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "Env"
      },
      [".env.local"] = {
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "EnvLocal"
      },
      [".env.development"] = {
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "EnvDevelopment"
      },
      [".env.production"] = {
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "EnvProduction"
      },
      -- Markdown
      md = {
        icon = "",
        color = "#519aba",
        cterm_color = "67",
        name = "Md"
      },
      -- README especial
      ["README.md"] = {
        icon = "",
        color = "#4285f4",
        cterm_color = "33",
        name = "Readme"
      },
      -- License
      ["LICENSE"] = {
        icon = "",
        color = "#d0bf41",
        cterm_color = "185",
        name = "License"
      },
      -- Shell scripts
      sh = {
        icon = "",
        color = "#4EAA25",
        cterm_color = "34",
        name = "Sh"
      },
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "34",
        name = "Zsh"
      },
      fish = {
        icon = "",
        color = "#4d5a5e",
        cterm_color = "59",
        name = "Fish"
      },
      -- PowerShell
      ps1 = {
        icon = "",
        color = "#012456",
        cterm_color = "68",
        name = "Powershell"
      },
      -- Log files
      log = {
        icon = "",
        color = "#81e043",
        cterm_color = "113",
        name = "Log"
      },
      -- XML
      xml = {
        icon = "",
        color = "#e37933",
        cterm_color = "173",
        name = "Xml"
      },
      -- YAML con el logo oficial
      yml = {
        icon = "",
        color = "#cb171e",
        cterm_color = "160",
        name = "Yml"
      },
      yaml = {
        icon = "",
        color = "#cb171e",
        cterm_color = "160",
        name = "Yaml"
      },
      -- TOML
      toml = {
        icon = "",
        color = "#6d8086",
        cterm_color = "66",
        name = "Toml"
      },
      -- SQL
      sql = {
        icon = "",
        color = "#dad8d8",
        cterm_color = "188",
        name = "Sql"
      },
      -- Database
      db = {
        icon = "",
        color = "#dad8d8",
        cterm_color = "188",
        name = "Database"
      },
      -- WSL
      wsl = {
        icon = "",
        color = "#ffffff",
        cterm_color = "15",
        name = "Wsl"
      },
      -- Configuración de frameworks adicionales
      ["tailwind.config.js"] = {
        icon = "",
        color = "#38bdf8",
        cterm_color = "45",
        name = "TailwindConfig"
      },
      ["next.config.js"] = {
        icon = "",
        color = "#000000",
        cterm_color = "16",
        name = "NextConfig"
      },
      ["nuxt.config.js"] = {
        icon = "",
        color = "#00c58e",
        cterm_color = "42",
        name = "NuxtConfig"
      },
      ["astro.config.mjs"] = {
        icon = "",
        color = "#ff5d01",
        cterm_color = "202",
        name = "AstroConfig"
      },
    },
    -- Configuración general
    default = true,
    color_icons = true,
    strict = true,
  })

  -- Mensaje de confirmación
  vim.notify("🎨 Iconos de tecnologías configurados correctamente", vim.log.levels.INFO, {
    title = "DevIcons",
    timeout = 2000,
  })
end

-- Función para probar los iconos
function M.test_icons()
  local devicons = require("nvim-web-devicons")

  -- Crear una ventana flotante para mostrar algunos iconos de prueba
  local files = {
    "index.html", "style.css", "script.js", "app.ts", "component.tsx",
    "main.py", "config.lua", "README.md", "package.json", ".gitignore",
    "Dockerfile", ".env", "main.go", "index.php", "App.java",
    "main.rs", "component.vue", "style.scss"
  }

  local lines = { "🎨 Iconos de tecnologías configurados:", "" }

  for _, file in ipairs(files) do
    local icon, color = devicons.get_icon(file, vim.fn.fnamemodify(file, ":e"), { default = true })
    table.insert(lines, string.format("%s %s", icon or "", file))
  end

  table.insert(lines, "")
  table.insert(lines, "✨ Si ves iconos en lugar de cuadrados, ¡todo funciona!")

  -- Crear buffer temporal
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Crear ventana flotante
  local width = 60
  local height = #lines + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    border = "rounded",
    title = " Prueba de Iconos ",
    title_pos = "center",
  })

  -- Configurar ventana
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:Normal")

  -- Keymap para cerrar
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

-- Crear comando para probar iconos
vim.api.nvim_create_user_command("TestIcons", function()
  M.test_icons()
end, { desc = "Probar iconos de tecnologías" })

-- Crear comando para recargar iconos
vim.api.nvim_create_user_command("ReloadIcons", function()
  -- Limpiar cache de require
  package.loaded["nvim-web-devicons"] = nil
  package.loaded["config.devicons"] = nil

  -- Recargar configuración
  M.setup()

  vim.notify("🔄 Iconos recargados", vim.log.levels.INFO, { title = "DevIcons" })
end, { desc = "Recargar configuración de iconos" })

return M