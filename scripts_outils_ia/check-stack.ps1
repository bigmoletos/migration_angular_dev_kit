<#
.SYNOPSIS
    Diagnostic complet de la stack technique pour migration Angular.

.DESCRIPTION
    Vérifie tous les outils nécessaires pour la migration Angular 5 → 20 :
    - Node.js (versions multiples via fnm)
    - npm / Angular CLI
    - Python / pip / Strands Agent
    - jscodeshift
    - Git

.NOTES
    Auteur  : Migration Angular Team
    Version : 1.0.0
    Date    : 2026-01-30

.EXAMPLE
    .\check-stack.ps1
    .\check-stack.ps1 -Verbose
    .\check-stack.ps1 -InstallMissing
#>

param(
    [switch]$Verbose,
    [switch]$InstallMissing
)

# Configuration
$NODE_VERSIONS_PATH = "C:\Users\$env:USERNAME\dev\nodejs-versions"
$REQUIRED_NODE_VERSIONS = @(
    @{ Version = "10"; Angular = "5-8"; Folder = "node-v10.24.1-win-x64" },
    @{ Version = "12"; Angular = "9-11"; Folder = "node-v12.22.12-win-x64" },
    @{ Version = "14"; Angular = "12"; Folder = "node-v14.21.3-win-x64" },
    @{ Version = "16"; Angular = "13-14"; Folder = "node-v16.20.2-win-x64" },
    @{ Version = "18"; Angular = "15-17"; Folder = "node-v18.20.4-win-x64" },
    @{ Version = "20"; Angular = "18-19"; Folder = "node-v20.18.0-win-x64" },
    @{ Version = "22"; Angular = "20"; Folder = "node-v22.11.0-win-x64" }
)

# Couleurs
function Write-Status {
    param([string]$Status, [string]$Message)
    switch ($Status) {
        "OK"    { Write-Host "  [OK] " -ForegroundColor Green -NoNewline; Write-Host $Message }
        "WARN"  { Write-Host "  [!!] " -ForegroundColor Yellow -NoNewline; Write-Host $Message }
        "ERROR" { Write-Host "  [X]  " -ForegroundColor Red -NoNewline; Write-Host $Message }
        "INFO"  { Write-Host "  [i]  " -ForegroundColor Cyan -NoNewline; Write-Host $Message }
    }
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor White
    Write-Host "=" * 60 -ForegroundColor Cyan
}

# Header
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       DIAGNOSTIC STACK - Migration Angular 5 → 20           ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$results = @{
    NodeVersions = @()
    Tools = @()
    Python = $null
    Strands = $null
    Issues = @()
    Warnings = @()
}

# ============================================================================
# SECTION 1 : NODE.JS VERSIONS
# ============================================================================

Write-Section "NODE.JS VERSIONS"

# Vérifier Node actuel
try {
    $currentNode = node --version 2>&1
    Write-Status "INFO" "Version active: $currentNode"
} catch {
    Write-Status "ERROR" "Node.js non trouvé dans le PATH"
    $results.Issues += "Node.js non installé ou non dans le PATH"
}

# Vérifier les versions disponibles
Write-Host ""
Write-Host "  Versions disponibles pour migration:" -ForegroundColor White

foreach ($nodeConfig in $REQUIRED_NODE_VERSIONS) {
    $folderPath = Join-Path $NODE_VERSIONS_PATH $nodeConfig.Folder
    $nodePath = Join-Path $folderPath "node.exe"
    
    if (Test-Path $nodePath) {
        try {
            $version = & $nodePath --version 2>&1
            Write-Status "OK" "Node $($nodeConfig.Version) ($version) - Angular $($nodeConfig.Angular)"
            $results.NodeVersions += @{
                Version = $nodeConfig.Version
                Path = $folderPath
                Status = "OK"
            }
        } catch {
            Write-Status "WARN" "Node $($nodeConfig.Version) trouvé mais erreur d'exécution"
            $results.NodeVersions += @{
                Version = $nodeConfig.Version
                Path = $folderPath
                Status = "WARN"
            }
        }
    } else {
        Write-Status "ERROR" "Node $($nodeConfig.Version) non trouvé - Angular $($nodeConfig.Angular)"
        $results.NodeVersions += @{
            Version = $nodeConfig.Version
            Path = $folderPath
            Status = "MISSING"
        }
        $results.Issues += "Node.js v$($nodeConfig.Version) manquant pour Angular $($nodeConfig.Angular)"
    }
}

# Vérifier fnm
Write-Host ""
try {
    $fnmVersion = fnm --version 2>&1
    Write-Status "OK" "fnm installé: $fnmVersion"
} catch {
    Write-Status "WARN" "fnm non trouvé (utilisation des Use-NodeXX comme alternative)"
}

# ============================================================================
# SECTION 2 : OUTILS NPM
# ============================================================================

Write-Section "OUTILS NPM"

# Angular CLI
try {
    $ngVersion = ng version 2>&1 | Select-String "Angular CLI" | Select-Object -First 1
    if ($ngVersion) {
        Write-Status "OK" "Angular CLI: $ngVersion"
    } else {
        $ngVersion = ng --version 2>&1 | Select-Object -First 3
        Write-Status "OK" "Angular CLI installé"
    }
} catch {
    Write-Status "WARN" "Angular CLI non trouvé globalement (OK si installé localement)"
    $results.Warnings += "Angular CLI non installé globalement"
}

# jscodeshift
try {
    $jscodeshift = npx jscodeshift --version 2>&1
    Write-Status "OK" "jscodeshift disponible via npx"
} catch {
    Write-Status "WARN" "jscodeshift non trouvé (installer avec: npm install -g jscodeshift)"
    $results.Warnings += "jscodeshift non installé"
}

