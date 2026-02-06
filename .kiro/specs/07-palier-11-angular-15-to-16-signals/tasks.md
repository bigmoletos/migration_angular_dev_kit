# Tasks - Palier 11 : Angular 15.2 → 16.2 (Signals)

## Phase 1 : pwc-ui-shared

- [ ] 1. Préparation
  - [ ] 1.1 Créer branche `palier-11-angular-16-signals`
  - [ ] 1.2 Créer tag `palier-10-angular-15-shared`
  - [ ] 1.3 Vérifier build réussi (Angular 15)
  - [ ] 1.4 Vérifier tests passent (Angular 15)

- [ ] 2. Migration Angular
  - [ ] 2.1 Exécuter `ng update @angular/cli@16 @angular/core@16 --dry-run`
  - [ ] 2.2 Exécuter `ng update @angular/cli@16 @angular/core@16 --allow-dirty`
  - [ ] 2.3 Vérifier Angular 16.2 installé
  - [ ] 2.4 Vérifier TypeScript 4.9+ installé
  - [ ] 2.5 Vérifier compilation réussie

- [ ] 3. Vérification Bibliothèques Tierces
  - [ ] 3.1 Lister toutes les dépendances : `npm list`
  - [ ] 3.2 Identifier les libs Angular (PrimeNG, NgRx, etc.)
  - [ ] 3.3 Vérifier compatibilité Ivy (version 15+)
  - [ ] 3.4 Mettre à jour les libs incompatibles
  - [ ] 3.5 Vérifier aucune erreur ngcc
  - [ ] 3.6 Vérifier compilation réussie

- [ ] 4. Découverte Signals (Lecture Documentation)
  - [ ] 4.1 Lire [Signals Guide](https://angular.io/guide/signals)
  - [ ] 4.2 Comprendre signal(), computed(), effect()
  - [ ] 4.3 Comprendre différence avec RxJS
  - [ ] 4.4 Lire [RxJS Interop](https://angular.io/guide/rxjs-interop)

- [ ] 5. Décision Adoption Signals
  - [ ] 5.1 Analyser complexité code existant
  - [ ] 5.2 Évaluer bénéfices attendus
  - [ ] 5.3 Évaluer temps disponible
  - [ ] 5.4 Décider : Option A (adopter) ou Option B (rester RxJS)
  - [ ] 5.5 Documenter la décision dans JOURNAL-DE-BORD.md

- [ ] 6. Migration vers Signals (SI Option A choisie)
  - [ ] 6.1 Identifier composants simples à migrer
  - [ ] 6.2 Migrer 1-2 composants pilotes
  - [ ] 6.3 Tester les composants migrés
  - [ ] 6.4 Valider pattern avec l'équipe
  - [ ] 6.5 Planifier migration progressive

- [ ] 7. Required Inputs (Optionnel)
  - [ ] 7.1 Identifier inputs obligatoires
  - [ ] 7.2 Ajouter `{ required: true }` aux @Input
  - [ ] 7.3 Vérifier compilation réussie

- [ ] 8. Build
  - [ ] 8.1 Exécuter `npm run build`
  - [ ] 8.2 Vérifier build réussi
  - [ ] 8.3 Vérifier aucune erreur ngcc

- [ ] 9. Tests
  - [ ] 9.1 Exécuter `npm test`
  - [ ] 9.2 Vérifier >95% des tests passent

- [ ] 10. Publication sur Nexus
  - [ ] 10.1 Incrémenter version : `npm version minor`
  - [ ] 10.2 Publier : `npm publish`
  - [ ] 10.3 Vérifier publication réussie

- [ ] 11. Tag Git
  - [ ] 11.1 Commit : `git add . && git commit -m "feat: migrate to Angular 16 with Signals support"`
  - [ ] 11.2 Tag : `git tag palier-11-shared-angular-16-signals`
  - [ ] 11.3 Push : `git push origin palier-11-angular-16-signals`
  - [ ] 11.4 Push tag : `git push origin palier-11-shared-angular-16-signals`

## Phase 2 : pwc-ui

- [ ] 12. Préparation
  - [ ] 12.1 Créer branche `palier-11-angular-16-signals`
  - [ ] 12.2 Créer tag `palier-10-angular-15-ui`
  - [ ] 12.3 Vérifier build réussi (Angular 15)
  - [ ] 12.4 Vérifier tests passent (Angular 15)

- [ ] 13. Mise à Jour @pwc/shared
  - [ ] 13.1 Exécuter `npm install @pwc/shared@latest`
  - [ ] 13.2 Vérifier version mise à jour
  - [ ] 13.3 Exécuter `npm install`

- [ ] 14. Migration Angular
  - [ ] 14.1 Exécuter `ng update @angular/cli@16 @angular/core@16 --allow-dirty`
  - [ ] 14.2 Vérifier Angular 16.2 installé
  - [ ] 14.3 Vérifier TypeScript 4.9+ installé

- [ ] 15. Vérification Bibliothèques Tierces
  - [ ] 15.1 Lister toutes les dépendances : `npm list`
  - [ ] 15.2 Vérifier compatibilité Ivy
  - [ ] 15.3 Mettre à jour les libs incompatibles
  - [ ] 15.4 Vérifier aucune erreur ngcc

- [ ] 16. Adoption Signals (Même décision que Shared)
  - [ ] 16.1 Appliquer la même stratégie que pwc-ui-shared
  - [ ] 16.2 Migrer composants pilotes si Option A
  - [ ] 16.3 Tester les composants migrés

- [ ] 17. Build
  - [ ] 17.1 Exécuter `npm run build`
  - [ ] 17.2 Vérifier build réussi

- [ ] 18. Tests
  - [ ] 18.1 Exécuter `npm test`
  - [ ] 18.2 Vérifier >95% des tests passent

- [ ] 19. Test Manuel
  - [ ] 19.1 Lancer application : `npm start`
  - [ ] 19.2 Tester login
  - [ ] 19.3 Tester navigation
  - [ ] 19.4 Vérifier aucune erreur console
  - [ ] 19.5 Vérifier aucune régression visuelle

- [ ] 20. Tag Git
  - [ ] 20.1 Commit : `git add . && git commit -m "feat: migrate to Angular 16 with Signals support"`
  - [ ] 20.2 Tag : `git tag palier-11-ui-angular-16-signals`
  - [ ] 20.3 Push : `git push origin palier-11-angular-16-signals`
  - [ ] 20.4 Push tag : `git push origin palier-11-ui-angular-16-signals`

## Documentation

- [ ] 21. Mise à Jour Documentation
  - [ ] 21.1 Mettre à jour `.kiro/state/strands-state.json`
  - [ ] 21.2 Documenter décision Signals (adopter ou pas)
  - [ ] 21.3 Documenter justification de la décision
  - [ ] 21.4 Documenter bibliothèques mises à jour
  - [ ] 21.5 Documenter problèmes rencontrés
  - [ ] 21.6 Documenter temps réel vs estimé
