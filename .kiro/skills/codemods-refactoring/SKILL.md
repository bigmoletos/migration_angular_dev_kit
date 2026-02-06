---
name: codemods-refactoring
displayName: Codemods & Automated Refactoring
description: Refactoring automatique avec jscodeshift, ts-morph et ng update itératif
version: 1.0.0

# LAZY LOADING CONFIG
loadOn:
  keywords:
    - codemod
    - refactor
    - refactoring
    - jscodeshift
    - ts-morph
    - transform
    - ast
    - automated
    - batch
    - bulk
  filePatterns:
    - "codemods/*.js"
    - "codemods/*.ts"
  manual: "#codemods"

# TOKEN ESTIMATION
tokenEstimate: 7000
priority: medium

# DEPENDENCIES
requires:
  - angular-migration
mcpNeeds:
  - filesystem
---

# 🔄 Codemods & Automated Refactoring Skill

## Activation

Ce skill se charge automatiquement quand :
- Le prompt contient : "codemod", "refactor", "jscodeshift", "ts-morph", "transform"
- On travaille sur des fichiers de transformation
- L'utilisateur tape : `#codemods`

---

## 🎯 Objectif

Automatiser les transformations de code répétitives :
- **ng update** : Migrations officielles Angular
- **jscodeshift** : Transformations JavaScript/TypeScript
- **ts-morph** : Manipulations AST TypeScript avancées
- **Codemods personnalisés** : Pour patterns spécifiques au projet

---

## ⚠️ Pourquoi pas OpenRewrite ?

**OpenRewrite** est excellent mais :
- ❌ Pas de support TypeScript natif
- ❌ Orienté Java/Kotlin/Groovy
- ❌ Complexe à configurer pour Angular

**Alternatives recommandées** :

| Outil | Cas d'usage | Support TS |
|-------|-------------|------------|
| `ng update` | Migrations Angular officielles | ✅ Natif |
| `jscodeshift` | Transformations JS/TS simples | ✅ Bon |
| `ts-morph` | Manipulations AST complexes | ✅ Excellent |
| `ESLint --fix` | Corrections automatiques | ✅ Bon |

---

## 📐 Architecture des Codemods

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      PIPELINE DE TRANSFORMATION                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ÉTAPE 1: ng update (Migrations officielles Angular)                    │
│  ─────────────────────────────────────────────────────                  │
│  ng update @angular/cli@X @angular/core@X                               │
│  → Applique les schematics de migration                                 │
│  → ModuleWithProviders<T>, ViewChild static, etc.                       │
│                                                                         │
│  ÉTAPE 2: rxjs-5-to-6-migrate (Migration RxJS)                          │
│  ─────────────────────────────────────────────────────                  │
│  rxjs-5-to-6-migrate -p tsconfig.json                                   │
│  → Convertit imports et chaînages                                       │
│                                                                         │
│  ÉTAPE 3: Codemods personnalisés (jscodeshift/ts-morph)                 │
│  ─────────────────────────────────────────────────────                  │
│  jscodeshift -t codemods/custom.js src/**/*.ts                          │
│  → Patterns spécifiques au projet                                       │
│                                                                         │
│  ÉTAPE 4: ESLint --fix + Prettier                                       │
│  ─────────────────────────────────────────────────────                  │
│  eslint --fix && prettier --write                                       │
│  → Nettoyage et formatage final                                         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 ng update Itératif

### Commandes par Palier

```bash
# Angular 5 → 6
ng update @angular/cli@6 @angular/core@6
npm install rxjs@6 rxjs-compat
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Angular 6 → 7
ng update @angular/cli@7 @angular/core@7

# Angular 7 → 8
ng update @angular/cli@8 @angular/core@8
# Migration lazy loading automatique

# Angular 8 → 9
ng update @angular/cli@9 @angular/core@9
# Ivy devient default, supprimer rxjs-compat
npm uninstall rxjs-compat

# Angular 9 → 10
ng update @angular/cli@10 @angular/core@10

# Angular 10 → 11
ng update @angular/cli@11 @angular/core@11

# Angular 11 → 12
ng update @angular/cli@12 @angular/core@12
# Mode strict renforcé

# Angular 12 → 13
ng update @angular/cli@13 @angular/core@13

# Angular 13 → 14
ng update @angular/cli@14 @angular/core@14
# Standalone components introduits

# Angular 14 → 15
ng update @angular/cli@15 @angular/core@15

# Angular 15 → 16
ng update @angular/cli@16 @angular/core@16
# Signals introduits

# Angular 16 → 17
ng update @angular/cli@17 @angular/core@17
# Nouveau control flow (@if, @for)

# Angular 17 → 18
ng update @angular/cli@18 @angular/core@18

# Angular 18 → 19
ng update @angular/cli@19 @angular/core@19

# Angular 19 → 20
ng update @angular/cli@20 @angular/core@20
```

