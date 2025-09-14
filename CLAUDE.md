# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration setup for Windows, optimized for development with LSP support, autocompletion, and a waifu-themed dashboard. The configuration has been **refactored from a monolithic single-file approach to a modular architecture** for better maintainability and extensibility.

## Architecture

### Modular Configuration Structure
The configuration is now organized into a clean, modular structure:

```
lua/
├── core/               # Core Neovim configuration
│   ├── init.lua        # Core loader
│   ├── options.lua     # vim.opt settings
│   ├── keymaps.lua     # Global key mappings
│   └── autocmds.lua    # Autocommands and events
├── plugins/            # Plugin specifications
│   ├── init.lua        # Plugin loader with lazy.nvim
│   ├── ui.lua          # UI and appearance plugins
│   ├── editor.lua      # Editor enhancement plugins
│   ├── coding.lua      # Development and coding tools
│   └── git.lua         # Git integration plugins
├── config/             # Plugin configurations
│   ├── alpha.lua       # Dashboard configuration
│   ├── lualine.lua     # Status line
│   ├── telescope.lua   # Fuzzy finder
│   ├── lsp.lua         # LSP configuration
│   ├── cmp.lua         # Autocompletion
│   └── [other configs] # Individual plugin configs
└── utils/              # Utilities and helpers
    ├── init.lua        # Helper functions
    └── ascii.lua       # ASCII art for dashboard
```

### Benefits of Modular Architecture
- **Maintainability**: Each component is isolated and easy to modify
- **Extensibility**: Adding new plugins or features is straightforward
- **Organization**: Related functionality is grouped logically
- **Performance**: Lazy loading and better plugin management
- **Debugging**: Issues can be isolated to specific modules

### Key Components

1. **Plugin Management**: lazy.nvim with automatic installation and configuration
2. **LSP Setup**: Mason for LSP server management with pre-configured servers for:
   - Lua (lua_ls)
   - Python (pyright)
   - TypeScript/JavaScript (ts_ls)
   - HTML (html)
   - CSS (cssls)
   - Emmet (emmet_ls)
3. **Completion**: nvim-cmp with multiple sources and snippet support
4. **Formatting/Linting**:
   - conform.nvim for formatting (prettier, black)
   - nvim-lint for linting (eslint_d, flake8)
5. **UI Components**:
   - Alpha dashboard with rotating waifu ASCII art
   - Lualine status bar with tokyonight theme
   - NvimTree file explorer
   - Telescope fuzzy finder

## Development Commands

### Neovim Configuration Management
```bash
# Open Neovim configuration
nvim $env:LOCALAPPDATA\nvim\init.lua

# Test configuration changes
nvim --noplugin  # Start without plugins
nvim -u NONE     # Start with minimal config
```

### Plugin Management (within Neovim)
```vim
:Lazy              " Open plugin manager UI
:Lazy install      " Install plugins
:Lazy update       " Update all plugins
:Lazy clean        " Remove unused plugins
:Lazy sync         " Install missing + update + clean
```

### LSP and Development Tools
```vim
:Mason             " Open LSP server installer
:LspInfo           " Show LSP client information
:LspRestart        " Restart LSP servers
:ConformInfo       " Show available formatters
:NullLsInfo        " Show linting information (if using null-ls)
```

## Key Bindings

The configuration uses `<Space>` as the leader key and includes extensive keymaps:

### File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Force quit without saving

### Navigation
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Browse buffers
- `<leader>e` - Toggle file explorer
- `Shift+h/l` - Navigate between buffers

### Development
- `<leader>f` - Format current file
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation

