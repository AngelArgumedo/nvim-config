-- =========================
-- Claude Workflow Optimization
-- Configuración específica para trabajar con Claude Code
-- =========================

local M = {}

-- ========================
-- CONFIGURACIÓN DE CLAUDE
-- ========================

-- Detectar si estamos en un proyecto con Claude
local function is_claude_project()
  local indicators = {
    ".claude_project",
    "CLAUDE.md",
    ".claude",
    "claude-context.md"
  }

  for _, file in ipairs(indicators) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
      return true
    end
  end
  return false
end

-- Crear estructura de proyecto Claude
local function setup_claude_project()
  local cwd = vim.fn.getcwd()
  local claude_files = {
    {
      name = "CLAUDE.md",
      content = [[# CLAUDE.md

Este archivo proporciona contexto a Claude Code sobre el proyecto.

## Descripción del Proyecto
Describe aquí tu proyecto...

## Estructura del Proyecto
```
proyecto/
├── src/           # Código fuente
├── docs/          # Documentación
├── tests/         # Tests
└── CLAUDE.md      # Este archivo
```

## Comandos Importantes
- `npm run dev` - Servidor de desarrollo
- `npm test` - Ejecutar tests
- `npm run build` - Build de producción

## Notas para Claude
- Usar TypeScript estricto
- Seguir convenciones de ESLint
- Tests con Jest
- Documentación con JSDoc

## Archivos Importantes
- `src/main.ts` - Punto de entrada
- `package.json` - Dependencias
- `tsconfig.json` - Configuración TypeScript
]]
    },
    {
      name = ".claude_project",
      content = [[# Claude Project Marker
# Este archivo indica que este es un proyecto optimizado para Claude Code
project_type=development
created_date=]] .. os.date("%Y-%m-%d") .. [[

framework=auto-detect
language=auto-detect
]]
    },
    {
      name = "claude-context.md",
      content = [[# Contexto del Proyecto para Claude

## Estado Actual
- Última sesión: ]] .. os.date("%Y-%m-%d %H:%M") .. [[
- Archivos trabajando:
- Tareas pendientes:

## Convenciones del Proyecto
- Estilo de código:
- Patrones de naming:
- Estructura preferida:

## Comandos Frecuentes
- Desarrollo:
- Testing:
- Deploy:

## Notas de la Sesión
(Claude actualizará esto automáticamente)
]]
    }
  }

  for _, file in ipairs(claude_files) do
    local file_path = cwd .. "/" .. file.name
    if vim.fn.filereadable(file_path) == 0 then
      local f = io.open(file_path, "w")
      if f then
        f:write(file.content)
        f:close()
        vim.notify("📄 Creado: " .. file.name, vim.log.levels.INFO, { title = "Claude Setup" })
      end
    end
  end
end

-- ========================
-- GESTIÓN DE SESIONES CLAUDE
-- ========================

-- Guardar contexto de sesión para Claude
local function save_claude_context()
  local cwd = vim.fn.getcwd()
  local context_file = cwd .. "/claude-context.md"

  if vim.fn.filereadable(context_file) == 1 then
    local buffers = vim.api.nvim_list_bufs()
    local open_files = {}

    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
        local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
        if not file_name:match("^term://") and file_name ~= "" then
          table.insert(open_files, file_name)
        end
      end
    end

    local context_update = [[

## Última Sesión Actualizada: ]] .. os.date("%Y-%m-%d %H:%M") .. [[

### Archivos Abiertos:
]] .. (next(open_files) and ("- " .. table.concat(open_files, "\n- ")) or "- Ninguno") .. [[

### Directorio Actual:
]] .. cwd .. [[

### Información de Git:
]] .. (vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "") or "No git") .. [[

]]

    -- Leer contenido actual y agregar actualización
    local lines = vim.fn.readfile(context_file)
    local new_content = {}
    local in_session_notes = false

    for _, line in ipairs(lines) do
      if line:match("## Notas de la Sesión") then
        in_session_notes = true
        table.insert(new_content, line)
        table.insert(new_content, context_update)
      elseif not in_session_notes then
        table.insert(new_content, line)
      end
    end

    vim.fn.writefile(new_content, context_file)
  end
end

-- Restaurar contexto de Claude
local function load_claude_context()
  local cwd = vim.fn.getcwd()
  local context_file = cwd .. "/claude-context.md"

  if vim.fn.filereadable(context_file) == 1 then
    -- Mostrar resumen del contexto
    local lines = vim.fn.readfile(context_file)
    local recent_info = {}
    local capture = false

    for _, line in ipairs(lines) do
      if line:match("## Última Sesión") then
        capture = true
      elseif line:match("^##") and capture then
        break
      elseif capture and line ~= "" then
        table.insert(recent_info, line)
      end
    end

    if #recent_info > 0 then
      vim.notify("📋 Contexto Claude cargado:\n" .. table.concat(recent_info, "\n"),
                vim.log.levels.INFO, { title = "Claude Context", timeout = 5000 })
    end
  end
end

-- ========================
-- COMANDOS CLAUDE OPTIMIZADOS
-- ========================

