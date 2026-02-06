@echo off
REM ============================================================================
REM Script d'installation des dépendances npm
REM ============================================================================
REM Version: 1.1.0
REM Date: 2026-02-02
REM Auteur: Franck Desmedt / Kiro
REM ============================================================================

echo.
echo ============================================================================
echo Installation des dependances npm pour les projets Angular 5
echo ============================================================================
echo.

REM Activer Node v10
call "%~dp0Use-Node10.bat"
if %errorlevel% neq 0 (
    pause
    exit /b 1
)

REM Définir les chemins des projets
set PROJECT_SHARED=C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
set PROJECT_UI=C:\repo_hps\pwc-ui\pwc-ui-v4-ia

echo [INFO] Node.js: %NODE_EXE%
echo [INFO] Version Node:
node --version
echo.

REM Menu de sélection
echo Quel projet souhaitez-vous installer ?
echo.
echo 1. pwc-ui-shared (Shared Library)
echo 2. pwc-ui (Main Application)
echo 3. Les deux projets
echo 4. Quitter
echo.
set /p choice="Votre choix (1-4): "

if "%choice%"=="1" goto install_shared
if "%choice%"=="2" goto install_ui
if "%choice%"=="3" goto install_both
if "%choice%"=="4" goto end
echo Choix invalide
pause
exit /b 1

:install_shared
echo.
echo ============================================================================
echo Installation de pwc-ui-shared
echo ============================================================================
echo.
cd /d "%PROJECT_SHARED%"
echo [INFO] Nettoyage du cache npm...
npm cache clean --force
echo.
echo [INFO] Installation des dependances...
npm install --legacy-peer-deps --ignore-scripts
if %errorlevel% neq 0 (
    echo [ERREUR] L'installation a echoue
    pause
    exit /b 1
)
echo.
echo [SUCCES] pwc-ui-shared installe avec succes
goto end

:install_ui
echo.
echo ============================================================================
echo Installation de pwc-ui
echo ============================================================================
echo.
cd /d "%PROJECT_UI%"
echo [INFO] Nettoyage du cache npm...
npm cache clean --force
echo.
echo [INFO] Installation des dependances...
npm install --legacy-peer-deps --ignore-scripts
if %errorlevel% neq 0 (
    echo [ERREUR] L'installation a echoue
    pause
    exit /b 1
)
echo.
echo [SUCCES] pwc-ui installe avec succes
goto end

:install_both
call :install_shared
echo.
call :install_ui
goto end

:end
echo.
echo ============================================================================
echo Installation terminee
echo ============================================================================
echo.
echo Pour lancer le serveur de developpement, utilisez:
echo   - start-pwc-ui-shared.bat
echo   - start-pwc-ui.bat
echo.
pause