### Terminal
- `<leader>ac` - Open Claude Code in floating terminal
- `<leader>tf` - Floating terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal
- `Ctrl+\` - Quick toggle terminal

### Git Integration
- `<leader>gd` - Git diff view
- `<leader>gc` - Close diff view
- `<leader>gh` - File history

## Prerequisites (Windows)

The configuration requires several external dependencies as documented in readme.md:

1. **NodeJS and Python** - Required for LSP servers and formatters
2. **MSYS2 toolchain** - Provides gcc, make for Treesitter compilation
3. **External tools**:
   ```bash
   npm install -g eslint_d prettier
   pip install flake8 black
   ```
4. **Nerd Font** - JetBrains Mono Nerd Font for proper icon display

## Configuration Structure

### Core Module (`lua/core/`)
- **options.lua**: All vim.opt configurations (numbers, indentation, search, etc.)
- **keymaps.lua**: Global key mappings organized by category (files, windows, buffers, LSP)
- **autocmds.lua**: Event-driven functionality (highlighting, formatting, file type settings)
- **init.lua**: Core loader that enables vim.loader and loads all core modules

### Plugin Organization (`lua/plugins/`)
Plugins are categorized by functionality:
- **ui.lua**: UI and appearance (tokyonight, alpha dashboard, lualine, nvim-tree, toggleterm)
- **editor.lua**: Editor enhancements (autopairs, comments, surround, trouble, telescope, treesitter)
- **coding.lua**: Development tools (LSP servers via Mason, autocompletion with nvim-cmp, formatting, linting)
- **git.lua**: Git integration (fugitive, diffview, gitsigns with advanced keymaps)

### Plugin Configurations (`lua/config/`)
Each major plugin has its dedicated configuration file:
- **alpha.lua**: Dashboard with rotating waifu ASCII art and dynamic footer
- **lsp.lua**: LSP server configurations with unified keymaps and diagnostics
- **cmp.lua**: Autocompletion with multiple sources and custom formatting
- **telescope.lua**: Fuzzy finder with custom pickers and keymaps
- **lualine.lua**: Status line with LSP information and custom sections

### Custom Features
- **Waifu Dashboard**: Alpha.nvim with rotating ASCII art waifus
- **Claude Integration**: Custom keymap (`<leader>ac`) to open Claude Code in floating terminal
- **Oil.nvim**: Alternative file manager accessible via `-` key
- **Which-key**: Contextual key binding hints

## File Locations (Windows)

- **Main config**: `%LOCALAPPDATA%\nvim\init.lua` (now minimal, loads modules)
- **Modular config**: `%LOCALAPPDATA%\nvim\lua\` (core/, plugins/, config/, utils/)
- **Backup config**: `%LOCALAPPDATA%\nvim\init.lua.backup` (original monolithic version)
- **Plugin data**: `%LOCALAPPDATA%\nvim-data\`
- **Lazy.nvim**: `%LOCALAPPDATA%\nvim-data\lazy\`
- **Mason LSP servers**: `%LOCALAPPDATA%\nvim-data\mason\`

## Development Workflow

### Adding New Plugins
1. Add plugin spec to appropriate file in `lua/plugins/` (ui.lua, editor.lua, coding.lua, git.lua)
2. Create configuration file in `lua/config/` if needed
3. Add keymaps to the plugin config or `lua/core/keymaps.lua`
4. Update which-key groups if applicable

### Modifying Existing Features
- **Core settings**: Edit files in `lua/core/`
- **Plugin behavior**: Edit corresponding file in `lua/config/`
- **Plugin specifications**: Edit files in `lua/plugins/`
- **Utilities**: Edit files in `lua/utils/`

### Migration Notes
- **Backup available**: Original monolithic config saved as `init.lua.backup`
- **Rollback procedure**: Simply replace `init.lua` with `init.lua.backup` and remove `lua/` directory
- **New structure**: The refactored config maintains all original functionality while improving organization

## Troubleshooting

### Configuration Issues
1. `:checkhealth` - Comprehensive health check
2. Check module loading: `:lua print(vim.inspect(require('core')))`
3. If config fails to load, temporarily restore backup: `mv init.lua.backup init.lua`

### Plugin Issues
1. `:Lazy` - Open plugin manager UI
2. `:Lazy restore` - Restore to lockfile state
3. `:Lazy clean` - Remove unused plugins
4. Delete `%LOCALAPPDATA%\nvim-data\lazy` and restart Neovim to reinstall all plugins

### LSP Issues
1. `:LspInfo` - Check server status
2. `:Mason` - Reinstall LSP servers
3. Ensure external dependencies (NodeJS, Python, MSYS2) are installed
4. Check LSP config: `:lua print(vim.inspect(vim.lsp.get_active_clients()))`

### Formatting/Linting Issues
Verify external tools are installed globally:
```bash
eslint_d --version
prettier --version
flake8 --version
black --version
```