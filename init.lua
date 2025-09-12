-- =========================
--   Neovim Config (init.lua)
-- =========================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim (gestor de plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versión estable
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  -- Tema
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

    -- Linting
    {
      "mfussenegger/nvim-lint",
      config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          python = { "flake8" },
        }

        -- Auto-lint al guardar
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            lint.try_lint()
          end,
        })
      end,
    },

    -- Formatting
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            python = { "black" },
          },
        })

        -- Keymap para formatear
        vim.keymap.set("n", "<leader>f", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "Format file" })
      end,
    },
   
    
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          direction = "float",
          float_opts = {
            border = "curved",
          },
        })

        -- Abrir Claude en una terminal flotante
        vim.keymap.set("n", "<leader>ac", function()
          vim.cmd("ToggleTerm direction=float cmd='claude'")
        end, { desc = "Abrir Claude en flotante" })
      end,
    },
      -- Explorador de archivos: oil.nvim
      {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("oil").setup({
            view_options = {
              show_hidden = true, -- mostrar archivos ocultos
            },
          })
          -- Atajo para abrir Oil en el directorio actual
          vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Abrir Oil" })
        end,
      },

  -- Dashboard con waifu
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      --  ASCII Art
      local headers = {
          -- Waifu 1
        {
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠉⠑⣶⣤⣄⣀⣠⣤⣶⣶⣿⣿⣿⣿⡇⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⣀⠤⠒⠉⠈⢉⡉⠻⢿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⣀⣴⣶⣿⣷⡄⠀⠀⠀⠀⢹⣿⣿⣿⣿⠏⠁⠀⢀⠄⠀⠀⠈⢀⠄⠀⢀⡖⠁⠀⢀⠀⠈⠻⣿⣿⣿⣿⡏⠀⠀⠀⠀]],
          [[⠀⠀⢠⣾⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⢸⣿⣿⠏⠀⠀⢀⡴⠁⠀⠀⣠⠖⠁⢀⠞⠋⠀⢠⡇⢸⡄⠀⠀⠈⢻⣿⣿⠁⠀⠀⠀⠀]],
          [[⠀⣠⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⢸⡿⠁⠀⠀⢀⡞⠀⠀⢀⡴⠃⠀⣰⠋⠀⠀⣰⡿⠀⡜⢳⡀⠘⣦⠀⢿⡇⠀⠀⠀⠀⠀]],
          [[⢠⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⢰⣿⠃⠀⢀⠆⡞⡄⠀⣠⡞⠁⣀⢾⠃⠀⣀⡜⢱⠇⣰⠁⠈⣷⠂⢸⡇⠸⣵⠀⠀⠀⠀⠀]],
          [[⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⢠⣿⠇⠀⠀⡜⣸⡟⢀⣴⡏⢠⣾⠋⡎⢀⣼⠋⢀⡎⡰⠃⠀⠀⣿⣓⢒⡇⠀⣿⠀⠀⠀⠀⠀]],
          [[⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠴⢻⣟⢀⣀⢀⣧⡇⢨⠟⢾⣔⡿⠃⢸⢀⠞⠃⢀⣾⡜⠁⠀⠀⠀⡏⠁⢠⠃⠀⢹⠀⠀⠀⠀⠀]],
          [[⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⢸⣼⢸⣿⡟⢻⣿⠿⣶⣿⣿⣿⣶⣾⣏⣀⣠⣾⣿⠔⠒⠉⠉⢠⠁⡆⡸⠀⡈⣸⠀⠀⠀⠀⠀]],
          [[⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⣸⣿⣸⣿⣇⢸⠃⡄⢻⠃⣾⣿⢋⠘⣿⣿⠏⣿⡟⣛⡛⢻⣿⢿⣶⣷⣿⣶⢃⣿⠀⠀⠀⠀⠀]],
          [[⢸⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⣰⠃⣿⣿⣿⣿⠀⣸⣧⠈⣸⣿⠃⠘⠃⢹⣿⠀⣿⠃⠛⠛⣿⡇⢸⣿⡇⢸⣿⡿⣿⡀⠀⠀⠀⠀]],
          [[⠀⠻⣿⣿⣿⣿⣦⡀⠀⢀⡔⣹⣼⡟⡟⣿⣿⣿⠛⠻⠶⠿⠷⣾⣿⣿⣬⣿⣠⣿⣀⣿⣿⣿⡇⠸⡿⠀⣾⡏⢠⣿⣇⠀⠀⠀⠀]],
          [[⠀⠀⠙⢿⣿⣿⣿⣿⣷⡞⢠⣿⢿⡇⣿⡹⡝⢿⡷⣄⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠙⠛⠛⠻⠿⣶⣶⣾⣿⣇⣾⠉⢯⠃⠀⠀⠀]],
          [[⠀⠀⠀⠀⠙⠿⣿⣿⣿⠇⢸⠇⠘⣇⠸⡇⣿⣮⣳⡀⠉⠂⠀⠀⣀⣤⡤⢤⣀⠀⠀⠀⠀⠀⢈⣿⠟⣠⣾⠿⣿⡆⡄⣧⡀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠙⠻⡘⠾⣄⠀⠘⢦⣿⠃⠹⣿⣿⣶⠤⠀⠀⣿⠋⠉⠻⣿⠁⠀⠠⣀⣤⣾⣵⣾⡿⠃⣾⠏⣿⣧⠋⡇⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⣠⠖⠳⣄⡈⠃⠀⠼⠋⠙⢷⣞⢻⣿⣿⣀⡀⠈⠤⣀⠬⠟⠀⢀⣠⣶⠿⢛⡽⠋⣠⣾⣏⣠⡿⣃⣞⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠉⠛⠓⠢⠶⣶⡤⠺⡟⢺⣿⠿⣿⣶⣤⣀⣠⣴⣾⡿⠿⢵⠋⠙⠲⣏⡝⠁⠀⣹⢿⡣⣌⠒⠄⠀]],
          [[⠀⠀⠀⠀⠀⠀⢸⠈⡄⠀⠇⠀⠀⡖⠁⢢⡞⠀⢰⠻⣆⡏⣇⠙⠻⣿⣿⣿⣿⠋⢀⡴⣪⢷⡀⠀⡘⠀⢀⠜⠁⢀⠟⢆⠑⢄⠀]],
          [[⠀⠀⠀⠀⠀⠀⠘⡄⠱⠀⠸⡀⠄⠳⡀⠀⢳⡀⢰⠀⢸⢇⡟⠑⠦⢈⡉⠁⢼⢠⡏⣴⠟⢙⠇⠀⡇⢠⠃⢀⡴⠁⠀⠘⠀⠈⡆]],
          [[⠀⠀⠀⠀⠀⠀⠀⠇⠀⠣⠀⡗⢣⡀⠘⢄⠀⢧⠀⢳⡟⠛⠙⣧⣧⣠⣄⣀⣠⢿⣶⠁⠀⠸⡀⠀⠓⠚⢴⣋⣠⠔⠀⠀⠀⠀⠁]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠧⡤⠙⢤⡈⣦⡼⠀⠀⠧⢶⠚⡇⠈⠁⠈⠃⠀⡰⢿⣄⠀⠀⠑⢤⣀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀]],
        },

          -- Waifu 2
        {
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⡞⡷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠘⡍⢳⡀⠀⠀]],
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠀⠀⢠⡇⡇⠹⡄⠀⣀⡠⠤⠴⠒⠒⠒⠒⠒⠒⠒⠢⠤⠤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢇⠹⡄⢧⠀⠀]],
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠈⣷⡇⠀⣻⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠒⠤⢄⡀⠀⠀⠀⣼⢡⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡀⠱⡈⡇⠀]],
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠅⠀⠀⢀⣴⣿⡇⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠢⣼⢹⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⢳⡸⡄]],
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠄⠀⡰⠋⠘⢿⣿⡾⢀⡤⠒⠚⠉⠉⠉⠉⠑⠒⠒⠒⠤⠤⠤⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⡇⡏⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢇⢳]],
          [[  ⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⡼⠸⠀⡼⠁⣠⠔⠳⡉⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠒⠦⣄⡀⠀⠀⡇⣧⡟⣹⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠸⡈]],
          [[  ⠀⠀⠀⠸⡀⠀⠀⠀⠀⢠⠇⡄⣜⡠⠊⠁⠀⠀⠑⠞⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢳⠀⢻⡿⢡⡟⠀⠙⢄⠀⠀⠀⠀⠀⠀⠀⠠⡀⢹⠀⠀⢧]],
          [[  ⠀⠀⠀⠀⢱⠀⠀⠀⠀⡸⢀⠛⠋⠀⠀⠀⠀⠀⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⢀⢤⣀⠀⠀⠈⢳⡀⠀⠀⠀⠀⠀⠀⠃⢸⠀⠀⠘]],
          [[  ⠀⠀⠀⠀⠀⢣⢀⡠⠖⡇⠸⠀⠀⠀⡀⠀⠀⠀⢀⢞⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠊⠁⠀⠈⠳⢄⠀⠀⢱⡀⠀⠀⠀⠀⠀⠈⢸⠀⠀⠀]],
          [[  ⠀⠀⠀⠀⢀⠞⠉⠀⠀⡇⠀⠀⠀⠀⡇⠀⠀⢀⣾⠋⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀⠙⢦⡀⢳⡀⠀⠀⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⠀⡶⠃⠀⢀⠄⣰⡇⠀⠀⠀⢠⠇⠀⢀⡾⠁⠀⡇⠀⡏⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⢦⠀⠀⠀⠀⠙⠦⣷⠀⠀⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⢠⠇⠀⣰⣣⠔⢹⠀⠀⠀⠀⢸⠀⠀⡜⠀⠀⠀⡇⢠⡇⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠹⡄⠀⠂⢸⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⣸⠀⢠⢻⠃⠀⣸⠀⠀⠀⠀⢸⠀⡼⢥⡀⠀⠀⢣⢸⢻⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⢀⡿⡀⠀⠀⠀⠀⠀⢠⣇⢳⠀⠀⠀⡇⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⡇⠀⡎⡏⠀⠀⣿⠀⠀⠀⠀⢸⢰⠁⠀⠙⢶⣄⣸⠸⢻⡀⠀⠀⠀⠀⡇⠀⡄⠀⠀⠀⠀⢸⢰⡇⠀⠀⠀⠀⠀⢸⠈⢿⡆⠀⠀⢻⠘⠀⠀⠀⠀⠀⠀⣰⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⡇⢰⢣⠁⠀⢸⠻⠀⠀⠀⠀⣿⠆⠀⠀⠀⠀⠉⢻⣿⣬⣇⠀⠀⠀⠀⣇⠀⡇⠀⠀⠀⠀⣾⠏⡇⢤⠀⠀⠀⠀⣇⡠⠬⢷⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⢸⠀⠀⠀]],
          [[  ⠀⠀⢳⢸⢸⠀⠀⢸⡆⠀⠀⠀⠀⡿⢖⣒⣶⣤⣄⡓⠾⣯⣙⠺⣀⠀⠀⠀⣿⠀⣿⠀⠀⠀⢠⠏⢀⡁⣼⠀⠀⢠⣿⠁⠀⠀⠈⡆⠀⠀⡇⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⡿⠀⠀⠀]],
          [[  ⠀⠀⢸⣸⣸⠀⠀⠀⡇⠀⠀⠀⠀⡇⠀⠙⠛⠛⠻⠿⣿⣿⣝⡳⣿⣧⠀⠀⡿⡄⡧⡆⠀⠀⣸⣏⣛⡇⣿⠀⢀⣾⡏⠀⠀⠀⠀⢱⠀⢠⠃⠀⠀⠀⠀⠀⡏⠑⣆⠀⠀⡇⠀⠀⠀]],
          [[  ⠀⠀⠀⡇⢻⠀⠀⠀⡇⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠚⠏⢧⠀⡇⢇⢱⢱⡀⠀⣇⠤⠒⣿⢻⢀⣎⣈⣠⣤⣤⣤⣄⣈⣇⢸⠀⠀⠀⠀⠀⣸⠋⠳⣼⠀⢐⠇⠀⠀⠀]],
          [[  ⠳⣄⠀⢱⠈⠀⠀⠀⡇⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠁⠈⠙⠠⢥⣈⠀⠐⠚⠛⡿⠛⠛⠛⠛⠻⠛⠻⠗⠚⠻⡟⠀⠀⠀⠀⢀⡏⠉⢚⡏⠀⢸⠀⠀⠀⢠ ]],
          [[  ⣷⣈⠳⣌⡇⠀⠀⠀⢹⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⣸⠀⠀⡜⠀⠀⢸⠀⢀⡴⣿]],
          [[  ⣿⣿⣷⡈⢻⠀⠀⠀⢸⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⢀⠇⢀⡼⠁⠀⠀⣤⢔⣿⣿⣿]],
          [[  ⣿⣿⣿⣷⣶⣆⠀⠀⢸⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢚⠓⠲⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⣠⠞⠀⠀⠀⠀⣿⣿⣿⠟⠁]],
          [[  ⣿⣿⣿⣿⣿⣿⡄⠀⠘⡆⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⡞⠁⠀⠀⠀⠀⠀⣿⠟⠉⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣷⡀⠀⡇⠀⠀⠀⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⢠⡇⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣧⠀⢧⠀⠀⠀⢸⢳⡀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣴⡀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⡸⡇⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⡆⢸⠀⠀⠀⠸⡆⠑⣄⠀⠀⠀⠀⠀⠈⣿⢍⠉⠑⠒⠒⠒⠒⠒⠈⠉⢉⣁⣀⣾⡇⠀⠀⠀⠀⠀⠀⢀⠞⡏⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⢀⡇⡇⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⡆⠀⠀⠀⡇⠀⡇⠑⢄⡀⠀⠀⠀⠘⠲⠤⣀⣀⡀⠀⠀⠀⠀⣁⣉⡤⠼⠛⠁⠀⠀⠀⠀⢀⠔⠁⠀⡇⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⡼⠀⡇⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠁⠀⠀⠀⡇⠀⡇⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠉⠁⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⠀⢀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⢠⠇⠀⣧⡀⠀⠀⠀ ]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⢀⠀⣇⠀⠀⠀⠀⠉⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠚⠁⠀⠀⠀⠀⢸⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⡜⠀⢀⡲⠙⠢⡀⠀ ]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⢸⠀⡇⠳⡄⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠔⡻⠋⠀⠀⠀⠀⠀⠀⠀⡞⠀⠀⠀⢸⠀⠀⠀⠀⠀⢀⠃⠀⢸⡶⠀⠁⠹⢦   ]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠸⡄⣧⠀⠈⠢⡀⠀⠀⠀⠀⠈⠲⢄⣀⣤⣤⠒⠊⠉⢀⡠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⢸⠀⣾⣦⣆⡈   ]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⡇⣟⣣⠀⠀⠙⢆⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⡇⠀⠀⠀⠀⢠⠇⠀⠀⣼⣸⣿⣿⣿⣿   ]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⢹⣿⣿⣧⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⢀⠇⠀⠀⠀⠀⡜⠀⠀⠀⡇⣿⣿⣿⣿⣿   ]],
        },
          -- Waifu 3
        {
          [[  ⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⣰⣿⣿⣿⣿⣿⣿⢻⣿⣿⠏⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⢀⣿⣿⣿⣿⣿⡟⣿⡟⠘⣿⡇⢞⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀]],
          [[  ⢸⣿⣿⣿⣿⣿⣷⣿⡇⠀⠹⣿⣧⠼⢾⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣿⣿⣹⣗⠒⠋⠙⢿⣆⠈⢫⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀]],
          [[  ⣿⣿⣿⣿⣿⣻⣿⠘⢿⠀⠠⣖⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⠚⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀]],
          [[  ⢹⣿⣿⣿⣿⣿⣿⡄⠀⠣⠀⠻⠋⠀⠘⣿⠿⠛⢆⢻⣿⣿⣿⣿⣿⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀]],
          [[  ⣼⣿⣿⣿⣿⠛⣿⡷⣀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠘⣄⣿⣿⣿⣿⣿⣍⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡀⠀⠀]],
          [[  ⡇⣿⣿⣿⣿⡗⠈⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⡇⠀⠀]],
          [[  ⡇⢿⣿⣿⣿⣷⠾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⡇⠀⠀]],
          [[  ⡇⢸⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣹⡿⢿⠿⠒⠓⠒⠂]],
          [[  ⢣⠸⣿⣿⣿⣿⣷⡀⠀⠀⣀⣤⡀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢇⡿⠋⠀⠁⠀⠀⠀⠀⠀]],
          [[  ⠸⠀⣿⣿⣿⣿⣿⣷⣄⡀⠘⠭⠄⠀⠀⠀⠀⠀⠀⡗⣿⣿⣿⢸⣿⣿⣿⣿⡟⣽⢿⠞⢀⣀⣀⣀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⢇⢹⣿⢹⣿⣿⣿⣿⠙⣦⡀⠀⠀⠀⠀⣀⡤⠴⢿⣿⣿⣿⡏⠀⣿⡟⣿⡿⠋⢰⠋⡸⠉⠁⠀⠀⢀⡤⠚⠁⠀⠀]],
          [[  ⠀⠈⠛⣿⢀⢿⣿⡿⣿⠀⣿⡙⠲⠒⠒⠉⠙⠢⠀⣿⣿⣿⣿⡇⠀⣹⠙⠏⠁⢀⠎⢠⠃⠀⠀⡠⠖⠁⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⠀⠹⣿⠀⢻⣷⡿⡐⠋⠁⠀⠀⠀⠀⠀⠀⣰⢟⣿⢏⡞⢻⢷⠏⠀⠀⠀⢸⣰⠃⢀⡤⠊⠀⡠⠴⠒⠉⠀⠀⠀]],
          [[  ⠀⠀⠀⠀⠹⣇⠀⠙⠢⠀⠀⠀⠀⠀⠀⠀⠀⠚⠁⠞⢁⣾⠃⡇⢸⣆⠀⠀⠀⢀⣇⡰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⢻⠀⠀⢸⡿⣧⡀⠀⡼⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],  
        },
          -- Waifu 4
        {
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣷⡀⠘⣇⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠘⡄⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⡆⠀⠙⢿⣿⣿⣿⣶⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢳⡀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⡟⠇⠀⢠⣦⠹⢿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢸⣇⠀⠙⢀⣾⡿⠿⣛⣛⣭⣭⣥⣤⣤⡍⢄⠀⢼⠅⣾⣦⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠄⠰⢛⣥⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣎⣋⠴⣶⣦⣍⡻⣿⣿⣿⣿⣿⣿⣿⣿⣯⡢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⢻⣿⡿⣿⣿⡏⢻⡆⣌⢻⣯⡁⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣷⣾⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⡇⣿⣿⡇⢸⡇⢿⣆⠻⡇⣼⣿⣿⣿⣿⣿⣧⢿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣸⣿⢸⣿⣿⣿⡇⡆⣿⡇⢻⣿⡇⠀⡇⣈⠻⣧⡙⢿⣿⣿⢹⣿⣿⣿⠸⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⢿⡇⣿⣿⢸⣿⣿⣿⡇⡇⢿⡇⢸⣿⣷⠀⠇⣿⣶⡙⣷⣾⣿⣿⢸⣿⡟⢿⡄⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⢻⣿⣿⢸⡇⣿⣿⠘⡟⣿⣿⡇⡇⢸⡇⠀⣋⣥⢀⡆⣿⣿⣦⡈⢿⣿⣿⣼⣿⠧⠠⠡⢻⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⣿⣿⣿⣿⡇⢿⣿⠃⡇⣿⣿⣷⠀⣅⣆⠘⠉⠁⠀⢁⣈⢛⠛⠃⢸⣿⣿⣿⣿⡆⢃⠀⢸⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⣿⢸⣿⢿⡇⢸⣛⠀⠹⠘⡇⣿⣸⣼⢏⣠⣆⠸⠅⠀⢙⣀⣾⡇⢸⣿⣿⢹⣿⠃⠀⠀⠈⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣿⠸⣿⠈⣧⢀⠙⠁⠀⠆⣿⣼⣿⣿⣿⣿⣶⣶⣶⣾⣿⣿⣿⡇⢸⢹⡇⣿⣿⠀⢶⣭⠃⢸⣿⢻⣷⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⢉⠀⢿⡔⠹⠀⣶⣦⠇⠂⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⣼⣿⣿⡟⣰⣦⣻⡷⢸⣿⣾⡏⠀⠀⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡖⠂⠀⠸⡌⣧⣷⠁⢹⣧⣖⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢠⣿⣿⣿⡇⢿⡝⣿⠇⣌⣿⡟⣿⡆⠐⠀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠏⠀⡐⣰⣷⢠⢹⣿⡇⢸⣿⣿⣷⣌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣼⣿⣿⣿⢁⣨⠄⠋⠀⣿⣿⡇⠿⢿⡀⠂⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠇⢀⡜⣱⣿⡿⠈⢸⣿⣇⠀⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⡿⢠⣿⢏⣿⡏⣘⠋⠀⠄⣇⢳⣿⣿⠀⠂⢻⡀⠀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⣠⡿⢃⣾⣿⠇⠼⢸⣿⣿⢰⠘⢿⣿⣿⣿⣦⣿⣿⣷⣾⣿⣿⣿⣿⣿⠃⢸⣿⢸⣿⣿⣿⠀⠀⠀⢸⢸⣿⣿⡄⡀⠀⢿⡀⠀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣷⣾⠟⢁⣿⣿⡟⡘⣼⢸⣿⣿⢸⠈⠀⡙⢿⣿⣿⣧⣤⣿⣿⣿⣿⣿⣿⠇⡆⣸⡇⣿⣿⣿⣿⠀⣦⢠⠈⠘⣿⣿⡇⠻⠀⠀⢻⡀⠀⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡿⠃⢠⣾⣿⡟⠀⣸⣿⢸⣿⣿⢸⠀⢸⣿⡦⡙⢿⣿⣿⣿⣿⣿⣿⠿⢋⣠⡆⡿⢸⣿⣿⣿⣿⠀⠛⠈⣿⡆⣿⣿⣿⡸⣦⠀⠀⢻⡄⠀       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣟⠟⠀⢀⣾⣿⡟⠀⣴⣿⠁⣿⣿⣿⢸⢀⣿⣿⢡⣿⣦⠙⠿⠟⠛⠉⣤⣴⢁⣿⢠⢇⣿⡟⢸⣭⣴⣶⢀⢣⣿⡇⢿⣿⣿⡇⢿⡆⠰⠀⢻⣄       ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⣿⡇⠀⢠⣿⣿⣿⢃⣼⣿⡏⣎⣿⣿⣿⢸⢁⣿⠏⣼⣿⣿⡀⢸⣿⡇⠀⢿⡏⡾⠟⡈⣼⣿⢱⣿⣿⣿⣿⠈⢸⣿⢷⢸⣿⣿⣿⠸⣷⡀⠂⠀⢿        ]],
          [[ ⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⣽⠄⣰⣿⣿⡟⠑⠿⣿⡿⠀⣾⡟⢹⣿⢸⢸⡟⢠⣿⣿⣿⠀⢸⣿⠁⠀⠈⢁⣶⣇⣠⣿⡏⣾⣿⣿⣿⣿⡄⠘⣿⠘⠀⢿⣿⣿⡆⣿⣷⡈⠀⠈        ]],
          [[ ⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⠀⠀⡟⣸⣿⡿⢫⣾⣿⣷⡿⠁⣽⠟⡡⣸⣿⢸⡞⠀⣈⣿⣿⡇⣸⢸⡿⠀⢸⠀⢸⡿⢸⣿⡿⢸⣿⣿⡿⠟⠛⣃⠀⣿⡇⡆⠸⣿⣿⣿⠘⣿⡧⠐⠀       ]],
          [[ ⠀⠀⠀⠀⢀⣴⣿⡿⠃⠀⠀⣰⣿⣿⡿⢡⣄⠻⠿⠟⢡⣴⠏⣼⡇⣿⡇⠀⣰⢃⣿⡿⣿⠁⡇⣾⡇⠀⠞⣠⣾⢃⣿⣿⢃⣿⢟⣵⡖⢋⣉⡉⡉⣹⡷⢀⠀⣿⣿⣿⣇⠻⣷⣄⠀       ]],
          [[ ⠀⠀⠀⢀⣾⣿⠟⠀⠀⢀⣾⣿⠿⠍⣠⣍⢻⠶⢋⣴⠿⢡⣾⣿⠁⣿⡇⢸⡏⣸⣿⢃⡟⣸⢀⡿⢃⢰⣿⣿⢸⣿⣿⠋⢈⣁⣸⣿⣿⣷⣶⡾⢟⡘⢿⣶⣶⣶⣶⣮⣭⣤⡹⣿⣆       ]],
          [[ ⠀⠀⢠⣿⣿⠏⣠⣽⣰⣿⡋⣤⣶⡌⣿⡟⢠⣾⡇⠁⣠⣿⡿⠁⡀⣿⡇⣿⢡⣿⠏⡾⢀⣹⡸⢁⣠⣿⣿⡏⢈⣿⡟⠀⣛⡻⠁⠙⠌⠛⢯⣴⣿⠟⣈⠻⢦⡶⢶⣶⠖⣢⣍⠸⣿       ]],
          [[ ⠀⢠⣿⣿⠏⠀⢿⣿⡇⣿⣇⢸⣿⡇⣿⢻⣿⢏⠀⣰⣿⠟⡰⢃⡄⣿⢡⡏⣾⢏⣼⡣⠟⣫⣴⣿⡿⠟⣉⠄⣼⣿⢡⣼⠟⠀⠀⢀⣤⢀⣴⠟⣥⣾⣿⣿⣶⣤⣤⣶⣾⣿⣿⣿⡄       ]],
          [[ ⢀⣾⣿⠟⣠⣾⡾⢿⡇⠹⣿⢸⡟⣠⣦⣾⢃⢮⣾⡿⢋⠔⣠⣾⡧⣿⢸⠟⢃⡾⠋⢀⠾⣿⣿⢿⣰⡿⢏⣤⣿⠃⠜⡁⠀⠀⢠⠞⣁⡾⢁⣼⣿⣿⣿⣿⣿⠿⠿⣿⣿⣿⡿⣿⣿       ]],
        },
          -- Waifu 5
        {
          [[ ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷ ]],
          [[ ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇ ]],
          [[ ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽ ]],
          [[ ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕ ]],
          [[ ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕ ]],
          [[ ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕ ]],
          [[ ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄ ]],
          [[ ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕ ]],
          [[ ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿ ]],
          [[ ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ]],
          [[ ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟ ]],
          [[ ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠ ]],
          [[ ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙ ]],
          [[ ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣ ]],
        },
      }

      -- Semilla aleatoria y selección
      math.randomseed(os.time())
      dashboard.section.header.val = headers[math.random(#headers)]

      dashboard.section.buttons.val = {
        dashboard.button("e", "►  Nuevo archivo", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "■  Buscar archivo", ":Telescope find_files<CR>"),
        dashboard.button("r", "▲  Archivos recientes", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "◆  Salir", ":qa<CR>"),
      }

      dashboard.section.footer.val =
        "✦  想像できれば、プログラムできます。✦"

      alpha.setup(dashboard.config)
    end,
  },

  -- Barra de estado
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Explorador de archivos
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Telescope (buscador)
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter (resaltado moderno)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Autocompletado
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },

  -- Snippets
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/cmp-vsnip" },

  -- LSP (Lenguajes)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
})

