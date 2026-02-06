@echo off
REM Script batch pour synchroniser tous les index Kiro
REM Usage: sync-all.bat

echo.
echo ================================================================
echo   SYNCHRONISATION DES INDEX KIRO
echo ================================================================
echo.

REM Définir le répertoire du script
set SCRIPT_DIR=%~dp0

REM Vérifier que Node.js est installé
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERREUR] Node.js n'est pas installe ou n'est pas dans le PATH
    echo.
    echo Veuillez installer Node.js depuis https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [INFO] Node.js detecte :
node --version
echo.

REM Exécuter le script de synchronisation
echo [INFO] Execution de la synchronisation...
echo.
node "%SCRIPT_DIR%sync-all-indexes.js"

set EXIT_CODE=%errorlevel%

echo.
echo ================================================================

if %EXIT_CODE% equ 0 (
    echo   SYNCHRONISATION TERMINEE AVEC SUCCES
) else (
    echo   ERREUR LORS DE LA SYNCHRONISATION
)

echo ================================================================
echo.

REM Pause seulement si le script a été double-cliqué (pas en ligne de commande)
echo %CMDCMDLINE% | find /i "%~0" >nul
if not errorlevel 1 (
    pause
)

exit /b %EXIT_CODE%
