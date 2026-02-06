# Tasks - Workflow de Tests avec Gate Playwright

## Installation et Configuration (Une Fois)

- [ ] 1. Installation Playwright
  - [ ] 1.1 Installer Playwright : `npm install -D @playwright/test`
  - [ ] 1.2 Installer navigateurs : `npx playwright install`
  - [ ] 1.3 Créer `playwright.config.ts`
  - [ ] 1.4 Créer dossier `e2e/tests/`

- [ ] 2. Création des Tests
  - [ ] 2.1 Créer `e2e/tests/demo-home.spec.ts`
  - [ ] 2.2 Créer `e2e/tests/demo-forms.spec.ts`
  - [ ] 2.3 Créer `e2e/tests/demo-navigation.spec.ts`

- [ ] 3. Configuration package.json
  - [ ] 3.1 Ajouter script `"test:e2e": "playwright test"`
  - [ ] 3.2 Ajouter script `"test:e2e:ui": "playwright test --ui"`
  - [ ] 3.3 Ajouter script `"test:e2e:debug": "playwright test --debug"`
  - [ ] 3.4 Ajouter script `"test:e2e:report": "playwright show-report"`

## Workflow par Palier

### Phase 1 : pwc-ui-shared (AVEC GATE)

- [ ] 4. Préparation
  - [ ] 4.1 Vérifier branche active
  - [ ] 4.2 Vérifier état Git propre

- [ ] 5. Migration Angular
  - [ ] 5.1 Exécuter migration selon spec du palier
  - [ ] 5.2 Vérifier compilation réussie

- [ ] 6. Build
  - [ ] 6.1 Exécuter `npm run build`
  - [ ] 6.2 Vérifier build réussi
  - [ ] 6.3 Vérifier aucune erreur

- [ ] 7. Tests Unitaires
  - [ ] 7.1 Exécuter `npm test`
  - [ ] 7.2 Vérifier >95% des tests passent
  - [ ] 7.3 Corriger tests échoués si nécessaire

- [ ] 8. 🚦 GATE PLAYWRIGHT (BLOQUANT)
  - [ ] 8.1 Lancer app demo sur port 4201
    - [ ] 8.1.1 Option 1 (RECOMMANDÉ) : `C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat`
    - [ ] 8.1.2 Option 2 (Manuel) : `npm start -- --port 4201`
  - [ ] 8.2 Attendre que l'app soit prête
  - [ ] 8.3 Vérifier dans navigateur : http://localhost:4201
  - [ ] 8.4 Lancer tests Playwright (nouveau terminal) : `npm run test:e2e`
  - [ ] 8.5 Attendre fin des tests

- [ ] 9. Validation Gate
  - [ ] 9.1 Vérifier 100% des tests passent
  - [ ] 9.2 Vérifier page accueil charge < 5s
  - [ ] 9.3 Vérifier 0 erreur console critique
  - [ ] 9.4 Vérifier composants form visibles
  - [ ] 9.5 Vérifier navigation fonctionne

- [ ] 10. Résultat Gate : ✅ PASSÉ
  - [ ] 10.1 Arrêter l'app demo (Ctrl+C)
  - [ ] 10.2 Consulter rapport : `npm run test:e2e:report`
  - [ ] 10.3 Documenter résultats dans JOURNAL-DE-BORD.md
  - [ ] 10.4 Commiter : `git add . && git commit -m "Palier N: Gate Playwright OK"`
  - [ ] 10.5 **PASSER À LA PHASE 2 (pwc-ui)**

- [ ] 11. Résultat Gate : ❌ ÉCHOUÉ
  - [ ] 11.1 Arrêter l'app demo (Ctrl+C)
  - [ ] 11.2 Analyser erreurs : `npm run test:e2e:report`
  - [ ] 11.3 Identifier problèmes dans pwc-ui-shared
  - [ ] 11.4 Corriger les problèmes
  - [ ] 11.5 Relancer depuis l'étape 6 (Build)
  - [ ] 11.6 **NE PAS passer à pwc-ui**

### Phase 2 : pwc-ui (SEULEMENT APRÈS GATE VALIDÉ)

- [ ] 12. Préparation
  - [ ] 12.1 Vérifier gate pwc-ui-shared validé
  - [ ] 12.2 Vérifier branche active

- [ ] 13. Mise à Jour @pwc/shared
  - [ ] 13.1 Exécuter `npm install @pwc/shared@latest`
  - [ ] 13.2 Vérifier version mise à jour
  - [ ] 13.3 Exécuter `npm install`

- [ ] 14. Migration Angular
  - [ ] 14.1 Exécuter migration selon spec du palier
  - [ ] 14.2 Vérifier compilation réussie

- [ ] 15. Build
  - [ ] 15.1 Exécuter `npm run build`
  - [ ] 15.2 Vérifier build réussi

- [ ] 16. Tests
  - [ ] 16.1 Exécuter `npm test`
  - [ ] 16.2 Vérifier >95% des tests passent

- [ ] 17. Lancer et Tester Application
  - [ ] 17.1 Lancer app sur port 4200
    - [ ] 17.1.1 Option 1 (RECOMMANDÉ) : `C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat`
    - [ ] 17.1.2 Option 2 (Manuel) : `npm start`
  - [ ] 17.2 Vérifier dans navigateur : http://localhost:4200
  - [ ] 17.3 Tester login
  - [ ] 17.4 Tester navigation
  - [ ] 17.5 Tester fonctionnalités critiques
  - [ ] 17.6 Vérifier aucune erreur console
  - [ ] 17.7 Vérifier aucune régression visuelle

- [ ] 18. Commit
  - [ ] 18.1 Arrêter l'app (Ctrl+C)
  - [ ] 18.2 Commiter : `git add . && git commit -m "Palier N: Integration avec Shared OK"`

## Commandes Utiles

### Shared (Port 4201)
```bash
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Build
npm run build

# Tests unitaires
npm test

# Lancer app demo (Option 1 - RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Lancer app demo (Option 2 - Manuel)
npm start -- --port 4201

# Tests Playwright
npm run test:e2e
npm run test:e2e:ui
npm run test:e2e:debug
npm run test:e2e:report
```

### UI (Port 4200)
```bash
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Mettre à jour shared
npm install @pwc/shared@latest

# Build
npm run build

# Tests unitaires
npm test

# Lancer app (Option 1 - RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat

# Lancer app (Option 2 - Manuel)
npm start
```

## Dépannage

- [ ] 19. Port Déjà Utilisé
  - [ ] 19.1 Identifier processus : `netstat -ano | findstr :4201`
  - [ ] 19.2 Tuer processus : `taskkill /PID <PID> /F`

- [ ] 20. Tests Flaky
  - [ ] 20.1 Augmenter timeouts dans `playwright.config.ts`
  - [ ] 20.2 Augmenter retries
  - [ ] 20.3 Ajouter waitFor explicites

- [ ] 21. Playwright Non Installé
  - [ ] 21.1 Installer : `npm install -D @playwright/test`
  - [ ] 21.2 Installer navigateurs : `npx playwright install`

## Documentation

- [ ] 22. Documenter Résultats Gate
  - [ ] 22.1 Mettre à jour `.kiro/state/strands-state.json`
  - [ ] 22.2 Documenter dans `Documentation/JOURNAL-DE-BORD.md`
  - [ ] 22.3 Sauvegarder screenshots si échecs
  - [ ] 22.4 Archiver rapport Playwright
