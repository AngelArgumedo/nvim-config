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
- **Codeium Integration**: Free AI autocompletion (like Copilot)
- **Claude Code Integration**: Floating terminal with `<leader>ac`
- **Smart Suggestions**: Context-aware code completion

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
- **GitSigns**: Visual indicators for changes, additions, deletions
- **DiffView**: Professional merge conflict resolution
- **Git Integration**: Neovim as default Git editor (no more VSCode!)
- **Conflict Resolution**: Quick keymaps for choosing versions

### 🔧 Developer Tools
- **Mason**: Automatic LSP server management
- **Which-Key**: Interactive keymap hints
- **Auto-pairs**: Intelligent bracket/quote completion
- **Terminal Integration**: Multiple terminal layouts

## 📦 Installation

### Prerequisites (Windows)

1. **Install Scoop** (package manager):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

2. **Install Required Dependencies**:
```bash
# Core tools
scoop install neovim git nodejs python go php composer
scoop bucket add extras
scoop install extras/vcredist2022

# Formatters and tools
npm install -g prettier eslint_d @prettier/plugin-php tree-sitter-cli
pip install black flake8
scoop install stylua

# Font (recommended)
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
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

3. **Setup Codeium** (AI autocompletion):
```bash
# In Neovim, run:
:Codeium Auth
# Follow the authentication process
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

### 📝 Editing
| Key | Action | Description |
|-----|--------|-------------|
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
- **Codeium**: Free GitHub Copilot alternative
- **Priority Order**: AI → LSP → Snippets → Buffer → Path
- **Visual Indicator**: 🤖 [AI] for AI suggestions

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

**Codeium not working:**
```bash
:Codeium Auth     # Re-authenticate
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
- **Codeium**: Free AI autocompletion
- **Neovim Community**: Amazing ecosystem and plugins

---

<div align="center">

**✦  想像できれば、プログラムできます。✦**

*If you can imagine it, you can program it.*

Made with ❤️ and ☕ for the Neovim community

</div>