-- Terminal Claude mejorado con integración global
local function open_claude_persistent()
  local Terminal = require("toggleterm.terminal").Terminal
  local claude_global = require("config.claude-agents-global")

  -- Usar directorio del proyecto actual para sesión específica
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local agent_info = claude_global.get_recommended_agent()

  local claude_term = Terminal:new({
    cmd = "claude",
    direction = "float",
    close_on_exit = false,
    dir = vim.fn.getcwd(),
    count = 99, -- ID único para Claude
    float_opts = {
      border = "curved",
      width = function() return math.floor(vim.o.columns * 0.95) end,
      height = function() return math.floor(vim.o.lines * 0.95) end,
      winblend = 0,
      title = " 🤖 Claude Code - " .. project_name .. " [" .. agent_info.agent .. "] ",
      title_pos = "center",
    },
    on_open = function(term)
      vim.cmd("startinsert!")
      -- Guardar contexto al abrir Claude
      save_claude_context()

      -- Configuración específica para Claude
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-q>", "<cmd>close<CR>", {noremap = true, silent = true})

      -- Mensaje de bienvenida con información del agente
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(term.bufnr) then
          vim.notify(string.format("🤖 Claude listo para %s\n🎯 Agente: %s %s",
            project_name,
            agent_info.agent,
            agent_info.available and "✅" or "❌"
          ), vim.log.levels.INFO, {
            title = "Claude Code"
          })
        end
      end, 1000)
    end,
    on_close = function()
      -- Guardar contexto al cerrar
      save_claude_context()
    end
  })

  claude_term:toggle()
end

-- Función para compartir archivo actual con Claude
local function share_file_with_claude()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("No hay archivo actual para compartir", vim.log.levels.WARN)
    return
  end

  local relative_path = vim.fn.fnamemodify(current_file, ":.")
  local file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

  -- Copiar información del archivo al clipboard
  local share_content = string.format([[
Archivo: %s

```%s
%s
```

Línea actual: %d
Proyecto: %s
]], relative_path, vim.bo.filetype, file_content, vim.fn.line("."), vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))

  vim.fn.setreg("+", share_content)
  vim.notify("📋 Archivo copiado al clipboard para Claude\n" .. relative_path, vim.log.levels.INFO, {
    title = "Claude Share"
  })
end

-- Función para crear snippet de código para Claude
local function create_claude_snippet()
  local start_line, end_line
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" then
    start_line = vim.fn.getpos("'<")[2]
    end_line = vim.fn.getpos("'>")[2]
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

  local snippet = string.format([[
📍 %s:%d-%d

```%s
%s
```
]], file_path, start_line, end_line, vim.bo.filetype, table.concat(lines, "\n"))

  vim.fn.setreg("+", snippet)
  vim.notify("✂️ Snippet copiado para Claude", vim.log.levels.INFO, { title = "Claude Snippet" })
end

-- ========================
-- PLANTILLAS DE PROYECTO
-- ========================

local project_templates = {
  react = {
    name = "React + TypeScript",
    files = {
      ["src/App.tsx"] = [[import React from 'react';

function App() {
  return (
    <div className="App">
      <h1>React + TypeScript Project</h1>
    </div>
  );
}

export default App;
]],
      ["src/main.tsx"] = [[import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
]],
      ["tsconfig.json"] = [[{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
]]
    }
  },
  python = {
    name = "Python Project",
    files = {
      ["main.py"] = [[#!/usr/bin/env python3
"""
Main module for the project.
"""

def main():
    """Main function."""
    print("Hello, Claude!")

if __name__ == "__main__":
    main()
]],
      ["requirements.txt"] = [[# Core dependencies
requests>=2.28.0
pytest>=7.0.0

# Development dependencies
black>=22.0.0
flake8>=5.0.0
]]
    }
  },
  node = {
    name = "Node.js + TypeScript",
    files = {
      ["src/index.ts"] = [[/**
 * Main entry point for the application
 */

console.log("Hello, Claude!");

export {};
]],
      ["package.json"] = [[{
  "name": "claude-project",
  "version": "1.0.0",
  "description": "Project created with Claude workflow",
  "main": "dist/index.js",
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0"
  }
}
]]
    }
  }
}

-- Crear proyecto desde plantilla
local function create_project_template()
  vim.ui.select(vim.tbl_keys(project_templates), {
    prompt = "Seleccionar plantilla de proyecto:",
    format_item = function(item)
      return "🚀 " .. project_templates[item].name
    end,
  }, function(choice)
    if choice then
      local template = project_templates[choice]
      local cwd = vim.fn.getcwd()

      -- Crear archivos de la plantilla
      for file_path, content in pairs(template.files) do
        local full_path = cwd .. "/" .. file_path
        vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")

        local f = io.open(full_path, "w")
        if f then
          f:write(content)
          f:close()
        end
      end

      -- Configurar proyecto Claude
      setup_claude_project()

      vim.notify("🎉 Proyecto " .. template.name .. " creado con configuración Claude",
                vim.log.levels.INFO, { title = "Project Template" })
    end
  end)
end

