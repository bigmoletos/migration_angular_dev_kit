# Requirements - État Actuel du Workspace

## Objectif

Documenter l'état actuel complet des repositories pwc-ui-shared et pwc-ui avant la migration Angular 5 → 20.

## Contexte

- **Date d'analyse** : 2026-02-03
- **Workspace** : repo_hps
- **Repos** : pwc-ui-shared (bibliothèque) et pwc-ui (application)

## Exigences Fonctionnelles

### EF-1 : Versions Détectées
Documenter toutes les versions des frameworks et outils pour les deux repos.

### EF-2 : Dépendances Critiques
Lister toutes les bibliothèques tierces critiques avec leurs versions.

### EF-3 : Points d'Attention
Identifier les configurations custom, modules dépréciés, et particularités.

### EF-4 : Complexité Estimée
Évaluer la complexité globale (composants, services, modules).

### EF-5 : Objectif Final
Définir l'état cible après migration complète.

## Critères d'Acceptation

### CA-1 : Versions Documentées
- [ ] Angular, RxJS, TypeScript, Zone.js, Angular CLI, Webpack
- [ ] Pour pwc-ui-shared ET pwc-ui
- [ ] Nombre de composants, services, modules comptés

### CA-2 : Dépendances Listées
- [ ] Toutes les libs tierces listées (NgRx, PrimeNG, etc.)
- [ ] Versions actuelles documentées

### CA-3 : Points d'Attention Identifiés
- [ ] Dépendance @pwc/shared documentée
- [ ] Webpack custom identifié
- [ ] Modules dépréciés listés

### CA-4 : Complexité Évaluée
- [ ] Tableau récapitulatif créé
- [ ] Complexité globale évaluée (Très Élevée)

### CA-5 : Objectif Final Défini
- [ ] Versions cibles documentées
- [ ] Technologies optionnelles listées

## Contraintes

- **C-1** : Analyse non intrusive (pas de modification du code)
- **C-2** : Utiliser des outils automatiques (grep, npm list, etc.)
- **C-3** : Document à jour et versionné

## Dépendances

- `package.json` des deux repos
- `tsconfig.json` des deux repos
- Commandes : `ng version`, `npm list`, `grep`
