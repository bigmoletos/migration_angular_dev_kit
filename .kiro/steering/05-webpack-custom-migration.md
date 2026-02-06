---
inclusion: fileMatch
fileMatchPattern: "**/webpack*.js"
priority: 80
---

# Migration Webpack Custom (pwc-ui uniquement)

> **Contexte** : Palier 7 (Angular 11→12) - Migration vers Webpack 5

---

## 🎯 Contexte

`pwc-ui` utilise des configurations Webpack custom :
- `webpack.dev.config.js`
- `webpack.prod.config.js`

Angular CLI 12+ impose Webpack 5, ce qui peut casser les configurations custom.

---

## 🔀 Deux Options

### Option 1 : Migrer vers Angular CLI Natif (RECOMMANDÉ)
- Plus simple à maintenir
- Mises à jour automatiques
- Moins de configuration custom

### Option 2 : Adapter les Configs pour Webpack 5
- Garde le contrôle total
- Plus de travail de maintenance
- Nécessite expertise Webpack

---

## 📋 Option 1 : Migration vers Angular CLI Natif

### Avantages
- ✅ Maintenance simplifiée
- ✅ Mises à jour automatiques avec `ng update`
- ✅ Optimisations Angular intégrées
- ✅ Moins de code custom

### Inconvénients
- ❌ Perte de contrôle sur certaines optimisations
- ❌ Nécessite de reconfigurer dans `angular.json`

### Étapes

#### 1. Analyser les Configs Actuelles
```bash
# Lire les configs
cat webpack.dev.config.js
cat webpack.prod.config.js
```

Identifier :
- Loaders custom
- Plugins custom
- Optimisations custom
- Variables d'environnement

#### 2. Migrer vers angular.json

**Exemple** : Si `webpack.prod.config.js` contient :
```javascript
module.exports = {
  optimization: {
    minimize: true,
    splitChunks: {
      chunks: 'all'
    }
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.API_URL': JSON.stringify('https://api.prod.com')
    })
  ]
};
```

**Migrer vers** `angular.json` :
```json
{
  "projects": {
    "pwc-ui": {
      "architect": {
        "build": {
          "configurations": {
            "production": {
              "optimization": true,
              "buildOptimizer": true,
              "fileReplacements": [
                {
                  "replace": "src/environments/environment.ts",
                  "with": "src/environments/environment.prod.ts"
                }
              ]
            }
          }
        }
      }
    }
  }
}
```

#### 3. Utiliser @angular-builders si Nécessaire

Si des customisations sont vraiment nécessaires :
```bash
npm install @angular-builders/custom-webpack --save-dev
```

**angular.json** :
```json
{
  "architect": {
    "build": {
      "builder": "@angular-builders/custom-webpack:browser",
      "options": {
        "customWebpackConfig": {
          "path": "./webpack.extra.js"
        }
      }
    }
  }
}
```

**webpack.extra.js** (config minimale) :
```javascript
module.exports = {
  plugins: [
    // Plugins custom uniquement
  ]
};
```

#### 4. Mettre à Jour package.json

**AVANT** :
```json
{
  "scripts": {
    "start": "node --max-old-space-size=4096 ./node_modules/webpack-dev-server/bin/webpack-dev-server --config webpack.dev.config.js --port=4200",
    "build": "node --max-old-space-size=12288 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js"
  }
}
```

**APRÈS** :
```json
{
  "scripts": {
    "start": "ng serve --port=4200",
    "build": "ng build --configuration=production"
  }
}
```

#### 5. Tester

```bash
# Dev
npm start

# Build
npm run build

# Vérifier que tout fonctionne
```

---

## 📋 Option 2 : Adapter pour Webpack 5

### Changements Webpack 4 → 5

#### 1. Suppression de Plugins Obsolètes

**Webpack 4** :
```javascript
const webpack = require('webpack');

module.exports = {
  plugins: [
    new webpack.NamedModulesPlugin(), // Obsolète
    new webpack.NoEmitOnErrorsPlugin() // Obsolète
  ]
};
```

**Webpack 5** :
```javascript
module.exports = {
  // Ces fonctionnalités sont maintenant intégrées
  optimization: {
    moduleIds: 'named', // Remplace NamedModulesPlugin
    emitOnErrors: false // Remplace NoEmitOnErrorsPlugin
  }
};
```

#### 2. Node Polyfills

**Webpack 4** : Polyfills Node.js automatiques

**Webpack 5** : Polyfills manuels requis

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

#### 3. Cache

**Webpack 5** introduit un cache persistant :
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

#### 4. Asset Modules

**Webpack 4** :
```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/,
        use: ['file-loader']
      }
    ]
  }
};
```

**Webpack 5** :
```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/,
        type: 'asset/resource'
      }
    ]
  }
};
```

---

## 🔧 Migration Détaillée des Configs

### webpack.dev.config.js

