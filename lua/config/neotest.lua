-- =========================
-- Configuración de Neotest (Testing integrado)
-- Ejecutar y visualizar tests desde Neovim
-- =========================

local neotest = require("neotest")

-- Configurar adaptadores de forma condicional
local adapters = {}

-- JavaScript/TypeScript con Jest (solo si el adaptador está disponible)
local jest_ok, neotest_jest = pcall(require, "neotest-jest")
if jest_ok then
  table.insert(adapters, neotest_jest({
    jestCommand = "npm test --",
    jestConfigFile = function(file)
      -- Buscar configuración de Jest en el proyecto
      if vim.fn.filereadable(vim.fn.getcwd() .. "/jest.config.js") == 1 then
        return vim.fn.getcwd() .. "/jest.config.js"
      elseif vim.fn.filereadable(vim.fn.getcwd() .. "/jest.config.ts") == 1 then
        return vim.fn.getcwd() .. "/jest.config.ts"
      end
      return nil
    end,
    env = { CI = true },
    cwd = function(path)
      return vim.fn.getcwd()
    end,
  }))
end

-- Python con pytest (solo si el adaptador está disponible)
local python_ok, neotest_python = pcall(require, "neotest-python")
if python_ok then
  table.insert(adapters, neotest_python({
    dap = { justMyCode = false },
    runner = "pytest",
    python = function()
      -- Detectar entorno virtual
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      elseif vim.fn.executable(cwd .. "/venv/Scripts/python.exe") == 1 then
        return cwd .. "/venv/Scripts/python.exe"
      elseif vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
        return cwd .. "/.venv/Scripts/python.exe"
      else
        return "python"
      end
    end,
    pytest_discover_instances = true,
  }))
end

-- Go tests (solo si el adaptador está disponible)
local go_ok, neotest_go = pcall(require, "neotest-go")
if go_ok then
  table.insert(adapters, neotest_go({
    experimental = {
      test_table = true,
    },
    args = { "-count=1", "-timeout=60s" }
  }))
end

-- Rust tests (solo si el adaptador está disponible)
local rust_ok, neotest_rust = pcall(require, "neotest-rust")
if rust_ok then
  table.insert(adapters, neotest_rust({
    args = { "--no-capture" },
    dap_adapter = "lldb",
  }))
end

-- Si no hay adaptadores disponibles, mostrar mensaje informativo
if #adapters == 0 then
  vim.notify("ℹ️ No se encontraron adaptadores de Neotest. Los adaptadores se instalarán según el tipo de archivo.",
            vim.log.levels.INFO, { title = "Neotest" })
end

