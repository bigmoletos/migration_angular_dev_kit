# Requirements - Plan de Migration Angular 5 → 20

## Objectif

Définir un plan de migration incrémentale d'Angular 5.2 vers Angular 20.0 pour les repositories pwc-ui-shared et pwc-ui.

## Contexte

- **Repos concernés** : pwc-ui-shared (bibliothèque) et pwc-ui (application cliente)
- **Version actuelle** : Angular 5.2.0, RxJS 5.5.6, TypeScript 2.5-2.6
- **Version cible** : Angular 20.0, RxJS 7.8+, TypeScript 5.6+
- **Complexité** : 2816 composants au total
- **Ordre impératif** : pwc-ui-shared AVANT pwc-ui

## Exigences Fonctionnelles

### EF-1 : Migration Incrémentale
Le plan doit définir une migration par paliers successifs (5→6→7→...→20), sans sauter de version majeure.

### EF-2 : Ordre de Migration
Pour chaque palier, pwc-ui-shared doit être migré et validé AVANT pwc-ui.

### EF-3 : Paliers Détaillés
Chaque palier doit spécifier :
- Versions Angular source et cible
- Breaking changes majeurs
- Actions requises pour pwc-ui-shared
- Actions requises pour pwc-ui
- Codemods disponibles
- Durée estimée
- Complexité

### EF-4 : Compatibilité Node.js
Chaque palier doit indiquer les versions Node.js compatibles.

### EF-5 : Jalons Critiques
Identifier les paliers critiques nécessitant une attention particulière (RxJS, Ivy, Webpack 5, Signals, Control Flow).

## Exigences Non-Fonctionnelles

### ENF-1 : Documentation
Le plan doit être clair, structuré et facilement consultable.

### ENF-2 : Traçabilité
Chaque palier doit être traçable via tags Git et documentation.

### ENF-3 : Validation
Définir des critères de validation clairs pour chaque palier (build, tests, publication).

### ENF-4 : Durée Totale
La migration complète doit être réalisable en 8-12 semaines.

## Critères d'Acceptation

### CA-1 : 15 Paliers Définis
Le plan doit contenir exactement 15 paliers couvrant Angular 5→6→7→8→9→10→11→12→13→14→15→16→17→18→19→20.

### CA-2 : Breaking Changes Documentés
Chaque palier doit lister les breaking changes majeurs.

### CA-3 : Actions Détaillées
Pour chaque palier, les actions pour pwc-ui-shared et pwc-ui doivent être détaillées.

### CA-4 : Codemods Identifiés
Les codemods disponibles (officiels ou custom) doivent être listés par palier.

### CA-5 : Matrice Récapitulative
Une matrice résumant tous les paliers (versions, durée, complexité, Node.js) doit être fournie.

### CA-6 : Jalons Critiques Identifiés
Les 5 paliers critiques (1, 4, 7, 11, 12) doivent être clairement identifiés et justifiés.

### CA-7 : Validation par Palier
Les critères de validation (build, tests, publication, gate Playwright) doivent être définis pour chaque phase.

## Contraintes

- **C-1** : Respecter l'ordre pwc-ui-shared → pwc-ui
- **C-2** : Ne pas sauter de version majeure Angular
- **C-3** : Utiliser les versions LTS quand disponibles
- **C-4** : Publier pwc-ui-shared sur Nexus après chaque palier validé
- **C-5** : Valider avec tests Playwright (gate bloquant) pour pwc-ui-shared

## Dépendances

- `.kiro/specs/01-etat-actuel.md` : État initial des repos
- `.kiro/specs/03-risques-identifies.md` : Risques par palier
- `.kiro/steering/02-migration-angular-rules.md` : Règles de migration
- `.kiro/steering/09-version-management.md` : Gestion des versions Node.js
