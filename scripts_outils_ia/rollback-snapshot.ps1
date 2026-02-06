<#
.SYNOPSIS
    Restaure un fichier depuis son snapshot

.DESCRIPTION
    Ce script restaure un fichier à son état précédent en utilisant le snapshot
    créé avant modification. Il met également à jour l'index des modifications.

.VERSION
    1.0.0

.LAST UPDATE
    2026-02-04

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-04) : Création initiale

.PARAMETER ModificationId
    ID de la modification à annuler (ex: mod-20260204-143000)

.PARAMETER File
    Chemin du fichier à restaurer (alternative à ModificationId)

.PARAMETER Force
    Force le rollback sans confirmation

.EXAMPLE
    .\rollback-snapshot.ps1 -ModificationId "mod-20260204-143000"

.EXAMPLE
    .\rollback-snapshot.ps1 -File "pwc-ui/pwc-ui-v4-ia/package.json"

.EXAMPLE
    .\rollback-snapshot.ps1 -ModificationId "mod-20260204-143000" -Force
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$ModificationId,
    
    [Parameter(Mandatory=$false)]
    [string]$File,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configuration
$indexFile = ".kiro/state/modifications-index.json"

# Vérifier qu'au moins un paramètre est fourni
if (-not $ModificationId -and -not $File) {
    Write-Error "❌ Vous devez spécifier -ModificationId ou -File"
    exit 1
}

# Lire l'index
if (-not (Test-Path $indexFile)) {
    Write-Error "❌ Index des modifications non trouvé : $indexFile"
    exit 1
}

$index = Get-Content $indexFile -Raw | ConvertFrom-Json

# Trouver la modification
$modification = $null

if ($ModificationId) {
    $modification = $index.modifications | Where-Object { $_.id -eq $ModificationId }
} elseif ($File) {
    # Trouver la dernière modification pour ce fichier
    $modification = $index.modifications | 
        Where-Object { $_.file -like "*$File*" -and $_.status -eq "applied" } |
        Sort-Object -Property date -Descending |
        Select-Object -First 1
}

if (-not $modification) {
    Write-Error "❌ Modification non trouvée"
    exit 1
}

# Vérifier que le snapshot existe
if (-not (Test-Path $modification.snapshot)) {
    Write-Error "❌ Snapshot non trouvé : $($modification.snapshot)"
    exit 1
}

# Afficher les informations
Write-Host ""
Write-Host "🔙 ROLLBACK PRÉVU"
Write-Host "================="
Write-Host "ID          : $($modification.id)"
Write-Host "Fichier     : $($modification.file)"
Write-Host "Snapshot    : $($modification.snapshot)"
Write-Host "Description : $($modification.description)"
Write-Host "Date        : $($modification.date)"
Write-Host ""

# Demander confirmation si pas -Force
if (-not $Force) {
    $confirm = Read-Host "Voulez-vous restaurer ce fichier ? (O/N)"
    if ($confirm -ne "O" -and $confirm -ne "o") {
        Write-Host "❌ Rollback annulé"
        exit 0
    }
}

# Effectuer le rollback
Copy-Item $modification.snapshot $modification.file -Force
Write-Host "✅ Fichier restauré : $($modification.file)"

# Mettre à jour le statut dans l'index
$modIndex = [array]::IndexOf($index.modifications.id, $modification.id)
if ($modIndex -ge 0) {
    $index.modifications[$modIndex].status = "rolled-back"
    $index.metadata.lastUpdate = Get-Date -Format "yyyy-MM-dd"
    $index | ConvertTo-Json -Depth 10 | Set-Content $indexFile -Encoding UTF8
    Write-Host "✅ Index mis à jour : statut = rolled-back"
}

Write-Host ""
Write-Host "✅ ROLLBACK TERMINÉ"
Write-Host ""
