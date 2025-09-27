-- =========================
-- Configuración de Neogen (Generación automática de documentación)
-- Genera JSDoc, docstrings, y documentación para múltiples lenguajes
-- =========================

local neogen = require("neogen")

neogen.setup({
  -- Habilitar todos los lenguajes soportados
  enabled = true,

  -- Configuración de snippet engine (compatible con vim-vsnip)
  snippet_engine = "vsnip",

  -- Configuración de input prompts
  input_after_comment = true, -- Ir al primer campo editable automáticamente

  -- Configuraciones específicas por lenguaje
  languages = {
    -- JavaScript/TypeScript - JSDoc style
    javascript = {
      template = {
        annotation_convention = "jsdoc", -- jsdoc, typescript, flow
        jsdoc = {
          { nil, "/**", { no_results = true, type = { "class", "func" } } },
          { nil, " * $1", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param {$1|any|} ${2|parameter_name|} - ${3|description|}", { type = { "func" } } },
          { nil, " * @returns {$1|any|} ${2|description|}", { type = { "func" } } },
          { nil, " * @throws {$1|Error|} ${2|description|}", { type = { "func" } } },
          { nil, " * @example", { type = { "func" } } },
          { nil, " * $1", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "class", "func" } } },
        }
      }
    },

    typescript = {
      template = {
        annotation_convention = "typescript",
        typescript = {
          { nil, "/**", { no_results = true, type = { "class", "func", "type" } } },
          { nil, " * $1", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param ${1|parameter_name|} - ${2|description|}", { type = { "func" } } },
          { nil, " * @returns ${1|description|}", { type = { "func" } } },
          { nil, " * @throws ${1|description|}", { type = { "func" } } },
          { nil, " * @example", { type = { "func" } } },
          { nil, " * ```typescript", { type = { "func" } } },
          { nil, " * $1", { type = { "func" } } },
          { nil, " * ```", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "class", "func", "type" } } },
        }
      }
    },

    -- Python - Google style docstrings
    python = {
      template = {
        annotation_convention = "google_docstrings", -- google_docstrings, numpydoc, reST
        google_docstrings = {
          { nil, '"""$1', { no_results = true, type = { "class", "func" } } },
          { nil, "", { no_results = true, type = { "func" } } },
          { nil, "${1|Summary line.|}", { no_results = true, type = { "func" } } },
          { nil, "", { no_results = true, type = { "func" } } },
          { nil, "${1|Extended description.|}", { no_results = true, type = { "func" } } },
          { nil, "", { no_results = true, type = { "func" } } },
          { nil, "Args:", { type = { "func" } } },
          { nil, "    ${1|parameter_name|} (${2|type|}): ${3|Parameter description.|}", { type = { "func" } } },
          { nil, "", { type = { "func" } } },
          { nil, "Returns:", { type = { "func" } } },
          { nil, "    ${1|type|}: ${2|Return description.|}", { type = { "func" } } },
          { nil, "", { type = { "func" } } },
          { nil, "Raises:", { type = { "func" } } },
          { nil, "    ${1|exception_type|}: ${2|Exception description.|}", { type = { "func" } } },
          { nil, "", { type = { "func" } } },
          { nil, "Example:", { type = { "func" } } },
          { nil, "    >>> ${1|example_usage|}", { type = { "func" } } },
          { nil, '"""', { no_results = true, type = { "class", "func" } } },
        }
      }
    },

    -- Go - Standard Go documentation
    go = {
      template = {
        annotation_convention = "godoc",
        godoc = {
          { nil, "// ${1|function_name|} ${2|description|}", { no_results = true, type = { "func" } } },
          { nil, "//", { no_results = true, type = { "func" } } },
          { nil, "// Parameters:", { type = { "func" } } },
          { nil, "//   ${1|parameter_name|}: ${2|description|}", { type = { "func" } } },
          { nil, "//", { type = { "func" } } },
          { nil, "// Returns:", { type = { "func" } } },
          { nil, "//   ${1|description|}", { type = { "func" } } },
        }
      }
    },

    -- Rust - Standard Rust documentation
    rust = {
      template = {
        annotation_convention = "rustdoc",
        rustdoc = {
          { nil, "/// ${1|Summary description.|}", { no_results = true, type = { "func" } } },
          { nil, "///", { no_results = true, type = { "func" } } },
          { nil, "/// # Arguments", { type = { "func" } } },
          { nil, "///", { type = { "func" } } },
          { nil, "/// * `${1|parameter_name|}` - ${2|Parameter description|}", { type = { "func" } } },
          { nil, "///", { type = { "func" } } },
          { nil, "/// # Returns", { type = { "func" } } },
          { nil, "///", { type = { "func" } } },
          { nil, "/// ${1|Return description|}", { type = { "func" } } },
          { nil, "///", { type = { "func" } } },
          { nil, "/// # Examples", { type = { "func" } } },
          { nil, "///", { type = { "func" } } },
          { nil, "/// ```", { type = { "func" } } },
          { nil, "/// ${1|example_code|}", { type = { "func" } } },
          { nil, "/// ```", { type = { "func" } } },
        }
      }
    },

    -- Lua - LuaDoc style
    lua = {
      template = {
        annotation_convention = "ldoc",
        ldoc = {
          { nil, "--- ${1|Summary description.|}", { no_results = true, type = { "func" } } },
          { nil, "-- ${2|Extended description.|}", { no_results = true, type = { "func" } } },
          { nil, "-- @param ${1|parameter_name|} ${2|type|} ${3|Parameter description|}", { type = { "func" } } },
          { nil, "-- @return ${1|type|} ${2|Return description|}", { type = { "func" } } },
          { nil, "-- @usage ${1|example_usage|}", { type = { "func" } } },
        }
      }
    },

    -- PHP - PHPDoc style
    php = {
      template = {
        annotation_convention = "phpdoc",
        phpdoc = {
          { nil, "/**", { no_results = true, type = { "func", "class" } } },
          { nil, " * ${1|Summary description.|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * ${1|Extended description.|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param ${1|type|} $${2|parameter_name|} ${3|Parameter description|}", { type = { "func" } } },
          { nil, " * @return ${1|type|} ${2|Return description|}", { type = { "func" } } },
          { nil, " * @throws ${1|Exception|} ${2|Exception description|}", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "func", "class" } } },
        }
      }
    },

    -- Java - Javadoc style
    java = {
      template = {
        annotation_convention = "javadoc",
        javadoc = {
          { nil, "/**", { no_results = true, type = { "func", "class" } } },
          { nil, " * ${1|Summary description.|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * ${1|Extended description.|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param ${1|parameter_name|} ${2|Parameter description|}", { type = { "func" } } },
          { nil, " * @return ${1|Return description|}", { type = { "func" } } },
          { nil, " * @throws ${1|Exception|} ${2|Exception description|}", { type = { "func" } } },
          { nil, " * @since ${1|version|}", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "func", "class" } } },
        }
      }
    },

    -- C/C++ - Doxygen style
    c = {
      template = {
        annotation_convention = "doxygen",
        doxygen = {
          { nil, "/**", { no_results = true, type = { "func" } } },
          { nil, " * @brief ${1|Brief description|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * ${1|Detailed description|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param ${1|parameter_name|} ${2|Parameter description|}", { type = { "func" } } },
          { nil, " * @return ${1|Return description|}", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "func" } } },
        }
      }
    },

    cpp = {
      template = {
        annotation_convention = "doxygen",
        doxygen = {
          { nil, "/**", { no_results = true, type = { "func", "class" } } },
          { nil, " * @brief ${1|Brief description|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * ${1|Detailed description|}", { no_results = true, type = { "func" } } },
          { nil, " *", { no_results = true, type = { "func" } } },
          { nil, " * @param ${1|parameter_name|} ${2|Parameter description|}", { type = { "func" } } },
          { nil, " * @return ${1|Return description|}", { type = { "func" } } },
          { nil, " * @throw ${1|exception|} ${2|Exception description|}", { type = { "func" } } },
          { nil, " */", { no_results = true, type = { "func", "class" } } },
        }
      }
    },
  }
})

