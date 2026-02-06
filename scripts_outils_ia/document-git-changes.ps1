# document-git-changes.ps1
# Documente les fichiers modifies dans Git qui n'ont pas encore ete commites

param(
    [string]$RepoPath = ".",
    [switch]$DryRun
)

Write-Host "Analyse des fichiers modifies dans Git..."
Write-Host "Repo : $RepoPath"
Write-Host ""

# Obtenir les fichiers modifies
$gitStatus = git -C $RepoPath status --porcelain | Where-Object { $_ -match '^ M ' }

if (-not $gitStatus) {
    Write-Host "Aucun fichier modifie trouve"
    exit 0
}

Write-Host "Fichiers modifies trouves :"
$gitStatus | ForEach-Object {
    $file = $_ -replace '^ M ', ''
    Write-Host "  - $file"
}
Write-Host ""

# Charger l'index
$indexPath = "../.kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "[ERROR] Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

# Pour chaque fichier modifie
$documented = 0
$alreadyDocumented = 0

foreach ($line in $gitStatus) {
    $file = $line -replace '^ M ', ''
    $fullPath = Join-Path $RepoPath $file
    $fullPath = $fullPath -replace '\\', '/'
    
    # Verifier si deja documente
    $existing = $index.modifications | Where-Object { $_.file -eq $fullPath -and $_.status -eq "applied" }
    
    if ($existing) {
        Write-Host "[SKIP] $file - Deja documente ($($existing.id))"
        $alreadyDocumented++
        continue
    }
    
    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[NEW] $file"
    Write-Host ""
    
    # Demander les informations
    if (-not $DryRun) {
        $description = Read-Host "Description de la modification"
        $reason = Read-Host "Raison de la modification"
        $type = Read-Host "Type (modification/addition/deprecation/creation)"
        $journalEntry = Read-Host "Version du journal (ex: v0.4.0)"
        
        # Creer un backup
        Write-Host ""
        Write-Host "Creation du backup..."
        
        try {
            $backupResult = & "$PSScriptRoot\backup-file.ps1" -File $fullPath
            
            # Enregistrer la modification
            Write-Host "Enregistrement de la modification..."
            
            $index.lastModificationId++
            $modId = "mod-{0:D3}" -f $index.lastModificationId
            
            $modification = @{
                id = $modId
                date = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                author = "Kiro"
                file = $fullPath
                type = $type
                description = $description
                reason = $reason
                backup = $backupResult
                rollbackCommand = "Copy-Item $backupResult $fullPath -Force"
                changes = @()
                relatedJournalEntry = $journalEntry
                status = "applied"
            }
            
            $index.modifications += $modification
            
            Write-Host "[OK] $modId : $description"
            $documented++
        }
        catch {
            Write-Error "[ERROR] Echec : $_"
        }
    }
    else {
        Write-Host "[DRY RUN] Serait documente"
        $documented++
    }
}

# Sauvegarder l'index
if (-not $DryRun) {
    $index | ConvertTo-Json -Depth 10 | Set-Content $indexPath
}

Write-Host ""
Write-Host "============================================================"
Write-Host "Resume :"
Write-Host "  Documentes : $documented"
Write-Host "  Deja documentes : $alreadyDocumented"
Write-Host ""

if ($DryRun) {
    Write-Host "Mode DRY RUN - Aucune modification effectuee"
}