neotest.setup({
  adapters = adapters,

  -- Configuración general
  benchmark = {
    enabled = true
  },
  consumers = {},
  default_strategy = "integrated",
  diagnostic = {
    enabled = true,
    severity = 1,
  },
  discovery = {
    concurrent = 1,
    enabled = true,
  },
  floating = {
    border = "rounded",
    max_height = 0.6,
    max_width = 0.6,
    options = {}
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestWinSelect",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown",
    watching = "NeotestWatching",
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    notify = "",
    passed = "",
    running = "",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "",
    unknown = "",
    watching = "",
  },
  jump = {
    enabled = true
  },
  log_level = 3,
  output = {
    enabled = true,
    open_on_run = "short",
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15",
  },
  projects = {},
  quickfix = {
    enabled = true,
    open = false,
  },
  run = {
    enabled = true,
  },
  running = {
    concurrent = true,
  },
  state = {
    enabled = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false,
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120,
    },
  },
  summary = {
    animated = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      debug = "d",
      debug_marked = "D",
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      help = "?",
      jumpto = "i",
      mark = "m",
      next_failed = "J",
      output = "o",
      prev_failed = "K",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t",
      watch = "w",
    },
    open = "botright vsplit | vertical resize 50"
  },
  watch = {
    enabled = true,
    symbol_queries = {
      go = "        ;query\n        ;Captures imported types\n        (qualified_type name: (type_identifier) @symbol)\n        ;Captures package-local and built-in types\n        (type_identifier)@symbol\n        ;Captures imported function calls\n        (selector_expression field: (field_identifier) @symbol)\n        ;Captures package-local functions\n        (identifier)@symbol \n      ",
      javascript = "  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default imports\n  (import_default_specifier name: (identifier) @symbol)\n  ;Captures namespace imports\n  (namespace_import name: (identifier) @symbol)\n  ;Captures re-assigned exports\n  (export_specifier name: (identifier) @symbol)\n  ;Captures variable declarations\n  (variable_declarator name: (identifier) @symbol)\n  ;Captures function declarations\n  (function_declaration name: (identifier) @symbol)\n  ;Captures method definitions\n  (method_definition name: (property_identifier) @symbol)\n  ",
      lua = "        ;query\n        ;Captures module names in require calls\n        (function_call name: ((identifier) @function (#eq? @function \"require\")) arguments: ((arguments (string) @symbol)))\n      ",
      python = "        ;query\n        ;Captures imports and modules they're imported from\n        (import_from_statement module_name: (dotted_name) @symbol)\n        (import_statement name: (dotted_name) @symbol)\n        (aliased_import name: (dotted_name) @symbol)\n        ;Captures function definitions\n        (function_definition name: (identifier) @symbol)\n        ;Captures class definitions\n        (class_definition name: (identifier) @symbol)\n      ",
      ruby = "        ;query\n        ;rspec - class name\n        (call\n          method: (identifier) @_ (#match? @_ \"(describe|context)\")\n          arguments: (argument_list (constant) @symbol )\n        )\n        ;rspec - namespaced class name\n        (call\n          method: (identifier) @_ (#match? @_ \"(describe|context)\")\n          arguments: (argument_list (scope_resolution name: (constant) @symbol) )\n        )\n      ",
      rust = "        ;query\n        ;submodule import\n        (mod_item\n          name: (identifier) @symbol)\n        ;single import\n        (use_declaration\n          argument: (scoped_identifier\n            name: (identifier) @symbol))\n        ;import list\n        (use_declaration\n          argument: (scoped_use_list\n            list: (use_list\n              [(scoped_identifier\n                 path: (identifier)\n                 name: (identifier) @symbol)\n               (identifier) @symbol])))\n        ;wildcard import\n        (use_declaration\n          argument: (scoped_use_list\n            path: (identifier)\n            list: (use_list\n              [(scoped_identifier\n                 path: (identifier)\n                 name: (identifier) @symbol)\n               (identifier) @symbol])))\n      ",
      typescript = "  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default imports\n  (import_default_specifier name: (identifier) @symbol)\n  ;Captures namespace imports\n  (namespace_import name: (identifier) @symbol)\n  ;Captures re-assigned exports\n  (export_specifier name: (identifier) @symbol)\n  ;Captures variable declarations\n  (variable_declarator name: (identifier) @symbol)\n  ;Captures function declarations\n  (function_declaration name: (identifier) @symbol)\n  ;Captures method definitions\n  (method_definition name: (property_identifier) @symbol)\n  ;Captures interface declarations\n  (interface_declaration name: (type_identifier) @symbol)\n  ;Captures type alias declarations\n  (type_alias_declaration name: (type_identifier) @symbol)\n  ;Captures enum declarations\n  (enum_declaration name: (identifier) @symbol)\n  ;Captures class declarations\n  (class_declaration name: (type_identifier) @symbol)\n  ;Captures method signatures\n  (method_signature name: (property_identifier) @symbol)\n  ;Captures abstract method signatures\n  (abstract_method_signature name: (property_identifier) @symbol)\n  "
    }
  }
})

