-- =========================
-- Claude Agents Global Configuration
-- Sistema portable que detecta automáticamente la configuración de Claude
-- =========================

local M = {}

-- ========================
-- DETECCIÓN AUTOMÁTICA DE CONFIGURACIÓN
-- ========================

-- Detectar directorio de Claude automáticamente
local function detect_claude_dir()
  local possible_paths = {}

  -- Windows
  if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    local home = os.getenv('USERPROFILE') or os.getenv('HOME')
    if home then
      table.insert(possible_paths, home .. '\\.claude')
    end
    -- También buscar en AppData
    local appdata = os.getenv('APPDATA')
    if appdata then
      table.insert(possible_paths, appdata .. '\\claude')
    end
    local localappdata = os.getenv('LOCALAPPDATA')
    if localappdata then
      table.insert(possible_paths, localappdata .. '\\claude')
    end
  else
    -- Linux/Mac
    local home = os.getenv('HOME')
    if home then
      table.insert(possible_paths, home .. '/.claude')
      table.insert(possible_paths, home .. '/.config/claude')
    end
    -- También buscar en ubicaciones estándar
    table.insert(possible_paths, '/usr/local/share/claude')
    table.insert(possible_paths, '/opt/claude')
  end

  -- Verificar qué directorio existe y contiene archivos de Claude
  for _, path in ipairs(possible_paths) do
    if vim.fn.isdirectory(path) == 1 then
      -- Verificar que tenga la estructura típica de Claude
      local agents_dir = path .. (vim.fn.has('win32') == 1 and '\\agents' or '/agents')
      local projects_dir = path .. (vim.fn.has('win32') == 1 and '\\projects' or '/projects')

      if vim.fn.isdirectory(agents_dir) == 1 or vim.fn.isdirectory(projects_dir) == 1 then
        return path
      end
    end
  end

  return nil
end

-- ========================
-- CONFIGURACIÓN ADAPTABLE
-- ========================

local CLAUDE_GLOBAL_DIR = detect_claude_dir()
local AGENTS_MAPPING = {}

-- Cargar agentes disponibles dinámicamente
local function load_available_agents()
  if not CLAUDE_GLOBAL_DIR then
    vim.notify("⚠️ No se encontró configuración global de Claude", vim.log.levels.WARN, {
      title = "Claude Config"
    })
    return {}
  end

  local agents_dir = CLAUDE_GLOBAL_DIR .. (vim.fn.has('win32') == 1 and '\\agents' or '/agents')
  local agents = {}

  if vim.fn.isdirectory(agents_dir) == 1 then
    local files = vim.fn.glob(agents_dir .. (vim.fn.has('win32') == 1 and '\\*.md' or '/*.md'), false, true)

    for _, file in ipairs(files) do
      local agent_name = vim.fn.fnamemodify(file, ':t:r')

      -- Leer el archivo para obtener descripción
      local content = vim.fn.readfile(file, '', 10) -- Leer solo las primeras 10 líneas
      local description = "Agente especializado"

      for _, line in ipairs(content) do
        if line:match('^description:') then
          description = line:gsub('^description:%s*', '')
          break
        end
      end

      agents[agent_name] = {
        file = file,
        description = description,
        name = agent_name
      }
    end
  end

  return agents
end

-- ========================
-- MAPEO INTELIGENTE DE AGENTES POR PROYECTO
-- ========================