-- ========================
-- KEYMAPS CLAUDE
-- ========================

local keymap = vim.keymap.set

-- Claude terminal optimizado
keymap("n", "<leader>ac", open_claude_persistent, { desc = "🤖 Claude Code (Optimized)" })

-- Compartir con Claude
keymap("n", "<leader>cs", share_file_with_claude, { desc = "📋 Compartir archivo con Claude" })
keymap({"n", "v"}, "<leader>cc", create_claude_snippet, { desc = "✂️ Crear snippet para Claude" })

-- Gestión de contexto
keymap("n", "<leader>cx", save_claude_context, { desc = "💾 Guardar contexto Claude" })
keymap("n", "<leader>cl", load_claude_context, { desc = "📋 Cargar contexto Claude" })

-- Setup de proyecto
keymap("n", "<leader>cp", setup_claude_project, { desc = "🔧 Setup proyecto Claude" })
keymap("n", "<leader>ct", create_project_template, { desc = "🚀 Crear proyecto desde plantilla" })

-- Navegación rápida a archivos Claude
keymap("n", "<leader>cC", function()
  vim.cmd("edit CLAUDE.md")
end, { desc = "📝 Abrir CLAUDE.md" })

keymap("n", "<leader>cn", function()
  vim.cmd("edit claude-context.md")
end, { desc = "📋 Abrir contexto Claude" })

-- Integración con configuración global
keymap("n", "<leader>ci", function()
  require("config.claude-agents-global").show_system_info()
end, { desc = "ℹ️ Info del sistema Claude" })

keymap("n", "<leader>ca", function()
  local claude_global = require("config.claude-agents-global")
  local agent_info = claude_global.get_recommended_agent()

  vim.ui.input({
    prompt = "Describe tu tarea: ",
    default = "Analizar y mejorar el código actual"
  }, function(user_prompt)
    if user_prompt then
      local contextual_prompt, _ = claude_global.create_contextual_prompt(user_prompt, true)

      -- Guardar en historial global
      claude_global.save_prompt_history(user_prompt, agent_info.agent)

      -- Copiar prompt al clipboard
      vim.fn.setreg("+", contextual_prompt)

      -- Abrir Claude
      open_claude_persistent()

      vim.notify(string.format("📋 Prompt contextualizado copiado\n🤖 Agente: %s %s",
        agent_info.agent,
        agent_info.available and "✅" or "❌"
      ), vim.log.levels.INFO, {
        title = "Claude Global",
        timeout = 4000
      })
    end
  end)
end, { desc = "🤖 Claude con contexto global" })

-- ========================
-- AUTO-COMANDOS CLAUDE
-- ========================

-- Auto-setup al entrar en directorio
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("claude_workflow", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      if is_claude_project() then
        load_claude_context()
        vim.notify("🤖 Proyecto Claude detectado", vim.log.levels.INFO, {
          title = "Claude Workflow"
        })
      end
    end, 1000)
  end,
})

-- Auto-save contexto al salir
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("claude_autosave", { clear = true }),
  callback = function()
    if is_claude_project() then
      save_claude_context()
    end
  end,
})

-- ========================
-- COMANDOS CLAUDE
-- ========================

vim.api.nvim_create_user_command("ClaudeSetup", setup_claude_project, {
  desc = "Configurar proyecto para Claude"
})

vim.api.nvim_create_user_command("ClaudeContext", load_claude_context, {
  desc = "Mostrar contexto Claude"
})

vim.api.nvim_create_user_command("ClaudeTemplate", create_project_template, {
  desc = "Crear proyecto desde plantilla"
})

-- ========================
-- INTEGRACIÓN CON WHICH-KEY
-- ========================

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>c", group = "🤖 Claude Workflow" },
    { "<leader>ac", desc = "🤖 Claude Code Terminal" },
    { "<leader>ca", desc = "🤖 Claude con contexto global" },
    { "<leader>ci", desc = "ℹ️ Info del sistema Claude" },
    { "<leader>cs", desc = "📋 Share File" },
    { "<leader>cc", desc = "✂️ Create Snippet" },
    { "<leader>cx", desc = "💾 Save Context" },
    { "<leader>cl", desc = "📋 Load Context" },
    { "<leader>cp", desc = "🔧 Setup Project" },
    { "<leader>ct", desc = "🚀 Project Template" },
    { "<leader>cC", desc = "📝 Open CLAUDE.md" },
    { "<leader>cn", desc = "📋 Open Context" },
  })
end

-- Configuración inicial
M.setup = function()
  -- Cargar configuración global
  local success, claude_global = pcall(require, "config.claude-agents-global")
  if success then
    claude_global.setup()
  end

  -- Cargar workflows automatizados
  local workflows_success, claude_workflows = pcall(require, "config.claude-workflows")
  if workflows_success then
    claude_workflows.setup()
  end

  vim.notify("🤖 Claude Workflow configurado", vim.log.levels.INFO, {
    title = "Claude Workflow",
    timeout = 2000,
  })
end

-- Exponer función para otros módulos
M.open_claude_persistent = open_claude_persistent

return M