# import-existing-modifications.ps1
# Importe les modifications existantes depuis le journal de bord

Write-Host "Import des modifications existantes depuis le journal de bord..."
Write-Host ""

# Charger l'index
$indexPath = "../.kiro/state/modifications-index.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "[ERROR] Index introuvable : $indexPath"
    exit 1
}

$index = Get-Content $indexPath | ConvertFrom-Json

# Modifications connues depuis le journal de bord v0.1.0 à v0.6.0
$existingModifications = @(
    @{
        file = "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/gradle.properties"
        type = "addition"
        description = "Ajout variables Nexus et Docker"
        reason = "Configuration Nexus selon modop_nexus.md"
        date = "2026-01-31T10:00:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/settings.gradle"
        type = "modification"
        description = "Fallback sur gradle.properties pour Nexus"
        reason = "Permettre l'utilisation de System.getProperty en fallback"
        date = "2026-01-31T10:30:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/.npmrc"
        type = "modification"
        description = "Configuration authentification Nexus"
        reason = "Accès aux packages custom HPS"
        date = "2026-01-31T11:00:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/gradle.properties"
        type = "addition"
        description = "Ajout variables Nexus et Docker"
        reason = "Configuration Nexus selon modop_nexus.md"
        date = "2026-01-31T10:00:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/settings.gradle"
        type = "modification"
        description = "Fallback sur gradle.properties pour Nexus"
        reason = "Permettre l'utilisation de System.getProperty en fallback"
        date = "2026-01-31T10:30:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/.npmrc"
        type = "modification"
        description = "Configuration authentification Nexus"
        reason = "Accès aux packages custom HPS"
        date = "2026-01-31T11:00:00Z"
        journalEntry = "v0.1.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json"
        type = "modification"
        description = "Lien local vers @pwc/shared"
        reason = "@pwc/shared n'existe pas sur npmjs.org"
        date = "2026-02-02T14:00:00Z"
        journalEntry = "v0.3.0"
    },
    @{
        file = "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json"
        type = "addition"
        description = "Ajout de json-ignore"
        reason = "json-ignore utilisé par @pwc/shared mais non déclaré"
        date = "2026-02-02T16:00:00Z"
        journalEntry = "v0.4.0"
    }
)

Write-Host "$($existingModifications.Count) modifications a importer"
Write-Host ""

$imported = 0

foreach ($mod in $existingModifications) {
    $index.lastModificationId++
    $modId = "mod-{0:D3}" -f $index.lastModificationId
    
    # Créer un backup si le fichier existe
    $backup = $null
    if (Test-Path $mod.file) {
        try {
            $backupDir = "../.kiro-backup/backup/$(($mod.date -split 'T')[0])"
            if (-not (Test-Path $backupDir)) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            }
            
            $fileName = Split-Path $mod.file -Leaf
            $backupPath = Join-Path $backupDir "$modId-$fileName.bak"
            Copy-Item $mod.file $backupPath -Force
            $backup = $backupPath
            
            Write-Host "[OK] Backup cree : $backupPath"
        }
        catch {
            Write-Warning "[WARN] Impossible de creer le backup pour $($mod.file)"
        }
    }
    
    # Créer l'entrée
    $modification = @{
        id = $modId
        date = $mod.date
        author = "Kiro"
        file = $mod.file
        type = $mod.type
        description = $mod.description
        reason = $mod.reason
        backup = $backup
        rollbackCommand = if ($backup) { "Copy-Item $backup $($mod.file) -Force" } else { "" }
        changes = @()
        relatedJournalEntry = $mod.journalEntry
        status = "applied"
    }
    
    $index.modifications += $modification
    $imported++
    
    Write-Host "[MOD] $modId : $($mod.description)"
}

# Sauvegarder l'index
$index | ConvertTo-Json -Depth 10 | Set-Content $indexPath

Write-Host ""
Write-Host "============================================================"
Write-Host "[OK] Import termine : $imported modifications importees"
Write-Host ""
Write-Host "Utilisez .\list-modifications.ps1 pour voir toutes les modifications"
