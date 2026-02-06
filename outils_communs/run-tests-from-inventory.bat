@echo off
REM Script pour lancer les tests basés sur l'inventaire
REM Tests automatisés des 9 composants trouvés

echo ========================================
echo Tests des Composants depuis Inventaire
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
echo Lancement des tests automatises...
echo.
echo Tests a executer:
echo   1. Amount - Inputs et buttons
echo   2. Email - Validation email
echo   3. FormInput - Tous les types d'inputs
echo   4. Catalog - Buttons
echo   5. Date - Buttons
echo   6. Checkbox - Presence
echo   7. Text - Presence
echo   8. Tree - Presence
echo   9. FileUpload - Presence
echo  10. Inventaire - Statistiques
echo.

npx playwright test e2e/tests/components-from-inventory.spec.ts --headed --workers=1

echo.
echo ========================================
echo Tests termines !
echo ========================================
echo.
echo Pour voir le rapport HTML:
echo   npx playwright show-report
echo.

pause
