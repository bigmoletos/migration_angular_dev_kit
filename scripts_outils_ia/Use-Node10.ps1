<#
.SYNOPSIS
    Bascule vers Node.js v10 (Angular 5-8)

.DESCRIPTION
    Configure le PATH pour utiliser Node.js v10.24.1
    Compatible avec Angular 5, 6, 7, 8 (Paliers 1-4)

.EXAMPLE
    Use-Node10
    node --version  # v10.24.1
#>

$NODE_VERSION = "10"
$NODE_FOLDER = "node-v10.24.1-win-x64"
$NODE_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions\$NODE_FOLDER"

if (Test-Path $NODE_PATH) {
    # Retirer les anciennes versions Node du PATH
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*nodejs-versions*' }) -join ';'
    
    # Ajouter la nouvelle version en début de PATH
    $env:PATH = "$NODE_PATH;$env:PATH"
    
    Write-Host "✅ Node.js v$NODE_VERSION activé" -ForegroundColor Green
    Write-Host "   Path: $NODE_PATH" -ForegroundColor Cyan
    Write-Host "   Compatible: Angular 5-8 (Paliers 1-4)" -ForegroundColor Yellow
    
    # Vérifier
    $version = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Host "   Node: $version | npm: $npmVersion" -ForegroundColor White
} else {
    Write-Host "❌ Node.js v$NODE_VERSION non trouvé" -ForegroundColor Red
    Write-Host "   Chemin attendu: $NODE_PATH" -ForegroundColor Yellow
    Write-Host "   Télécharger: https://nodejs.org/dist/v10.24.1/node-v10.24.1-win-x64.zip" -ForegroundColor Cyan
}
