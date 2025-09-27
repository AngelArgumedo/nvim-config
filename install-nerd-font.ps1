# ==================================================================
# Script para instalar JetBrains Mono Nerd Font en Windows
# Soluciona el problema de iconos no visibles en Neovim
# ==================================================================

Write-Host "🔧 Instalando JetBrains Mono Nerd Font..." -ForegroundColor Cyan

# URL de descarga de JetBrains Mono Nerd Font
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
$tempDir = "$env:TEMP\NerdFont"
$zipFile = "$tempDir\JetBrainsMono.zip"
$extractDir = "$tempDir\JetBrainsMono"

# Crear directorio temporal
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
New-Item -ItemType Directory -Force -Path $extractDir | Out-Null

try {
    # Descargar la fuente
    Write-Host "📥 Descargando JetBrains Mono Nerd Font..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $fontUrl -OutFile $zipFile -UseBasicParsing

    # Extraer el archivo
    Write-Host "📂 Extrayendo archivos..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

    # Instalar fuentes
    Write-Host "🔧 Instalando fuentes..." -ForegroundColor Yellow
    $fontFiles = Get-ChildItem -Path $extractDir -Filter "*.ttf" | Where-Object { $_.Name -match "(Regular|Bold|Italic|Light)" -and $_.Name -notmatch "NL" }

    $shell = New-Object -ComObject Shell.Application
    $fontsFolder = $shell.Namespace(0x14)  # Fonts folder

    $installedCount = 0
    foreach ($font in $fontFiles) {
        try {
            $fontsFolder.CopyHere($font.FullName, 0x10)
            Write-Host "✅ Instalada: $($font.Name)" -ForegroundColor Green
            $installedCount++
        }
        catch {
            Write-Host "⚠️  Error instalando: $($font.Name)" -ForegroundColor Red
        }
    }

    # Limpiar archivos temporales
    Remove-Item -Path $tempDir -Recurse -Force

    Write-Host "`n🎉 ¡Instalación completada!" -ForegroundColor Green
    Write-Host "📊 Fuentes instaladas: $installedCount" -ForegroundColor Cyan

    # Instrucciones para configurar terminal
    Write-Host "`n🔧 SIGUIENTE PASO - Configura tu terminal:" -ForegroundColor Magenta
    Write-Host "1. Abre la configuración de tu terminal" -ForegroundColor White
    Write-Host "2. Cambia la fuente a 'JetBrainsMono Nerd Font'" -ForegroundColor White
    Write-Host "3. Reinicia Neovim para ver los iconos" -ForegroundColor White

    Write-Host "`n📝 Para Windows Terminal (recomendado):" -ForegroundColor Yellow
    Write-Host "   - Ctrl+, → Perfiles → Valores predeterminados → Apariencia" -ForegroundColor Gray
    Write-Host "   - Tipo de letra: 'JetBrainsMono Nerd Font'" -ForegroundColor Gray
    Write-Host "   - Tamaño: 12-14" -ForegroundColor Gray

    Write-Host "`n📝 Para PowerShell:" -ForegroundColor Yellow
    Write-Host "   - Click derecho en la barra de título → Propiedades → Fuente" -ForegroundColor Gray
    Write-Host "   - Seleccionar 'JetBrainsMono Nerd Font'" -ForegroundColor Gray

    Write-Host "`n🔄 Después de cambiar la fuente, ejecuta en Neovim:" -ForegroundColor Cyan
    Write-Host "   :lua print(require('nvim-web-devicons').get_icon('test.js'))" -ForegroundColor Gray

}
catch {
    Write-Host "❌ Error durante la instalación: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Intenta ejecutar como administrador" -ForegroundColor Yellow
}

Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")