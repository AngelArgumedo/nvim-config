# =============================================================================
# 🌸 Professional Neovim Configuration - Automated Installation Script
# =============================================================================
# This script installs everything needed for the complete Neovim setup
# Compatible with Windows 10/11
# =============================================================================

param(
    [string]$OpenAiApiKey = "",
    [switch]$SkipFont = $false,
    [switch]$Verbose = $false
)

# Enable verbose output if requested
if ($Verbose) {
    $VerbosePreference = "Continue"
}

# Colors for output
$Color = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
    Magenta = "Magenta"
}

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput "`n🚀 $Message" $Color.Cyan
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "✅ $Message" $Color.Green
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "⚠️  $Message" $Color.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "❌ $Message" $Color.Red
}

function Test-Command {
    param([string]$Command)
    try {
        if (Get-Command $Command -ErrorAction SilentlyContinue) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

# =============================================================================
# Main Installation Script
# =============================================================================

Write-ColorOutput @"
╔══════════════════════════════════════════════════════════════════╗
║  🌸 Professional Neovim Configuration - Auto Installer          ║
║                                                                  ║
║  This will install:                                              ║
║  • Scoop package manager                                         ║
║  • Neovim + All dependencies                                     ║
║  • Language servers (Lua, Python, JS/TS, PHP, Go)               ║
║  • Formatters and linters                                        ║
║  • JetBrains Mono Nerd Font                                      ║
║  • Git configuration for Neovim                                  ║
║  • Professional Neovim config with AI autocompletion            ║
║                                                                  ║
║  ⚡ Total installation time: ~5-10 minutes                       ║
╚══════════════════════════════════════════════════════════════════╝
"@ $Color.Magenta

Write-ColorOutput "`nPress any key to continue or Ctrl+C to cancel..." $Color.Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================

Write-Step "Checking system requirements..."

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "PowerShell 5.0 or higher is required. Please update PowerShell."
    exit 1
}

Write-Success "PowerShell version: $($PSVersionTable.PSVersion)"

# =============================================================================
# Step 2: Install Scoop Package Manager
# =============================================================================

Write-Step "Installing Scoop package manager..."

if (-not (Test-Command "scoop")) {
    try {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
        Write-Success "Scoop installed successfully"
    }
    catch {
        Write-Error "Failed to install Scoop: $_"
        exit 1
    }
}
else {
    Write-Success "Scoop already installed"
}

# Update Scoop
Write-ColorOutput "Updating Scoop..." $Color.Blue
scoop update

# Add required buckets
Write-ColorOutput "Adding Scoop buckets..." $Color.Blue
scoop bucket add extras
scoop bucket add nerd-fonts

# =============================================================================
# Step 3: Install Core Tools
# =============================================================================

Write-Step "Installing core development tools..."

$CoreTools = @(
    "neovim",
    "git",
    "nodejs",
    "python",
    "go",
    "php",
    "composer"
)

foreach ($tool in $CoreTools) {
    Write-ColorOutput "Installing $tool..." $Color.Blue
    if (scoop list $tool 2>$null) {
        Write-Success "$tool already installed"
    }
    else {
        scoop install $tool
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$tool installed successfully"
        }
        else {
            Write-Warning "Failed to install $tool, continuing..."
        }
    }
}

# Install Visual C++ Redistributable for PHP
Write-ColorOutput "Installing Visual C++ Redistributable..." $Color.Blue
scoop install extras/vcredist2022

# =============================================================================
# Step 4: Install Formatters and Linters
# =============================================================================

Write-Step "Installing formatters and linters..."

# Node.js packages
Write-ColorOutput "Installing Node.js packages..." $Color.Blue
$NodePackages = @(
    "prettier",
    "eslint_d",
    "@prettier/plugin-php",
    "tree-sitter-cli"
)

foreach ($package in $NodePackages) {
    Write-ColorOutput "Installing $package..." $Color.Blue
    npm install -g $package
}

# Python packages
Write-ColorOutput "Installing Python packages..." $Color.Blue
$PythonPackages = @("black", "flake8")
foreach ($package in $PythonPackages) {
    Write-ColorOutput "Installing $package..." $Color.Blue
    pip install $package
}

# StyLua for Lua formatting
Write-ColorOutput "Installing StyLua..." $Color.Blue
scoop install stylua

# Go tools
Write-ColorOutput "Installing Go tools..." $Color.Blue
go install golang.org/x/tools/cmd/goimports@latest

Write-Success "All formatters and linters installed"

# =============================================================================
# Step 5: Install Nerd Font
# =============================================================================

if (-not $SkipFont) {
    Write-Step "Installing JetBrains Mono Nerd Font..."

    try {
        scoop install nerd-fonts/JetBrainsMono-NF
        Write-Success "JetBrains Mono Nerd Font installed"
        Write-Warning "Please set your terminal font to 'JetBrains Mono Nerd Font'"
    }
    catch {
        Write-Warning "Failed to install Nerd Font. You can install it manually from: https://www.nerdfonts.com/"
    }
}
else {
    Write-Warning "Skipping font installation (--SkipFont flag used)"
}

# =============================================================================
# Step 6: Configure Git
# =============================================================================

Write-Step "Configuring Git for Neovim integration..."

git config --global core.editor "nvim"
git config --global merge.tool "vimdiff"
git config --global merge.conflictstyle "diff3"
git config --global mergetool.keepBackup false
git config --global mergetool.vimdiff.cmd 'nvim -d $LOCAL $REMOTE $MERGED -c "wincmd w" -c "wincmd J"'
git config --global difftool.default "vimdiff"