-- Keymaps para Neogen
local keymap = vim.keymap.set

-- Generar documentación para función/clase
keymap("n", "<leader>nf", function()
  neogen.generate({ type = "func" })
end, { desc = "📝 Generar doc de función" })

keymap("n", "<leader>nc", function()
  neogen.generate({ type = "class" })
end, { desc = "📝 Generar doc de clase" })

keymap("n", "<leader>nt", function()
  neogen.generate({ type = "type" })
end, { desc = "📝 Generar doc de tipo" })

keymap("n", "<leader>nF", function()
  neogen.generate({ type = "file" })
end, { desc = "📝 Generar doc de archivo" })

-- Generar documentación automática (detecta el contexto)
keymap("n", "<leader>ng", function()
  neogen.generate()
end, { desc = "📝 Generar documentación automática" })

-- Funciones auxiliares personalizadas
local function generate_with_style()
  local ft = vim.bo.filetype
  local styles = {}

  if ft == "javascript" or ft == "typescript" then
    styles = { "jsdoc", "typescript" }
  elseif ft == "python" then
    styles = { "google_docstrings", "numpydoc", "reST" }
  elseif ft == "java" then
    styles = { "javadoc" }
  elseif ft == "php" then
    styles = { "phpdoc" }
  elseif ft == "c" or ft == "cpp" then
    styles = { "doxygen" }
  else
    vim.notify("Estilo de documentación no configurado para " .. ft, vim.log.levels.WARN)
    return
  end

  if #styles == 1 then
    neogen.generate({ annotation_convention = styles[1] })
  else
    vim.ui.select(styles, {
      prompt = "Seleccionar estilo de documentación:",
      format_item = function(item)
        return "📝 " .. item
      end,
    }, function(choice)
      if choice then
        neogen.generate({ annotation_convention = choice })
      end
    end)
  end
