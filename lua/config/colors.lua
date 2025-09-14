-- =========================
-- Configuración de colores adicionales
-- =========================

-- Esta función configura colores personalizados después de cargar el tema
local function setup_custom_colors()
  -- GitSigns colors más vibrantes
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e", bold = true })
  vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#bb9af7", bold = true })

  -- GitSigns number line colors
  vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#9ece6a", bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#7aa2f7", bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#f7768e", bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = "#bb9af7", bg = "NONE" })

  -- Current line blame
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
    fg = "#565f89",
    bg = "NONE",
    italic = true
  })

  -- LSP colors más vibrantes
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff7a93", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffb86c", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#1abc9c", bold = true })

  -- LSP underlines más visibles
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
    undercurl = true,
    sp = "#ff7a93"
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
    undercurl = true,
    sp = "#ffb86c"
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
    undercurl = true,
    sp = "#7aa2f7"
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
    undercurl = true,
    sp = "#1abc9c"
  })

  -- Telescope colors
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#292e42" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#7aa2f7", bg = "#292e42" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#1a1b26", bg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#1a1b26", bg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#1a1b26", bg = "#bb9af7", bold = true })

  -- Floating window improvements
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "#1f2335" })

  -- Cursor line more subtle
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292e42" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e64", bold = true })

  -- Visual selection more vibrant
  vim.api.nvim_set_hl(0, "Visual", { bg = "#364A82" })

  -- Search highlights
  vim.api.nvim_set_hl(0, "Search", { fg = "#1a1b26", bg = "#ff9e64", bold = true })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#1a1b26", bg = "#f7768e", bold = true })

  -- StatusLine improvements
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#c0caf5", bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#565f89", bg = "#1a1b26" })

  -- Alpha Dashboard colors
  vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#c0caf5" })
  vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#bb9af7", italic = true })
  vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ff9e64", bold = true })

  -- Custom button highlights
  vim.api.nvim_set_hl(0, "AlphaButtonText", { fg = "#c0caf5" })
  vim.api.nvim_set_hl(0, "AlphaButtonIcon", { fg = "#7aa2f7", bold = true })

  -- File modification indicators
  vim.api.nvim_set_hl(0, "ModifiedFile", { fg = "#f7768e", bold = true })
  vim.api.nvim_set_hl(0, "SavedFile", { fg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "UnmodifiedFile", { fg = "#c0caf5" })

  -- Tab line modifications
  vim.api.nvim_set_hl(0, "TabModified", { fg = "#f7768e", bg = "#292e42", bold = true })
  vim.api.nvim_set_hl(0, "TabUnmodified", { fg = "#c0caf5", bg = "#1a1b26" })
end

-- Autocommand para aplicar colores después de cargar colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = setup_custom_colors,
})

-- Aplicar colores inmediatamente si ya hay un colorscheme cargado
if vim.g.colors_name then
  setup_custom_colors()
end

return {
  setup = setup_custom_colors
}