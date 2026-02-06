# Requirements - Risques Identifiés Migration Angular 5 → 20

## Objectif

Identifier, documenter et proposer des mitigations pour tous les risques de la migration Angular 5 → 20.

## Contexte

Migration complexe de 2816 composants sur 15 paliers avec dépendances critiques.

## Exigences Fonctionnelles

### EF-1 : Risques Critiques (🔴)
Identifier tous les risques bloquants avec impact critique.

### EF-2 : Risques Élevés (🟠)
Identifier tous les risques à impact élevé.

### EF-3 : Risques Moyens (🟡)
Identifier tous les risques à impact moyen.

### EF-4 : Risques Faibles (🟢)
Identifier tous les risques à impact faible.

### EF-5 : Mitigations
Proposer des mitigations concrètes pour chaque risque.

### EF-6 : Matrice des Risques
Créer une matrice récapitulative (risque, criticité, probabilité, impact, palier).

## Critères d'Acceptation

### CA-1 : Risques Critiques Documentés
- [ ] Dépendance circulaire pwc-ui ↔ pwc-ui-shared
- [ ] Migration RxJS 5→6
- [ ] Migration Ivy
- [ ] Webpack custom
- [ ] Mitigations proposées pour chacun

### CA-2 : Risques Élevés Documentés
- [ ] Bibliothèques tierces obsolètes
- [ ] Tests unitaires (2816 composants)
- [ ] TypeScript 2.5 → 5.6
- [ ] Mitigations proposées

### CA-3 : Risques Moyens et Faibles Documentés
- [ ] Node.js v10 → v20
- [ ] Gradle build
- [ ] Nexus registry
- [ ] Zone.js, Polyfills

### CA-4 : Matrice des Risques Créée
- [ ] Tableau avec 12 risques
- [ ] Criticité, probabilité, impact, palier concerné

### CA-5 : Plan de Mitigation Global
- [ ] Actions avant migration
- [ ] Actions pendant migration
- [ ] Actions après chaque palier
- [ ] Procédure de rollback

### CA-6 : Indicateurs de Succès
- [ ] Métriques définies (build, tests, couverture, temps)
- [ ] Cibles définies

## Contraintes

- **C-1** : Couvrir tous les paliers (0-15)
- **C-2** : Mitigations actionnables
- **C-3** : Références vers documentation officielle

## Dépendances

- `.kiro/specs/02-plan-migration.md` : Plan détaillé
- `.kiro/specs/01-etat-actuel.md` : État actuel
- Documentation Angular, RxJS, Ivy
