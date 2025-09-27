-- =========================
-- Configuración de Telescope (Fuzzy Finder)
-- =========================

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "truncate" },
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.npm/",
      "vendor/",
      "%.DS_Store",
      "%.pyc",
      "__pycache__/",
    },
    mappings = {
      i = {
        ["<C-n>"] = "move_selection_next",
        ["<C-p>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-c>"] = "close",
        ["<Down>"] = "move_selection_next",
        ["<Up>"] = "move_selection_previous",
        ["<CR>"] = "select_default",
        ["<C-x>"] = "select_horizontal",
        ["<C-v>"] = "select_vertical",
        ["<C-t>"] = "select_tab",
        ["<C-u>"] = "preview_scrolling_up",
        ["<C-d>"] = "preview_scrolling_down",
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = false,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
        n = {
          ["dd"] = "delete_buffer",
        }
      }
    },
    colorscheme = {
      enable_preview = true,
    },
  },
  extensions = {},
})

-- Keymaps para Telescope
local keymap = vim.keymap.set

-- Función personalizada para buscar en archivo actual primero
local function grep_current_buffer_then_project()
  -- Obtener el nombre del archivo actual
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    -- Si no hay archivo actual, buscar en todo el proyecto
    builtin.live_grep()
    return
  end

  -- Buscar en el archivo actual primero
  builtin.current_buffer_fuzzy_find({
    prompt_title = "🔍 Buscar en archivo actual",
  })
end

-- Función para buscar texto con prioridad en archivo actual
local function smart_grep()
  vim.ui.select(
    {
      "Archivo actual",
      "Todo el proyecto"
    },
    {
      prompt = "¿Dónde buscar?",
      format_item = function(item)
        local icons = {
          ["Archivo actual"] = "📄",
          ["Todo el proyecto"] = "🌐"
        }
        return icons[item] .. " " .. item
      end
    },
    function(choice)
      if choice == "Archivo actual" then
        builtin.current_buffer_fuzzy_find({
          prompt_title = "🔍 Buscar en " .. vim.fn.expand("%:t"),
        })
      elseif choice == "Todo el proyecto" then
        builtin.live_grep({
          prompt_title = "🔍 Buscar en todo el proyecto",
        })
      end
    end
  )
end

-- Keymaps principales
keymap("n", "<leader>r", builtin.oldfiles, { desc = "Archivos recientes" })

-- Keymaps con prefijo 'f' para Find
keymap("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
keymap("n", "<leader>fg", smart_grep, { desc = "Buscar texto (archivo actual → proyecto)" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buscar buffers" })
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ayuda" })
keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Archivos recientes" })
keymap("n", "<leader>fc", builtin.colorscheme, { desc = "Cambiar tema" })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "Ver keymaps" })
keymap("n", "<leader>fs", builtin.grep_string, { desc = "Buscar palabra bajo cursor" })
keymap("n", "<leader>fa", builtin.current_buffer_fuzzy_find, { desc = "Buscar en archivo actual" })
keymap("n", "<leader>fp", builtin.live_grep, { desc = "Buscar en todo el proyecto" })

-- Búsquedas específicas de LSP
keymap("n", "<leader>lr", builtin.lsp_references, { desc = "LSP References" })
keymap("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP Definitions" })
keymap("n", "<leader>lt", builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
keymap("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP Implementations" })

-- Git con Telescope
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

-- ========================
-- FUNCIONES PARA CREAR ARCHIVOS
-- ========================

