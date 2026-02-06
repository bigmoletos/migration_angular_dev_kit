# Design - État Actuel du Workspace

## Approche Technique

Analyse automatisée et non intrusive de l'état actuel des deux repositories.

## Méthodes d'Analyse

### Détection Versions
- `ng version` : Versions Angular, CLI, TypeScript
- `npm list` : Dépendances installées
- `package.json` : Versions déclarées

### Comptage Composants
- `grep -r "@Component" src/` : Nombre de composants
- `grep -r "@Injectable" src/` : Nombre de services
- `grep -r "@NgModule" src/` : Nombre de modules

### Analyse Dépendances
- `npm outdated` : Dépendances obsolètes
- Lecture manuelle de package.json

## Structure du Document

1. **Versions Détectées** : Tableau comparatif pwc-ui-shared vs pwc-ui
2. **Dépendances Critiques** : Liste des libs tierces
3. **Points d'Attention** : Configurations custom, modules dépréciés
4. **Complexité Estimée** : Tableau récapitulatif
5. **Objectif Final** : État cible

## Livrables

- Document `.kiro/specs/01-etat-actuel.md` (déjà créé)
- Mise à jour régulière après chaque palier
