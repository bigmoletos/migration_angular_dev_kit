#!/usr/bin/env pwsh
<#
Script PowerShell pour lancer deux applications dans des terminaux séparés
#>

# Chemin vers les scripts batch
$script1 = "C:\repo_hps\outils_communs\start-pwc-ui-shared-4201.bat"
$script2 = "C:\repo_hps\outils_communs\start-pwc-ui.bat"

# Vérifier que les scripts existent
if (-not (Test-Path $script1)) {
    Write-Error "Le script $script1 n'existe pas"
    exit 1
}

if (-not (Test-Path $script2)) {
    Write-Error "Le script $script2 n'existe pas"
    exit 1
}

# Lancer le premier script dans un nouveau terminal PowerShell
Write-Host "Lancement de $script1 dans un nouveau terminal..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& { & '$script1' }" -WindowStyle Normal

# Attendre un peu pour éviter les conflits
Start-Sleep -Seconds 3

# Lancer le deuxième script dans un nouveau terminal PowerShell
Write-Host "Lancement de $script2 dans un nouveau terminal..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& { & '$script2' }" -WindowStyle Normal

Write-Host "Les deux applications ont été lancées dans des terminaux séparés."