-- Configurar highlights personalizados
vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#e0af68" })
vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#f7768e" })
vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#565f89" })
vim.api.nvim_set_hl(0, "NeotestTest", { fg = "#c0caf5" })
vim.api.nvim_set_hl(0, "NeotestNamespace", { fg = "#bb9af7" })
vim.api.nvim_set_hl(0, "NeotestFocused", { fg = "#ff9e64" })
vim.api.nvim_set_hl(0, "NeotestFile", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "NeotestDir", { fg = "#7dcfff" })
vim.api.nvim_set_hl(0, "NeotestBorder", { fg = "#565f89" })
vim.api.nvim_set_hl(0, "NeotestIndent", { fg = "#414868" })
vim.api.nvim_set_hl(0, "NeotestExpandMarker", { fg = "#565f89" })
vim.api.nvim_set_hl(0, "NeotestAdapterName", { fg = "#bb9af7", bold = true })
vim.api.nvim_set_hl(0, "NeotestWinSelect", { fg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "NeotestMarked", { fg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "NeotestTarget", { fg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "NeotestUnknown", { fg = "#565f89" })
vim.api.nvim_set_hl(0, "NeotestWatching", { fg = "#e0af68" })

-- Keymaps para Neotest
local keymap = vim.keymap.set

-- Ejecutar tests
keymap("n", "<leader>tr", function()
  neotest.run.run()
end, { desc = "🧪 Ejecutar test más cercano" })

keymap("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "🧪 Ejecutar tests del archivo" })

keymap("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, { desc = "🧪 Debug test más cercano" })

keymap("n", "<leader>ta", function()
  neotest.run.run(vim.fn.getcwd())
end, { desc = "🧪 Ejecutar todos los tests" })

-- Gestión de tests
keymap("n", "<leader>ts", function()
  neotest.run.stop()
end, { desc = "🧪 Detener tests" })

keymap("n", "<leader>tw", function()
  neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "🧪 Watch archivo actual" })

-- Navegación de tests
keymap("n", "<leader>to", function()
  neotest.output.open({ enter = true, auto_close = true })
end, { desc = "🧪 Ver output del test" })

keymap("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, { desc = "🧪 Toggle panel de output" })

keymap("n", "<leader>tS", function()
  neotest.summary.toggle()
end, { desc = "🧪 Toggle resumen de tests" })

-- Navegación entre tests
keymap("n", "]t", function()
  neotest.jump.next({ status = "failed" })
end, { desc = "🧪 Próximo test fallido" })

keymap("n", "[t", function()
  neotest.jump.prev({ status = "failed" })
end, { desc = "🧪 Test fallido anterior" })

-- Funciones auxiliares personalizadas
local function run_tests_by_pattern()
  vim.ui.input({
    prompt = "Patrón de test a ejecutar: ",
    default = "",
  }, function(pattern)
    if pattern and pattern ~= "" then
      neotest.run.run({
        suite = false,
        extra_args = { "--grep", pattern }
      })
    end
  end)
end

local function run_test_file_with_coverage()
  local file = vim.fn.expand("%")
  neotest.run.run({
    file,
    extra_args = { "--coverage" }
  })
end

keymap("n", "<leader>tp", run_tests_by_pattern, { desc = "🧪 Ejecutar tests por patrón" })
keymap("n", "<leader>tc", run_test_file_with_coverage, { desc = "🧪 Ejecutar con coverage" })

-- Auto-comandos para mejorar experiencia
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neotest-output", "neotest-summary", "neotest-output-panel" },
  group = vim.api.nvim_create_augroup("neotest_config", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Función para configuración rápida según el proyecto
local function setup_project_tests()
  local cwd = vim.fn.getcwd()
  local package_json = cwd .. "/package.json"
  local pytest_ini = cwd .. "/pytest.ini"
  local cargo_toml = cwd .. "/Cargo.toml"

  if vim.fn.filereadable(package_json) == 1 then
    vim.notify("📦 Proyecto JavaScript/TypeScript detectado", vim.log.levels.INFO, {
      title = "Neotest"
    })
  elseif vim.fn.filereadable(pytest_ini) == 1 then
    vim.notify("🐍 Proyecto Python detectado", vim.log.levels.INFO, {
      title = "Neotest"
    })
  elseif vim.fn.filereadable(cargo_toml) == 1 then
    vim.notify("🦀 Proyecto Rust detectado", vim.log.levels.INFO, {
      title = "Neotest"
    })
  end
end

-- Configurar automáticamente al entrar en un proyecto
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("neotest_project_setup", { clear = true }),
  callback = function()
    vim.defer_fn(setup_project_tests, 1000)
  end,
})

-- Comando para limpiar resultados de tests
vim.api.nvim_create_user_command("TestClean", function()
  neotest.run.stop()
  neotest.output_panel.clear()
  vim.notify("🧹 Resultados de tests limpiados", vim.log.levels.INFO, {
    title = "Neotest"
  })
end, { desc = "Limpiar resultados de tests" })

-- Integración con which-key
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>t", group = "Tests" },
    { "<leader>tr", desc = "🧪 Run Nearest" },
    { "<leader>tf", desc = "🧪 Run File" },
    { "<leader>td", desc = "🧪 Debug Test" },
    { "<leader>ta", desc = "🧪 Run All" },
    { "<leader>ts", desc = "🧪 Stop" },
    { "<leader>tw", desc = "🧪 Watch" },
    { "<leader>to", desc = "🧪 Output" },
    { "<leader>tO", desc = "🧪 Output Panel" },
    { "<leader>tS", desc = "🧪 Summary" },
    { "<leader>tp", desc = "🧪 Pattern" },
    { "<leader>tc", desc = "🧪 Coverage" },
  })
end

-- Solo mostrar mensaje si hay adaptadores configurados
if #adapters > 0 then
  vim.notify(string.format("🧪 Neotest configurado con %d adaptador(es)", #adapters), vim.log.levels.INFO, {
    title = "Neotest",
    timeout = 2000,
  })
end