end

local function generate_enhanced_docs()
  local ft = vim.bo.filetype

  -- Templates mejorados según el contexto
  if ft == "javascript" or ft == "typescript" then
    neogen.generate({
      type = "func",
      annotation_convention = "jsdoc",
      template = {
        { nil, "/**" },
        { nil, " * ${1|Function description|}" },
        { nil, " *" },
        { nil, " * @param {${1|type|}} ${2|param|} - ${3|Parameter description|}" },
        { nil, " * @returns {${1|type|}} ${2|Return description|}" },
        { nil, " * @throws {Error} ${1|Error description|}" },
        { nil, " * @example" },
        { nil, " * // ${1|Usage example|}" },
        { nil, " * ${2|example_code|}" },
        { nil, " * @since ${1|version|}" },
        { nil, " * @author ${1|" .. os.getenv("USER") or "Author" .. "|}" },
        { nil, " */" },
      }
    })
  elseif ft == "python" then
    neogen.generate({
      type = "func",
      annotation_convention = "google_docstrings"
    })
  end
end

-- Más keymaps útiles
keymap("n", "<leader>ns", generate_with_style, { desc = "📝 Generar con estilo específico" })
keymap("n", "<leader>ne", generate_enhanced_docs, { desc = "📝 Generar documentación mejorada" })

-- Auto-comandos para configuración específica por proyecto
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = vim.api.nvim_create_augroup("neogen_config", { clear = true }),
  callback = function()
    local ft = vim.bo.filetype
    local cwd = vim.fn.getcwd()

    -- Configurar estilo automático según archivos del proyecto
    if ft == "javascript" or ft == "typescript" then
      local jsdoc_config = cwd .. "/jsdoc.json"
      local tsconfig = cwd .. "/tsconfig.json"

      if vim.fn.filereadable(tsconfig) == 1 then
        -- Proyecto TypeScript detectado
        vim.b.neogen_annotation_convention = "typescript"
      elseif vim.fn.filereadable(jsdoc_config) == 1 then
        -- Configuración JSDoc detectada
        vim.b.neogen_annotation_convention = "jsdoc"
      end
    elseif ft == "python" then
      local setup_py = cwd .. "/setup.py"
      local pyproject_toml = cwd .. "/pyproject.toml"

      if vim.fn.filereadable(setup_py) == 1 or vim.fn.filereadable(pyproject_toml) == 1 then
        -- Proyecto Python estructurado
        vim.b.neogen_annotation_convention = "google_docstrings"
      end
    end
  end,
})

