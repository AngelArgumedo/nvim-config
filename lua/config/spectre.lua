-- =========================
-- Configuración de Spectre (Find & Replace potente)
-- Buscar y reemplazar en todo el proyecto con preview
-- =========================

local spectre = require("spectre")

spectre.setup({
  color_devicons = true,
  open_cmd = "vnew",
  live_update = false, -- auto ejecutar búsqueda cuando cambies query
  line_sep_start = "┌─────────────────────────────────────────",
  result_padding = "│  ",
  line_sep = "└─────────────────────────────────────────",
  highlight = {
    ui = "String",
    search = "DiffChange",
    replace = "DiffDelete"
  },
  mapping = {
    ["toggle_line"] = {
      map = "dd",
      cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
      desc = "toggle item"
    },
    ["enter_file"] = {
      map = "<cr>",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
      desc = "ir al archivo"
    },
    ["send_to_qf"] = {
      map = "<leader>q",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "enviar todo a quickfix"
    },
    ["replace_cmd"] = {
      map = "<leader>c",
      cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
      desc = "comando de entrada de reemplazo"
    },
    ["show_option_menu"] = {
      map = "<leader>o",
      cmd = "<cmd>lua require('spectre').show_options()<CR>",
      desc = "mostrar opciones"
    },
    ["run_current_replace"] = {
      map = "<leader>rc",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "reemplazar actual"
    },
    ["run_replace"] = {
      map = "<leader>R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "reemplazar todo"
    },
    ["change_view_mode"] = {
      map = "<leader>v",
      cmd = "<cmd>lua require('spectre').change_view()<CR>",
      desc = "cambiar modo de vista"
    },
    ["change_replace_sed"] = {
      map = "trs",
      cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
      desc = "usar sed para reemplazar"
    },
    ["change_replace_oxi"] = {
      map = "tro",
      cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
      desc = "usar oxi para reemplazar"
    },
    ["toggle_live_update"] = {
      map = "tu",
      cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
      desc = "toggle actualización en vivo"
    },
    ["toggle_ignore_case"] = {
      map = "ti",
      cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
      desc = "toggle ignorar mayúsculas"
    },
    ["toggle_ignore_hidden"] = {
      map = "th",
      cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
      desc = "toggle archivos ocultos"
    },
    ["resume_last_search"] = {
      map = "<leader>l",
      cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
      desc = "reanudar última búsqueda"
    },
  },
  find_engine = {
    -- rg is map with finder_cmd
    ["rg"] = {
      cmd = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      options = {
        ["ignore-case"] = {
          value = "--ignore-case",
          icon = "[I]",
          desc = "ignore case"
        },
        ["hidden"] = {
          value = "--hidden",
          desc = "hidden file",
          icon = "[H]"
        },
        -- puedes especificar tipos de archivo
        ["type"] = {
          value = "--type",
          desc = "file type",
          icon = "[T]"
        },
      }
    },
    ["ag"] = {
      cmd = "ag",
      args = {
        "--vimgrep",
        "-s"
      },
      options = {
        ["ignore-case"] = {
          value = "-i",
          icon = "[I]",
          desc = "ignore case"
        },
        ["hidden"] = {
          value = "--hidden",
          desc = "hidden file",
          icon = "[H]"
        },
      }
    },
  },
  replace_engine = {
    ["sed"] = {
      cmd = "sed",
      args = nil,
      options = {
        ["ignore-case"] = {
          value = "--ignore-case",
          icon = "[I]",
          desc = "ignore case"
        },
      }
    },
    -- llamar a oxi desde lua para obtener un mejor rendimiento
    ["oxi"] = {
      cmd = "oxi",
      args = {},
      options = {
        ["ignore-case"] = {
          value = "i",
          icon = "[I]",
          desc = "ignore case"
        },
      }
    }
  },
  default = {
    find = {
      --pick entre 'ag' y 'rg'
      cmd = "rg",
      options = {"ignore-case"}
    },
    replace = {
      --pick entre 'sed' y 'oxi'
      cmd = "sed"
    }
  },
  replace_vim_cmd = "cdo",
  is_open = false,
  is_insert_mode = false  -- start in insert mode
})

-- Keymaps principales para Spectre
local keymap = vim.keymap.set

-- Abrir Spectre en ventana completa
keymap("n", "<leader>S", function()
  spectre.toggle()
end, { desc = "🔍 Toggle Spectre" })

-- Buscar palabra actual
keymap("n", "<leader>sw", function()
  spectre.open_visual({ select_word = true })
end, { desc = "🔍 Buscar palabra actual" })

