# Design - Risques Identifiés Migration Angular 5 → 20

## Approche Technique

Analyse systématique des risques par catégorie de criticité avec mitigations concrètes.

## Catégorisation des Risques

### 🔴 Critiques (4 risques)
Impact bloquant, nécessitent attention maximale.

### 🟠 Élevés (3 risques)
Impact important, peuvent bloquer partiellement.

### 🟡 Moyens (3 risques)
Impact modéré, gérables.

### 🟢 Faibles (2 risques)
Impact minimal, gérés automatiquement.

## Structure par Risque

Pour chaque risque :
1. **Description** : Nature du risque
2. **Impact** : Conséquences si non traité
3. **Probabilité** : Chance d'occurrence
4. **Mitigation** : Actions concrètes
5. **Palier concerné** : Quand le risque se manifeste

## Risques Critiques Identifiés

1. **Dépendance circulaire** : pwc-ui dépend de @pwc/shared
2. **Migration RxJS** : 2816 composants impactés
3. **Migration Ivy** : Changement moteur de rendu
4. **Webpack custom** : Incompatibilité Webpack 5

## Mitigations Clés

- **Dépendance** : npm link + publication Nexus
- **RxJS** : rxjs-compat + codemod officiel
- **Ivy** : Migration progressive + tests approfondis
- **Webpack** : Migration CLI natif OU adaptation configs

## Matrice des Risques

Tableau récapitulatif avec 12 risques classés par criticité, probabilité, impact et palier concerné.

## Plan de Mitigation Global

- **Avant** : Backup, branche, tags, codemods
- **Pendant** : Ordre pwc-ui-shared → pwc-ui, validation systématique
- **Après** : Build, tests, publication, commit

## Livrables

- Document `.kiro/specs/03-risques-identifies.md` (déjà créé)
- Mise à jour après chaque palier si nouveaux risques