-- =========================
-- Opciones generales
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Colores
vim.cmd([[colorscheme tokyonight]])

-- =========================
-- Configuración de plugins
-- =========================

-- Lualine
require("lualine").setup({
  options = {
    theme = "tokyonight",
    section_separators = { "✦", "▸" },
    component_separators = { "✦", "►" },
  },
  sections = {
    lualine_a = { "mode" }, -- Modo (NORMAL, INSERT, VISUAL...) con color
    lualine_b = { "branch", "diff", "diagnostics" }, -- Rama Git, cambios y diagnósticos LSP
    lualine_c = { "filename" }, -- Nombre del archivo activo
    lualine_x = { "encoding", "fileformat", "filetype" }, -- UTF-8, formato y tipo de archivo
    lualine_y = { "progress" }, -- Progreso en el archivo
    lualine_z = { "location" }, -- Línea y columna
  },
})

-- Nvim-tree
require("nvim-tree").setup({
  view = {
    width = 35,
    side = "left",
    number = true,
    relativenumber = true,
  },
  renderer = {
    highlight_opened_files = "name",
    indent_markers = { enable = true },
    highlight_git = true, -- Colores para estado Git
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  git = {
    enable = true, -- Asegura que Nvim-tree lea el estado Git
  },
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buscar buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ayuda" })

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    -- Core
    "lua",
    "vim",
    "vimdoc",

    -- Frontend / Angular
    "javascript",
    "typescript",
    "html",
    "css",
    "scss",
    "json",

    -- Backend / Fullstack
    "python",
    "php",
    "sql",

    -- Utilidades
    "bash",
    "markdown",
    "markdown_inline",
    "yaml",
    "dockerfile",
    "gitignore"
  },
  highlight = { enable = true },
  indent = { enable = true }
})