-- Buscar en archivo actual
keymap("n", "<leader>sp", function()
  spectre.open_file_search({ select_word = true })
end, { desc = "🔍 Buscar en archivo actual" })

-- Buscar selección en modo visual
keymap("v", "<leader>sw", function()
  spectre.open_visual()
end, { desc = "🔍 Buscar selección" })

-- Funciones auxiliares personalizadas
local function spectre_in_directory()
  vim.ui.input({
    prompt = "Directorio para buscar: ",
    default = vim.fn.getcwd(),
    completion = "dir",
  }, function(dir)
    if dir then
      spectre.open({
        path = dir
      })
    end
  end)
end

local function spectre_by_filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    vim.notify("Tipo de archivo no detectado", vim.log.levels.WARN)
    return
  end

  local extensions = {
    javascript = "js",
    typescript = "ts",
    python = "py",
    lua = "lua",
    html = "html",
    css = "css",
    json = "json",
    markdown = "md",
  }

  local ext = extensions[ft] or ft
  spectre.open({
    search_text = vim.fn.expand("<cword>"),
    path = vim.fn.getcwd(),
    is_file = false,
    replace_engine = {
      options = {
        type = ext
      }
    }
  })
end

-- Keymaps adicionales
keymap("n", "<leader>sd", spectre_in_directory, { desc = "🔍 Spectre en directorio" })
keymap("n", "<leader>st", spectre_by_filetype, { desc = "🔍 Spectre por tipo de archivo" })

-- Función para búsqueda de patrones comunes
local function common_patterns()
  local patterns = {
    "TODO:",
    "FIXME:",
    "BUG:",
    "NOTE:",
    "HACK:",
    "XXX:",
    "console.log",
    "print(",
    "debugger",
    "eslint-disable",
  }

  vim.ui.select(patterns, {
    prompt = "Seleccionar patrón a buscar:",
    format_item = function(item)
      return "🔍 " .. item
    end,
  }, function(choice)
    if choice then
      spectre.open({
        search_text = choice,
        replace_text = "",
      })
    end
  end)
end

keymap("n", "<leader>sc", common_patterns, { desc = "🔍 Buscar patrones comunes" })

-- Comando para configuraciones rápidas
vim.api.nvim_create_user_command("SpectreConfig", function(opts)
  local config = opts.args

  if config == "case-sensitive" then
    spectre.change_options("ignore-case")
    vim.notify("🔍 Búsqueda sensible a mayúsculas", vim.log.levels.INFO)
  elseif config == "hidden" then
    spectre.change_options("hidden")
    vim.notify("🔍 Incluir archivos ocultos", vim.log.levels.INFO)
  elseif config == "live" then
    spectre.toggle_live_update()
    vim.notify("🔍 Actualización en vivo toggled", vim.log.levels.INFO)
  else
    vim.notify("Opciones: case-sensitive, hidden, live", vim.log.levels.INFO)
  end
end, {
  nargs = 1,
  complete = function()
    return { "case-sensitive", "hidden", "live" }
  end,
  desc = "Configurar opciones de Spectre"
})

-- Auto-comando para configurar highlights personalizados
vim.api.nvim_create_autocmd("FileType", {
  pattern = "spectre_panel",
  group = vim.api.nvim_create_augroup("spectre_config", { clear = true }),
  callback = function()
    -- Configurar buffer específico
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = true

    -- Highlights personalizados
    vim.api.nvim_set_hl(0, "SpectreSearch", { fg = "#ff9e64", bold = true })
    vim.api.nvim_set_hl(0, "SpectreReplace", { fg = "#9ece6a", bold = true })
    vim.api.nvim_set_hl(0, "SpectreFile", { fg = "#7aa2f7", bold = true })

    -- Mapeos adicionales para el buffer de Spectre
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", opts)
  end,
})

-- Integración con which-key si está disponible
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>s", group = "Search & Replace" },
    { "<leader>S", desc = "🔍 Spectre Toggle" },
    { "<leader>sw", desc = "🔍 Search Word" },
    { "<leader>sp", desc = "🔍 Search in File" },
    { "<leader>sd", desc = "🔍 Search in Directory" },
    { "<leader>st", desc = "🔍 Search by Filetype" },
    { "<leader>sc", desc = "🔍 Common Patterns" },
  })
end

vim.notify("🔍 Spectre configurado - Find & Replace potente activado", vim.log.levels.INFO, {
  title = "Spectre",
  timeout = 2000,
})