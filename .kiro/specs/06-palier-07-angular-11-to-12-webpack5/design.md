# Design - Palier 7 : Angular 11.2 → 12.2 (Webpack 5)

## Architecture

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────┐
│                PALIER 7 : WEBPACK 5                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Phase 1: pwc-ui-shared (Simple)                        │
│  ├─ Migration Angular 11 → 12                           │
│  ├─ Webpack 5 installé automatiquement                  │
│  ├─ Polyfills vérifiés                                  │
│  └─ Build et tests                                      │
│                                                          │
│  Phase 2: pwc-ui (Complexe - Webpack Custom)            │
│  ├─ Mise à jour @pwc/shared                             │
│  ├─ Migration Angular 11 → 12                           │
│  ├─ DÉCISION CRITIQUE :                                 │
│  │  ├─ Option A : Migrer vers CLI natif (RECOMMANDÉ)   │
│  │  └─ Option B : Adapter configs Webpack 5            │
│  └─ Tests complets                                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Changements Majeurs Webpack 5

#### 1. Plugins Obsolètes

```javascript
// AVANT (Webpack 4)
const webpack = require('webpack');

module.exports = {
  plugins: [
    new webpack.NamedModulesPlugin(),      // Obsolète
    new webpack.NoEmitOnErrorsPlugin()     // Obsolète
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

#### 2. Polyfills Node.js

```javascript
// Webpack 5 ne polyfill plus automatiquement
// Installer : npm install node-polyfill-webpack-plugin --save-dev

const NodePolyfillPlugin = require('node-polyfill-webpack-plugin');

module.exports = {
  plugins: [
    new NodePolyfillPlugin()
  ]
};
```

#### 3. Asset Modules

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

#### 4. Cache Filesystem

```javascript
// Nouveau dans Webpack 5
module.exports = {
  cache: {
    type: 'filesystem',
    buildDependencies: {
      config: [__filename]
    }
  }
};
```

#### 5. DevServer

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

## Stratégie de Migration

### Phase 1 : pwc-ui-shared (Simple)

#### Étape 1 : Migration Angular
```bash
ng update @angular/cli@12 @angular/core@12 --allow-dirty
```

**Résultat** :
- Angular 12.2 installé
- Webpack 5 installé automatiquement
- TypeScript 4.2+ installé

#### Étape 2 : Vérification Polyfills
Vérifier `polyfills.ts` :
```typescript
import 'zone.js';  // Included with Angular CLI.
```

#### Étape 3 : Build et Tests
```bash
npm run build
npm test
```

### Phase 2 : pwc-ui (Complexe)

#### DÉCISION CRITIQUE : Webpack Custom

**pwc-ui utilise des configs Webpack custom !**

##### Option A : Migrer vers Angular CLI Natif (RECOMMANDÉ)

**Avantages** :
- ✅ Maintenance simplifiée
- ✅ Mises à jour automatiques
- ✅ Moins de dette technique
- ✅ Support officiel Angular

**Inconvénients** :
- ⚠️ Nécessite analyse des customisations
- ⚠️ Peut nécessiter refactoring

**Processus** :
1. Analyser `webpack.dev.config.js` et `webpack.prod.config.js`
2. Identifier les customisations nécessaires
3. Migrer vers `angular.json`
4. Utiliser `@angular-builders/custom-webpack` si nécessaire

**Voir** : `.kiro/steering/05-webpack-custom-migration.md`

##### Option B : Adapter pour Webpack 5

**Avantages** :
- ✅ Garde les configs existantes
- ✅ Moins de refactoring

**Inconvénients** :
- ⚠️ Dette technique maintenue
- ⚠️ Maintenance manuelle requise
- ⚠️ Risque d'incompatibilité future

**Changements requis** :

1. **Supprimer plugins obsolètes**
2. **Ajouter polyfills Node.js**
3. **Migrer vers Asset Modules**
4. **Configurer le cache**
5. **Mettre à jour devServer**

## Patterns de Code

### Pattern 1 : Configuration Webpack 5 Minimale

```javascript
// webpack.config.js
const NodePolyfillPlugin = require('node-polyfill-webpack-plugin');

