<#
.SYNOPSIS
    Installation des dépendances pour migration Angular (sans droits admin).

.DESCRIPTION
    Installe les outils nécessaires en mode utilisateur :
    - jscodeshift (npm)
    - Strands Agents (pip)
    - Autres dépendances

.NOTES
    Auteur  : Migration Angular Team
    Version : 1.0.0
    Date    : 2026-01-30

.EXAMPLE
    .\install-dependencies.ps1
    .\install-dependencies.ps1 -SkipStrands
#>

param(
    [switch]$SkipStrands,
    [switch]$SkipNpm,
    [switch]$Force
)

function Write-Step {
    param([int]$Number, [string]$Message)
    Write-Host ""
    Write-Host "[$Number] $Message" -ForegroundColor Cyan
    Write-Host ("-" * 50) -ForegroundColor DarkGray
}

function Write-Status {
    param([string]$Status, [string]$Message)
    switch ($Status) {
        "OK"    { Write-Host "    [OK] " -ForegroundColor Green -NoNewline; Write-Host $Message }
        "SKIP"  { Write-Host "    [--] " -ForegroundColor DarkGray -NoNewline; Write-Host $Message }
        "ERROR" { Write-Host "    [X]  " -ForegroundColor Red -NoNewline; Write-Host $Message }
        "INFO"  { Write-Host "    [i]  " -ForegroundColor Yellow -NoNewline; Write-Host $Message }
        "RUN"   { Write-Host "    [>]  " -ForegroundColor White -NoNewline; Write-Host $Message }
    }
}

# Header
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     INSTALLATION DÉPENDANCES - Migration Angular 5 → 20     ║" -ForegroundColor Green
Write-Host "║                    (Mode utilisateur, sans admin)            ║" -ForegroundColor Gray
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

$errors = @()

# ============================================================================
# STEP 1 : NPM DEPENDENCIES
# ============================================================================

Write-Step 1 "Installation des dépendances npm"

if ($SkipNpm) {
    Write-Status "SKIP" "Installation npm ignorée (-SkipNpm)"
} else {
    # jscodeshift
    Write-Status "RUN" "Installation de jscodeshift..."
    try {
        $result = npm install -g jscodeshift 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "OK" "jscodeshift installé globalement"
        } else {
            # Essayer en local
            Write-Status "INFO" "Installation globale échouée, essai en local..."
            npm install jscodeshift --save-dev 2>&1 | Out-Null
            Write-Status "OK" "jscodeshift installé localement (utiliser npx jscodeshift)"
        }
    } catch {
        Write-Status "ERROR" "Échec installation jscodeshift: $_"
        $errors += "jscodeshift"
    }

    # typescript (si pas présent)
    Write-Status "RUN" "Vérification TypeScript..."
    try {
        $tscCheck = tsc --version 2>&1
        Write-Status "OK" "TypeScript déjà installé: $tscCheck"
    } catch {
        Write-Status "RUN" "Installation de TypeScript..."
        npm install -g typescript 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Status "OK" "TypeScript installé"
        } else {
            Write-Status "INFO" "TypeScript sera utilisé depuis les projets locaux"
        }
    }

    # ts-node (utile pour les codemods TypeScript)
    Write-Status "RUN" "Installation de ts-node..."
    try {
        npm install -g ts-node 2>&1 | Out-Null
        Write-Status "OK" "ts-node installé"
    } catch {
        Write-Status "INFO" "ts-node non installé (optionnel)"
    }
}

# ============================================================================
# STEP 2 : PYTHON DEPENDENCIES
# ============================================================================

Write-Step 2 "Installation des dépendances Python"

