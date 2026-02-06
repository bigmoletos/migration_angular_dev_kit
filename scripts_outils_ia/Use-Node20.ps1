<#
.SYNOPSIS
    Bascule vers Node.js v20 (Angular 18-19)

.DESCRIPTION
    Configure le PATH pour utiliser Node.js v20.18.0
    Compatible avec Angular 18, 19 (Palier 14)

.EXAMPLE
    Use-Node20
    node --version  # v20.18.0
#>

$NODE_VERSION = "20"
$NODE_FOLDER = "node-v20.18.0-win-x64"
$NODE_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions\$NODE_FOLDER"

if (Test-Path $NODE_PATH) {
    # Retirer les anciennes versions Node du PATH
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*nodejs-versions*' }) -join ';'
    
    # Ajouter la nouvelle version en début de PATH
    $env:PATH = "$NODE_PATH;$env:PATH"
    
    Write-Host "✅ Node.js v$NODE_VERSION activé" -ForegroundColor Green
    Write-Host "   Path: $NODE_PATH" -ForegroundColor Cyan
    Write-Host "   Compatible: Angular 18-19 (Palier 14)" -ForegroundColor Yellow
    
    # Vérifier
    $version = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Host "   Node: $version | npm: $npmVersion" -ForegroundColor White
} else {
    Write-Host "❌ Node.js v$NODE_VERSION non trouvé" -ForegroundColor Red
    Write-Host "   Chemin attendu: $NODE_PATH" -ForegroundColor Yellow
    Write-Host "   Télécharger: https://nodejs.org/dist/v20.18.0/node-v20.18.0-win-x64.zip" -ForegroundColor Cyan
}
