# Tasks - Plan de Migration Angular 5 → 20

## Tâches

- [ ] 1. Définir les 15 paliers de migration
  - [x] 1.1 Palier 1 : Angular 5→6 (RxJS)
  - [x] 1.2 Palier 2 : Angular 6→7
  - [x] 1.3 Palier 3 : Angular 7→8
  - [x] 1.4 Palier 4 : Angular 8→9 (Ivy)
  - [x] 1.5 Palier 5 : Angular 9→10
  - [x] 1.6 Palier 6 : Angular 10→11
  - [x] 1.7 Palier 7 : Angular 11→12 (Webpack 5)
  - [x] 1.8 Palier 8 : Angular 12→13
  - [x] 1.9 Palier 9 : Angular 13→14
  - [x] 1.10 Palier 10 : Angular 14→15
  - [x] 1.11 Palier 11 : Angular 15→16 (Signals)
  - [x] 1.12 Palier 12 : Angular 16→17 (Control Flow)
  - [x] 1.13 Palier 13 : Angular 17→18
  - [x] 1.14 Palier 14 : Angular 18→19
  - [x] 1.15 Palier 15 : Angular 19→20

- [x] 2. Documenter les breaking changes par palier
  - [x] 2.1 Identifier les breaking changes majeurs
  - [x] 2.2 Documenter les impacts sur pwc-ui-shared
  - [x] 2.3 Documenter les impacts sur pwc-ui

- [x] 3. Définir les actions par palier
  - [x] 3.1 Actions pour pwc-ui-shared
  - [x] 3.2 Actions pour pwc-ui
  - [x] 3.3 Commandes ng update
  - [x] 3.4 Codemods à appliquer

- [x] 4. Identifier les codemods disponibles
  - [x] 4.1 Codemods officiels (RxJS, Angular)
  - [x] 4.2 Codemods custom (scripts_outils_ia)

- [x] 5. Créer la matrice récapitulative
  - [x] 5.1 Versions Angular par palier
  - [x] 5.2 Durée estimée par palier
  - [x] 5.3 Complexité par palier
  - [x] 5.4 Versions Node.js compatibles

- [x] 6. Identifier les jalons critiques
  - [x] 6.1 Palier 1 : Migration RxJS
  - [x] 6.2 Palier 4 : Migration Ivy
  - [x] 6.3 Palier 7 : Webpack 5
  - [x] 6.4 Palier 11 : Signals
  - [x] 6.5 Palier 12 : Control Flow

- [x] 7. Définir les critères de validation
  - [x] 7.1 Validation pwc-ui-shared (build, tests, Playwright gate)
  - [x] 7.2 Validation pwc-ui (build, tests, app démarre)
  - [x] 7.3 Publication Nexus
  - [x] 7.4 Tags Git

- [x] 8. Documenter les versions Node.js
  - [x] 8.1 Compatibilité par palier
  - [x] 8.2 Scripts Use-NodeXX
  - [x] 8.3 Référence vers 09-version-management.md

- [ ] 9. Valider le plan avec l'équipe
  - [ ] 9.1 Revue du plan complet
  - [ ] 9.2 Ajustements si nécessaire
  - [ ] 9.3 Approbation finale

- [ ] 10. Préparer les specs détaillées par palier
  - [x] 10.1 Spec Palier 1 (04-palier-01-angular-5-to-6.md)
  - [ ] 10.2 Spec Palier 4 (05-palier-04-angular-8-to-9-ivy.md)
  - [ ] 10.3 Spec Palier 7 (06-palier-07-angular-11-to-12-webpack5.md)
  - [ ] 10.4 Spec Palier 11 (07-palier-11-angular-15-to-16-signals.md)
  - [ ] 10.5 Spec Palier 12 (08-palier-12-angular-16-to-17-control-flow.md)
  - [ ] 10.6 Spec Palier 15 (09-palier-15-angular-19-to-20-final.md)
