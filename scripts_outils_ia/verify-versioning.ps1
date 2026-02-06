<#
.SYNOPSIS
    Verifie que tous les fichiers .kiro ont un versioning

.DESCRIPTION
    Ce script parcourt les fichiers dans .kiro/ et verifie qu'ils ont tous
    un numero de version et une date de mise a jour.

.VERSION
    1.0.0

.LAST UPDATE
    2026-02-03

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-03) : Creation initiale

.PARAMETER Fix
    Si specifie, tente de corriger automatiquement les fichiers sans versioning

.EXAMPLE
    .\verify-versioning.ps1
    Verifie tous les fichiers

.EXAMPLE
    .\verify-versioning.ps1 -Fix
    Verifie et corrige les fichiers sans versioning
#>

param(
    [switch]$Fix
)

Write-Host "=== Verification du Versioning des Fichiers .kiro ===" -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()
$success = @()

# Fonction pour verifier un fichier Markdown
function Test-MarkdownVersioning {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    
    if (-not $content) {
        return @{
            HasVersion = $false
            HasDate = $false
            HasChangelog = $false
            Message = "Fichier vide ou illisible"
        }
    }
    
    $hasVersion = $content -match "Version\s*:\s*\d+\.\d+\.\d+"
    $hasDate = $content -match "Derniere mise a jour\s*:\s*\d{4}-\d{2}-\d{2}"
    $hasChangelog = $content -match "Changelog\s*:"
    
    return @{
        HasVersion = $hasVersion
        HasDate = $hasDate
        HasChangelog = $hasChangelog
        Message = if ($hasVersion -and $hasDate) { "OK" } else { "Manque version ou date" }
    }
}

# Fonction pour verifier un fichier JSON
function Test-JsonVersioning {
    param([string]$FilePath)
    
    try {
        $json = Get-Content $FilePath -Raw | ConvertFrom-Json
        
        $hasMetadata = $null -ne $json.metadata
        $hasVersion = $hasMetadata -and $null -ne $json.metadata.version
        $hasDate = $hasMetadata -and $null -ne $json.metadata.lastUpdate
        
        return @{
            HasVersion = $hasVersion
            HasDate = $hasDate
            HasChangelog = $hasMetadata -and $null -ne $json.metadata.changelog
            Message = if ($hasVersion -and $hasDate) { "OK" } else { "Manque metadata.version ou metadata.lastUpdate" }
        }
    } catch {
        return @{
            HasVersion = $false
            HasDate = $false
            HasChangelog = $false
            Message = "Erreur de parsing JSON: $($_.Exception.Message)"
        }
    }
}

# Fonction pour verifier un fichier PowerShell
function Test-PowerShellVersioning {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    
    if (-not $content) {
        return @{
            HasVersion = $false
            HasDate = $false
            HasChangelog = $false
            Message = "Fichier vide ou illisible"
        }
    }
    
    $hasVersion = $content -match "\.VERSION\s+\d+\.\d+\.\d+"
    $hasDate = $content -match "\.LAST UPDATE\s+\d{4}-\d{2}-\d{2}"
    $hasChangelog = $content -match "\.CHANGELOG"
    
    return @{
        HasVersion = $hasVersion
        HasDate = $hasDate
        HasChangelog = $hasChangelog
        Message = if ($hasVersion -and $hasDate) { "OK" } else { "Manque .VERSION ou .LAST UPDATE" }
    }
}

# Verifier les fichiers Markdown dans steering
Write-Host "Verification des fichiers Markdown (.kiro/steering/)..." -ForegroundColor Yellow
Get-ChildItem -Path "..\\.kiro\\steering" -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $result = Test-MarkdownVersioning -FilePath $_.FullName
    $relativePath = $_.FullName -replace [regex]::Escape((Get-Location).Path), "."
    
    if ($result.HasVersion -and $result.HasDate) {
        $success += "OK $relativePath"
        Write-Host "  OK $($_.Name)" -ForegroundColor Green
    } else {
        $errors += "ERREUR $relativePath : $($result.Message)"
        Write-Host "  ERREUR $($_.Name) : $($result.Message)" -ForegroundColor Red
    }
}

# Verifier les fichiers Markdown dans specs
Write-Host "`nVerification des fichiers Markdown (.kiro/specs/)..." -ForegroundColor Yellow
Get-ChildItem -Path "..\\.kiro\\specs" -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $result = Test-MarkdownVersioning -FilePath $_.FullName
    $relativePath = $_.FullName -replace [regex]::Escape((Get-Location).Path), "."
    
    if ($result.HasVersion -and $result.HasDate) {
        $success += "OK $relativePath"
        Write-Host "  OK $($_.Name)" -ForegroundColor Green
    } else {
        $errors += "ERREUR $relativePath : $($result.Message)"
        Write-Host "  ERREUR $($_.Name) : $($result.Message)" -ForegroundColor Red
    }
}

# Verifier les fichiers JSON dans hooks
Write-Host "`nVerification des fichiers JSON (.kiro/hooks/)..." -ForegroundColor Yellow
Get-ChildItem -Path "..\\.kiro\\hooks" -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
    $result = Test-JsonVersioning -FilePath $_.FullName
    $relativePath = $_.FullName -replace [regex]::Escape((Get-Location).Path), "."
    
    if ($result.HasVersion -and $result.HasDate) {
        $success += "OK $relativePath"
        Write-Host "  OK $($_.Name)" -ForegroundColor Green
    } else {
        $errors += "ERREUR $relativePath : $($result.Message)"
        Write-Host "  ERREUR $($_.Name) : $($result.Message)" -ForegroundColor Red
    }
}

# Verifier les scripts PowerShell
Write-Host "`nVerification des scripts PowerShell (scripts_outils_ia/)..." -ForegroundColor Yellow
Get-ChildItem -Path "." -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    # Ignorer le script de verification lui-meme
    if ($_.Name -eq "verify-versioning.ps1") {
        Write-Host "  SKIP $($_.Name) (script de verification)" -ForegroundColor Gray
        return
    }
    
    $result = Test-PowerShellVersioning -FilePath $_.FullName
    $relativePath = $_.FullName -replace [regex]::Escape((Get-Location).Path), "."
    
    if ($result.HasVersion -and $result.HasDate) {
        $success += "OK $relativePath"
        Write-Host "  OK $($_.Name)" -ForegroundColor Green
    } else {
        $warnings += "ATTENTION $relativePath : $($result.Message)"
        Write-Host "  ATTENTION $($_.Name) : $($result.Message)" -ForegroundColor Yellow
    }
}

# Afficher le resume
Write-Host "`n=== Resume ===" -ForegroundColor Cyan
Write-Host "Fichiers OK : $($success.Count)" -ForegroundColor Green
Write-Host "Erreurs : $($errors.Count)" -ForegroundColor Red
Write-Host "Avertissements : $($warnings.Count)" -ForegroundColor Yellow

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "`nTous les fichiers ont un versioning correct!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`nFichiers avec erreurs :" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    
    if ($warnings.Count -gt 0) {
        Write-Host "`nFichiers avec avertissements :" -ForegroundColor Yellow
        $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    }
    
    if ($Fix) {
        Write-Host "`nMode Fix active : ajout des versions manquantes..." -ForegroundColor Cyan
        Write-Host "TODO: Implementation de la correction automatique" -ForegroundColor Yellow
    } else {
        Write-Host "`nUtilisez -Fix pour tenter une correction automatique" -ForegroundColor Cyan
    }
    
    exit 1
}