-- Función para crear archivo con selección de directorio
local function create_file_with_directory_picker()
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

  -- Obtener directorios del proyecto
  local function get_directories()
    local dirs = {}
    local current_dir = vim.fn.getcwd()

    -- Agregar directorio actual
    table.insert(dirs, { path = current_dir, display = "📁 . (actual)" })

    -- Buscar subdirectorios comunes
    local common_dirs = {
      "src", "lib", "components", "pages", "utils", "config", "styles",
      "assets", "public", "scripts", "docs", "tests", "__tests__", "spec"
    }

    for _, dir in ipairs(common_dirs) do
      local full_path = current_dir .. "/" .. dir
      if vim.fn.isdirectory(full_path) == 1 then
        table.insert(dirs, { path = full_path, display = "📂 " .. dir })
      end
    end

    -- Buscar otros directorios (máximo 10 para no saturar)
    local handle = io.popen('find "' .. current_dir .. '" -type d -maxdepth 2 2>/dev/null | head -10')
    if handle then
      for line in handle:lines() do
        local rel_path = line:gsub(current_dir .. "/", "")
        if rel_path ~= current_dir and not rel_path:match("%.git") and not rel_path:match("node_modules") then
          local display_name = rel_path:match("([^/]+)$") or rel_path
          if not vim.tbl_contains(vim.tbl_map(function(d) return d.display end, dirs), "📂 " .. display_name) then
            table.insert(dirs, { path = line, display = "📂 " .. display_name })
          end
        end
      end
      handle:close()
    end

    return dirs
  end

  local directories = get_directories()

  pickers.new({}, {
    prompt_title = "📁 Seleccionar directorio para nuevo archivo",
    finder = finders.new_table({
      results = directories,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.display,
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local dir_path = selection.value.path

          -- Pedir nombre del archivo
          vim.ui.input({
            prompt = "📝 Nombre del archivo: ",
            default = "",
          }, function(filename)
            if filename and filename ~= "" then
              local full_path = dir_path .. "/" .. filename

              -- Crear directorios padre si no existen
              vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")

              -- Crear y abrir el archivo
              vim.cmd("edit " .. vim.fn.fnameescape(full_path))
              vim.notify("📄 Archivo creado: " .. filename, vim.log.levels.INFO)
            end
          end)
        end
      end)
      return true
    end,
  }):find()
end

-- Función para crear archivo rápido en directorio actual
local function create_file_current_dir()
  vim.ui.input({
    prompt = "📝 Nombre del archivo (directorio actual): ",
    default = "",
  }, function(filename)
    if filename and filename ~= "" then
      local current_dir = vim.fn.getcwd()
      local full_path = current_dir .. "/" .. filename

      -- Crear directorios padre si se especifica una ruta
      vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")

      -- Crear y abrir el archivo
      vim.cmd("edit " .. vim.fn.fnameescape(full_path))
      vim.notify("📄 Archivo creado: " .. filename, vim.log.levels.INFO)
    end
  end)
end

-- Función para crear archivo en el mismo directorio que el archivo actual
local function create_file_same_dir()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("No hay archivo actual. Usando directorio de trabajo.", vim.log.levels.WARN)
    create_file_current_dir()
    return
  end

  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  local relative_dir = vim.fn.fnamemodify(current_dir, ":.")

  vim.ui.input({
    prompt = "📝 Nuevo archivo en " .. relative_dir .. ": ",
    default = "",
  }, function(filename)
    if filename and filename ~= "" then
      local full_path = current_dir .. "/" .. filename

      -- Crear y abrir el archivo
      vim.cmd("edit " .. vim.fn.fnameescape(full_path))
      vim.notify("📄 Archivo creado: " .. filename, vim.log.levels.INFO)
    end
  end)
end

-- Función para crear archivos con plantillas predefinidas
local function create_file_with_template()
  local templates = {
    { name = "JavaScript (.js)", ext = ".js", template = "// " .. vim.fn.expand("%:t") .. "\n\n" },
    { name = "TypeScript (.ts)", ext = ".ts", template = "// " .. vim.fn.expand("%:t") .. "\n\nexport {};\n" },
    { name = "React Component (.tsx)", ext = ".tsx", template = [[import React from 'react';

interface Props {}

const COMPONENT_NAME: React.FC<Props> = () => {
  return (
    <div>
      <h1>COMPONENT_NAME</h1>
    </div>
  );
};

export default COMPONENT_NAME;
]] },
    { name = "Vue Component (.vue)", ext = ".vue", template = [[<template>
  <div>
    <h1>{{ title }}</h1>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const title = ref('COMPONENT_NAME')
</script>

<style scoped>
</style>
]] },
    { name = "Python (.py)", ext = ".py", template = "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n\n" },
    { name = "Lua (.lua)", ext = ".lua", template = "-- " .. vim.fn.expand("%:t") .. "\n\n" },
    { name = "CSS (.css)", ext = ".css", template = "/* " .. vim.fn.expand("%:t") .. " */\n\n" },
    { name = "HTML (.html)", ext = ".html", template = [[<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TITLE</title>
</head>
<body>

</body>
</html>
]] },
    { name = "Markdown (.md)", ext = ".md", template = "# TITLE\n\n" },
    { name = "JSON (.json)", ext = ".json", template = "{\n  \n}\n" },
  }

  vim.ui.select(templates, {
    prompt = "🎨 Seleccionar tipo de archivo:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      vim.ui.input({
        prompt = "📝 Nombre del archivo (sin extensión): ",
        default = "",
      }, function(filename)
        if filename and filename ~= "" then
          local current_dir = vim.fn.getcwd()
          local full_filename = filename .. choice.ext
          local full_path = current_dir .. "/" .. full_filename

          -- Crear archivo
          vim.cmd("edit " .. vim.fn.fnameescape(full_path))

          -- Insertar plantilla
          local content = choice.template
          content = content:gsub("COMPONENT_NAME", filename)
          content = content:gsub("TITLE", filename)

          local lines = vim.split(content, "\n")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

          -- Posicionar cursor en lugar útil
          if choice.ext == ".tsx" or choice.ext == ".vue" then
            vim.cmd("normal! gg")
            vim.fn.search("COMPONENT_NAME")
          end

          vim.notify("🎨 " .. choice.name .. " creado: " .. full_filename, vim.log.levels.INFO)
        end
      end)
    end
  end)
end

-- ========================
-- KEYMAPS PARA CREAR ARCHIVOS
-- ========================

-- Keymaps principales para crear archivos
keymap("n", "<leader>nf", create_file_with_directory_picker, { desc = "📁 Nuevo archivo (seleccionar dir)" })
keymap("n", "<leader>nc", create_file_current_dir, { desc = "📝 Nuevo archivo (dir actual)" })
keymap("n", "<leader>ns", create_file_same_dir, { desc = "📄 Nuevo archivo (mismo dir)" })
keymap("n", "<leader>nt", create_file_with_template, { desc = "🎨 Nuevo archivo con plantilla" })

-- Atajos alternativos más cortos
keymap("n", "<leader>cf", create_file_current_dir, { desc = "📝 Crear archivo" })
keymap("n", "<leader>ct", create_file_with_template, { desc = "🎨 Crear con plantilla" })