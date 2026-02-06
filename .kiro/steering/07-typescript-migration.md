---
inclusion: fileMatch
fileMatchPattern: "**/*.ts"
priority: 70
---

# Migration TypeScript 2.5 → 5.6

> **Contexte** : Migration progressive de TypeScript à travers les paliers

---

## 🎯 Objectif

Migrer TypeScript de la version 2.5 (Angular 5) à 5.6 (Angular 20) en suivant les paliers Angular.

---

## 📋 Versions TypeScript par Palier

| Palier | Angular | TypeScript | Breaking Changes |
|--------|---------|------------|------------------|
| 1 | 5→6 | 2.5→2.7 | Faibles |
| 2 | 6→7 | 2.7→3.1 | Faibles |
| 3 | 7→8 | 3.1→3.4 | Faibles |
| 4 | 8→9 | 3.4→3.8 | Moyens |
| 5 | 9→10 | 3.8→3.9 | Faibles |
| 6 | 10→11 | 3.9→4.0 | **Élevés** |
| 7 | 11→12 | 4.0→4.2 | Faibles |
| 8 | 12→13 | 4.2→4.4 | Moyens |
| 9 | 13→14 | 4.4→4.6 | Faibles |
| 10 | 14→15 | 4.6→4.8 | Faibles |
| 11 | 15→16 | 4.8→4.9 | Moyens |
| 12 | 16→17 | 4.9→5.2 | **Élevés** |
| 13 | 17→18 | 5.2→5.4 | Faibles |
| 14 | 18→19 | 5.4→5.5 | Faibles |
| 15 | 19→20 | 5.5→5.6 | Faibles |

---

## 🔄 Breaking Changes Majeurs

### TypeScript 3.0 (Palier 2-3)
- `unknown` type introduit
- Tuples optionnels
- Rest parameters avec tuples

```typescript
// unknown type (plus sûr que any)
function process(value: unknown) {
  if (typeof value === 'string') {
    return value.toUpperCase();
  }
}
```

---

### TypeScript 3.7 (Palier 4)
- Optional chaining (`?.`)
- Nullish coalescing (`??`)

```typescript
// Optional chaining
const name = user?.profile?.name;

// Nullish coalescing
const displayName = name ?? 'Anonymous';
```

---

### TypeScript 4.0 (Palier 6) 🔴
- Variadic tuple types
- Labeled tuple elements
- `unknown` dans catch clauses

```typescript
// Labeled tuples
type Point = [x: number, y: number];

// unknown dans catch
try {
  // ...
} catch (error: unknown) {
  if (error instanceof Error) {
    console.error(error.message);
  }
}
```

---

### TypeScript 4.4 (Palier 8)
- Control flow analysis amélioré
- Index signatures pour symbols

---

### TypeScript 5.0 (Palier 12) 🔴
- Decorators standard (Stage 3)
- `const` type parameters
- `satisfies` operator

```typescript
// satisfies operator
const config = {
  url: 'https://api.example.com',
  timeout: 5000
} satisfies Config;
```

---

### TypeScript 5.2 (Palier 12)
- `using` keyword (explicit resource management)

```typescript
using file = openFile('data.txt');
// file est automatiquement fermé à la fin du scope
```

---

## ⚙️ Configuration TypeScript

### tsconfig.json Évolution

#### Angular 5 (TypeScript 2.5)
```json
{
  "compilerOptions": {
    "target": "es5",
    "module": "es2015",
    "lib": ["es2017", "dom"],
    "strict": false,
    "noImplicitAny": false
  }
}
```

#### Angular 9 (TypeScript 3.8)
```json
{
  "compilerOptions": {
    "target": "es2015",
    "module": "es2020",
    "lib": ["es2018", "dom"],
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

#### Angular 20 (TypeScript 5.6)
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2023", "dom"],
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "useDefineForClassFields": true
  }
}
```

---

## 🛠️ Stratégie de Migration

### 1. Activer `strict` Progressivement

#### Palier 4-6 : Activer les flags de base
```json
{
  "compilerOptions": {
    "strict": false,
    "noImplicitAny": true,
    "strictNullChecks": false
  }
}
```

#### Palier 7-9 : Activer strictNullChecks
```json
{
  "compilerOptions": {
    "strict": false,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

#### Palier 10+ : Activer strict complet
```json
{
  "compilerOptions": {
    "strict": true
  }
}
```

---

### 2. Fixer les Erreurs par Catégorie

#### Erreur : "Type 'null' is not assignable"
```typescript
// AVANT
let name: string = null; // Erreur avec strictNullChecks

// APRÈS
let name: string | null = null;
```

#### Erreur : "Object is possibly 'undefined'"
```typescript
// AVANT
function getName(user: User) {
  return user.name.toUpperCase(); // Erreur si name peut être undefined
}

// APRÈS
function getName(user: User) {
  return user.name?.toUpperCase() ?? 'UNKNOWN';
}
```

#### Erreur : "Parameter 'x' implicitly has an 'any' type"
```typescript
// AVANT
function process(data) { // Erreur avec noImplicitAny
  return data.value;
}

// APRÈS
function process(data: { value: string }) {
  return data.value;
}
```

---

## 📊 Vérification des Erreurs

### Compiler sans Émettre
```bash
# Vérifier les erreurs TypeScript sans générer de fichiers
tsc --noEmit

# Avec un tsconfig spécifique
tsc --noEmit -p tsconfig.json
```

### Compter les Erreurs
```bash
# Compter les erreurs
tsc --noEmit | grep "error TS" | wc -l
```

---

## ⚠️ Problèmes Courants

### Problème 1 : Trop d'erreurs après activation de strict
**Solution** : Activer les flags progressivement, pas tous en même temps.

### Problème 2 : Bibliothèques tierces sans types
**Solution** :
```bash
# Installer les types
npm install --save-dev @types/library-name

# Ou créer un fichier de déclaration
// src/typings.d.ts
declare module 'library-name';
```

### Problème 3 : Erreurs dans node_modules
**Solution** :
```json
{
  "compilerOptions": {
    "skipLibCheck": true
  }
}
```

---

## ✅ Checklist par Palier

### Palier 1-3 (TypeScript 2.5 → 3.4)
- [ ] TypeScript mis à jour
- [ ] Compilation réussie
- [ ] Aucune erreur bloquante

### Palier 4-6 (TypeScript 3.4 → 4.0)
- [ ] TypeScript mis à jour
- [ ] `noImplicitAny: true` activé
- [ ] Erreurs fixées
- [ ] Compilation réussie

### Palier 7-9 (TypeScript 4.0 → 4.6)
- [ ] TypeScript mis à jour
- [ ] `strictNullChecks: true` activé
- [ ] Erreurs fixées
- [ ] Compilation réussie

### Palier 10-12 (TypeScript 4.6 → 5.2)
- [ ] TypeScript mis à jour
- [ ] `strict: true` activé
- [ ] Erreurs fixées
- [ ] Compilation réussie

### Palier 13-15 (TypeScript 5.2 → 5.6)
- [ ] TypeScript mis à jour
- [ ] Compilation réussie
- [ ] Tous les flags strict activés

---

## 📚 Ressources

- [TypeScript Release Notes](https://www.typescriptlang.org/docs/handbook/release-notes/overview.html)
- [TypeScript Breaking Changes](https://github.com/microsoft/TypeScript/wiki/Breaking-Changes)
- [Angular TypeScript Compatibility](https://angular.io/guide/versions)

---

## 🎯 Objectif Final

TypeScript 5.6 avec configuration stricte complète :
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2023", "dom"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "useDefineForClassFields": true
  }
}
```
