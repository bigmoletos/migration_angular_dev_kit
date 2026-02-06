@echo off
cd /d "C:\Users\franck.desmedt\dev\kiro_migration_angular"
"C:\Users\franck.desmedt\dev\github_cli\bin\gh.exe" repo create kiro-migration-angular --public --source=. --remote=origin --push
pause