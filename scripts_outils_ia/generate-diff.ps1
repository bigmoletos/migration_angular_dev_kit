<#
.SYNOPSIS
    Génère un diff après modification d'un fichier

.DESCRIPTION
    Ce script génère un fichier diff comparant le snapshot original
    avec le fichier modifié, pour documentation et traçabilité.

.VERSION
    1.0.0

.LAST UPDATE
    2026-02-04

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-04) : Création initiale

.PARAMETER ModificationId
    ID de la modification (ex: mod-20260204-143000)

.EXAMPLE
    .\generate-diff.ps1 -ModificationId "mod-20260204-143000"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ModificationId
)

# Configuration
$indexFile = ".kiro/state/modifications-index.json"
$diffsDir = ".kiro-backup/diffs"

# Lire l'index
if (-not (Test-Path $indexFile)) {
    Write-Error "❌ Index des modifications non trouvé : $indexFile"
    exit 1
}

$index = Get-Content $indexFile -Raw | ConvertFrom-Json

# Trouver la modification
$modification = $index.modifications | Where-Object { $_.id -eq $ModificationId }

if (-not $modification) {
    Write-Error "❌ Modification non trouvée : $ModificationId"
    exit 1
}

# Vérifier que le snapshot existe
if (-not (Test-Path $modification.snapshot)) {
    Write-Error "❌ Snapshot non trouvé : $($modification.snapshot)"
    exit 1
}

# Vérifier que le fichier modifié existe
if (-not (Test-Path $modification.file)) {
    Write-Error "❌ Fichier modifié non trouvé : $($modification.file)"
    exit 1
}

# Créer le dossier diffs si nécessaire
if (-not (Test-Path $diffsDir)) {
    New-Item -ItemType Directory -Path $diffsDir -Force | Out-Null
}

# Générer le diff
$diffFile = "$diffsDir/$ModificationId.diff"

# Utiliser git diff si disponible, sinon Compare-Object
try {
    $gitDiff = git diff --no-index $modification.snapshot $modification.file 2>&1
    $gitDiff | Out-File -FilePath $diffFile -Encoding UTF8
    Write-Host "✅ Diff généré avec git : $diffFile"
} catch {
    # Fallback : utiliser Compare-Object
    $original = Get-Content $modification.snapshot
    $modified = Get-Content $modification.file
    $diff = Compare-Object $original $modified -PassThru
    
    $diffContent = @()
    $diffContent += "--- $($modification.snapshot)"
    $diffContent += "+++ $($modification.file)"
    $diffContent += ""
    foreach ($line in $diff) {
        if ($line.SideIndicator -eq "<=") {
            $diffContent += "- $line"
        } else {
            $diffContent += "+ $line"
        }
    }
    
    $diffContent | Out-File -FilePath $diffFile -Encoding UTF8
    Write-Host "✅ Diff généré avec Compare-Object : $diffFile"
}

# Mettre à jour le statut dans l'index
for ($i = 0; $i -lt $index.modifications.Count; $i++) {
    if ($index.modifications[$i].id -eq $ModificationId) {
        $index.modifications[$i].status = "applied"
        $index.modifications[$i].diff = $diffFile
        break
    }
}

$index.metadata.lastUpdate = Get-Date -Format "yyyy-MM-dd"
$index | ConvertTo-Json -Depth 10 | Set-Content $indexFile -Encoding UTF8
Write-Host "✅ Index mis à jour : statut = applied"

# Afficher le diff
Write-Host ""
Write-Host "📄 CONTENU DU DIFF"
Write-Host "=================="
Get-Content $diffFile | Select-Object -First 50
if ((Get-Content $diffFile).Count -gt 50) {
    Write-Host "... (tronqué, voir $diffFile pour le diff complet)"
}
Write-Host ""
