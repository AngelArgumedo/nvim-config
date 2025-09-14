# Quick Installation Script for Professional Neovim Configuration
# Run with: powershell -ExecutionPolicy Bypass -File quick-install.ps1

Write-Host "🌸 Professional Neovim Configuration - Quick Installer" -ForegroundColor Magenta

# Install Scoop if not present
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

# Install everything in one go
Write-Host "Installing all dependencies..." -ForegroundColor Yellow

scoop bucket add extras
scoop bucket add nerd-fonts
scoop install neovim git nodejs python go php composer extras/vcredist2022 stylua nerd-fonts/JetBrainsMono-NF

# Install formatters
npm install -g prettier eslint_d @prettier/plugin-php tree-sitter-cli
pip install black flake8
go install golang.org/x/tools/cmd/goimports@latest

# Configure Git
git config --global core.editor "nvim"
git config --global merge.tool "vimdiff"
git config --global merge.conflictstyle "diff3"
git config --global mergetool.keepBackup false

# Install config
$nvimPath = "$env:LOCALAPPDATA\nvim"
if (Test-Path $nvimPath) {
    Move-Item $nvimPath "$env:LOCALAPPDATA\nvim-backup-$(Get-Date -Format 'yyyyMMdd')"
}

git clone https://github.com/AngelArgumedo/nvim-config.git $nvimPath

Write-Host "✅ Installation complete! Run 'nvim' to start." -ForegroundColor Green
Write-Host "Don't forget to set your OpenAI API key: `$env:OPENAI_API_KEY = 'your-key'" -ForegroundColor Cyan