-- Comandos personalizados
vim.api.nvim_create_user_command("NeogenFile", function()
  neogen.generate({ type = "file" })
end, { desc = "Generar documentación de archivo completo" })

vim.api.nvim_create_user_command("NeogenClass", function()
  neogen.generate({ type = "class" })
end, { desc = "Generar documentación de clase" })

vim.api.nvim_create_user_command("NeogenFunc", function()
  neogen.generate({ type = "func" })
end, { desc = "Generar documentación de función" })

-- Configurar highlights personalizados para la documentación
vim.api.nvim_set_hl(0, "NeogenParameter", { fg = "#ff9e64", italic = true })
vim.api.nvim_set_hl(0, "NeogenType", { fg = "#7aa2f7", bold = true })
vim.api.nvim_set_hl(0, "NeogenDescription", { fg = "#9ece6a" })

-- Función para generar documentación masiva
local function generate_docs_for_file()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local functions_found = 0

  for i, line in ipairs(lines) do
    -- Detectar funciones según el lenguaje
    local ft = vim.bo.filetype
    local is_function = false

    if ft == "javascript" or ft == "typescript" then
      is_function = line:match("^%s*function") or
                   line:match("^%s*const%s+%w+%s*=%s*function") or
                   line:match("^%s*const%s+%w+%s*=%s*%(") or
                   line:match("^%s*%w+%(.*%)%s*=>") or
                   line:match("^%s*async%s+function")
    elseif ft == "python" then
      is_function = line:match("^%s*def%s+") or line:match("^%s*async%s+def%s+")
    elseif ft == "lua" then
      is_function = line:match("^%s*function") or line:match("^%s*local%s+function")
    end

    if is_function then
      -- Verificar si ya tiene documentación
      local prev_line = i > 1 and lines[i-1] or ""
      local has_docs = prev_line:match("%*%/") or
                      prev_line:match('"""') or
                      prev_line:match("^%s*%-%-%-") or
                      prev_line:match("^%s*#")

      if not has_docs then
        vim.api.nvim_win_set_cursor(0, {i, 0})
        neogen.generate({ type = "func" })
        functions_found = functions_found + 1
      end
    end
  end

  if functions_found > 0 then
    vim.notify(string.format("📝 Documentación generada para %d funciones", functions_found),
              vim.log.levels.INFO, { title = "Neogen" })
  else
    vim.notify("ℹ️ No se encontraron funciones sin documentar",
              vim.log.levels.INFO, { title = "Neogen" })
  end
end

vim.api.nvim_create_user_command("NeogenAll", generate_docs_for_file, {
  desc = "Generar documentación para todas las funciones del archivo"
})

-- Integración con which-key si está disponible
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>n", group = "Neogen (Documentation)" },
    { "<leader>nf", desc = "📝 Generate Function Doc" },
    { "<leader>nc", desc = "📝 Generate Class Doc" },
    { "<leader>nt", desc = "📝 Generate Type Doc" },
    { "<leader>nF", desc = "📝 Generate File Doc" },
    { "<leader>ng", desc = "📝 Generate Auto Doc" },
    { "<leader>ns", desc = "📝 Generate with Style" },
    { "<leader>ne", desc = "📝 Generate Enhanced" },
  })
end

vim.notify("📝 Neogen configurado - Generación automática de documentación activada", vim.log.levels.INFO, {
  title = "Neogen",
  timeout = 2000,
})