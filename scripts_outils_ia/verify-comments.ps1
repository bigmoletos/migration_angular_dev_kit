# verify-comments.ps1
# Vérifie que les fichiers modifiés ont des commentaires

param(
    [string]$File = ""
)

# Charger l'index
$indexPath = ".kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "❌ Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

Write-Host "🔍 Vérification des commentaires..."
Write-Host ""

$modifications = $index.modifications

if ($File) {
    $modifications = $modifications | Where-Object { $_.file -like "*$File*" }
}

$total = 0
$withComments = 0
$withoutComments = 0

foreach ($mod in $modifications) {
    if (-not (Test-Path $mod.file)) {
        continue
    }
    
    $total++
    $content = Get-Content $mod.file -Raw
    
    # Chercher les commentaires de modification
    $hasModComment = $content -match "MODIFIED:.*$($mod.id)"
    $hasNewComment = $content -match "NEW:.*$($mod.id)"
    $hasDeprecatedComment = $content -match "DEPRECATED:.*$($mod.id)"
    
    if ($hasModComment -or $hasNewComment -or $hasDeprecatedComment) {
        $withComments++
        Write-Host "✅ $($mod.id) : $($mod.file)"
    } else {
        $withoutComments++
        Write-Warning "❌ $($mod.id) : $($mod.file) - COMMENTAIRES MANQUANTS"
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "📊 Résumé :"
Write-Host "   Total : $total"
Write-Host "   ✅ Avec commentaires : $withComments"
Write-Host "   ❌ Sans commentaires : $withoutComments"
Write-Host ""

if ($withoutComments -eq 0) {
    Write-Host "✅ Tous les fichiers ont des commentaires"
    exit 0
} else {
    Write-Warning "⚠️ $withoutComments fichier(s) sans commentaires"
    exit 1
}
