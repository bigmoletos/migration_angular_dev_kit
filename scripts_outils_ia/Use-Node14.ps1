<#
.SYNOPSIS
    Bascule vers Node.js v14 (Angular 12)

.DESCRIPTION
    Configure le PATH pour utiliser Node.js v14.21.3
    Compatible avec Angular 12 (Palier 8)

.EXAMPLE
    Use-Node14
    node --version  # v14.21.3
#>

$NODE_VERSION = "14"
$NODE_FOLDER = "node-v14.21.3-win-x64"
$NODE_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions\$NODE_FOLDER"

if (Test-Path $NODE_PATH) {
    # Retirer les anciennes versions Node du PATH
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*nodejs-versions*' }) -join ';'
    
    # Ajouter la nouvelle version en début de PATH
    $env:PATH = "$NODE_PATH;$env:PATH"
    
    Write-Host "✅ Node.js v$NODE_VERSION activé" -ForegroundColor Green
    Write-Host "   Path: $NODE_PATH" -ForegroundColor Cyan
    Write-Host "   Compatible: Angular 12 (Palier 8)" -ForegroundColor Yellow
    
    # Vérifier
    $version = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Host "   Node: $version | npm: $npmVersion" -ForegroundColor White
} else {
    Write-Host "❌ Node.js v$NODE_VERSION non trouvé" -ForegroundColor Red
    Write-Host "   Chemin attendu: $NODE_PATH" -ForegroundColor Yellow
    Write-Host "   Télécharger: https://nodejs.org/dist/v14.21.3/node-v14.21.3-win-x64.zip" -ForegroundColor Cyan
}