# TypeScript
try {
    $tscVersion = tsc --version 2>&1
    Write-Status "OK" "TypeScript: $tscVersion"
} catch {
    Write-Status "INFO" "TypeScript non global (OK si installé dans les projets)"
}

# ============================================================================
# SECTION 3 : PYTHON & STRANDS
# ============================================================================

Write-Section "PYTHON et STRANDS AGENT"

# Python
try {
    $pythonVersion = python --version 2>&1
    Write-Status "OK" "Python: $pythonVersion"
    $results.Python = $pythonVersion
    
    # pip
    try {
        $pipVersion = pip --version 2>&1
        Write-Status "OK" "pip: $pipVersion"
    } catch {
        Write-Status "WARN" "pip non trouvé"
        $results.Warnings += "pip non disponible"
    }
    
    # Strands Agent
    try {
        $strandsCheck = pip show strands-agents 2>&1
        if ($strandsCheck -like "*Name: strands-agents*") {
            $strandsVersion = ($strandsCheck | Select-String "Version:").ToString().Split(":")[1].Trim()
            Write-Status "OK" "Strands Agents: v$strandsVersion"
            $results.Strands = $strandsVersion
        } else {
            Write-Status "WARN" "Strands Agents non installé"
            Write-Status "INFO" "  Installer avec: pip install --user strands-agents"
            $results.Warnings += "Strands Agents non installé"
        }
    } catch {
        Write-Status "WARN" "Strands Agents non installé"
        Write-Status "INFO" "  Installer avec: pip install --user strands-agents"
        $results.Warnings += "Strands Agents non installé"
    }
} catch {
    Write-Status "ERROR" "Python non trouvé"
    Write-Status "INFO" "  Télécharger: https://www.python.org/downloads/"
    Write-Status "INFO" "  Installation portable possible sans droits admin"
    $results.Issues += "Python non installé"
}

# ============================================================================
# SECTION 4 : GIT & OUTILS
# ============================================================================

Write-Section "GIT et OUTILS"

# Git
try {
    $gitVersion = git --version 2>&1
    Write-Status "OK" "Git: $gitVersion"
} catch {
    Write-Status "ERROR" "Git non trouvé"
    $results.Issues += "Git non installé"
}

# Git Bash
$gitBashPath = "C:\Program Files\Git\bin\bash.exe"
if (Test-Path $gitBashPath) {
    Write-Status "OK" "Git Bash disponible"
} else {
    Write-Status "WARN" "Git Bash non trouvé au chemin standard"
}

# ============================================================================
# SECTION 5 : CHEMINS PROJET
# ============================================================================

Write-Section "CHEMINS PROJET"

$projectPaths = @(
    @{ Name = "Workspace Parent"; Path = "C:\repo_hps" },
    @{ Name = "Lib (shared)"; Path = "C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia" },
    @{ Name = "Client (ui)"; Path = "C:\repo_hps\pwc-ui\pwc-ui-v4-ia" },
    @{ Name = "Kiro Config Parent"; Path = "C:\repo_hps\.kiro" },
    @{ Name = "Scripts"; Path = "C:\repo_hps\scripts_outils_ia" },
    @{ Name = "Codemods"; Path = "C:\repo_hps\scripts_outils_ia\codemods" }
)

foreach ($proj in $projectPaths) {
    if (Test-Path $proj.Path) {
        Write-Status "OK" "$($proj.Name): $($proj.Path)"
    } else {
        Write-Status "WARN" "$($proj.Name) non trouvé: $($proj.Path)"
        $results.Warnings += "$($proj.Name) non trouvé"
    }
}

# ============================================================================
# SECTION 6 : RÉSUMÉ
# ============================================================================

Write-Section "RÉSUMÉ"

$issueCount = $results.Issues.Count
$warnCount = $results.Warnings.Count

if ($issueCount -eq 0 -and $warnCount -eq 0) {
    Write-Host ""
    Write-Host "  ✅ Stack complète et prête pour la migration !" -ForegroundColor Green
    Write-Host ""
} else {
    if ($issueCount -gt 0) {
        Write-Host ""
        Write-Host "  ❌ PROBLÈMES BLOQUANTS ($issueCount):" -ForegroundColor Red
        foreach ($issue in $results.Issues) {
            Write-Host "     - $issue" -ForegroundColor Red
        }
    }
    
    if ($warnCount -gt 0) {
        Write-Host ""
        Write-Host "  ⚠️  AVERTISSEMENTS ($warnCount):" -ForegroundColor Yellow
        foreach ($warn in $results.Warnings) {
            Write-Host "     - $warn" -ForegroundColor Yellow
        }
    }
}

# ============================================================================
# SECTION 7 : PROCHAINES ÉTAPES
# ============================================================================

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "  PROCHAINES ÉTAPES" -ForegroundColor White
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

if ($results.Issues.Count -eq 0) {
    Write-Host "  1. Ouvrir Kiro : File - Open Folder - C:\repo_hps" -ForegroundColor White
    Write-Host "  2. Executer le prompt d'initialisation (voir GUIDE-DEMARRAGE-RAPIDE.md)" -ForegroundColor White
    Write-Host "  3. Lancer: Use-Node10 (pour Angular 5)" -ForegroundColor White
    Write-Host "  4. Tester: #strands status" -ForegroundColor White
} else {
    Write-Host "  1. Résoudre les problèmes bloquants listés ci-dessus" -ForegroundColor Yellow
    Write-Host "  2. Relancer ce script: .\check-stack.ps1" -ForegroundColor White
}

Write-Host ""

# Retourner le code de sortie
if ($results.Issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
