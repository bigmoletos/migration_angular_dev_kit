# Requirements - Palier 7 : Angular 11.2 → 12.2 (Webpack 5)

## Objectifs

### Objectif Principal
Migrer Angular 11.2 vers 12.2 avec Webpack 5 obligatoire, en adaptant les configurations custom de pwc-ui.

### Objectifs Spécifiques
1. Migrer vers Webpack 5 (obligatoire)
2. Adapter les configurations custom (webpack.dev.config.js, webpack.prod.config.js)
3. Supprimer View Engine complètement
4. Mettre à jour TypeScript 4.2+
5. Valider build et tests

## Contexte

### Situation Actuelle
- Angular 11.2 avec Webpack 4
- Configurations Webpack custom dans pwc-ui
- View Engine encore présent (déprécié)
- TypeScript 4.0

### Situation Cible
- Angular 12.2 avec Webpack 5
- Configurations Webpack adaptées ou migration vers CLI natif
- View Engine complètement supprimé
- TypeScript 4.2+
- Nullish coalescing dans templates disponible

## Contraintes

### Techniques
- **Durée estimée** : 1 semaine
- **Complexité** : 🟡 Moyenne
- **Criticité** : Impact sur build custom de pwc-ui
- **Tests** : >95% doivent passer
- **Ordre** : pwc-ui-shared AVANT pwc-ui

### Breaking Changes
1. **Webpack 5 obligatoire** : Webpack 4 n'est plus supporté
2. **Configurations custom** : Doivent être adaptées pour Webpack 5
3. **Polyfills Node.js** : Manuels requis (crypto, buffer, etc.)
4. **View Engine supprimé** : Ivy est le seul moteur
5. **TypeScript 4.2+** : Nouvelles fonctionnalités disponibles

## Critères d'Acceptation

### pwc-ui-shared
- [ ] Angular 12.2 installé
- [ ] Webpack 5 installé automatiquement
- [ ] TypeScript 4.2+ installé
- [ ] Polyfills à jour
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 12.2 installé
- [ ] Webpack 5 installé
- [ ] TypeScript 4.2+ installé
- [ ] Webpack configs adaptés OU migré vers CLI natif
- [ ] Polyfills Node.js ajoutés si nécessaire
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre
- [ ] Tests manuels OK
- [ ] Tag Git créé

## Risques Identifiés

### Risque 1 : Webpack Custom Incompatible
- **Probabilité** : Élevée
- **Impact** : Élevé
- **Mitigation** : Option A (CLI natif) ou Option B (adapter configs)

### Risque 2 : Polyfills Node.js Manquants
- **Probabilité** : Moyenne
- **Impact** : Moyen
- **Mitigation** : Installer node-polyfill-webpack-plugin

### Risque 3 : Build Très Lent
- **Probabilité** : Faible
- **Impact** : Moyen
- **Mitigation** : Configurer cache filesystem

## Dépendances

### Prérequis
- Palier 6 (Angular 11) complété et validé
- Node.js v12 installé
- Tests passent sur Angular 11

### Dépendances Externes
- Angular CLI 12.2
- TypeScript 4.2+
- Webpack 5
- node-polyfill-webpack-plugin (si nécessaire)

## Ressources

### Documentation
- [Angular 12 Release Notes](https://blog.angular.io/angular-v12-is-now-available-32ed51fbfd49)
- [Webpack 5 Migration Guide](https://webpack.js.org/migrate/5/)
- Steering : `.kiro/steering/05-webpack-custom-migration.md`

### Outils
- Angular CLI migration schematics
- node-polyfill-webpack-plugin
- webpack-bundle-analyzer
