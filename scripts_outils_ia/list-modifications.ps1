<#
.SYNOPSIS
    Liste les modifications enregistrées dans l'index

.DESCRIPTION
    Ce script affiche la liste des modifications avec leurs snapshots,
    permettant de voir l'historique et de préparer des rollbacks.

.VERSION
    1.0.0

.LAST UPDATE
    2026-02-04

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-04) : Création initiale

.PARAMETER File
    Filtrer par nom de fichier (optionnel)

.PARAMETER Palier
    Filtrer par numéro de palier (optionnel)

.PARAMETER Status
    Filtrer par statut : pending, applied, rolled-back (optionnel)

.PARAMETER Date
    Filtrer par date (format: yyyy-MM-dd) (optionnel)

.EXAMPLE
    .\list-modifications.ps1

.EXAMPLE
    .\list-modifications.ps1 -File "package.json"

.EXAMPLE
    .\list-modifications.ps1 -Palier 1 -Status "applied"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$File,
    
    [Parameter(Mandatory=$false)]
    [int]$Palier = -1,
    
    [Parameter(Mandatory=$false)]
    [string]$Status,
    
    [Parameter(Mandatory=$false)]
    [string]$Date
)

# Configuration
$indexFile = ".kiro/state/modifications-index.json"

# Lire l'index
if (-not (Test-Path $indexFile)) {
    Write-Host "⚠️ Aucune modification enregistrée (index non trouvé)"
    exit 0
}

$index = Get-Content $indexFile -Raw | ConvertFrom-Json

if ($index.modifications.Count -eq 0) {
    Write-Host "⚠️ Aucune modification enregistrée"
    exit 0
}

# Filtrer les modifications
$modifications = $index.modifications

if ($File) {
    $modifications = $modifications | Where-Object { $_.file -like "*$File*" }
}

if ($Palier -ge 0) {
    $modifications = $modifications | Where-Object { $_.palier -eq $Palier }
}

if ($Status) {
    $modifications = $modifications | Where-Object { $_.status -eq $Status }
}

if ($Date) {
    $modifications = $modifications | Where-Object { $_.date -like "$Date*" }
}

# Afficher les résultats
Write-Host ""
Write-Host "📋 LISTE DES MODIFICATIONS"
Write-Host "=========================="
Write-Host "Système : $($index.metadata.system) v$($index.metadata.version)"
Write-Host "Dernière mise à jour : $($index.metadata.lastUpdate)"
Write-Host ""

if ($modifications.Count -eq 0) {
    Write-Host "⚠️ Aucune modification correspondant aux critères"
    exit 0
}

Write-Host "Total : $($modifications.Count) modification(s)"
Write-Host ""

foreach ($mod in $modifications) {
    $statusIcon = switch ($mod.status) {
        "pending" { "⏳" }
        "applied" { "✅" }
        "rolled-back" { "🔙" }
        default { "❓" }
    }
    
    $snapshotExists = if (Test-Path $mod.snapshot) { "✅" } else { "❌" }
    
    Write-Host "─────────────────────────────────────────"
    Write-Host "$statusIcon ID: $($mod.id)"
    Write-Host "   Fichier     : $($mod.file)"
    Write-Host "   Description : $($mod.description)"
    Write-Host "   Date        : $($mod.date)"
    Write-Host "   Palier      : $($mod.palier)"
    Write-Host "   Statut      : $($mod.status)"
    Write-Host "   Snapshot    : $snapshotExists $($mod.snapshot)"
}

Write-Host "─────────────────────────────────────────"
Write-Host ""

# Statistiques
$pending = ($modifications | Where-Object { $_.status -eq "pending" }).Count
$applied = ($modifications | Where-Object { $_.status -eq "applied" }).Count
$rolledBack = ($modifications | Where-Object { $_.status -eq "rolled-back" }).Count

Write-Host "📊 STATISTIQUES"
Write-Host "==============="
Write-Host "⏳ En attente   : $pending"
Write-Host "✅ Appliquées   : $applied"
Write-Host "🔙 Annulées     : $rolledBack"
Write-Host ""
