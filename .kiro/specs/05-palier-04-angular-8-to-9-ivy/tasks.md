# Tasks - Palier 4 : Angular 8.2 → 9.1 (Ivy)

## Phase 1 : pwc-ui-shared

- [ ] 1. Préparation
  - [ ] 1.1 Créer branche `palier-4-angular-9-ivy`
  - [ ] 1.2 Créer tag `palier-3-angular-8-shared`
  - [ ] 1.3 Vérifier build réussi (Angular 8)
  - [ ] 1.4 Vérifier tests passent (Angular 8)

- [ ] 2. Migration Angular
  - [ ] 2.1 Exécuter `ng update @angular/cli@9 @angular/core@9 --dry-run`
  - [ ] 2.2 Exécuter `ng update @angular/cli@9 @angular/core@9 --allow-dirty`
  - [ ] 2.3 Vérifier Angular 9.1 installé
  - [ ] 2.4 Vérifier compilation réussie

- [ ] 3. Activation Ivy
  - [ ] 3.1 Vérifier `enableIvy: true` dans tsconfig.json
  - [ ] 3.2 Ajouter si absent
  - [ ] 3.3 Vérifier compilation réussie

- [ ] 4. Migrations Automatiques
  - [ ] 4.1 Exécuter `ng update @angular/core --migrate-only --from=8 --to=9`
  - [ ] 4.2 Vérifier migrations appliquées
  - [ ] 4.3 Vérifier compilation réussie

- [ ] 5. Typage ModuleWithProviders
  - [ ] 5.1 Chercher tous les `ModuleWithProviders` non typés : `grep -r "ModuleWithProviders[^<]" src/ --include="*.ts"`
  - [ ] 5.2 Typer chaque occurrence avec `<NomDuModule>`
  - [ ] 5.3 OU utiliser codemod : `node scripts_outils_ia/codemods/migrate-module-with-providers.js src/**/*.ts`
  - [ ] 5.4 Vérifier aucun `ModuleWithProviders` non typé restant
  - [ ] 5.5 Vérifier compilation réussie

- [ ] 6. Suppression entryComponents
  - [ ] 6.1 Chercher tous les `entryComponents` : `grep -r "entryComponents" src/ --include="*.ts"`
  - [ ] 6.2 Supprimer chaque occurrence
  - [ ] 6.3 Vérifier aucun `entryComponents` restant
  - [ ] 6.4 Vérifier compilation réussie

- [ ] 7. Validation Composants Dynamiques
  - [ ] 7.1 Identifier tous les composants dynamiques : `grep -r "ComponentFactoryResolver" src/ --include="*.ts"`
  - [ ] 7.2 Identifier tous les createComponent : `grep -r "createComponent" src/ --include="*.ts"`
  - [ ] 7.3 Tester chaque composant dynamique (dialogs, modals)
  - [ ] 7.4 Vérifier tous fonctionnent correctement

- [ ] 8. Build avec Ivy
  - [ ] 8.1 Exécuter `npm run build`
  - [ ] 8.2 Vérifier build réussi
  - [ ] 8.3 Vérifier taille des bundles (devrait être -10 à -30%)
  - [ ] 8.4 Comparer avec Angular 8

- [ ] 9. Tests Unitaires
  - [ ] 9.1 Exécuter `npm test`
  - [ ] 9.2 Vérifier >95% des tests passent
  - [ ] 9.3 Corriger tests échoués si nécessaire
  - [ ] 9.4 Vérifier aucun test critique échoue

- [ ] 10. Tests Approfondis
  - [ ] 10.1 Tester composants dynamiques manuellement
  - [ ] 10.2 Tester lazy loading
  - [ ] 10.3 Tester directives structurelles custom
  - [ ] 10.4 Tester pipes custom
  - [ ] 10.5 Tester providers avec useFactory

- [ ] 11. Publication sur Nexus
  - [ ] 11.1 Incrémenter version : `npm version minor`
  - [ ] 11.2 Publier : `npm publish`
  - [ ] 11.3 Vérifier publication réussie

