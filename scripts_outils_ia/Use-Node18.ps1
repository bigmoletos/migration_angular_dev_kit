<#
.SYNOPSIS
    Bascule vers Node.js v18 (Angular 15-17)

.DESCRIPTION
    Configure le PATH pour utiliser Node.js v18.20.4
    Compatible avec Angular 15, 16, 17 (Paliers 11-13)

.EXAMPLE
    Use-Node18
    node --version  # v18.20.4
#>

$NODE_VERSION = "18"
$NODE_FOLDER = "node-v18.20.4-win-x64"
$NODE_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions\$NODE_FOLDER"

if (Test-Path $NODE_PATH) {
    # Retirer les anciennes versions Node du PATH
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*nodejs-versions*' }) -join ';'
    
    # Ajouter la nouvelle version en début de PATH
    $env:PATH = "$NODE_PATH;$env:PATH"
    
    Write-Host "✅ Node.js v$NODE_VERSION activé" -ForegroundColor Green
    Write-Host "   Path: $NODE_PATH" -ForegroundColor Cyan
    Write-Host "   Compatible: Angular 15-17 (Paliers 11-13)" -ForegroundColor Yellow
    
    # Vérifier
    $version = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Host "   Node: $version | npm: $npmVersion" -ForegroundColor White
} else {
    Write-Host "❌ Node.js v$NODE_VERSION non trouvé" -ForegroundColor Red
    Write-Host "   Chemin attendu: $NODE_PATH" -ForegroundColor Yellow
    Write-Host "   Télécharger: https://nodejs.org/dist/v18.20.4/node-v18.20.4-win-x64.zip" -ForegroundColor Cyan
}