### Script Automatisé

```bash
#!/bin/bash
# scripts/ng-update-iterative.sh

set -e

CURRENT=$1
TARGET=$2

echo "🚀 Migration itérative Angular $CURRENT → $TARGET"

for ((version=$CURRENT; version<$TARGET; version++)); do
    next=$((version + 1))
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "📦 Palier $version → $next"
    echo "═══════════════════════════════════════════════════════"
    
    # Mise à jour
    ng update @angular/cli@$next @angular/core@$next --force
    
    # Codemods spécifiques au palier
    if [ -f "scripts/codemods/angular-$version-to-$next.js" ]; then
        echo "🔧 Application codemod palier $version→$next"
        jscodeshift -t scripts/codemods/angular-$version-to-$next.js src/**/*.ts
    fi
    
    # Build de validation
    echo "🔨 Build de validation..."
    npm run build
    
    # Tests
    echo "🧪 Tests..."
    npm run test -- --watch=false --browsers=ChromeHeadless
    
    echo "✅ Palier $version → $next complété"
    
    # Checkpoint git
    git add -A
    git commit -m "chore(migration): Angular $version → $next"
done

echo ""
echo "🎉 Migration complète ! Angular $CURRENT → $TARGET"
```

---

## 📝 Codemods Personnalisés

### 1. RxJS Imports (jscodeshift)

```javascript
// scripts/codemods/rxjs-imports.js

module.exports = function(fileInfo, api) {
  const j = api.jscodeshift;
  const root = j(fileInfo.source);
  
  // Mapping des imports RxJS 5 → 6
  const importMapping = {
    'rxjs/Observable': 'rxjs',
    'rxjs/Subject': 'rxjs',
    'rxjs/BehaviorSubject': 'rxjs',
    'rxjs/ReplaySubject': 'rxjs',
    'rxjs/operators/map': 'rxjs/operators',
    'rxjs/operators/filter': 'rxjs/operators',
    'rxjs/operators/switchMap': 'rxjs/operators',
    'rxjs/operators/catchError': 'rxjs/operators',
    'rxjs/add/operator/map': null,  // À supprimer
    'rxjs/add/operator/filter': null,
  };
  
  // Transformer les imports
  root
    .find(j.ImportDeclaration)
    .forEach(path => {
      const source = path.value.source.value;
      
      if (importMapping.hasOwnProperty(source)) {
        if (importMapping[source] === null) {
          // Supprimer l'import
          j(path).remove();
        } else {
          // Remplacer la source
          path.value.source.value = importMapping[source];
        }
      }
    });
  
  return root.toSource({ quote: 'single' });
};
```

### 2. ViewChild Static (ts-morph)

```typescript
// scripts/codemods/viewchild-static.ts

import { Project, SyntaxKind } from 'ts-morph';

const project = new Project({
  tsConfigFilePath: './tsconfig.json',
});

let modifiedCount = 0;

project.getSourceFiles('src/**/*.ts').forEach(sourceFile => {
  sourceFile.getDescendantsOfKind(SyntaxKind.Decorator)
    .filter(d => d.getText().startsWith('@ViewChild'))
    .forEach(decorator => {
      const args = decorator.getArguments();
      
      // Si un seul argument (pas d'options)
      if (args.length === 1) {
        const currentText = decorator.getText();
        
        // Ajouter { static: false }
        const newText = currentText.replace(
          /@ViewChild\(([^)]+)\)/,
          '@ViewChild($1, { static: false })'
        );
        
        decorator.replaceWithText(newText);
        modifiedCount++;
        
        console.log(`  ✓ ${sourceFile.getFilePath()}`);
      }
    });
});

project.saveSync();
console.log(`\n${modifiedCount} @ViewChild modifiés`);
```

### 3. Console.log → Logger (jscodeshift)

```javascript
// scripts/codemods/console-to-logger.js

module.exports = function(fileInfo, api) {
  const j = api.jscodeshift;
  const root = j(fileInfo.source);
  
  // Vérifier si LoggerService est importé
  let hasLoggerImport = root
    .find(j.ImportDeclaration)
    .filter(path => path.value.source.value.includes('LoggerService'))
    .size() > 0;
  
  // Compter les console.log
  const consoleLogs = root
    .find(j.CallExpression, {
      callee: {
        object: { name: 'console' },
        property: { name: 'log' }
      }
    });
  
  if (consoleLogs.size() === 0) {
    return null; // Pas de modification
  }
  
  // Ajouter l'import si nécessaire
  if (!hasLoggerImport) {
    const imports = root.find(j.ImportDeclaration);
    const lastImport = imports.at(-1);
    
    if (lastImport.size() > 0) {
      lastImport.insertAfter(
        j.importDeclaration(
          [j.importSpecifier(j.identifier('LoggerService'))],
          j.literal('@core/services/logger.service')
        )
      );
    }
  }
  
  // Remplacer console.log par this.logger.log
  consoleLogs.replaceWith(path => {
    const args = path.value.arguments;
    
    return j.callExpression(
      j.memberExpression(
        j.memberExpression(j.thisExpression(), j.identifier('logger')),
        j.identifier('log')
      ),
      args
    );
  });
  
  return root.toSource({ quote: 'single' });
};
```