- [ ] 12. Tag Git
  - [ ] 12.1 Commit : `git add . && git commit -m "feat: migrate to Angular 9 with Ivy"`
  - [ ] 12.2 Tag : `git tag palier-4-shared-angular-9-ivy`
  - [ ] 12.3 Push : `git push origin palier-4-angular-9-ivy`
  - [ ] 12.4 Push tag : `git push origin palier-4-shared-angular-9-ivy`

## Phase 2 : pwc-ui

- [ ] 13. Préparation
  - [ ] 13.1 Créer branche `palier-4-angular-9-ivy`
  - [ ] 13.2 Créer tag `palier-3-angular-8-ui`
  - [ ] 13.3 Vérifier build réussi (Angular 8)
  - [ ] 13.4 Vérifier tests passent (Angular 8)

- [ ] 14. Mise à Jour @pwc/shared
  - [ ] 14.1 Exécuter `npm install @pwc/shared@latest`
  - [ ] 14.2 Vérifier version mise à jour
  - [ ] 14.3 Exécuter `npm install`

- [ ] 15. Migration Angular
  - [ ] 15.1 Exécuter `ng update @angular/cli@9 @angular/core@9 --allow-dirty`
  - [ ] 15.2 Vérifier Angular 9.1 installé
  - [ ] 15.3 Vérifier compilation réussie

- [ ] 16. Activation Ivy
  - [ ] 16.1 Vérifier `enableIvy: true` dans tsconfig.json
  - [ ] 16.2 Ajouter si absent

- [ ] 17. Migrations Automatiques
  - [ ] 17.1 Exécuter `ng update @angular/core --migrate-only --from=8 --to=9`
  - [ ] 17.2 Vérifier migrations appliquées

- [ ] 18. Typage ModuleWithProviders
  - [ ] 18.1 Chercher tous les `ModuleWithProviders` non typés
  - [ ] 18.2 Typer chaque occurrence
  - [ ] 18.3 Vérifier aucun non typé restant

- [ ] 19. Suppression entryComponents
  - [ ] 19.1 Chercher tous les `entryComponents`
  - [ ] 19.2 Supprimer chaque occurrence
  - [ ] 19.3 Vérifier aucun restant

- [ ] 20. Adaptation Webpack (si nécessaire)
  - [ ] 20.1 Vérifier `webpack.dev.config.js`
  - [ ] 20.2 Vérifier `webpack.prod.config.js`
  - [ ] 20.3 Adapter si erreurs
  - [ ] 20.4 Vérifier build réussi avec webpack custom

- [ ] 21. Build
  - [ ] 21.1 Exécuter `npm run build`
  - [ ] 21.2 Vérifier build réussi
  - [ ] 21.3 Vérifier bundles plus petits

- [ ] 22. Tests Unitaires
  - [ ] 22.1 Exécuter `npm test`
  - [ ] 22.2 Vérifier >95% des tests passent

- [ ] 23. Test Manuel Approfondi
  - [ ] 23.1 Lancer application : `npm start`
  - [ ] 23.2 Tester login
  - [ ] 23.3 Tester navigation
  - [ ] 23.4 Tester dialogs/modals
  - [ ] 23.5 Tester lazy loading
  - [ ] 23.6 Vérifier aucune erreur console
  - [ ] 23.7 Vérifier aucune régression visuelle
  - [ ] 23.8 Tester toutes les fonctionnalités critiques

- [ ] 24. Tag Git
  - [ ] 24.1 Commit : `git add . && git commit -m "feat: migrate to Angular 9 with Ivy"`
  - [ ] 24.2 Tag : `git tag palier-4-ui-angular-9-ivy`
  - [ ] 24.3 Push : `git push origin palier-4-angular-9-ivy`
  - [ ] 24.4 Push tag : `git push origin palier-4-ui-angular-9-ivy`

## Documentation

- [ ] 25. Mise à Jour Documentation
  - [ ] 25.1 Mettre à jour `.kiro/state/strands-state.json`
  - [ ] 25.2 Documenter problèmes rencontrés
  - [ ] 25.3 Documenter solutions appliquées
  - [ ] 25.4 Documenter temps réel vs estimé
  - [ ] 25.5 Documenter taille bundles avant/après