#### AVANT (Webpack 4)
```javascript
const webpack = require('webpack');
const path = require('path');

module.exports = {
  mode: 'development',
  devtool: 'eval-source-map',
  entry: './src/main.ts',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js'
  },
  resolve: {
    extensions: ['.ts', '.js']
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: ['ts-loader']
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      }
    ]
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  devServer: {
    contentBase: './dist',
    hot: true,
    port: 4200
  }
};
```

#### APRÈS (Webpack 5)
```javascript
const webpack = require('webpack');
const path = require('path');

module.exports = {
  mode: 'development',
  devtool: 'eval-source-map',
  entry: './src/main.ts',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js',
    clean: true // Nouveau : nettoie dist automatiquement
  },
  resolve: {
    extensions: ['.ts', '.js']
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: ['ts-loader']
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      }
    ]
  },
  plugins: [
    // HotModuleReplacementPlugin n'est plus nécessaire
  ],
  devServer: {
    static: './dist', // Remplace contentBase
    hot: true,
    port: 4200
  },
  cache: {
    type: 'filesystem' // Nouveau : cache persistant
  }
};
```

### webpack.prod.config.js

#### AVANT (Webpack 4)
```javascript
const webpack = require('webpack');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  mode: 'production',
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        cache: true,
        parallel: true
      })
    ]
  }
};
```

#### APRÈS (Webpack 5)
```javascript
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  mode: 'production',
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        parallel: true,
        terserOptions: {
          compress: {
            drop_console: true
          }
        }
      })
    ]
  }
};
```

---

## ⚠️ Problèmes Courants

### Problème 1 : "Module not found: Error: Can't resolve 'crypto'"

**Cause** : Webpack 5 ne polyfill plus Node.js automatiquement.

**Solution** :
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

---

### Problème 2 : "file-loader" ne fonctionne plus

**Cause** : Webpack 5 utilise Asset Modules.

**Solution** :
```javascript
// AVANT
{
  test: /\.(png|jpg|gif)$/,
  use: ['file-loader']
}

// APRÈS
{
  test: /\.(png|jpg|gif)$/,
  type: 'asset/resource'
}
```

---

### Problème 3 : Build très lent

**Cause** : Cache non configuré.

**Solution** :
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

---

## 📊 Comparaison des Options

| Critère | CLI Natif | Webpack Custom |
|---------|-----------|----------------|
| Maintenance | ✅ Facile | ❌ Complexe |
| Mises à jour | ✅ Automatiques | ❌ Manuelles |
| Contrôle | ⚠️ Limité | ✅ Total |
| Performance | ✅ Optimisé | ⚠️ Dépend config |
| Temps migration | ✅ 1-2 jours | ❌ 3-5 jours |

**Recommandation** : CLI Natif sauf si besoins très spécifiques.

---

## ✅ Checklist de Migration

### Option 1 : CLI Natif
- [ ] Analyser webpack.dev.config.js
- [ ] Analyser webpack.prod.config.js
- [ ] Identifier les customisations nécessaires
- [ ] Migrer vers angular.json
- [ ] Installer @angular-builders si nécessaire
- [ ] Mettre à jour package.json scripts
- [ ] Tester `npm start`
- [ ] Tester `npm run build`
- [ ] Supprimer webpack.*.config.js (optionnel)

### Option 2 : Webpack 5 Custom
- [ ] Mettre à jour webpack vers 5.x
- [ ] Remplacer plugins obsolètes
- [ ] Ajouter polyfills Node.js si nécessaire
- [ ] Migrer vers Asset Modules
- [ ] Configurer le cache
- [ ] Mettre à jour devServer config
- [ ] Tester `npm start`
- [ ] Tester `npm run build`
- [ ] Vérifier les performances

---

## 🚀 Commandes de Test

```bash
# Nettoyer
rm -rf node_modules dist package-lock.json
npm install

# Dev
npm start
# Vérifier que l'app démarre sur http://localhost:4200

# Build
npm run build
# Vérifier que dist/ est créé

# Tester le build
cd dist
npx http-server -p 8080
# Ouvrir http://localhost:8080
```

---

## 📚 Ressources

- [Webpack 5 Migration Guide](https://webpack.js.org/migrate/5/)
- [Angular CLI Custom Webpack](https://github.com/just-jeb/angular-builders/tree/master/packages/custom-webpack)
- [Webpack 5 Release Notes](https://webpack.js.org/blog/2020-10-10-webpack-5-release/)

---

## 🎯 Décision Recommandée

**Pour pwc-ui** : Migrer vers Angular CLI natif avec `@angular-builders/custom-webpack` pour les customisations minimales.

**Raison** :
- Maintenance simplifiée
- Mises à jour automatiques
- Moins de dette technique
- Performances optimisées par Angular

**Customisations à garder** (si nécessaire) :
- Variables d'environnement spécifiques
- Plugins de sécurité (obfuscation)
- Optimisations spécifiques au projet
