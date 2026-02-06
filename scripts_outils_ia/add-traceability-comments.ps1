# add-traceability-comments.ps1
# Ajoute les commentaires de tracabilite dans les fichiers modifies

param(
    [Parameter(Mandatory=$true)]
    [string]$File,
    
    [Parameter(Mandatory=$true)]
    [string]$ModificationId
)

# Charger l'index
$indexPath = "../.kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "[ERROR] Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

# Trouver la modification
$mod = $index.modifications | Where-Object { $_.id -eq $ModificationId }

if (-not $mod) {
    Write-Error "[ERROR] Modification introuvable : $ModificationId"
    exit 1
}

Write-Host "Ajout des commentaires de tracabilite..."
Write-Host "Fichier : $File"
Write-Host "Modification : $ModificationId - $($mod.description)"
Write-Host ""

# Determiner le type de fichier
$extension = [System.IO.Path]::GetExtension($File)

# Format du commentaire selon le type de fichier
$commentPrefix = switch ($extension) {
    ".json" { "//" }
    ".ts" { "//" }
    ".js" { "//" }
    ".properties" { "#" }
    ".gradle" { "#" }
    ".npmrc" { "#" }
    default { "#" }
}

# Lire le contenu du fichier
$content = Get-Content $File -Raw

# Verifier si le commentaire existe deja
if ($content -match $ModificationId) {
    Write-Host "[SKIP] Le fichier contient deja des commentaires pour $ModificationId"
    exit 0
}

Write-Host "[INFO] Le fichier ne contient pas encore de commentaires de tracabilite"
Write-Host "[INFO] Vous devez ajouter manuellement les commentaires selon le format :"
Write-Host ""

switch ($mod.type) {
    "modification" {
        Write-Host "$commentPrefix ORIGINAL: <ligne originale>"
        Write-Host "$commentPrefix MODIFIED: $($mod.date.Split('T')[0]) - $($mod.author) - $($mod.description) ($ModificationId)"
        Write-Host "<nouvelle ligne>"
    }
    "addition" {
        Write-Host "$commentPrefix NEW: $($mod.date.Split('T')[0]) - $($mod.author) - $($mod.description) ($ModificationId)"
        Write-Host "<nouvelle ligne>"
    }
    "deprecation" {
        Write-Host "$commentPrefix DEPRECATED: $($mod.date.Split('T')[0]) - $($mod.author) - $($mod.description) ($ModificationId)"
        Write-Host "$commentPrefix <ancienne ligne commentee>"
    }
}

Write-Host ""
Write-Host "[INFO] Consultez .kiro/steering/12-modification-rules.md pour plus d'exemples"
