# Tasks - État Actuel du Workspace

## Tâches

- [x] 1. Détecter versions Angular, RxJS, TypeScript
  - [x] 1.1 pwc-ui-shared : `ng version`
  - [x] 1.2 pwc-ui : `ng version`
  - [x] 1.3 Créer tableau comparatif

- [x] 2. Compter composants, services, modules
  - [x] 2.1 pwc-ui-shared : `grep -r "@Component" src/`
  - [x] 2.2 pwc-ui-shared : `grep -r "@Injectable" src/`
  - [x] 2.3 pwc-ui-shared : `grep -r "@NgModule" src/`
  - [x] 2.4 pwc-ui : Idem
  - [x] 2.5 Créer tableau récapitulatif

- [x] 3. Lister dépendances critiques
  - [x] 3.1 Lire package.json (pwc-ui-shared)
  - [x] 3.2 Lire package.json (pwc-ui)
  - [x] 3.3 Identifier libs tierces (NgRx, PrimeNG, etc.)

- [x] 4. Identifier points d'attention
  - [x] 4.1 Dépendance @pwc/shared
  - [x] 4.2 Webpack custom (pwc-ui)
  - [x] 4.3 Modules dépréciés (@angular/http)

- [x] 5. Évaluer complexité
  - [x] 5.1 Calculer total composants (2816)
  - [x] 5.2 Évaluer complexité (Très Élevée)

- [x] 6. Définir objectif final
  - [x] 6.1 Angular 20, RxJS 7.8, TypeScript 5.6
  - [x] 6.2 Technologies optionnelles (Signals, Standalone)

- [x] 7. Documenter
  - [x] 7.1 Créer document final
  - [x] 7.2 Versionner
