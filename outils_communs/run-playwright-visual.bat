@echo off
echo ========================================
echo Test Playwright Visuel - pwc-ui-shared
echo ========================================
echo.

REM Basculer vers Node 10
call Use-Node10

REM Vérifier la version
echo Version Node.js :
node --version
echo.

REM Aller dans le repo
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

REM Lancer les tests en mode headed avec le fichier demo-visual
echo Lancement des tests visuels...
echo.
npx playwright test e2e/tests/demo-visual.spec.ts --headed --workers=1

echo.
echo ========================================
echo Tests terminés !
echo ========================================
pause