-- Mason (gestor de LSP/DAP/formatters)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls" }
})

-- Configuración LSP
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.pyright.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })

-- Autocompletado con snippets
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer" },
    { name = "path" },
  })
})



-- =========================
-- Atajos rápidos (Keymaps)
-- =========================

-- Guardar y salir
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Guardar" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Cerrar" })
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Forzar cerrar sin guardar" })

-- Quitar highlight
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Quitar highlight" })

-- Manejo de ventanas
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Dividir vertical" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Dividir horizontal" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir izquierda" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir derecha" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir arriba" })

-- Manejo de buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Buffer siguiente" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer anterior" })
vim.keymap.set("n", "<leader>c", ":bd<CR>", { desc = "Cerrar buffer" })

-- Explorador de archivos
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Abrir explorador" })

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Buscar texto" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buscar buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Buscar ayuda" })

-- LSP / Diagnósticos
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Formatear código" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Ver error" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Error anterior" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Error siguiente" })

-- dashboard
vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Volver al Dashboard" })

-- Terminal
-- Salir de terminal a modo normal con <Esc>
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Salir de terminal a normal" })
-- Abrir terminal abajo y entrar directamente en modo terminal
vim.keymap.set("n", "<leader>tt", ":split | terminal<CR>i", { desc = "Terminal abajo" })
-- Abrir terminal a la derecha y entrar directamente en modo terminal
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>i", { desc = "Terminal derecha" })

