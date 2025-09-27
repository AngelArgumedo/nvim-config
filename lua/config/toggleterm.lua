-- =========================
-- ToggleTerm Enhanced Configuration
-- Terminal persistente con múltiples funcionalidades
-- =========================

local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

-- Configuración principal con mejoras visuales
toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float",
  close_on_exit = false, -- Mantener terminal abierta después de comandos
  shell = vim.o.shell,
  auto_scroll = true,

  -- Mejoras visuales
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.85),
    height = math.floor(vim.o.lines * 0.85),
    winblend = 0, -- Sin transparencia
    highlights = {
      border = "Normal",
      background = "Normal",
    },
    title_pos = "center",
  },

  -- Configuración de ventanas
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return string.format(" Terminal #%d ", term.id)
    end
  },
})

-- Función para obtener directorio inteligente
local function get_smart_dir()
  local current_file = vim.fn.expand("%:p")
  if current_file ~= "" then
    local file_dir = vim.fn.fnamemodify(current_file, ":h")
    -- Si estamos en un proyecto git, usar la raíz del repositorio
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(file_dir) .. " rev-parse --show-toplevel")[1]
    if git_root and git_root ~= "" and vim.v.shell_error == 0 then
      return git_root
    end
    return file_dir
  end
  return vim.fn.getcwd()
end

-- Almacenar terminales persistentes
local terminals = {}

-- Función para crear o obtener terminal numerada
local function get_or_create_terminal(num, direction, cmd)
  if not terminals[num] then
    local dir = get_smart_dir()
    terminals[num] = Terminal:new({
      id = num,
      cmd = cmd,
      dir = dir,
      direction = direction or "float",
      close_on_exit = false,
      on_open = function(term)
        vim.cmd("startinsert!")
        -- Actualizar título con información útil
        local title = string.format("Terminal #%d - %s", num, vim.fn.fnamemodify(dir, ":t"))
        vim.api.nvim_buf_set_var(term.bufnr, "term_title", title)
      end,
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
      on_stdout = function(term, job, data, name)
        -- Auto-scroll al final
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(term.bufnr) then
            local win = vim.fn.bufwinid(term.bufnr)
            if win ~= -1 then
              vim.api.nvim_win_set_cursor(win, {vim.api.nvim_buf_line_count(term.bufnr), 0})
            end
          end
        end)
      end,
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.85),
        winblend = 0,
        title = string.format(" Terminal #%d ", num),
        title_pos = "center",
      },
    })
  end
  return terminals[num]
end

