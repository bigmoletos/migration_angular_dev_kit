# Tasks - Palier 12 : Angular 16.2 → 17.3 (Control Flow Syntax)

## Phase 1 : pwc-ui-shared

- [ ] 1. Préparation
  - [ ] 1.1 Créer branche `palier-12-angular-17-control-flow`
  - [ ] 1.2 Créer tag `palier-11-angular-16-shared`
  - [ ] 1.3 Vérifier build réussi (Angular 16)
  - [ ] 1.4 Vérifier tests passent (Angular 16)

- [ ] 2. Migration Angular
  - [ ] 2.1 Exécuter `ng update @angular/cli@17 @angular/core@17 --dry-run`
  - [ ] 2.2 Exécuter `ng update @angular/cli@17 @angular/core@17 --allow-dirty`
  - [ ] 2.3 Vérifier Angular 17.3 installé
  - [ ] 2.4 Vérifier TypeScript 5.2+ installé
  - [ ] 2.5 Vérifier compilation réussie

- [ ] 3. Migration Automatique Templates
  - [ ] 3.1 Exécuter `ng generate @angular/core:control-flow --dry-run`
  - [ ] 3.2 Examiner les changements proposés
  - [ ] 3.3 Exécuter `ng generate @angular/core:control-flow`
  - [ ] 3.4 Vérifier templates mis à jour
  - [ ] 3.5 Vérifier compilation réussie

- [ ] 4. Vérification Manuelle Templates
  - [ ] 4.1 Chercher `*ngIf` restants : `grep -r "\*ngIf" src/ --include="*.html"`
  - [ ] 4.2 Chercher `*ngFor` restants : `grep -r "\*ngFor" src/ --include="*.html"`
  - [ ] 4.3 Chercher `*ngSwitch` restants : `grep -r "\*ngSwitch" src/ --include="*.html"`
  - [ ] 4.4 Décider : migrer manuellement ou laisser
  - [ ] 4.5 Migrer manuellement si nécessaire

- [ ] 5. Utilisation @defer (Optionnel)
  - [ ] 5.1 Identifier composants lourds
  - [ ] 5.2 Identifier composants rarement visibles
  - [ ] 5.3 Ajouter `@defer` si pertinent
  - [ ] 5.4 Tester lazy loading fonctionne

- [ ] 6. Build
  - [ ] 6.1 Exécuter `npm run build`
  - [ ] 6.2 Vérifier build réussi
  - [ ] 6.3 Vérifier bundles générés correctement

- [ ] 7. Tests
  - [ ] 7.1 Exécuter `npm test`
  - [ ] 7.2 Vérifier >95% des tests passent

- [ ] 8. Publication sur Nexus
  - [ ] 8.1 Incrémenter version : `npm version patch`
  - [ ] 8.2 Publier : `npm publish`
  - [ ] 8.3 Vérifier publication réussie

- [ ] 9. Tag Git
  - [ ] 9.1 Commit : `git add . && git commit -m "feat: migrate to Angular 17 with Control Flow syntax"`
  - [ ] 9.2 Tag : `git tag palier-12-shared-angular-17-control-flow`
  - [ ] 9.3 Push : `git push origin palier-12-angular-17-control-flow`
  - [ ] 9.4 Push tag : `git push origin palier-12-shared-angular-17-control-flow`

## Phase 2 : pwc-ui

- [ ] 10. Préparation
  - [ ] 10.1 Créer branche `palier-12-angular-17-control-flow`
  - [ ] 10.2 Créer tag `palier-11-angular-16-ui`
  - [ ] 10.3 Vérifier build réussi (Angular 16)
  - [ ] 10.4 Vérifier tests passent (Angular 16)

- [ ] 11. Mise à Jour @pwc/shared
  - [ ] 11.1 Exécuter `npm install @pwc/shared@latest`
  - [ ] 11.2 Vérifier version mise à jour
  - [ ] 11.3 Exécuter `npm install`

- [ ] 12. Migration Angular
  - [ ] 12.1 Exécuter `ng update @angular/cli@17 @angular/core@17 --allow-dirty`
  - [ ] 12.2 Vérifier Angular 17.3 installé
  - [ ] 12.3 Vérifier TypeScript 5.2+ installé

- [ ] 13. Migration Automatique Templates
  - [ ] 13.1 Exécuter `ng generate @angular/core:control-flow`
  - [ ] 13.2 Vérifier templates mis à jour
  - [ ] 13.3 Vérifier compilation réussie

- [ ] 14. Vérification Manuelle Templates
  - [ ] 14.1 Chercher patterns restants
  - [ ] 14.2 Migrer manuellement si nécessaire

- [ ] 15. Utilisation @defer (Optionnel)
  - [ ] 15.1 Identifier composants lourds
  - [ ] 15.2 Ajouter `@defer` si pertinent

- [ ] 16. Build
  - [ ] 16.1 Exécuter `npm run build`
  - [ ] 16.2 Vérifier build réussi

- [ ] 17. Tests
  - [ ] 17.1 Exécuter `npm test`
  - [ ] 17.2 Vérifier >95% des tests passent

- [ ] 18. Test Manuel
  - [ ] 18.1 Lancer application : `npm start`
  - [ ] 18.2 Tester login
  - [ ] 18.3 Tester navigation
  - [ ] 18.4 Vérifier templates affichent correctement
  - [ ] 18.5 Vérifier aucune erreur console
  - [ ] 18.6 Vérifier aucune régression visuelle

- [ ] 19. Tag Git
  - [ ] 19.1 Commit : `git add . && git commit -m "feat: migrate to Angular 17 with Control Flow syntax"`
  - [ ] 19.2 Tag : `git tag palier-12-ui-angular-17-control-flow`
  - [ ] 19.3 Push : `git push origin palier-12-angular-17-control-flow`
  - [ ] 19.4 Push tag : `git push origin palier-12-ui-angular-17-control-flow`

## Documentation

- [ ] 20. Mise à Jour Documentation
  - [ ] 20.1 Mettre à jour `.kiro/state/strands-state.json`
  - [ ] 20.2 Documenter décision migration templates
  - [ ] 20.3 Documenter problèmes rencontrés
  - [ ] 20.4 Documenter temps réel vs estimé
