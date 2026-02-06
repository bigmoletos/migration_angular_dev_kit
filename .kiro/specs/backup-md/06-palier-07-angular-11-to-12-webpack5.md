# Spec Palier 7 : Angular 11.2 → 12.2 (Webpack 5)

**Durée estimée** : 1 semaine  
**Complexité** : 🟡 Moyenne  
**Criticité** : Impact sur build custom de pwc-ui

---

## 🎯 Objectifs

1. Migrer Angular 11.2 → 12.2
2. Migrer vers Webpack 5 (obligatoire)
3. Adapter les configurations custom (pwc-ui)
4. Supprimer View Engine complètement
5. Valider build et tests

---

## 📋 Breaking Changes

### 1. Webpack 5 Obligatoire
- Webpack 4 n'est plus supporté
- Configurations custom doivent être adaptées
- Polyfills Node.js manuels requis

### 2. View Engine Complètement Supprimé
- Ivy est maintenant le seul moteur
- Toutes les APIs View Engine supprimées

### 3. Nullish Coalescing dans Templates
```html
<!-- Nouveau : nullish coalescing dans templates -->
<div>{{ value ?? 'default' }}</div>
```

### 4. TypeScript 4.2+ Requis
- Nouvelles fonctionnalités TypeScript disponibles

---

## 🔄 Ordre d'Exécution

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Créer une branche
git checkout -b palier-7-angular-12-webpack5

# Créer un tag de sauvegarde
git tag palier-6-angular-11-shared

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 11)
- [ ] Tests passent

---

#### Étape 1.2 : Mettre à jour Angular
```bash
# Dry-run
ng update @angular/cli@12 @angular/core@12 --dry-run

# Appliquer
ng update @angular/cli@12 @angular/core@12 --allow-dirty
```

**Ce qui change** :
- Angular 12.2 installé
- Webpack 5 installé automatiquement
- TypeScript 4.2+ installé
- Migrations automatiques appliquées

**Validation** :
- [ ] Angular 12.2 installé
- [ ] Webpack 5 installé
- [ ] TypeScript 4.2+ installé
- [ ] Compilation réussie

---

#### Étape 1.3 : Vérifier les Polyfills

**Vérifier** `polyfills.ts` :

Angular CLI 12 gère mieux les polyfills. Vérifier que le fichier est à jour.

```typescript
// polyfills.ts
import 'zone.js';  // Included with Angular CLI.
```

**Validation** :
- [ ] Polyfills à jour
- [ ] Compilation réussie

---

#### Étape 1.4 : Build
```bash
npm run build
```

**Vérifier** :
- Build réussi
- Pas d'erreurs Webpack 5
- Taille des bundles (devrait être similaire ou plus petit)

**Validation** :
- [ ] Build réussi
- [ ] Aucune erreur Webpack

---

#### Étape 1.5 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 1.6 : Publication sur Nexus
```bash
# Incrémenter la version (patch)
npm version patch

# Publier
npm publish
```

**Validation** :
- [ ] Version incrémentée
- [ ] Publication réussie

---

#### Étape 1.7 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 12 with Webpack 5"
git tag palier-7-shared-angular-12-webpack5
git push origin palier-7-angular-12-webpack5
git push origin palier-7-shared-angular-12-webpack5
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé
- [ ] Push réussi

---

### Phase 2 : pwc-ui (PRIORITÉ 2) - ATTENTION WEBPACK CUSTOM

#### Étape 2.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia

# Créer une branche
git checkout -b palier-7-angular-12-webpack5

# Créer un tag de sauvegarde
git tag palier-6-angular-11-ui

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 11)

---

#### Étape 2.2 : Mettre à jour @pwc/shared
```bash
npm install @pwc/shared@latest
```

**Validation** :
- [ ] `@pwc/shared` mis à jour
- [ ] `npm install` réussi

---

#### Étape 2.3 : Mettre à jour Angular
```bash
ng update @angular/cli@12 @angular/core@12 --allow-dirty
```

**Validation** :
- [ ] Angular 12.2 installé
- [ ] Webpack 5 installé

---

#### Étape 2.4 : CRITIQUE - Adapter Webpack Custom

**pwc-ui utilise des configs Webpack custom !**

Deux options :

##### Option A : Migrer vers Angular CLI Natif (RECOMMANDÉ)

**Avantages** :
- Maintenance simplifiée
- Mises à jour automatiques
- Moins de dette technique

