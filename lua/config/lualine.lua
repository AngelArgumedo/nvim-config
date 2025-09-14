-- =========================
-- Configuración de Lualine (Status line)
-- =========================

-- Custom theme with more vibrant colors
local custom_theme = require("lualine.themes.tokyonight")

-- Enhanced colors
custom_theme.normal.a.bg = "#7aa2f7"
custom_theme.normal.b.bg = "#292e42"
custom_theme.normal.c.bg = "#1a1b26"
custom_theme.insert.a.bg = "#9ece6a"
custom_theme.visual.a.bg = "#bb9af7"
custom_theme.replace.a.bg = "#f7768e"
custom_theme.command.a.bg = "#e0af68"

require("lualine").setup({
  options = {
    theme = custom_theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "dashboard", "NvimTree", "Outline" },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = { left = "" },
        right_padding = 2,
      },
    },
    lualine_b = {
      {
        "branch",
        icon = "",
      },
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        diff_color = {
          added = { fg = "#9ece6a" },
          modified = { fg = "#7aa2f7" },
          removed = { fg = "#f7768e" },
        },
      },
      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰌵 ",
        },
        diagnostics_color = {
          error = { fg = "#ff7a93" },
          warn = { fg = "#ffb86c" },
          info = { fg = "#7aa2f7" },
          hint = { fg = "#1abc9c" },
        },
      },
    },
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = true,
        path = 1,
        symbols = {
          modified = " ●",      -- Punto rojo para modificado
          readonly = " ",        -- Candado para solo lectura
          unnamed = "󰡯 ",        -- Archivo sin nombre
          newfile = " ",         -- Archivo nuevo
        },
        color = function()
          return vim.bo.modified and { fg = "#f7768e", gui = "bold" } or { fg = "#c0caf5" }
        end
      },
      {
        function()
          return vim.bo.modified and "UNSAVED" or ""
        end,
        color = { fg = "#f7768e", gui = "bold,italic" },
      }
    },
    lualine_x = {
      {
        "encoding",
        fmt = string.upper,
        color = { fg = "#7aa2f7" },
      },
      {
        "fileformat",
        symbols = {
          unix = " ",
          dos = " ",
          mac = " ",
        },
        color = { fg = "#9ece6a" },
      },
      {
        "filetype",
        colored = true,
        icon_only = false,
        icon = { align = "right" },
      },
      {
        function()
          local msg = "No Active LSP"
          local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return " " .. client.name
            end
          end
          return msg
        end,
        icon = "󰿘",
        color = { fg = "#bb9af7", gui = "bold" },
      }
    },
    lualine_y = {
      {
        "progress",
        separator = { right = "" },
        left_padding = 2,
      },
    },
    lualine_z = {
      {
        "location",
        separator = { right = "" },
        left_padding = 2,
      },
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "nvim-tree", "toggleterm" }
})