### 4. ModuleWithProviders Generic (ts-morph)

```typescript
// scripts/codemods/module-with-providers.ts

import { Project, SyntaxKind } from 'ts-morph';

const project = new Project({
  tsConfigFilePath: './tsconfig.json',
});

project.getSourceFiles('src/**/*.module.ts').forEach(sourceFile => {
  // Trouver les méthodes retournant ModuleWithProviders
  sourceFile.getFunctions().forEach(fn => {
    const returnType = fn.getReturnType().getText();
    
    if (returnType === 'ModuleWithProviders') {
      // Extraire le nom du module
      const moduleName = sourceFile.getBaseName().replace('.module.ts', '');
      const moduleClassName = moduleName
        .split('-')
        .map(s => s.charAt(0).toUpperCase() + s.slice(1))
        .join('') + 'Module';
      
      // Mettre à jour le type de retour
      fn.setReturnType(`ModuleWithProviders<${moduleClassName}>`);
      
      console.log(`  ✓ ${sourceFile.getFilePath()}: ${moduleClassName}`);
    }
  });
});

project.saveSync();
```

---

## 📁 Structure des Codemods

```
scripts/
├── codemods/
│   ├── angular-5-to-6.js       # Spécifique palier 5→6
│   ├── angular-7-to-8.js       # Spécifique palier 7→8
│   ├── angular-8-to-9.ts       # Ivy migration
│   │
│   ├── rxjs-imports.js         # RxJS 5→6
│   ├── console-to-logger.js    # Console → Logger
│   ├── viewchild-static.ts     # ViewChild migration
│   ├── module-with-providers.ts # Generic types
│   │
│   └── utils/
│       ├── ast-helpers.js
│       └── file-utils.js
│
├── ng-update-iterative.sh      # Script principal
└── run-codemods.sh             # Wrapper codemods
```

---

## 🚀 Utilisation

### Migration Complète

```bash
# 1. Migration itérative avec ng update
./scripts/ng-update-iterative.sh 5 20

# 2. Ou manuellement par palier
ng update @angular/cli@6 @angular/core@6
jscodeshift -t scripts/codemods/angular-5-to-6.js src/**/*.ts
npm run build && npm run test
```

### Codemod Unique

```bash
# Exécuter un codemod spécifique
jscodeshift -t scripts/codemods/console-to-logger.js src/**/*.ts

# Dry-run (prévisualisation)
jscodeshift -t scripts/codemods/console-to-logger.js --dry src/**/*.ts

# Avec ts-morph
npx ts-node scripts/codemods/viewchild-static.ts
```

### Via Chat Kiro

```
> #codemods run console-to-logger

[CODEMOD] Exécution: console-to-logger.js
[CODEMOD] Fichiers scannés: 234
[CODEMOD] Modifications: 47 fichiers
[CODEMOD] ✅ Terminé

> #codemods dry-run rxjs-imports

[CODEMOD] Mode dry-run: rxjs-imports.js
[CODEMOD] Fichiers affectés: 89
[CODEMOD] Aperçu des changements:
  src/app/services/user.service.ts:
    - import { Observable } from 'rxjs/Observable';
    + import { Observable } from 'rxjs';
  ...
```

---

## 📊 Estimation des Gains

| Tâche | Temps Manuel | Temps Codemod | Gain |
|-------|--------------|---------------|------|
| RxJS imports (200 fichiers) | 40h | 30min | 98% |
| console.log → Logger | 20h | 15min | 99% |
| ViewChild static | 10h | 10min | 98% |
| ModuleWithProviders<T> | 8h | 5min | 99% |
| **TOTAL** | ~78h | ~1h | **99%** |

---

## ⚠️ Précautions

1. **Toujours commiter avant** d'exécuter un codemod
2. **Dry-run d'abord** pour prévisualiser
3. **Tester après** chaque transformation
4. **Réviser les changements** (certains cas edge peuvent échouer)

---

## 📚 Ressources

- [jscodeshift Documentation](https://github.com/facebook/jscodeshift)
- [ts-morph Documentation](https://ts-morph.com/)
- [Angular Update Guide](https://update.angular.io/)
- [AST Explorer](https://astexplorer.net/) - Pour tester les transformations
