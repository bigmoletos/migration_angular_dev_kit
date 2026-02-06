# 🔧 Codemods - Migration Angular 5 → 20

Scripts de transformation automatique du code pour la migration Angular.

## 📋 Prérequis

```powershell
# Installer jscodeshift globalement
npm install -g jscodeshift

# Ou en local dans le projet
npm install --save-dev jscodeshift
```

## 🚀 Utilisation

### Mode Dry-Run (Prévisualisation)

Toujours commencer par un dry-run pour voir les changements sans modifier les fichiers :

```powershell
# Depuis la racine du repo (ex: C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia)
npx jscodeshift -t ../../../scripts_outils_ia/codemods/rxjs-imports.js src/**/*.ts --parser=ts --dry
```

### Mode Application

```powershell
npx jscodeshift -t ../../../scripts_outils_ia/codemods/rxjs-imports.js src/**/*.ts --parser=ts
```

## 📦 Codemods Disponibles

### 1. `rxjs-imports.js` - Migration RxJS 5 → 6+

**Quand l'utiliser** : Angular 5 → 6

**Transformations** :
```typescript
// Avant
import { Observable } from 'rxjs/Observable';
import { map } from 'rxjs/operators/map';
import 'rxjs/add/operator/map';

// Après
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
```

**Commande** :
```powershell
npx jscodeshift -t ../../../scripts_outils_ia/codemods/rxjs-imports.js src/**/*.ts --parser=ts
```

---

### 2. `viewchild-static.js` - ViewChild Static Option

**Quand l'utiliser** : Angular 7 → 8

**Transformations** :
```typescript
// Avant
@ViewChild('myRef') myElement: ElementRef;
@ContentChild(MyComponent) myComp: MyComponent;

// Après
@ViewChild('myRef', { static: false }) myElement: ElementRef;
@ContentChild(MyComponent, { static: false }) myComp: MyComponent;
```

**Commande** :
```powershell
npx jscodeshift -t ../../../scripts_outils_ia/codemods/viewchild-static.js src/**/*.ts --parser=ts
```

---

### 3. `module-with-providers.js` - Generic ModuleWithProviders

**Quand l'utiliser** : Angular 9 → 10

**Transformations** :
```typescript
// Avant
static forRoot(): ModuleWithProviders { ... }

// Après
static forRoot(): ModuleWithProviders<MyModule> { ... }
```

**Commande** :
```powershell
npx jscodeshift -t ../../../scripts_outils_ia/codemods/module-with-providers.js src/**/*.ts --parser=ts
```

---

### 4. `console-to-logger.js` - Console vers LoggerService

**Quand l'utiliser** : À tout moment (bonne pratique)

**Transformations** :
```typescript
// Avant
console.log('message');
console.error('error');

// Après
this.logger.log('message');
this.logger.error('error');
```

**Commande** :
```powershell
npx jscodeshift -t ../../../scripts_outils_ia/codemods/console-to-logger.js src/**/*.ts --parser=ts
```

---

## 📊 Ordre d'Exécution par Palier

| Palier | Angular | Codemods à Exécuter |
|--------|---------|---------------------|
| 1 | 5 → 6 | `rxjs-imports.js` |
| 2 | 6 → 7 | - |
| 3 | 7 → 8 | `viewchild-static.js` |
| 4 | 8 → 9 | - |
| 5 | 9 → 10 | `module-with-providers.js` |
| 6+ | 10+ | Selon besoins |

## ⚠️ Notes Importantes

1. **Toujours committer avant** d'exécuter un codemod
2. **Dry-run d'abord** pour prévisualiser les changements
3. **Vérifier le build** après chaque codemod
4. **Tests unitaires** pour valider le comportement

## 🔍 Dépannage

### Erreur de parsing TypeScript

```powershell
# Ajouter explicitement le parser TypeScript
npx jscodeshift --parser=ts --extensions=ts ...
```

### Fichiers ignorés

```powershell
# Vérifier les fichiers traités avec verbose
npx jscodeshift -t codemod.js src/**/*.ts --parser=ts --verbose=2
```

### Trop de changements

```powershell
# Traiter fichier par fichier
npx jscodeshift -t codemod.js src/app/specific-file.ts --parser=ts
```

## 🤖 Intégration Kiro

Ces codemods peuvent être lancés automatiquement par Kiro lors de la migration :

```
#codemods Exécute les codemods pour le palier Angular 5 → 6
```

Kiro détectera automatiquement le palier et exécutera les bons codemods.
