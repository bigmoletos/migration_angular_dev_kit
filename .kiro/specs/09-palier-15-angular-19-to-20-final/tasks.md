# Tasks - Palier 15 : Angular 19.0 → 20.0 (FINAL)

## Phase 1 : pwc-ui-shared

- [ ] 1. Préparation
  - [ ] 1.1 Créer branche `palier-15-angular-20-final`
  - [ ] 1.2 Créer tag `palier-14-angular-19-shared`
  - [ ] 1.3 Vérifier Node.js v20+ : `node -v`
  - [ ] 1.4 Installer Node.js v20 si nécessaire (Use-Node20)
  - [ ] 1.5 Vérifier build réussi (Angular 19)
  - [ ] 1.6 Vérifier tests passent (Angular 19)

- [ ] 2. Migration Angular
  - [ ] 2.1 Exécuter `ng update @angular/cli@20 @angular/core@20 --dry-run`
  - [ ] 2.2 Exécuter `ng update @angular/cli@20 @angular/core@20 --allow-dirty`
  - [ ] 2.3 Vérifier Angular 20.0 installé
  - [ ] 2.4 Vérifier TypeScript 5.6+ installé
  - [ ] 2.5 Vérifier compilation réussie

- [ ] 3. Nettoyer node_modules
  - [ ] 3.1 Exécuter `rm -rf node_modules package-lock.json`
  - [ ] 3.2 Exécuter `npm install`
  - [ ] 3.3 Vérifier aucune erreur

- [ ] 4. Build
  - [ ] 4.1 Exécuter `npm run build`
  - [ ] 4.2 Vérifier build réussi
  - [ ] 4.3 Vérifier bundles optimisés

- [ ] 5. Tests
  - [ ] 5.1 Exécuter `npm test`
  - [ ] 5.2 Vérifier >95% des tests passent

- [ ] 6. Publication VERSION MAJEURE
  - [ ] 6.1 Incrémenter version majeure : `npm version major` (2.x.x → 3.0.0)
  - [ ] 6.2 Publier : `npm publish`
  - [ ] 6.3 Vérifier publication réussie

- [ ] 7. Tag Git
  - [ ] 7.1 Commit : `git add . && git commit -m "feat: migrate to Angular 20 - FINAL VERSION"`
  - [ ] 7.2 Tag palier : `git tag palier-15-shared-angular-20-FINAL`
  - [ ] 7.3 Tag version : `git tag v3.0.0-angular-20`
  - [ ] 7.4 Push : `git push origin palier-15-angular-20-final`
  - [ ] 7.5 Push tags : `git push origin palier-15-shared-angular-20-FINAL v3.0.0-angular-20`

## Phase 2 : pwc-ui

- [ ] 8. Préparation
  - [ ] 8.1 Créer branche `palier-15-angular-20-final`
  - [ ] 8.2 Créer tag `palier-14-angular-19-ui`
  - [ ] 8.3 Vérifier Node.js v20+ : `node -v`
  - [ ] 8.4 Installer Node.js v20 si nécessaire (Use-Node20)
  - [ ] 8.5 Vérifier build réussi (Angular 19)
  - [ ] 8.6 Vérifier tests passent (Angular 19)

- [ ] 9. Mise à Jour @pwc/shared
  - [ ] 9.1 Exécuter `npm install @pwc/shared@3.0.0`
  - [ ] 9.2 Vérifier version mise à jour
  - [ ] 9.3 Exécuter `npm install`

- [ ] 10. Migration Angular
  - [ ] 10.1 Exécuter `ng update @angular/cli@20 @angular/core@20 --allow-dirty`
  - [ ] 10.2 Vérifier Angular 20.0 installé
  - [ ] 10.3 Vérifier TypeScript 5.6+ installé

- [ ] 11. Nettoyer node_modules
  - [ ] 11.1 Exécuter `rm -rf node_modules package-lock.json`
  - [ ] 11.2 Exécuter `npm install`

- [ ] 12. Build
  - [ ] 12.1 Exécuter `npm run build`
  - [ ] 12.2 Vérifier build réussi
  - [ ] 12.3 Vérifier bundles optimisés

- [ ] 13. Tests
  - [ ] 13.1 Exécuter `npm test`
  - [ ] 13.2 Vérifier >95% des tests passent

- [ ] 14. Test Manuel Complet
  - [ ] 14.1 Lancer application : `npm start`
  - [ ] 14.2 Tester login
  - [ ] 14.3 Tester navigation
  - [ ] 14.4 Tester tous les modules principaux
  - [ ] 14.5 Tester formulaires
  - [ ] 14.6 Tester tableaux
  - [ ] 14.7 Tester dialogs/modals
  - [ ] 14.8 Tester lazy loading
  - [ ] 14.9 Vérifier aucune erreur console
  - [ ] 14.10 Vérifier aucune régression visuelle
  - [ ] 14.11 Vérifier performance acceptable

- [ ] 15. Tests E2E (si disponibles)
  - [ ] 15.1 Exécuter `npm run e2e`
  - [ ] 15.2 Vérifier tests E2E passent

- [ ] 16. Tag Git
  - [ ] 16.1 Commit : `git add . && git commit -m "feat: migrate to Angular 20 - FINAL VERSION"`
  - [ ] 16.2 Tag palier : `git tag palier-15-ui-angular-20-FINAL`
  - [ ] 16.3 Tag version : `git tag v5.0.0-angular-20`
  - [ ] 16.4 Push : `git push origin palier-15-angular-20-final`
  - [ ] 16.5 Push tags : `git push origin palier-15-ui-angular-20-FINAL v5.0.0-angular-20`

## Documentation

- [ ] 17. Rapport Final de Migration
  - [ ] 17.1 Créer `MIGRATION-REPORT.md`
  - [ ] 17.2 Documenter durée totale
  - [ ] 17.3 Documenter problèmes majeurs
  - [ ] 17.4 Documenter solutions appliquées
  - [ ] 17.5 Documenter leçons apprises
  - [ ] 17.6 Documenter métriques avant/après
  - [ ] 17.7 Documenter recommandations maintenance

- [ ] 18. Mise à Jour Documentation
  - [ ] 18.1 Mettre à jour `.kiro/state/strands-state.json` (100%)
  - [ ] 18.2 Mettre à jour `Documentation/JOURNAL-DE-BORD.md`
  - [ ] 18.3 Mettre à jour `README.md` (Angular 20)
  - [ ] 18.4 Créer guide de maintenance

## 🎉 Célébration

- [ ] 19. CÉLÉBRER LA FIN DE LA MIGRATION !
  - [ ] 19.1 Partager le succès avec l'équipe
  - [ ] 19.2 Documenter les accomplissements
  - [ ] 19.3 Planifier les prochaines étapes (optimisations)
  - [ ] 19.4 Former l'équipe sur les nouvelles fonctionnalités
