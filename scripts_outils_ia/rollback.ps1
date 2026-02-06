# rollback.ps1
# Effectue un rollback d'une ou plusieurs modifications

param(
    [string]$ModificationId = "",
    [string]$File = "",
    [string]$Date = "",
    [string]$JournalVersion = ""
)

# Charger l'index
$indexPath = ".kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "❌ Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

# Filtrer les modifications selon les paramètres
$modifications = $index.modifications

if ($ModificationId) {
    $modifications = $modifications | Where-Object { $_.id -eq $ModificationId }
    Write-Host "🔍 Rollback de la modification : $ModificationId"
}
elseif ($File) {
    $modifications = $modifications | Where-Object { $_.file -like "*$File*" }
    Write-Host "🔍 Rollback des modifications du fichier : $File"
}
elseif ($Date) {
    $modifications = $modifications | Where-Object { $_.date -like "$Date*" }
    Write-Host "🔍 Rollback des modifications du : $Date"
}
elseif ($JournalVersion) {
    $modifications = $modifications | Where-Object { $_.relatedJournalEntry -eq $JournalVersion }
    Write-Host "🔍 Rollback des modifications de la version : $JournalVersion"
}
else {
    Write-Error "❌ Paramètre requis : -ModificationId, -File, -Date ou -JournalVersion"
    exit 1
}

# Vérifier qu'il y a des modifications à rollback
if ($modifications.Count -eq 0) {
    Write-Warning "⚠️ Aucune modification trouvée"
    exit 0
}

Write-Host "📋 $($modifications.Count) modification(s) à rollback"
Write-Host ""

# Demander confirmation
$modifications | ForEach-Object {
    Write-Host "  - $($_.id) : $($_.description)"
}
Write-Host ""

$confirm = Read-Host "Confirmer le rollback ? (O/N)"
if ($confirm -ne "O" -and $confirm -ne "o") {
    Write-Host "❌ Rollback annulé"
    exit 0
}

# Effectuer le rollback
$success = 0
$failed = 0

foreach ($mod in $modifications) {
    Write-Host ""
    Write-Host "🔄 Rollback : $($mod.id) - $($mod.description)"
    
    # Vérifier que le backup existe
    if (-not $mod.backup -or -not (Test-Path $mod.backup)) {
        Write-Warning "⚠️ Backup introuvable : $($mod.backup)"
        $failed++
        continue
    }
    
    # Vérifier que le fichier cible existe
    if (-not (Test-Path $mod.file)) {
        Write-Warning "⚠️ Fichier cible introuvable : $($mod.file)"
        $failed++
        continue
    }
    
    try {
        # Effectuer le rollback
        Copy-Item $mod.backup $mod.file -Force
        
        # Mettre à jour le statut
        $mod.status = "rolled_back"
        
        Write-Host "✅ Rollback réussi : $($mod.file)"
        $success++
    }
    catch {
        Write-Error "❌ Échec du rollback : $_"
        $failed++
    }
}

# Sauvegarder l'index mis à jour
$index | ConvertTo-Json -Depth 10 | Set-Content $indexPath

# Résumé
Write-Host ""
Write-Host "📊 Résumé du rollback :"
Write-Host "   ✅ Réussis : $success"
Write-Host "   ❌ Échecs : $failed"

if ($failed -eq 0) {
    Write-Host ""
    Write-Host "✅ Rollback terminé avec succès"
    exit 0
} else {
    Write-Host ""
    Write-Warning "⚠️ Rollback terminé avec des erreurs"
    exit 1
}
