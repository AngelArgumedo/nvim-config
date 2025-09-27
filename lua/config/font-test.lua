-- =========================
-- Font and Icon Test Utility
-- Prueba la funcionalidad de iconos
-- =========================

local M = {}

-- Función para probar iconos
function M.test_icons()
  local icons = require("nvim-web-devicons")

  local test_files = {
    { "test.js", "JavaScript" },
    { "test.html", "HTML" },
    { "test.css", "CSS" },
    { "test.py", "Python" },
    { "test.lua", "Lua" },
    { "test.json", "JSON" },
    { "test.md", "Markdown" },
    { "test.ts", "TypeScript" },
    { "test.tsx", "React TSX" },
    { "test.vue", "Vue" },
    { "package.json", "Package.json" },
    { ".gitignore", "Git Ignore" },
    { "README.md", "README" },
    { "Dockerfile", "Docker" }
  }

  print("🧪 PRUEBA DE ICONOS - Font Test")
  print("================================")

  for _, file_info in ipairs(test_files) do
    local filename, description = file_info[1], file_info[2]
    local icon, color = icons.get_icon(filename)

    if icon then
      print(string.format("✅ %s %s (%s) - Color: %s", icon, filename, description, color or "default"))
    else
      print(string.format("❌ NO ICON %s (%s)", filename, description))
    end
  end

  print("\n🔧 DIAGNÓSTICO:")
  print("Si ves '❌ NO ICON' o cuadros en lugar de iconos:")
  print("1. Tu terminal necesita una Nerd Font")
  print("2. Ejecuta: .\\install-nerd-font.ps1")
  print("3. Configura tu terminal para usar 'JetBrainsMono Nerd Font'")
  print("4. Reinicia Neovim")

  print("\n📱 PRUEBA RÁPIDA:")
  print("¿Puedes ver estos símbolos? → 🔧 📁 🌟 ⚡ 🔍")
  print("Si no los ves, el problema es la fuente de tu terminal.")
end

-- Función para mostrar información del terminal
function M.terminal_info()
  print("🖥️  INFORMACIÓN DEL TERMINAL")
  print("============================")
  print("OS: " .. vim.loop.os_uname().sysname)
  print("Terminal: " .. (os.getenv("TERM") or "Desconocido"))
  print("Shell: " .. (os.getenv("SHELL") or vim.o.shell))

  -- Probar soporte de Unicode
  local unicode_tests = { "█", "▓", "▒", "░", "🔧", "📁", "⚡" }
  print("\nPrueba Unicode:")
  for _, char in ipairs(unicode_tests) do
    print("  " .. char .. " ← ¿Ves este símbolo?")
  end
end

-- Comando para Neovim
vim.api.nvim_create_user_command("TestIcons", function()
  M.test_icons()
end, { desc = "Probar iconos de archivos" })

vim.api.nvim_create_user_command("TerminalInfo", function()
  M.terminal_info()
end, { desc = "Información del terminal" })

-- Keymaps para testing
vim.keymap.set("n", "<leader>ti", M.test_icons, { desc = "🧪 Test iconos" })
vim.keymap.set("n", "<leader>tt", M.terminal_info, { desc = "🖥️  Info terminal" })

return M