-- Terminal dedicado para Claude (mejorado)
local claude_terminal = Terminal:new({
  cmd = "claude",
  direction = "float",
  close_on_exit = false,
  dir = get_smart_dir(),
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
    winblend = 0,
    title = " 🤖 Claude Code ",
    title_pos = "center",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    -- Configuración específica para Claude
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

-- Función para listar terminales activas
local function list_terminals()
  local active_terms = {}
  for id, term in pairs(terminals) do
    if term:is_open() then
      table.insert(active_terms, string.format("Terminal #%d (%s)", id, term.dir))
    end
  end

  if #active_terms > 0 then
    vim.notify("🖥️  Terminales activas:\n• " .. table.concat(active_terms, "\n• "),
              vim.log.levels.INFO, { title = "Terminales" })
  else
    vim.notify("📭 No hay terminales activas", vim.log.levels.INFO, { title = "Terminales" })
  end
end

-- Función para enviar comando a terminal específica
local function send_command_to_terminal(num, cmd)
  local term = terminals[num]
  if term and term:is_open() then
    term:send(cmd)
    term:focus()
  else
    vim.notify("Terminal #" .. num .. " no está abierta", vim.log.levels.WARN)
  end
end

-- Sistema de autocompletado inteligente
local command_suggestions = {
  -- Git commands
  git = {
    "git status",
    "git add .",
    "git add -A",
    "git commit -m \"\"",
    "git commit --amend",
    "git push",
    "git push origin main",
    "git pull",
    "git branch",
    "git checkout -b ",
    "git merge ",
    "git log --oneline",
    "git diff",
    "git stash",
    "git stash pop",
    "git reset --hard HEAD",
  },
  -- NPM commands
  npm = {
    "npm install",
    "npm run dev",
    "npm run build",
    "npm run test",
    "npm run start",
    "npm run lint",
    "npm run format",
    "npm update",
    "npm audit",
    "npm audit fix",
    "npm ls",
    "npm init",
  },
  -- Python commands
  python = {
    "python -m venv venv",
    "python -m pip install --upgrade pip",
    "pip install -r requirements.txt",
    "pip install ",
    "pip freeze > requirements.txt",
    "python main.py",
    "python -m pytest",
    "python -m flake8",
    "python -m black .",
  },
  -- Docker commands
  docker = {
    "docker ps",
    "docker ps -a",
    "docker images",
    "docker build -t ",
    "docker run -it ",
    "docker exec -it ",
    "docker stop ",
    "docker rm ",
    "docker rmi ",
    "docker-compose up",
    "docker-compose down",
    "docker-compose logs",
  },
  -- File operations
  file = {
    "ls -la",
    "cd ..",
    "cd ",
    "mkdir ",
    "touch ",
    "rm ",
    "cp ",
    "mv ",
    "find . -name ",
    "grep -r ",
    "cat ",
    "head ",
    "tail ",
  },
  -- Neovim specific
  nvim = {
    "nvim .",
    "nvim init.lua",
    "nvim package.json",
    "nvim README.md",
    "nvim .gitignore",
  }
}

-- Función para obtener sugerencias contextuales
local function get_contextual_suggestions()
  local suggestions = {}
  local cwd = vim.fn.getcwd()

  -- Detectar tipo de proyecto y agregar sugerencias relevantes
  if vim.fn.filereadable(cwd .. "/package.json") == 1 then
    vim.list_extend(suggestions, command_suggestions.npm)
  end

  if vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or
     vim.fn.filereadable(cwd .. "/setup.py") == 1 or
     vim.fn.isdirectory(cwd .. "/.venv") == 1 then
    vim.list_extend(suggestions, command_suggestions.python)
  end

  if vim.fn.filereadable(cwd .. "/Dockerfile") == 1 or
     vim.fn.filereadable(cwd .. "/docker-compose.yml") == 1 then
    vim.list_extend(suggestions, command_suggestions.docker)
  end

  if vim.fn.isdirectory(cwd .. "/.git") == 1 then
    vim.list_extend(suggestions, command_suggestions.git)
  end

  -- Siempre incluir comandos básicos de archivos
  vim.list_extend(suggestions, command_suggestions.file)
  vim.list_extend(suggestions, command_suggestions.nvim)

  return suggestions
end

-- Autocompletado inteligente con Telescope
local function smart_command_completion()
  local has_telescope, telescope = pcall(require, "telescope")
  if not has_telescope then
    vim.notify("Telescope no está disponible", vim.log.levels.ERROR)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local suggestions = get_contextual_suggestions()

  -- Agregar historial de comandos si está disponible
  local history_file = vim.fn.expand("~/.bash_history")
  if vim.fn.has("win32") == 1 then
    history_file = vim.fn.expand(os.getenv("APPDATA") .. "/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt")
  end

  if vim.fn.filereadable(history_file) == 1 then
    local lines = vim.fn.readfile(history_file)
    for i = #lines, math.max(1, #lines - 50), -1 do
      if lines[i] and lines[i] ~= "" and not vim.tbl_contains(suggestions, lines[i]) then
        table.insert(suggestions, 1, lines[i]) -- Agregar al inicio para prioridad
      end
    end
  end

  pickers.new({}, {
    prompt_title = "🚀 Sugerencias de Comandos Inteligentes",
    finder = finders.new_table({
      results = suggestions,
      entry_maker = function(entry)
        local category = "📁 General"
        for cat, cmds in pairs(command_suggestions) do
          if vim.tbl_contains(cmds, entry) then
            if cat == "git" then category = "🔀 Git"
            elseif cat == "npm" then category = "📦 NPM"
            elseif cat == "python" then category = "🐍 Python"
            elseif cat == "docker" then category = "🐳 Docker"
            elseif cat == "file" then category = "📁 Archivos"
            elseif cat == "nvim" then category = "⚡ Neovim"
            end
            break
          end
        end

        return {
          value = entry,
          display = string.format("%-30s %s", entry, category),
          ordinal = entry,
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local term = get_or_create_terminal(1, "float")
          term:open()
          vim.defer_fn(function()
            local cmd = selection.value
            -- Si el comando termina con espacio o comillas, posicionar cursor
            if cmd:match(' "$') or cmd:match(' $') then
              term:send(cmd)
              -- Simular backspace para posicionar cursor antes del final
              vim.defer_fn(function()
                if cmd:match(' "$') then
                  term:send('\b')
                end
              end, 50)
            else
              term:send(cmd)
            end
          end, 100)
        end
      end)

      -- Mapeo para preview de comandos
      map("i", "<C-p>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          vim.notify("💡 " .. selection.value, vim.log.levels.INFO, { title = "Preview" })
        end
      end)

      return true
    end,
  }):find()
end

-- Integración con Telescope para historial de comandos (mejorada)
local function telescope_terminal_history()
  local has_telescope, telescope = pcall(require, "telescope")
  if not has_telescope then
    vim.notify("Telescope no está disponible", vim.log.levels.ERROR)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Obtener historial de comandos del shell
  local history_file = vim.fn.expand("~/.bash_history")
  if vim.fn.has("win32") == 1 then
    history_file = vim.fn.expand(os.getenv("APPDATA") .. "/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt")
  end

  local history = {}
  if vim.fn.filereadable(history_file) == 1 then
    local lines = vim.fn.readfile(history_file)
    local seen = {}
    for i = #lines, math.max(1, #lines - 200), -1 do
      if lines[i] and lines[i] ~= "" and not seen[lines[i]] then
        table.insert(history, lines[i])
        seen[lines[i]] = true
      end
    end
  else
    -- Comandos comunes predefinidos mejorados
    history = get_contextual_suggestions()
  end

  pickers.new({}, {
    prompt_title = "📋 Historial de Comandos",
    finder = finders.new_table({
      results = history,
      entry_maker = function(entry)
        local icon = "📝"
        if entry:match("^git") then icon = "🔀"
        elseif entry:match("^npm") then icon = "📦"
        elseif entry:match("^python") or entry:match("^pip") then icon = "🐍"
        elseif entry:match("^docker") then icon = "🐳"
        elseif entry:match("^cd") or entry:match("^ls") or entry:match("^mkdir") then icon = "📁"
        elseif entry:match("^nvim") then icon = "⚡"
        end

        return {
          value = entry,
          display = icon .. " " .. entry,
          ordinal = entry,
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local term = get_or_create_terminal(1, "float")
          term:open()
          vim.defer_fn(function()
            term:send(selection.value)
          end, 100)
        end
      end)
      return true
    end,
  }):find()
end

-- ========================
-- KEYMAPS MEJORADOS
-- ========================

local keymap = vim.keymap.set

-- Claude terminal (mejorado)
keymap("n", "<leader>ac", function()
  claude_terminal:toggle()
end, { desc = "🤖 Abrir Claude" })

-- Terminales numeradas (1-5)
for i = 1, 5 do
  keymap("n", "<leader>t" .. i, function()
    get_or_create_terminal(i, "float"):toggle()
  end, { desc = "Terminal #" .. i })
end

-- Terminales por dirección
keymap("n", "<leader>tf", function()
  get_or_create_terminal(1, "float"):toggle()
end, { desc = "🪟 Terminal flotante" })

keymap("n", "<leader>th", function()
  get_or_create_terminal(2, "horizontal"):toggle()
end, { desc = "📐 Terminal horizontal" })

keymap("n", "<leader>tv", function()
  get_or_create_terminal(3, "vertical"):toggle()
end, { desc = "📏 Terminal vertical" })

-- Funcionalidades avanzadas
keymap("n", "<leader>tl", list_terminals, { desc = "📋 Listar terminales" })

keymap("n", "<leader>th", telescope_terminal_history, { desc = "🔍 Historial de comandos" })

keymap("n", "<leader>ts", smart_command_completion, { desc = "🚀 Sugerencias inteligentes" })

keymap("n", "<leader>tc", smart_command_completion, { desc = "🎯 Autocompletado de comandos" })

keymap("n", "<leader>tn", function()
  local input = vim.fn.input("Número de terminal (1-9): ")
  local num = tonumber(input)
  if num and num >= 1 and num <= 9 then
    get_or_create_terminal(num, "float"):toggle()
  else
    vim.notify("Número inválido", vim.log.levels.ERROR)
  end
end, { desc = "🔢 Nueva terminal numerada" })

-- Comandos rápidos
keymap("n", "<leader>tg", function()
  local term = get_or_create_terminal(4, "float")
  term:open()
  vim.defer_fn(function()
    term:send("git status")
  end, 100)
end, { desc = "📊 Git status" })

keymap("n", "<leader>td", function()
  local term = get_or_create_terminal(5, "float")
  term:open()
  vim.defer_fn(function()
    if vim.fn.filereadable("package.json") == 1 then
      term:send("npm run dev")
    elseif vim.fn.filereadable("requirements.txt") == 1 then
      term:send("python main.py")
    else
      term:send("ls -la")
    end
  end, 100)
end, { desc = "🚀 Dev command" })

-- Navegación mejorada en terminal
keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Terminal: ir izquierda" })
keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Terminal: ir abajo" })
keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Terminal: ir arriba" })
keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Terminal: ir derecha" })
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Salir a modo normal" })

-- Cerrar todas las terminales
keymap("n", "<leader>tq", function()
  for _, term in pairs(terminals) do
    if term:is_open() then
      term:close()
    end
  end
  claude_terminal:close()
  terminals = {}
  vim.notify("🔴 Todas las terminales cerradas", vim.log.levels.INFO)
end, { desc = "❌ Cerrar todas las terminales" })

-- Exportar funciones para uso externo
return {
  get_or_create_terminal = get_or_create_terminal,
  send_command_to_terminal = send_command_to_terminal,
  list_terminals = list_terminals,
  telescope_terminal_history = telescope_terminal_history,
  smart_command_completion = smart_command_completion,
  get_contextual_suggestions = get_contextual_suggestions,
}