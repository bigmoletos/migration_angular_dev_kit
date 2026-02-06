@echo off
REM ============================================================================
REM Script de lancement du serveur de développement pwc-ui (Main Application)
REM ============================================================================
REM Version: 1.1.0
REM Date: 2026-02-02
REM Auteur: Franck Desmedt / Kiro
REM ============================================================================

echo.
echo ============================================================================
echo Demarrage du serveur de developpement pwc-ui (Angular 5)
echo ============================================================================
echo.

REM Activer Node v10
call "%~dp0Use-Node10.bat"
if %errorlevel% neq 0 (
    pause
    exit /b 1
)

REM Définir le chemin du projet
set PROJECT_PATH=C:\repo_hps\pwc-ui\pwc-ui-v4-ia

REM Vérifier que le projet existe
if not exist "%PROJECT_PATH%" (
    echo [ERREUR] Projet introuvable dans %PROJECT_PATH%
    echo Veuillez verifier le chemin du projet
    pause
    exit /b 1
)

REM Vérifier que node_modules existe
if not exist "%PROJECT_PATH%\node_modules" (
    echo [ERREUR] node_modules introuvable
    echo Veuillez d'abord installer les dependances avec:
    echo   cd %PROJECT_PATH%
    echo   %NODE_PATH%\npm.cmd install --legacy-peer-deps --ignore-scripts
    pause
    exit /b 1
)

echo [INFO] Node.js: %NODE_EXE%
echo [INFO] Projet: %PROJECT_PATH%
echo [INFO] Version Node:
node --version
echo.

REM Se déplacer dans le répertoire du projet
cd /d "%PROJECT_PATH%"

echo [INFO] Lancement du serveur Angular...
echo [INFO] L'application sera accessible sur http://localhost:4200
echo [INFO] Appuyez sur Ctrl+C pour arreter le serveur
echo.
echo ============================================================================
echo.

REM Lancer le serveur de développement
npm start

REM Si le serveur s'arrête
echo.
echo ============================================================================
echo Le serveur de developpement s'est arrete
echo ============================================================================
pause
