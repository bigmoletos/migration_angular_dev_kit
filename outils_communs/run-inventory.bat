@echo off
REM Script pour lancer l'inventaire complet des composants pwc-ui-shared
REM Ce script explore tous les composants et génère un rapport JSON + Markdown

echo ========================================
echo  INVENTAIRE DES COMPOSANTS PWC-UI-SHARED
echo ========================================
echo.

REM Vérifier que l'application tourne sur le port 4201
echo [1/3] Verification que l'application tourne sur le port 4201...
curl -s http://localhost:4201 > nul 2>&1
if errorlevel 1 (
    echo.
    echo ERREUR: L'application ne tourne pas sur le port 4201
    echo.
    echo Veuillez demarrer l'application avec:
    echo   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
    echo   npm start
    echo.
    echo Ou utilisez le raccourci PowerShell: pwc3
    echo.
    pause
    exit /b 1
)
echo OK - Application accessible sur le port 4201
echo.

REM Aller dans le répertoire pwc-ui-shared
echo [2/3] Navigation vers le repertoire pwc-ui-shared...
cd /d C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
echo.

REM Créer le dossier screenshots si nécessaire
if not exist "e2e\screenshots\inventory" mkdir "e2e\screenshots\inventory"

REM Lancer le test d'inventaire
echo [3/3] Lancement du test d'inventaire...
echo.
echo Ce test va:
echo   - Explorer tous les composants de la demo
echo   - Cataloguer les inputs, buttons, selects, etc.
echo   - Prendre des screenshots
echo   - Generer un rapport JSON et Markdown
echo.
echo Cela peut prendre quelques minutes...
echo.

npx playwright test e2e/tests/demo-inventory.spec.ts --headed --workers=1

echo.
echo ========================================
echo  INVENTAIRE TERMINE
echo ========================================
echo.
echo Fichiers generes:
echo   - e2e/inventory.json (donnees brutes)
echo   - e2e/INVENTORY-REPORT.md (rapport lisible)
echo   - e2e/screenshots/inventory/*.png (captures d'ecran)
echo.
echo Pour voir le rapport:
echo   code e2e\INVENTORY-REPORT.md
echo.
pause
