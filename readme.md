# 🌸 Professional Neovim Configuration

<div align="center">

![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

**A modern, feature-rich Neovim setup optimized for Windows development**

*With AI autocompletion, professional Git integration, and anime-themed dashboard* ✨
![preview](./screenshot.png)

</div>

## 🚀 Features

### 🤖 AI-Powered Development
- **Supermaven Integration**: Ultra-fast AI autocompletion (supports OpenAI API)
- **Claude Code Integration**: Floating terminal with `<leader>ac`
- **Smart Suggestions**: Context-aware code completion with inline display

### 🛠️ Language Support
- **LSP Servers**: Lua, Python, TypeScript/JavaScript, HTML, CSS, PHP, Go
- **Auto-formatting**: Prettier, Black, StyLua, gofmt, goimports
- **Syntax Highlighting**: Advanced Treesitter configuration
- **Error Detection**: Real-time diagnostics and linting

### 🎨 Professional UI
- **Tokyo Night Theme**: Customized with vibrant colors
- **Anime Dashboard**: Rotating waifu ASCII art with Japanese footer
- **Enhanced Status Line**: Custom lualine with LSP info and Git status
- **File Explorer**: NvimTree + Oil.nvim dual setup
- **Fuzzy Finder**: Telescope with custom pickers

### ⚡ Git Integration
- **LazyGit**: Terminal UI para Git con navegación visual intuitiva
- **GitSigns**: Visual indicators for changes, additions, deletions
- **DiffView**: Professional merge conflict resolution
- **Git Integration**: Neovim as default Git editor (no more VSCode!)
- **Conflict Resolution**: Quick keymaps for choosing versions

### 🔧 Developer Tools
- **Mason**: Automatic LSP server management
- **Which-Key**: Interactive keymap hints
- **Auto-pairs**: Intelligent bracket/quote completion
- **Terminal Integration**: Multiple terminal layouts
- **Markdown Preview**: Renderizado inline de Markdown mientras escribes
- **Testing Integration**: Neotest para ejecutar y visualizar tests
- **Debugging**: DAP (Debug Adapter Protocol) integrado

## 📦 Installation

### 🔧 Prerequisites & Dependencies

Esta configuración requiere las siguientes herramientas instaladas:

#### 📥 Instaladores de Paquetes
- **Scoop**: [https://scoop.sh/](https://scoop.sh/)
- **Node.js**: [https://nodejs.org/](https://nodejs.org/)
- **Python**: [https://python.org/](https://python.org/)

#### 🛠️ Herramientas Esenciales
- **Neovim**: [https://neovim.io/](https://neovim.io/)
- **Git**: [https://git-scm.com/](https://git-scm.com/)
- **LazyGit**: [https://github.com/jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)
- **Ripgrep**: [https://github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
- **FZF**: [https://github.com/junegunn/fzf](https://github.com/junegunn/fzf)

#### 🎨 Fuentes
- **JetBrains Mono Nerd Font**: [https://www.nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
- **Cascadia Code**: [https://github.com/microsoft/cascadia-code](https://github.com/microsoft/cascadia-code)

#### 🔧 LSP y Formatters
- **Tree-sitter CLI**: [https://tree-sitter.github.io/tree-sitter/](https://tree-sitter.github.io/tree-sitter/)
- **Prettier**: [https://prettier.io/](https://prettier.io/)
- **ESLint**: [https://eslint.org/](https://eslint.org/)
- **Black**: [https://black.readthedocs.io/](https://black.readthedocs.io/)
- **StyLua**: [https://github.com/JohnnyMorganz/StyLua](https://github.com/JohnnyMorganz/StyLua)

### 🚀 Instalación Automática (Recomendada)

1. **Instalar Scoop** (administrador de paquetes):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

2. **Ejecutar script de instalación automática**:
```powershell
# Descargar e instalar todo automáticamente
powershell -ExecutionPolicy Bypass -File install-nerd-font.ps1

# Con API key de OpenAI (opcional)
powershell -ExecutionPolicy Bypass -File install-nerd-font.ps1 -OpenAiApiKey "tu-api-key"
```

### 🔧 Instalación Manual

1. **Instalar dependencias básicas**:
```bash
# Herramientas esenciales
scoop install neovim git nodejs python go php composer
scoop bucket add extras
scoop install extras/vcredist2022

# Herramientas adicionales
scoop install ripgrep fzf fd lazygit

# Formatters y linters
npm install -g prettier eslint_d @prettier/plugin-php tree-sitter-cli
pip install black flake8
scoop install stylua

# Fuente Nerd Font
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

2. **Verificar instalación**:
```bash
# Verificar que todas las herramientas estén instaladas
nvim --version
git --version
node --version
python --version
lazygit --version
rg --version
fd --version
```

### Setup Neovim Configuration

1. **Clone this repository**:
```bash
git clone https://github.com/AngelArgumedo/nvim-config.git %LOCALAPPDATA%\nvim
```

2. **Install plugins** (first launch):
```bash
nvim
# Lazy.nvim will automatically install all plugins
```

3. **Setup Supermaven** (AI autocompletion):
```bash
# Set your OpenAI API key (recommended):
$env:OPENAI_API_KEY = "your-openai-api-key-here"

# Or use free version:
# In Neovim, run: :SupermavenUseFree
```

4. **Configure Git integration**:
```bash
git config --global core.editor "nvim"
git config --global merge.tool "vimdiff"
git config --global merge.conflictstyle diff3
git config --global mergetool.keepBackup false
```

## ⌨️ Key Mappings

### 🗂️ File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>w` | `:w` | Save file |
| `<leader>q` | `:q` | Quit |
| `<leader>Q` | `:q!` | Force quit without saving |
| `<leader>e` | `NvimTreeToggle` | Toggle file explorer |
| `-` | `Oil` | Open Oil file manager |

### 🔍 Search & Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>f` | Find files | Telescope file finder |
| `<leader>r` | Recent files | Recently opened files |
| `<leader>ff` | Find files | Same as `<leader>f` |
| `<leader>fg` | Live grep | Search text in files |
| `<leader>fb` | Browse buffers | Open buffer list |
| `<leader>fh` | Help tags | Search help documentation |

### 💻 Coding & LSP
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>fm` | Format file | Format current file |
| `<leader>ca` | Code actions | Show available code actions |
| `<leader>rn` | Rename symbol | Rename symbol under cursor |
| `gd` | Go to definition | Jump to definition |
| `gr` | Go to references | Show references |
| `K` | Hover documentation | Show documentation |
| `[d` / `]d` | Navigate diagnostics | Previous/next diagnostic |

### 🌿 Git Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit interface |
| `<leader>gG` | LazyGit Config | Open LazyGit configuration |
| `<leader>gd` | Git diff | Open diff view |
| `<leader>gc` | Close diff | Close diff view |
| `<leader>gh` | File history | Show file history |
| `<leader>gM` | Resolve conflicts | Open merge conflict resolution |
| `<leader>co` | Choose ours | Accept our version |
| `<leader>ct` | Choose theirs | Accept their version |
| `<leader>cb` | Choose base | Accept base version |
| `]c` / `[c` | Navigate hunks | Next/previous git hunk |

### 🏠 Git Hunks (GitSigns)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>hs` | Stage hunk | Stage current hunk |
| `<leader>hr` | Reset hunk | Reset current hunk |
| `<leader>hp` | Preview hunk | Preview hunk changes |
| `<leader>hb` | Blame line | Show git blame |
| `<leader>tb` | Toggle blame | Toggle line blame |

### 📺 Terminal
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ac` | Claude terminal | Open Claude Code in floating terminal |
| `<leader>tf` | Float terminal | Open floating terminal |
| `<leader>th` | Horizontal terminal | Open terminal below |
| `<leader>tv` | Vertical terminal | Open terminal to the side |
| `<C-\>` | Toggle terminal | Quick toggle terminal |

### 📝 Editing & AI
| Key | Action | Description |
|-----|--------|-------------|
| `<Tab>` | Accept AI suggestion | Accept full Supermaven suggestion |
| `<C-j>` | Accept word | Accept one word from suggestion |
| `<C-]>` | Clear suggestion | Clear current AI suggestion |
| `<S-h>` / `<S-l>` | Switch buffers | Navigate between buffers |
| `<C-h/j/k/l>` | Window navigation | Move between splits |
| `gcc` | Toggle comment | Comment/uncomment line |
| `gbc` | Block comment | Toggle block comment |

## 🎨 Customization

### Themes & Colors
- **Primary Theme**: Tokyo Night (Night variant)
- **Custom Highlights**: Enhanced syntax highlighting for all languages
- **GitSigns Colors**: Vibrant green (add), blue (change), red (delete)
- **Dashboard**: Rotating waifu ASCII art with Japanese footer

### AI Autocompletion
- **Supermaven**: Ultra-fast AI autocompletion (faster than Copilot)
- **OpenAI API Support**: Use your own API key for unlimited suggestions
- **Inline Suggestions**: Ghost text appears while typing
- **Smart Accept**: Tab for full suggestion, Ctrl+J for word-by-word

### Dashboard Buttons
| Key | Action | Command |
|-----|--------|---------|
| `f` | Find Files | `<cmd>Telescope find_files<CR>` |
| `r` | Recent Files | `<cmd>Telescope oldfiles<CR>` |
| `t` | Find Text | `<cmd>Telescope live_grep<CR>` |
| `n` | New File | `<cmd>ene<CR>` |
| `p` | Projects | `<cmd>Telescope git_files<CR>` |
| `s` | Lazy Sync | `<cmd>Lazy sync<CR>` |
| `c` | Configuration | `<cmd>e $MYVIMRC<CR>` |
| `q` | Quit | `<cmd>qa<CR>` |

## 🏗️ Architecture

### Modular Structure
```
lua/
├── core/               # Core Neovim settings
│   ├── init.lua        # Core loader
│   ├── options.lua     # vim.opt configurations
│   ├── keymaps.lua     # Global keymaps
│   └── autocmds.lua    # Autocommands
├── plugins/            # Plugin specifications
│   ├── init.lua        # Lazy.nvim setup
│   ├── ui.lua          # UI plugins (theme, dashboard, statusline)
│   ├── editor.lua      # Editor enhancements
│   ├── coding.lua      # Development tools (LSP, completion)
│   └── git.lua         # Git integration
├── config/             # Plugin configurations
│   ├── alpha.lua       # Dashboard config
│   ├── lsp.lua         # LSP configuration
│   ├── cmp.lua         # Autocompletion
│   ├── colors.lua      # Custom color schemes
│   └── [others]        # Individual plugin configs
└── utils/              # Utility functions
    ├── init.lua        # Helper functions
    └── ascii.lua       # ASCII art for dashboard
```

## 🛠️ Troubleshooting

### Common Issues

**LSP not working:**
```bash
:LspInfo          # Check LSP status
:Mason            # Reinstall LSP servers
```

**Supermaven not working:**
```bash
:SupermavenStart     # Start Supermaven
:SupermavenStop      # Stop Supermaven
:SupermavenRestart   # Restart Supermaven
```

**Git merge conflicts not opening in Neovim:**
```bash
git config --global core.editor "nvim"
git mergetool     # Test merge tool
```

**Plugin errors:**
```bash
:Lazy clean       # Remove unused plugins
:Lazy sync        # Update and install plugins
```

**Permission errors (Windows):**
```bash
git config --global --add safe.directory "C:/Users/YourUser/AppData/Local/nvim-data"
```

### Health Check
```bash
:checkhealth      # Comprehensive health check
:checkhealth lazy # Check plugin manager
:checkhealth lsp  # Check LSP configuration
```
## ✨ Nuevas Características Agregadas

### 📝 Renderizado de Markdown en Tiempo Real
- **render-markdown.nvim**: Renderiza Markdown inline mientras escribes
- **Características**:
  - Headers con diferentes tamaños y colores
  - **Texto en negrita** y *cursiva* renderizado visualmente
  - `código inline` con highlighting
  - Listas con bullets apropiados
  - Links clickeables y tablas formateadas
  - Se activa automáticamente en archivos `.md`

### 🚀 LazyGit Integration
- **LazyGit UI**: Interfaz terminal visual para Git
- **Funcionalidades**:
  - Vista visual del estado del repositorio
  - Commits, pushes, pulls con navegación simple
  - Gestión de branches y merges visualmente
  - Resolución de conflictos interactiva
  - Diffs y logs de forma gráfica
- **Keybindings**:
  - `<leader>gg` - Abrir LazyGit
  - `<leader>gG` - Configuración de LazyGit

### 🎯 Navegación LazyGit
Una vez abierto LazyGit:
- `↑↓←→` - Navegar entre paneles
- `Enter` - Seleccionar/confirmar
- `Space` - Stage/unstage archivos
- `c` - Commit
- `P` - Push, `p` - Pull
- `n` - Nueva branch
- `m` - Merge
- `d` - Ver diff
- `l` - Ver logs
- `q` - Salir

## 📋 Instalación con Script PowerShell

### Opción 1: Instalación Automática Completa
```powershell
# Instalar todo (Neovim + dependencias + fuentes + configuración)
powershell -ExecutionPolicy Bypass -File install-nerd-font.ps1
```

### Opción 2: Con API Key de OpenAI
```powershell
# Instalar con clave API para Supermaven
powershell -ExecutionPolicy Bypass -File install-nerd-font.ps1 -OpenAiApiKey "tu-api-key"
```

### ¿Qué hace el script?
1. Instala Scoop si no está instalado
2. Instala todas las dependencias automáticamente
3. Descarga e instala JetBrains Mono Nerd Font
4. Clona la configuración de Neovim
5. Configura Git para usar Neovim como editor
6. Instala y configura Supermaven con tu API key (opcional)

## 🤝 Contributing

Feel free to:
- Report bugs by creating an issue
- Suggest new features
- Submit pull requests for improvements
- Share your customizations

## 📜 License

This configuration is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Tokyo Night**: Beautiful color scheme
- **Lazy.nvim**: Fast and modern plugin manager
- **Supermaven**: Ultra-fast AI autocompletion
- **Neovim Community**: Amazing ecosystem and plugins

---

<div align="center">

**✦  想像できれば、プログラムできます。✦**

*If you can imagine it, you can program it.*

Made with ❤️ and ☕ for the Neovim community

</div>
