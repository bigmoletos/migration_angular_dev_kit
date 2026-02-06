# verify-backups.ps1
# Vérifie que tous les backups existent

# Charger l'index
$indexPath = ".kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "❌ Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

Write-Host "🔍 Vérification des backups..."
Write-Host ""

$total = 0
$missing = 0
$found = 0

foreach ($mod in $index.modifications) {
    if (-not $mod.backup) {
        continue
    }
    
    $total++
    
    if (Test-Path $mod.backup) {
        $found++
        Write-Host "✅ $($mod.id) : $($mod.backup)"
    } else {
        $missing++
        Write-Warning "❌ $($mod.id) : $($mod.backup) - MANQUANT"
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "📊 Résumé :"
Write-Host "   Total : $total"
Write-Host "   ✅ Trouvés : $found"
Write-Host "   ❌ Manquants : $missing"
Write-Host ""

if ($missing -eq 0) {
    Write-Host "✅ Tous les backups sont présents"
    exit 0
} else {
    Write-Warning "⚠️ $missing backup(s) manquant(s)"
    exit 1
}
