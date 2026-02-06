# cleanup-backups.ps1
# Nettoie les backups anciens

param(
    [int]$DaysOld = 30,
    [switch]$DryRun
)

$backupRoot = ".kiro-backup/backup"

if (-not (Test-Path $backupRoot)) {
    Write-Host "📁 Aucun dossier de backup trouvé"
    exit 0
}

$cutoffDate = (Get-Date).AddDays(-$DaysOld)

Write-Host "🧹 Nettoyage des backups de plus de $DaysOld jours..."
Write-Host "   Date limite : $($cutoffDate.ToString('yyyy-MM-dd'))"
Write-Host ""

$folders = Get-ChildItem $backupRoot -Directory
$deleted = 0
$kept = 0
$totalSize = 0

foreach ($folder in $folders) {
    try {
        $folderDate = [DateTime]::ParseExact($folder.Name, "yyyy-MM-dd", $null)
        
        if ($folderDate -lt $cutoffDate) {
            $size = (Get-ChildItem $folder.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
            $totalSize += $size
            $sizeMB = [math]::Round($size / 1MB, 2)
            
            if ($DryRun) {
                Write-Host "🗑️  [DRY RUN] Supprimerait : $($folder.Name) ($sizeMB MB)"
            } else {
                Remove-Item $folder.FullName -Recurse -Force
                Write-Host "🗑️  Supprimé : $($folder.Name) ($sizeMB MB)"
            }
            $deleted++
        } else {
            Write-Host "✅ Conservé : $($folder.Name)"
            $kept++
        }
    }
    catch {
        Write-Warning "⚠️ Impossible de traiter : $($folder.Name)"
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "📊 Résumé :"
Write-Host "   🗑️  Supprimés : $deleted"
Write-Host "   ✅ Conservés : $kept"
Write-Host "   💾 Espace libéré : $([math]::Round($totalSize / 1MB, 2)) MB"
Write-Host ""

if ($DryRun) {
    Write-Host "💡 Exécutez sans -DryRun pour supprimer réellement"
}
