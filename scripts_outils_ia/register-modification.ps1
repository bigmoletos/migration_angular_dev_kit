# register-modification.ps1
# Enregistre une modification dans l'index

param(
    [Parameter(Mandatory=$true)]
    [string]$File,
    
    [Parameter(Mandatory=$true)]
    [string]$Type,  # modification, addition, deprecation, creation
    
    [Parameter(Mandatory=$true)]
    [string]$Description,
    
    [string]$Reason = "",
    [string]$Backup = "",
    [string]$RelatedJournalEntry = "",
    [string]$Author = "Kiro"
)

# Charger l'index
$indexPath = ".kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "❌ Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

# Générer un nouvel ID
$index.lastModificationId++
$modId = "mod-{0:D3}" -f $index.lastModificationId

# Créer l'entrée de modification
$modification = @{
    id = $modId
    date = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    author = $Author
    file = $File
    type = $Type
    description = $Description
    reason = $Reason
    backup = $Backup
    rollbackCommand = if ($Backup) { "Copy-Item $Backup $File -Force" } else { "" }
    changes = @()
    relatedJournalEntry = $RelatedJournalEntry
    status = "pending"
}

# Ajouter à l'index
$index.modifications += $modification

# Sauvegarder l'index
$index | ConvertTo-Json -Depth 10 | Set-Content $indexPath

Write-Host "✅ Modification enregistrée : $modId"
Write-Host "   Fichier : $File"
Write-Host "   Type : $Type"
Write-Host "   Description : $Description"

# Retourner l'ID
return $modId
