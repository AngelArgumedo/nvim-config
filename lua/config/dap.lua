-- =========================
-- Configuración de DAP (Debug Adapter Protocol)
-- Debugging visual con breakpoints y variables
-- =========================

local dap = require("dap")
local dapui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Configurar virtual text para mostrar variables
dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = '<module',
  virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil
})

-- Configurar DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- Configuraciones de adaptadores por lenguaje

-- JavaScript/TypeScript (Node.js)
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.configurations.typescript = {
  {
    name = 'ts-node (Node2 with ts-node)',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = {'-r', 'ts-node/register'},
    runtimeExecutable = 'node',
    args = {'--inspect', '${file}'},
    sourceMaps = true,
    skipFiles = {'<node_internals>/**', 'node_modules/**'},
  },
  {
    name = 'Jest Tests',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = {'--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest', '--runInBand'},
    runtimeExecutable = 'node',
    args = {'${file}'},
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
  }
}

-- Python
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = "Launch file",

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
}

-- Go
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }
}

-- Rust
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

-- Configurar breakpoints con iconos
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '🔵', texthl = 'DapLogPoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

-- Configurar highlights
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#f1c40f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#a9dc76' })
vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#31352f' })
vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#e51400' })

-- Auto-abrir/cerrar DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Keymaps para debugging
local keymap = vim.keymap.set

-- Control básico de debugging
keymap("n", "<F5>", function() dap.continue() end, { desc = "🐛 Continuar/Iniciar debug" })
keymap("n", "<F10>", function() dap.step_over() end, { desc = "🐛 Step over" })
keymap("n", "<F11>", function() dap.step_into() end, { desc = "🐛 Step into" })
keymap("n", "<F12>", function() dap.step_out() end, { desc = "🐛 Step out" })

-- Breakpoints
keymap("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "🐛 Toggle breakpoint" })
keymap("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input('Condición de breakpoint: '))
end, { desc = "🐛 Breakpoint condicional" })
keymap("n", "<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = "🐛 Log point" })

-- DAP UI
keymap("n", "<leader>du", function() dapui.toggle() end, { desc = "🐛 Toggle DAP UI" })
keymap("n", "<leader>dr", function() dap.repl.open() end, { desc = "🐛 Abrir REPL" })

-- Sesiones de debugging
keymap("n", "<leader>dc", function() dap.run_to_cursor() end, { desc = "🐛 Ejecutar hasta cursor" })
keymap("n", "<leader>dt", function() dap.terminate() end, { desc = "🐛 Terminar sesión" })
keymap("n", "<leader>ds", function() dap.session() end, { desc = "🐛 Ver sesión actual" })

-- Variables y evaluación
keymap("n", "<leader>dh", function() dapui.eval() end, { desc = "🐛 Evaluar bajo cursor" })
keymap("v", "<leader>dh", function() dapui.eval() end, { desc = "🐛 Evaluar selección" })

-- Gestión de breakpoints
keymap("n", "<leader>dC", function() dap.clear_breakpoints() end, { desc = "🐛 Limpiar breakpoints" })
keymap("n", "<leader>dL", function()
  require('dap.ext.vscode').load_launchjs(nil, { node2 = {'javascript', 'typescript'} })
end, { desc = "🐛 Cargar launch.json" })

-- Funciones auxiliares personalizadas
local function debug_nearest_test()
  local ft = vim.bo.filetype

  if ft == "javascript" or ft == "typescript" then
    dap.run({
      type = 'node2',
      request = 'launch',
      cwd = vim.fn.getcwd(),
      runtimeArgs = {'--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest', '--runInBand'},
      runtimeExecutable = 'node',
      args = {'--testNamePattern', vim.fn.expand('<cword>'), '${file}'},
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    })
  elseif ft == "python" then
    dap.run({
      type = 'python',
      request = 'launch',
      name = 'Debug Test',
      module = 'pytest',
      args = {'${file}', '-v', '-s'},
    })
  end
end

local function debug_with_args()
  local args = vim.fn.input('Argumentos: ')
  local ft = vim.bo.filetype

  if ft == "python" then
    dap.run({
      type = 'python',
      request = 'launch',
      program = vim.fn.expand('%'),
      args = vim.split(args, " ", true),
    })
  elseif ft == "javascript" or ft == "typescript" then
    dap.run({
      type = 'node2',
      request = 'launch',
      program = vim.fn.expand('%'),
      args = vim.split(args, " ", true),
    })
  end
end

keymap("n", "<leader>dn", debug_nearest_test, { desc = "🐛 Debug test más cercano" })
keymap("n", "<leader>da", debug_with_args, { desc = "🐛 Debug con argumentos" })

-- Auto-comandos para mejorar experiencia
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  group = vim.api.nvim_create_augroup("dap_config", { clear = true }),
  callback = function()
    require('dap.ext.autocompl').attach()
  end,
})

-- Comando para configurar debugger rápidamente según el proyecto
vim.api.nvim_create_user_command("DebugSetup", function()
  local ft = vim.bo.filetype

  if ft == "javascript" or ft == "typescript" then
    -- Crear launch.json básico para Node.js
    local launch_json = {
      version = "0.2.0",
      configurations = {
        {
          name = "Launch Program",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true
        }
      }
    }

    local vscode_dir = vim.fn.getcwd() .. "/.vscode"
    vim.fn.mkdir(vscode_dir, "p")
    local launch_file = vscode_dir .. "/launch.json"
    local file = io.open(launch_file, "w")
    if file then
      file:write(vim.json.encode(launch_json))
      file:close()
      vim.notify("📁 launch.json creado para JavaScript/TypeScript", vim.log.levels.INFO)
    end
  elseif ft == "python" then
    vim.notify("🐍 Debugger Python configurado automáticamente", vim.log.levels.INFO)
  else
    vim.notify("ℹ️ Debugger genérico disponible", vim.log.levels.INFO)
  end
end, { desc = "Configurar debugger para el proyecto actual" })

-- Integración con which-key
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>d", group = "Debug" },
    { "<leader>db", desc = "🐛 Toggle Breakpoint" },
    { "<leader>dB", desc = "🐛 Conditional Breakpoint" },
    { "<leader>dl", desc = "🐛 Log Point" },
    { "<leader>du", desc = "🐛 Toggle UI" },
    { "<leader>dr", desc = "🐛 REPL" },
    { "<leader>dc", desc = "🐛 Run to Cursor" },
    { "<leader>dt", desc = "🐛 Terminate" },
    { "<leader>ds", desc = "🐛 Session" },
    { "<leader>dh", desc = "🐛 Hover/Eval" },
    { "<leader>dC", desc = "🐛 Clear Breakpoints" },
    { "<leader>dL", desc = "🐛 Load launch.json" },
    { "<leader>dn", desc = "🐛 Debug Test" },
    { "<leader>da", desc = "🐛 Debug with Args" },
  })
end

vim.notify("🐛 DAP configurado - Debugging visual activado", vim.log.levels.INFO, {
  title = "DAP",
  timeout = 2000,
})