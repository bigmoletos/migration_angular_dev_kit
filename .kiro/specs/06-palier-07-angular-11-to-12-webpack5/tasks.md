# Tasks - Palier 7 : Angular 11.2 → 12.2 (Webpack 5)

## Phase 1 : pwc-ui-shared

- [ ] 1. Préparation
  - [ ] 1.1 Créer branche `palier-7-angular-12-webpack5`
  - [ ] 1.2 Créer tag `palier-6-angular-11-shared`
  - [ ] 1.3 Vérifier build réussi (Angular 11)
  - [ ] 1.4 Vérifier tests passent (Angular 11)

- [ ] 2. Migration Angular
  - [ ] 2.1 Exécuter `ng update @angular/cli@12 @angular/core@12 --dry-run`
  - [ ] 2.2 Exécuter `ng update @angular/cli@12 @angular/core@12 --allow-dirty`
  - [ ] 2.3 Vérifier Angular 12.2 installé
  - [ ] 2.4 Vérifier Webpack 5 installé
  - [ ] 2.5 Vérifier TypeScript 4.2+ installé
  - [ ] 2.6 Vérifier compilation réussie

- [ ] 3. Vérification Polyfills
  - [ ] 3.1 Vérifier `polyfills.ts` à jour
  - [ ] 3.2 Vérifier import `zone.js` présent
  - [ ] 3.3 Vérifier compilation réussie

- [ ] 4. Build
  - [ ] 4.1 Exécuter `npm run build`
  - [ ] 4.2 Vérifier build réussi
  - [ ] 4.3 Vérifier aucune erreur Webpack 5
  - [ ] 4.4 Vérifier taille des bundles

- [ ] 5. Tests
  - [ ] 5.1 Exécuter `npm test`
  - [ ] 5.2 Vérifier >95% des tests passent

- [ ] 6. Publication sur Nexus
  - [ ] 6.1 Incrémenter version : `npm version patch`
  - [ ] 6.2 Publier : `npm publish`
  - [ ] 6.3 Vérifier publication réussie

- [ ] 7. Tag Git
  - [ ] 7.1 Commit : `git add . && git commit -m "feat: migrate to Angular 12 with Webpack 5"`
  - [ ] 7.2 Tag : `git tag palier-7-shared-angular-12-webpack5`
  - [ ] 7.3 Push : `git push origin palier-7-angular-12-webpack5`
  - [ ] 7.4 Push tag : `git push origin palier-7-shared-angular-12-webpack5`

## Phase 2 : pwc-ui

- [ ] 8. Préparation
  - [ ] 8.1 Créer branche `palier-7-angular-12-webpack5`
  - [ ] 8.2 Créer tag `palier-6-angular-11-ui`
  - [ ] 8.3 Vérifier build réussi (Angular 11)
  - [ ] 8.4 Vérifier tests passent (Angular 11)

- [ ] 9. Mise à Jour @pwc/shared
  - [ ] 9.1 Exécuter `npm install @pwc/shared@latest`
  - [ ] 9.2 Vérifier version mise à jour
  - [ ] 9.3 Exécuter `npm install`

- [ ] 10. Migration Angular
  - [ ] 10.1 Exécuter `ng update @angular/cli@12 @angular/core@12 --allow-dirty`
  - [ ] 10.2 Vérifier Angular 12.2 installé
  - [ ] 10.3 Vérifier Webpack 5 installé

- [ ] 11. DÉCISION CRITIQUE : Webpack Custom
  - [ ] 11.1 Analyser `webpack.dev.config.js`
  - [ ] 11.2 Analyser `webpack.prod.config.js`
  - [ ] 11.3 Décider : Option A (CLI natif) ou Option B (adapter configs)
  - [ ] 11.4 Documenter la décision

- [ ] 12. Option A : Migration vers CLI Natif (SI CHOISI)
  - [ ] 12.1 Identifier les customisations nécessaires
  - [ ] 12.2 Migrer vers `angular.json`
  - [ ] 12.3 Installer `@angular-builders/custom-webpack` si nécessaire
  - [ ] 12.4 Créer nouveau `webpack.config.js` minimal
  - [ ] 12.5 Tester build
  - [ ] 12.6 Voir `.kiro/steering/05-webpack-custom-migration.md`

- [ ] 13. Option B : Adapter Webpack 5 (SI CHOISI)
  - [ ] 13.1 Supprimer plugins obsolètes (NamedModulesPlugin, NoEmitOnErrorsPlugin)
  - [ ] 13.2 Migrer vers optimization.moduleIds et optimization.emitOnErrors
  - [ ] 13.3 Installer node-polyfill-webpack-plugin : `npm install node-polyfill-webpack-plugin --save-dev`
  - [ ] 13.4 Ajouter NodePolyfillPlugin dans plugins
  - [ ] 13.5 Migrer file-loader vers Asset Modules (type: 'asset/resource')
  - [ ] 13.6 Configurer cache filesystem
  - [ ] 13.7 Mettre à jour devServer (contentBase → static)
  - [ ] 13.8 Tester build

- [ ] 14. Build
  - [ ] 14.1 Exécuter `npm run build`
  - [ ] 14.2 Vérifier build réussi avec Webpack 5
  - [ ] 14.3 Vérifier aucune erreur
  - [ ] 14.4 Vérifier bundles générés correctement

- [ ] 15. Tests
  - [ ] 15.1 Exécuter `npm test`
  - [ ] 15.2 Vérifier >95% des tests passent

- [ ] 16. Test Manuel
  - [ ] 16.1 Lancer application : `npm start`
  - [ ] 16.2 Tester login
  - [ ] 16.3 Tester navigation
  - [ ] 16.4 Vérifier aucune erreur console
  - [ ] 16.5 Vérifier aucune régression visuelle

- [ ] 17. Tag Git
  - [ ] 17.1 Commit : `git add . && git commit -m "feat: migrate to Angular 12 with Webpack 5"`
  - [ ] 17.2 Tag : `git tag palier-7-ui-angular-12-webpack5`
  - [ ] 17.3 Push : `git push origin palier-7-angular-12-webpack5`
  - [ ] 17.4 Push tag : `git push origin palier-7-ui-angular-12-webpack5`

## Documentation

- [ ] 18. Mise à Jour Documentation
  - [ ] 18.1 Mettre à jour `.kiro/state/strands-state.json`
  - [ ] 18.2 Documenter décision Webpack (CLI natif ou custom)
  - [ ] 18.3 Documenter problèmes rencontrés
  - [ ] 18.4 Documenter solutions appliquées
  - [ ] 18.5 Documenter temps réel vs estimé
