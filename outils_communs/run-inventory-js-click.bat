@echo off
REM Script pour lancer l'inventaire avec clics JavaScript
REM Contourne le problème d'interception des éléments <a>

echo ========================================
echo Inventaire Composants - JS Click
echo ========================================
echo.

cd /d C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

echo Verification de l'application...
echo L'application doit tourner sur http://localhost:4201
echo.
echo Si ce n'est pas le cas, lancez d'abord:
echo   pwc3
echo.

pause

echo.
echo Lancement du test d'inventaire avec clics JavaScript...
echo.

npx playwright test e2e/tests/demo-inventory-js-click.spec.ts --headed --workers=1 --timeout=600000

echo.
echo ========================================
echo Test termine !
echo ========================================
echo.
echo Fichiers generes:
echo   - e2e/inventory.json
echo   - e2e/INVENTORY-REPORT.md
echo   - e2e/screenshots/inventory/*.png
echo.

pause