# Fix Git safe directories for plugins
$nvimDataPath = "$env:LOCALAPPDATA\nvim-data"
git config --global --add safe.directory $nvimDataPath
git config --global --add safe.directory "$nvimDataPath\lazy\*"

Write-Success "Git configured for Neovim"

# =============================================================================
# Step 7: Install Neovim Configuration
# =============================================================================

Write-Step "Installing Neovim configuration..."

$NvimConfigPath = "$env:LOCALAPPDATA\nvim"

# Backup existing config if it exists
if (Test-Path $NvimConfigPath) {
    $BackupPath = "$env:LOCALAPPDATA\nvim-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Warning "Existing Neovim config found. Creating backup at: $BackupPath"
    Move-Item $NvimConfigPath $BackupPath
}

# Clone the configuration
try {
    Write-ColorOutput "Cloning Neovim configuration..." $Color.Blue
    git clone https://github.com/AngelArgumedo/nvim-config.git $NvimConfigPath
    Write-Success "Neovim configuration installed"
}
catch {
    Write-Error "Failed to clone Neovim configuration: $_"
    exit 1
}

# =============================================================================
# Step 8: Setup OpenAI API Key (if provided)
# =============================================================================

if ($OpenAiApiKey -ne "") {
    Write-Step "Setting up OpenAI API key for Supermaven..."

    try {
        [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $OpenAiApiKey, "User")
        $env:OPENAI_API_KEY = $OpenAiApiKey
        Write-Success "OpenAI API key configured"
    }
    catch {
        Write-Warning "Failed to set OpenAI API key: $_"
    }
}
else {
    Write-Warning "No OpenAI API key provided. You can set it later with:"
    Write-ColorOutput '  $env:OPENAI_API_KEY = "your-api-key-here"' $Color.Blue
}

# =============================================================================
# Step 9: First Neovim Launch (Plugin Installation)
# =============================================================================

Write-Step "Installing Neovim plugins..."

Write-ColorOutput @"
🔄 Starting Neovim for first-time plugin installation...
   This may take 2-5 minutes depending on your internet connection.

   Neovim will:
   • Install Lazy.nvim plugin manager
   • Download and install all plugins
   • Configure LSP servers via Mason
   • Set up Treesitter parsers

   Please wait...
"@ $Color.Yellow

# Start Neovim and let it install plugins
try {
    # Use a headless mode to install plugins
    $process = Start-Process -FilePath "nvim" -ArgumentList "--headless", "+Lazy! sync", "+qall" -PassThru -WindowStyle Hidden

    # Wait for installation (with timeout)
    if (-not $process.WaitForExit(300000)) { # 5 minute timeout
        Write-Warning "Plugin installation is taking longer than expected..."
        Write-ColorOutput "You may need to run 'nvim' manually and execute ':Lazy sync'" $Color.Blue
        $process.Kill()
    }
    else {
        Write-Success "Plugins installed successfully"
    }
}
catch {
    Write-Warning "Automated plugin installation failed. You can install them manually:"
    Write-ColorOutput "  1. Open Neovim: nvim" $Color.Blue
    Write-ColorOutput "  2. Run: :Lazy sync" $Color.Blue
}

# =============================================================================
# Step 10: Verification and Final Steps
# =============================================================================

Write-Step "Verifying installation..."

# Check if key tools are available
$tools = @{
    "nvim" = "Neovim"
    "git" = "Git"
    "node" = "Node.js"
    "python" = "Python"
    "go" = "Go"
    "php" = "PHP"
    "composer" = "Composer"
}

$allGood = $true
foreach ($tool in $tools.Keys) {
    if (Test-Command $tool) {
        Write-Success "$($tools[$tool]) is available"
    }
    else {
        Write-Error "$($tools[$tool]) is not available in PATH"
        $allGood = $false
    }
}

# =============================================================================
# Installation Complete
# =============================================================================

Write-ColorOutput @"

╔══════════════════════════════════════════════════════════════════╗
║  🎉 Installation Complete!                                       ║
╚══════════════════════════════════════════════════════════════════╝

"@ $Color.Green

if ($allGood) {
    Write-ColorOutput @"
✅ Your professional Neovim setup is ready!

📚 What's installed:
   • Neovim with professional configuration
   • Tokyo Night theme with custom colors
   • Supermaven AI autocompletion
   • LSP servers for multiple languages
   • Git integration with merge conflict resolution
   • Claude Code integration (leader+ac)
   • File modification indicators
   • And much more!

🚀 Next steps:
   1. Restart your terminal/PowerShell
   2. Run: nvim
   3. Enjoy your new setup!

⌨️  Key shortcuts:
   • <leader>f  - Find files
   • <leader>r  - Recent files
   • <leader>ac - Open Claude Code
   • <leader>m  - Show unsaved files
   • <Tab>      - Accept AI suggestions

📖 Full documentation: README.md
"@ $Color.Cyan
}
else {
    Write-Warning @"
⚠️  Installation completed with some issues.
    Please check the error messages above and install missing tools manually.

    You can re-run this script or install missing components individually.
"@
}

Write-ColorOutput "`n✦  想像できれば、プログラムできます。✦" $Color.Magenta
Write-ColorOutput "Press any key to exit..." $Color.Blue
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")