local function detect_project_type()
  local cwd = vim.fn.getcwd()
  local indicators = {
    -- React/Next.js
    {
      files = {"package.json"},
      check = function()
        local package_json = cwd .. "/package.json"
        if vim.fn.filereadable(package_json) == 1 then
          local content = table.concat(vim.fn.readfile(package_json), "\n")
          if content:match('"next"') then
            return "scope-rule-architect-nextjs", "Next.js con App Router"
          elseif content:match('"react"') then
            return "scope-rule-architect-react", "React con TypeScript"
          elseif content:match('"@angular/core"') then
            return "scope-rule-architect-angular", "Angular con Clean Architecture"
          elseif content:match('"astro"') then
            return "scope-rule-architect-astro", "Astro con Islands"
          else
            return "software-architect", "Node.js/TypeScript"
          end
        end
        return nil
      end
    },
    -- Python
    {
      files = {"requirements.txt", "pyproject.toml", "Pipfile", "setup.py"},
      agent = "software-architect",
      description = "Proyecto Python"
    },
    -- Angular específico
    {
      files = {"angular.json"},
      agent = "angular-expert-architect",
      description = "Angular con Clean Architecture"
    },
    -- Go
    {
      files = {"go.mod", "go.sum"},
      agent = "software-architect",
      description = "Proyecto Go"
    },
    -- Rust
    {
      files = {"Cargo.toml"},
      agent = "software-architect",
      description = "Proyecto Rust"
    },
    -- Java
    {
      files = {"pom.xml", "build.gradle"},
      agent = "software-architect",
      description = "Proyecto Java"
    },
    -- Neovim Lua
    {
      files = {"init.lua", "lua/"},
      check = function()
        return "general-purpose", "Configuración Neovim"
      end
    }
  }

  for _, indicator in ipairs(indicators) do
    if indicator.check then
      local agent, desc = indicator.check()
      if agent then return agent, desc end
    else
      for _, file in ipairs(indicator.files) do
        if vim.fn.filereadable(cwd .. "/" .. file) == 1 or
           vim.fn.isdirectory(cwd .. "/" .. file) == 1 then
          return indicator.agent, indicator.description
        end
      end
    end
  end

  return "general-purpose", "Proyecto general"
end

-- ========================
-- GESTIÓN DE CONTEXTO GLOBAL
-- ========================

local function get_project_context_path()
  if not CLAUDE_GLOBAL_DIR then return nil end

  local projects_dir = CLAUDE_GLOBAL_DIR .. (vim.fn.has('win32') == 1 and '\\projects' or '/projects')
  vim.fn.mkdir(projects_dir, "p")

  -- Crear identificador único del proyecto basado en path
  local cwd = vim.fn.getcwd()
  local project_id = cwd:gsub("[^%w]", "-"):gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")

  return projects_dir .. (vim.fn.has('win32') == 1 and '\\' or '/') .. project_id .. ".jsonl"
end

-- Guardar contexto en formato compatible con Claude global
local function save_global_context(prompt, agent_type, context_data)
  local context_file = get_project_context_path()
  if not context_file then return end

  local entry = {
    timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    prompt = prompt,
    agent = agent_type,
    project_path = vim.fn.getcwd(),
    project_type = detect_project_type(),
    files_context = context_data or get_current_files_context(),
    git_branch = vim.trim(vim.fn.system("git branch --show-current 2>/dev/null") or ""),
    git_status = vim.trim(vim.fn.system("git status --porcelain 2>/dev/null") or "")
  }

  -- Escribir en formato JSONL (una línea por entrada)
  local f = io.open(context_file, "a")
  if f then
    f:write(vim.fn.json_encode(entry) .. "\n")
    f:close()
  end
end