if ($SkipStrands) {
    Write-Status "SKIP" "Installation Strands ignorée (-SkipStrands)"
} else {
    # Vérifier Python
    try {
        $pythonVersion = python --version 2>&1
        Write-Status "OK" "Python trouvé: $pythonVersion"
        
        # Vérifier pip
        try {
            $pipVersion = pip --version 2>&1
            Write-Status "OK" "pip trouvé: $pipVersion"
            
            # Installer Strands Agents
            Write-Status "RUN" "Installation de strands-agents (mode utilisateur)..."
            try {
                $result = pip install --user strands-agents 2>&1
                if ($LASTEXITCODE -eq 0 -or $result -like "*Successfully installed*" -or $result -like "*already satisfied*") {
                    Write-Status "OK" "strands-agents installé"
                    
                    # Vérifier l'installation
                    $strandsCheck = pip show strands-agents 2>&1
                    if ($strandsCheck -like "*Name: strands-agents*") {
                        $version = ($strandsCheck | Select-String "Version:").ToString().Split(":")[1].Trim()
                        Write-Status "OK" "Version installée: $version"
                    }
                } else {
                    Write-Status "ERROR" "Échec installation strands-agents"
                    Write-Status "INFO" "Erreur: $result"
                    $errors += "strands-agents"
                }
            } catch {
                Write-Status "ERROR" "Exception lors de l'installation: $_"
                $errors += "strands-agents"
            }
            
            # Installer boto3 (dépendance Strands pour AWS)
            Write-Status "RUN" "Installation de boto3 (optionnel, pour AWS)..."
            try {
                pip install --user boto3 2>&1 | Out-Null
                Write-Status "OK" "boto3 installé"
            } catch {
                Write-Status "INFO" "boto3 non installé (optionnel)"
            }
            
        } catch {
            Write-Status "ERROR" "pip non disponible"
            Write-Status "INFO" "Installer pip: python -m ensurepip --upgrade"
            $errors += "pip"
        }
    } catch {
        Write-Status "ERROR" "Python non trouvé"
        Write-Status "INFO" "Télécharger Python: https://www.python.org/downloads/"
        Write-Status "INFO" "Installation portable possible dans C:\Users\$env:USERNAME\dev\python"
        $errors += "python"
    }
}

# ============================================================================
# STEP 3 : VÉRIFICATION FINALE
# ============================================================================

Write-Step 3 "Vérification finale"

# jscodeshift
try {
    $jscsVersion = npx jscodeshift --version 2>&1
    Write-Status "OK" "jscodeshift: disponible via npx"
} catch {
    Write-Status "ERROR" "jscodeshift non disponible"
}

# Strands
if (-not $SkipStrands) {
    try {
        $strandsCheck = pip show strands-agents 2>&1
        if ($strandsCheck -like "*Name: strands-agents*") {
            Write-Status "OK" "strands-agents: installé"
        } else {
            Write-Status "ERROR" "strands-agents: non installé"
        }
    } catch {
        Write-Status "ERROR" "Impossible de vérifier strands-agents"
    }
}

# ============================================================================
# RÉSUMÉ
# ============================================================================

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "  RÉSUMÉ INSTALLATION" -ForegroundColor White
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

if ($errors.Count -eq 0) {
    Write-Host "  ✅ Toutes les dépendances sont installées !" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Prochaines étapes:" -ForegroundColor White
    Write-Host "    1. Lancer le diagnostic: .\check-stack.ps1" -ForegroundColor Gray
    Write-Host "    2. Ouvrir Kiro sur C:\repo_hps" -ForegroundColor Gray
    Write-Host "    3. Exécuter le prompt d'initialisation" -ForegroundColor Gray
} else {
    Write-Host "  ❌ Certaines installations ont échoué:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "     - $err" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "  Essayez:" -ForegroundColor Yellow
    Write-Host "    - Relancer avec: .\install-dependencies.ps1 -Force" -ForegroundColor Gray
    Write-Host "    - Vérifier votre connexion internet" -ForegroundColor Gray
    Write-Host "    - Vérifier les paramètres proxy npm/pip" -ForegroundColor Gray
}

Write-Host ""

# Code de sortie
if ($errors.Count -gt 0) {
    exit 1
} else {
    exit 0
}
