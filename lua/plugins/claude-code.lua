-- =========================
-- Claude Code Integration
-- Integración oficial con Claude Code CLI
-- =========================

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  lazy = false,  -- Cargar inmediatamente (no lazy)

  opts = {
    terminal = {
      split_side = "right",           -- Panel a la derecha
      split_width_percentage = 0.45,  -- 45% de ancho
      provider = "snacks",            -- Usa snacks.nvim para mejor UI
    },
  },

  config = function(_, opts)
    require("claudecode").setup(opts)

    -- ========================
    -- HELPERS PERSONALIZADOS
    -- ========================

    -- Enviar línea actual con contexto completo
    local function send_current_line()
      local file = vim.fn.expand("%:.")
      local line = vim.fn.line(".")
      local total_lines = vim.fn.line("$")
      local content = vim.fn.getline(".")
      local filetype = vim.bo.filetype

      local message = string.format([[
📄 **Archivo:** `%s`
📍 **Línea:** %d de %d
🔤 **Tipo:** %s

```%s
%s
```

¿Qué necesitas saber sobre esta línea?]],
        file, line, total_lines, filetype, filetype, content
      )

      vim.fn.setreg("+", message)
      vim.cmd("ClaudeCode")

      vim.notify(
        string.format("📋 Contexto copiado\n📄 %s:%d", file, line),
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end

    -- Enviar función completa donde está el cursor
    local function send_current_function()
      -- Usar Treesitter para detectar la función
      local ts_utils = require("nvim-treesitter.ts_utils")
      local node = ts_utils.get_node_at_cursor()

      if not node then
        vim.notify("❌ No se detectó función", vim.log.levels.WARN)
        return
      end

      -- Buscar nodo de función
      while node do
        local node_type = node:type()
        if node_type:match("function") or
           node_type:match("method") or
           node_type:match("arrow_function") then
          break
        end
        node = node:parent()
      end

      if not node then
        vim.notify("❌ No estás dentro de una función", vim.log.levels.WARN)
        return
      end

      -- Obtener rango de la función
      local start_row, start_col, end_row, end_col = node:range()
      local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
      local function_code = table.concat(lines, "\n")

      local file = vim.fn.expand("%:.")
      local filetype = vim.bo.filetype

      local message = string.format([[
📄 **Archivo:** `%s`
🔧 **Función completa** (líneas %d-%d)
🔤 **Tipo:** %s

```%s
%s
```

¿Qué necesitas sobre esta función?]],
        file, start_row + 1, end_row + 1, filetype, filetype, function_code
      )

      vim.fn.setreg("+", message)
      vim.cmd("ClaudeCode")

      vim.notify(
        string.format("📋 Función copiada\n📄 %s:%d-%d", file, start_row + 1, end_row + 1),
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end

    -- Enviar rango de líneas con contexto
    local function send_line_range(start_line, end_line)
      local file = vim.fn.expand("%:.")
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      local content = table.concat(lines, "\n")
      local filetype = vim.bo.filetype

      local message = string.format([[
📄 **Archivo:** `%s`
📍 **Líneas:** %d-%d
🔤 **Tipo:** %s

```%s
%s
```

Contexto de estas líneas?]],
        file, start_line, end_line, filetype, filetype, content
      )

      vim.fn.setreg("+", message)
      vim.cmd("ClaudeCode")

      vim.notify(
        string.format("📋 Rango copiado\n📄 %s:%d-%d", file, start_line, end_line),
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end

    -- Enviar archivo completo con metadatos
    local function send_full_file_with_context()
      local file = vim.fn.expand("%:.")
      local total_lines = vim.fn.line("$")
      local filetype = vim.bo.filetype
      local modified = vim.bo.modified and "✏️ Modificado" or "✅ Guardado"

      -- Git info
      local git_branch = vim.trim(vim.fn.system("git branch --show-current 2>/dev/null") or "")
      local git_status = vim.trim(vim.fn.system("git status --porcelain " .. vim.fn.shellescape(file) .. " 2>/dev/null") or "")

      local message = string.format([[
📄 **Archivo completo:** `%s`
📊 **Total líneas:** %d
🔤 **Tipo:** %s
%s
🌳 **Branch:** %s
%s

He agregado este archivo completo al contexto. ¿Qué necesitas?]],
        file,
        total_lines,
        filetype,
        modified,
        git_branch ~= "" and git_branch or "N/A",
        git_status ~= "" and "⚠️ Cambios sin commit" or ""
      )

      -- Agregar buffer y enviar mensaje
      vim.cmd("ClaudeCodeAdd %")
      vim.fn.setreg("+", message)
      vim.cmd("ClaudeCodeFocus")

      vim.notify(
        string.format("📋 Archivo completo agregado\n📄 %s (%d líneas)", file, total_lines),
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end

    -- Enviar proyecto completo (tree)
    local function send_project_context()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      local git_branch = vim.trim(vim.fn.system("git branch --show-current 2>/dev/null") or "")

      -- Detectar tipo de proyecto
      local project_type = "General"
      if vim.fn.filereadable("package.json") == 1 then
        project_type = "Node.js/TypeScript"
      elseif vim.fn.filereadable("requirements.txt") == 1 then
        project_type = "Python"
      elseif vim.fn.filereadable("Cargo.toml") == 1 then
        project_type = "Rust"
      elseif vim.fn.filereadable("go.mod") == 1 then
        project_type = "Go"
      end

      local message = string.format([[
🏗️ **Proyecto:** %s
📂 **Tipo:** %s
🌳 **Branch:** %s
📍 **Path:** %s

He iniciado conversación sobre este proyecto. ¿En qué puedo ayudarte?]],
        project_name,
        project_type,
        git_branch ~= "" and git_branch or "N/A",
        vim.fn.getcwd()
      )

      vim.fn.setreg("+", message)
      vim.cmd("ClaudeCode")

      vim.notify(
        "🏗️ Contexto de proyecto listo\n📂 " .. project_name,
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end

    -- ========================
    -- KEYMAPS
    -- ========================

    local keymap = vim.keymap.set

    -- Grupo AI (sin conflicto con dashboard)
    keymap("n", "<leader>a", "<nop>", { desc = "+AI Claude" })

    -- Core Claude
    keymap("n", "<leader>ai", "<cmd>ClaudeCode<cr>", { desc = "🤖 Iniciar Claude" })
    keymap("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "👁️ Focus Claude" })
    keymap("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "🔄 Resume conversación" })
    keymap("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "➡️ Continuar Claude" })

    -- Enviar contexto (mejorado)
    keymap("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "📤 Enviar selección" })
    keymap("n", "<leader>al", send_current_line, { desc = "📍 Enviar línea actual" })
    keymap("n", "<leader>af", send_current_function, { desc = "🔧 Enviar función actual" })
    keymap("n", "<leader>aF", send_full_file_with_context, { desc = "📄 Enviar archivo completo" })
    keymap("n", "<leader>ap", send_project_context, { desc = "🏗️ Contexto de proyecto" })

    -- Agregar al contexto
    keymap("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "➕ Add buffer actual" })
    keymap("n", "<leader>aA", function()
      -- Agregar todos los buffers abiertos
      local buffers = vim.api.nvim_list_bufs()
      local count = 0
      for _, bufnr in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if not fname:match("^term://") then
            vim.cmd("ClaudeCodeAdd " .. vim.fn.fnameescape(fname))
            count = count + 1
          end
        end
      end
      vim.notify(
        string.format("📚 %d archivos agregados al contexto", count),
        vim.log.levels.INFO,
        { title = "Claude Context" }
      )
    end, { desc = "📚 Add todos los buffers" })

    -- Model & Config
    keymap("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "🎛️ Seleccionar modelo" })

    -- Diffs (sin conflicto con dashboard)
    keymap("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "✅ Aceptar diff" })
    keymap("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "❌ Rechazar diff" })
    keymap("n", "<leader>ad", "<cmd>ClaudeCodeDiffAcceptAll<cr>", { desc = "✅✅ Aceptar todos" })

    -- Integración con which-key
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "<leader>a", group = "🤖 AI Claude" },
        { "<leader>ai", desc = "🤖 Iniciar Claude" },
        { "<leader>af", desc = "👁️ Focus Claude" },
        { "<leader>ar", desc = "🔄 Resume" },
        { "<leader>aC", desc = "➡️ Continue" },
        { "<leader>as", desc = "📤 Send selección", mode = "v" },
        { "<leader>al", desc = "📍 Línea actual" },
        { "<leader>af", desc = "🔧 Función actual" },
        { "<leader>aF", desc = "📄 Archivo completo" },
        { "<leader>ap", desc = "🏗️ Proyecto" },
        { "<leader>ab", desc = "➕ Add buffer" },
        { "<leader>aA", desc = "📚 Add todos" },
        { "<leader>am", desc = "🎛️ Modelo" },
        { "<leader>ay", desc = "✅ Accept diff" },
        { "<leader>an", desc = "❌ Deny diff" },
        { "<leader>ad", desc = "✅✅ Accept all" },
      })
    end

    -- ========================
    -- AUTO-COMANDOS
    -- ========================

    -- Guardar última conversación al salir
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("claude_persistence", { clear = true }),
      callback = function()
        -- Claude CLI ya guarda automáticamente, pero podemos agregar log
        local log_file = vim.fn.stdpath("data") .. "/claude_sessions.log"
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

        local f = io.open(log_file, "a")
        if f then
          f:write(string.format("[%s] Sesión guardada - Proyecto: %s\n", timestamp, project))
          f:close()
        end
      end,
    })

    vim.notify(
      "🤖 Claude Code configurado\n✅ CLI integrado\n📋 Helpers personalizados listos",
      vim.log.levels.INFO,
      { title = "Claude Code", timeout = 3000 }
    )
  end,
}