module.exports = {
  // Cache pour améliorer les performances
  cache: {
    type: 'filesystem',
    buildDependencies: {
      config: [__filename]
    }
  },
  
  // Optimisations
  optimization: {
    moduleIds: 'named',
    emitOnErrors: false
  },
  
  // Plugins
  plugins: [
    new NodePolyfillPlugin()
  ],
  
  // Asset Modules
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif|svg)$/,
        type: 'asset/resource'
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        type: 'asset/resource'
      }
    ]
  },
  
  // DevServer
  devServer: {
    static: './dist',
    hot: true,
    port: 4200
  }
};
```

### Pattern 2 : Migration vers CLI Natif avec Custom Builder

```bash
# Installer custom builder
npm install -D @angular-builders/custom-webpack
```

```json
// angular.json
{
  "projects": {
    "my-app": {
      "architect": {
        "build": {
          "builder": "@angular-builders/custom-webpack:browser",
          "options": {
            "customWebpackConfig": {
              "path": "./webpack.config.js",
              "mergeRules": {
                "externals": "replace"
              }
            }
          }
        }
      }
    }
  }
}
```

### Pattern 3 : Polyfills Node.js Sélectifs

```javascript
// Si vous n'avez besoin que de certains polyfills
const webpack = require('webpack');

module.exports = {
  resolve: {
    fallback: {
      "crypto": require.resolve("crypto-browserify"),
      "stream": require.resolve("stream-browserify"),
      "buffer": require.resolve("buffer/")
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
      Buffer: ['buffer', 'Buffer'],
      process: 'process/browser'
    })
  ]
};
```

## Gestion des Erreurs

### Erreur 1 : "Module not found: Error: Can't resolve 'crypto'"
**Cause** : Webpack 5 ne polyfill plus Node.js automatiquement

**Solution** :
```bash
npm install node-polyfill-webpack-plugin --save-dev
```

### Erreur 2 : "file-loader" ne fonctionne plus
**Cause** : Webpack 5 utilise Asset Modules

**Solution** : Migrer vers `type: 'asset/resource'`

### Erreur 3 : Build très lent
**Cause** : Cache non configuré

**Solution** : Configurer le cache filesystem

### Erreur 4 : Webpack custom ne fonctionne plus
**Cause** : Configurations incompatibles avec Webpack 5

**Solution** : Migrer vers Angular CLI natif (recommandé)

## Métriques de Validation

### Métriques Techniques

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Webpack 5 | ✅ | ✅ | |
| TypeScript 4.2+ | ✅ | ✅ | |
| Configs adaptées | N/A | ✅ | |
| Application démarre | N/A | ✅ | |

### Métriques de Performance

| Métrique | Avant (Webpack 4) | Après (Webpack 5) | Amélioration |
|----------|-------------------|-------------------|--------------|
| Temps build (dev) | Baseline | -20% | Attendu |
| Temps build (prod) | Baseline | -10% | Attendu |
| Taille cache | 0 | ~500 MB | Cache filesystem |

## Rollback

Si le palier échoue :

```bash
# Revenir au tag précédent
git reset --hard palier-6-angular-11-shared

# Nettoyer
rm -rf node_modules package-lock.json
npm install

# Vérifier
npm run build
npm test
```

## Documentation

### Fichiers à Mettre à Jour
- `.kiro/state/strands-state.json` : État du palier
- `Documentation/JOURNAL-DE-BORD.md` : Décision Webpack
- `README.md` : Version Angular et Webpack

### Informations à Documenter
- Décision Webpack (CLI natif ou custom)
- Problèmes rencontrés
- Solutions appliquées
- Temps réel vs estimé
- Customisations Webpack conservées ou migrées
