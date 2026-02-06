# backup-file.ps1
# Crée un backup d'un fichier avant modification

param(
    [Parameter(Mandatory=$true)]
    [string]$File,
    
    [string]$ModificationId = $null
)

# Vérifier que le fichier existe
if (-not (Test-Path $File)) {
    Write-Error "[ERROR] Fichier introuvable : $File"
    exit 1
}

# Créer le dossier de backup du jour
$today = Get-Date -Format "yyyy-MM-dd"
$backupDir = ".kiro-backup/backup/$today"

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Write-Host "[OK] Dossier de backup cree : $backupDir"
}

# Générer le nom du backup
$fileName = Split-Path $File -Leaf
if ($ModificationId) {
    $backupName = "$ModificationId-$fileName.bak"
} else {
    $timestamp = Get-Date -Format "HHmmss"
    $backupName = "$timestamp-$fileName.bak"
}

$backupPath = Join-Path $backupDir $backupName

# Copier le fichier
Copy-Item $File $backupPath -Force

# Vérifier que le backup a été créé
if (Test-Path $backupPath) {
    Write-Host "[OK] Backup cree : $backupPath"
    
    # Retourner le chemin du backup
    return $backupPath
} else {
    Write-Error "[ERROR] Echec de la creation du backup"
    exit 1
}