**Étapes** :
1. Analyser `webpack.dev.config.js` et `webpack.prod.config.js`
2. Identifier les customisations nécessaires
3. Migrer vers `angular.json`
4. Utiliser `@angular-builders/custom-webpack` si nécessaire

**Voir** : `.kiro/steering/05-webpack-custom-migration.md`

##### Option B : Adapter pour Webpack 5

**Changements requis** :

1. **Supprimer plugins obsolètes** :
```javascript
// AVANT (Webpack 4)
const webpack = require('webpack');

module.exports = {
  plugins: [
    new webpack.NamedModulesPlugin(), // Obsolète
    new webpack.NoEmitOnErrorsPlugin() // Obsolète
  ]
};

// APRÈS (Webpack 5)
module.exports = {
  optimization: {
    moduleIds: 'named',
    emitOnErrors: false
  }
};
```

2. **Ajouter polyfills Node.js** :
```bash
npm install node-polyfill-webpack-plugin --save-dev
```

```javascript
const NodePolyfillPlugin = require('node-polyfill-webpack-plugin');

module.exports = {
  plugins: [
    new NodePolyfillPlugin()
  ]
};
```

3. **Migrer vers Asset Modules** :
```javascript
// AVANT (Webpack 4)
{
  test: /\.(png|jpg|gif)$/,
  use: ['file-loader']
}

// APRÈS (Webpack 5)
{
  test: /\.(png|jpg|gif)$/,
  type: 'asset/resource'
}
```

4. **Configurer le cache** :
```javascript
module.exports = {
  cache: {
    type: 'filesystem',
    buildDependencies: {
      config: [__filename]
    }
  }
};
```

5. **Mettre à jour devServer** :
```javascript
// AVANT (Webpack 4)
devServer: {
  contentBase: './dist',
  hot: true
}

// APRÈS (Webpack 5)
devServer: {
  static: './dist',
  hot: true
}
```

**Validation** :
- [ ] Webpack configs adaptés
- [ ] Compilation réussie

---

#### Étape 2.5 : Build
```bash
npm run build
```

**Vérifier** :
- Build réussi avec Webpack 5
- Pas d'erreurs
- Bundles générés correctement

**Validation** :
- [ ] Build réussi
- [ ] Aucune erreur Webpack 5

---

#### Étape 2.6 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 2.7 : Test Manuel
```bash
npm start
```

**Tester** :
- [ ] Application démarre
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Aucune erreur console
- [ ] Aucune régression visuelle

---

#### Étape 2.8 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 12 with Webpack 5"
git tag palier-7-ui-angular-12-webpack5
git push origin palier-7-angular-12-webpack5
git push origin palier-7-ui-angular-12-webpack5
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé
- [ ] Push réussi

---

## 📊 Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Webpack 5 | ✅ | ✅ | |
| Configs adaptées | N/A | ✅ | |
| Application démarre | N/A | ✅ | |

---

## ⚠️ Problèmes Connus et Solutions

### Problème 1 : "Module not found: Error: Can't resolve 'crypto'"
**Cause** : Webpack 5 ne polyfill plus Node.js automatiquement.

**Solution** :
```bash
npm install node-polyfill-webpack-plugin --save-dev
```

### Problème 2 : "file-loader" ne fonctionne plus
**Cause** : Webpack 5 utilise Asset Modules.

**Solution** : Migrer vers `type: 'asset/resource'`

### Problème 3 : Build très lent
**Cause** : Cache non configuré.

**Solution** : Configurer le cache filesystem

### Problème 4 : Webpack custom ne fonctionne plus
**Cause** : Configurations incompatibles avec Webpack 5.

**Solution** : Migrer vers Angular CLI natif (recommandé)

---

## 📚 Ressources

- [Angular 12 Release Notes](https://blog.angular.io/angular-v12-is-now-available-32ed51fbfd49)
- [Webpack 5 Migration Guide](https://webpack.js.org/migrate/5/)
- Steering : `.kiro/steering/05-webpack-custom-migration.md`

---

## ✅ Checklist Finale

### pwc-ui-shared
- [ ] Angular 12.2 installé
- [ ] Webpack 5 installé
- [ ] TypeScript 4.2+ installé
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
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre
- [ ] Tests manuels OK
- [ ] Tag Git créé

### Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Problèmes rencontrés documentés
- [ ] Décision Webpack documentée (CLI natif ou custom)

---

## 🎯 Prochaine Étape

Une fois le Palier 7 validé, passer au **Palier 8 : Angular 12 → 13** (TypeScript 4.4+).
