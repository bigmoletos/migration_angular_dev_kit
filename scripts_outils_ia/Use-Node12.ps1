<#
.SYNOPSIS
    Bascule vers Node.js v12 (Angular 9-11)

.DESCRIPTION
    Configure le PATH pour utiliser Node.js v12.22.12
    Compatible avec Angular 9, 10, 11 (Paliers 5-7)

.EXAMPLE
    Use-Node12
    node --version  # v12.22.12
#>

$NODE_VERSION = "12"
$NODE_FOLDER = "node-v12.22.12-win-x64"
$NODE_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions\$NODE_FOLDER"

if (Test-Path $NODE_PATH) {
    # Retirer les anciennes versions Node du PATH
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*nodejs-versions*' }) -join ';'
    
    # Ajouter la nouvelle version en début de PATH
    $env:PATH = "$NODE_PATH;$env:PATH"
    
    Write-Host "✅ Node.js v$NODE_VERSION activé" -ForegroundColor Green
    Write-Host "   Path: $NODE_PATH" -ForegroundColor Cyan
    Write-Host "   Compatible: Angular 9-11 (Paliers 5-7)" -ForegroundColor Yellow
    
    # Vérifier
    $version = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Host "   Node: $version | npm: $npmVersion" -ForegroundColor White
} else {
    Write-Host "❌ Node.js v$NODE_VERSION non trouvé" -ForegroundColor Red
    Write-Host "   Chemin attendu: $NODE_PATH" -ForegroundColor Yellow
    Write-Host "   Télécharger: https://nodejs.org/dist/v12.22.12/node-v12.22.12-win-x64.zip" -ForegroundColor Cyan
}