-- Cargar contexto desde archivo global
local function load_global_context(limit)
  local context_file = get_project_context_path()
  if not context_file or vim.fn.filereadable(context_file) == 0 then
    return {}
  end

  local lines = vim.fn.readfile(context_file)
  local entries = {}

  -- Procesar últimas N entradas
  local start_idx = math.max(1, #lines - (limit or 10) + 1)
  for i = start_idx, #lines do
    local success, entry = pcall(vim.fn.json_decode, lines[i])
    if success then
      table.insert(entries, entry)
    end
  end

  return entries
end

-- ========================
-- FUNCIONES PRINCIPALES
-- ========================

-- Obtener agente recomendado
function M.get_recommended_agent()
  local available_agents = load_available_agents()
  local project_agent, project_desc = detect_project_type()

  -- Verificar si el agente recomendado existe en la configuración
  if available_agents[project_agent] then
    return {
      agent = project_agent,
      description = project_desc,
      available = true,
      file = available_agents[project_agent].file
    }
  else
    -- Fallback a general-purpose si está disponible
    for name, info in pairs(available_agents) do
      if name:match("general") then
        return {
          agent = name,
          description = "Agente de propósito general",
          available = true,
          file = info.file
        }
      end
    end

    -- Si no hay agentes disponibles
    return {
      agent = project_agent,
      description = project_desc,
      available = false,
      file = nil
    }
  end
end

-- Crear prompt contextualizado con historial global
function M.create_contextual_prompt(base_prompt, include_history)
  local agent_info = M.get_recommended_agent()
  local project_type, project_desc = detect_project_type()
  local files_context = get_current_files_context()

  local context_prompt = string.format([[
🤖 CONTEXTO DEL PROYECTO:
- Tipo: %s (%s)
- Agente recomendado: %s %s
- Directorio: %s
- Claude Global: %s

📁 ARCHIVOS ACTUALES:
%s

🎯 TAREA: %s
]],
    project_type,
    project_desc,
    agent_info.agent,
    agent_info.available and "✅" or "❌ (no disponible)",
    vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
    CLAUDE_GLOBAL_DIR and "✅ Detectado" or "❌ No encontrado",
    #files_context > 0 and table.concat(vim.tbl_map(function(f)
      return "- " .. f.path .. (f.modified and " (modificado)" or "")
    end, files_context), "\n") or "- Ninguno",
    base_prompt
  )

  if include_history and CLAUDE_GLOBAL_DIR then
    local history = load_global_context(3)
    if #history > 0 then
      context_prompt = context_prompt .. "\n\n📚 HISTORIAL RECIENTE:\n" ..
        table.concat(vim.tbl_map(function(h)
          return string.format("- [%s] %s (Agente: %s)",
                             h.timestamp,
                             h.prompt:sub(1, 80) .. "...",
                             h.agent)
        end, history), "\n")
    end
  end

  return context_prompt, agent_info
end

-- Guardar prompt en historial global
function M.save_prompt_history(prompt, agent_type, context_data)
  if CLAUDE_GLOBAL_DIR then
    save_global_context(prompt, agent_type, context_data)
  end
end

-- Mostrar información del sistema
function M.show_system_info()
  local agent_info = M.get_recommended_agent()
  local available_agents = load_available_agents()

  local info = string.format([[
🏠 CONFIGURACIÓN CLAUDE:
- Directorio global: %s
- Agentes disponibles: %d
- Proyecto detectado: %s
- Agente recomendado: %s %s

📋 AGENTES DISPONIBLES:
%s
]],
    CLAUDE_GLOBAL_DIR or "❌ No encontrado",
    vim.tbl_count(available_agents),
    detect_project_type(),
    agent_info.agent,
    agent_info.available and "✅" or "❌",
    next(available_agents) and table.concat(vim.tbl_map(function(name)
      return "- " .. name
    end, vim.tbl_keys(available_agents)), "\n") or "- Ninguno disponible"
  )

  vim.notify(info, vim.log.levels.INFO, {
    title = "Claude System Info",
    timeout = 10000
  })
end

-- Configuración inicial
M.setup = function()
  local agent_info = M.get_recommended_agent()
  local project_type = detect_project_type()

  vim.notify(string.format("🤖 Claude Global configurado\n📁 Proyecto: %s\n🎯 Agente: %s %s\n🏠 Global: %s",
    project_type,
    agent_info.agent,
    agent_info.available and "✅" or "❌",
    CLAUDE_GLOBAL_DIR and "✅" or "❌"
  ), vim.log.levels.INFO, {
    title = "Claude Global",
    timeout = 3000
  })
end

-- Obtener contexto de archivos actuales
function get_current_files_context()
  local buffers = vim.api.nvim_list_bufs()
  local files = {}

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
      local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
      if not file_name:match("^term://") and file_name ~= "" then
        table.insert(files, {
          path = file_name,
          modified = vim.api.nvim_buf_get_option(buf, "modified"),
          filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        })
      end
    end
  end

  return files
end

return M