---
inclusion: always
priority: 99
---

# Plan de Migration Angular 5 → 20

**Stratégie** : Migration incrémentale par paliers  
**Durée estimée** : 10-14 semaines (incluant Palier 0)  
**Ordre** : `pwc-ui-shared` → `pwc-ui`

---

## 🎯 Paliers de Migration

### Palier 0 : Validation Infrastructure & Gate Playwright (PRÉPARATOIRE)
**Durée** : 2 semaines  
**Node.js** : v10 (pour tests sur Angular 5 actuel)

#### Objectif
Valider que l'infrastructure de migration est opérationnelle et mettre en place le gate Playwright **AVANT** de commencer les migrations Angular.

#### Actions Principales
1. **Gate Playwright** :
   - Installer Playwright dans pwc-ui-shared
   - Créer tests E2E pour l'écran demo (port 4201)
   - Valider que les tests passent sur Angular 5 actuel
   - Établir le gate bloquant à 100% de tests passants

2. **Validation Infrastructure** :
   - Tester les codemods (RxJS, ModuleWithProviders)
   - Analyser webpack.config (pwc-ui)
   - Identifier les dépendances obsolètes
   - Créer la matrice de criticité des composants
   - Documenter la stratégie de rollback
   - Dry-run du Palier 1

#### Critères de Succès
- [ ] Playwright installé et configuré
- [ ] 3 fichiers de tests E2E créés et passants
- [ ] Gate validé : 100% des tests Playwright passent
- [ ] Codemods testés et documentés
- [ ] Webpack analysé
- [ ] Stratégie de rollback documentée
- [ ] Dry-run Palier 1 effectué

#### Spec Détaillée
Voir `.kiro/specs/00-palier-00-validation-infrastructure/`

---

### Palier 1 : Angular 5.2 → 6.1 (LTS)
**Durée** : 1-2 semaines  
**Node.js** : v10 (compatible)

#### Breaking Changes Majeurs
- `@angular/http` → `@angular/common/http`
- RxJS 5.5 → RxJS 6.0 (opérateurs pipeable)
- `rxjs-compat` requis temporairement

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@6 @angular/core@6`
   - Installer `rxjs-compat`
   - Migrer les imports RxJS avec codemod
   - Tests unitaires

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared` vers nouvelle version
   - `ng update @angular/cli@6 @angular/core@6`
   - Installer `rxjs-compat`
   - Adapter webpack.config si nécessaire

#### Codemods Disponibles
- `rxjs-5-to-6-migrate` (officiel)
- `scripts_outils_ia/codemods/migrate-rxjs.js`

---

### Palier 2 : Angular 6.1 → 7.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v10-v12

#### Breaking Changes
- `@angular/http` complètement supprimé
- Retirer `rxjs-compat`
- Virtual scrolling et drag-and-drop natifs

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@7 @angular/core@7`
   - Supprimer `rxjs-compat`
   - Vérifier tous les imports RxJS
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@7 @angular/core@7`
   - Supprimer `rxjs-compat`

---

### Palier 3 : Angular 7.2 → 8.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v12

#### Breaking Changes
- Ivy preview (optionnel)
- Differential loading (ES5 + ES2015)
- `@ViewChild` et `@ContentChild` nécessitent `{ static: true/false }`

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@8 @angular/core@8`
   - Ajouter `static` aux `@ViewChild`/`@ContentChild`
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@8 @angular/core@8`
   - Ajouter `static` aux queries

#### Codemod
- `scripts_outils_ia/codemods/add-static-flag.js`

---

### Palier 4 : Angular 8.2 → 9.1 (LTS)
**Durée** : 2 semaines  
**Node.js** : v12-v14

#### Breaking Changes MAJEURS
- **Ivy devient le moteur par défaut** (View Engine déprécié)
- Changements dans le système de modules
- `ModuleWithProviders<T>` requis
- `entryComponents` obsolète

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@9 @angular/core@9`
   - Activer Ivy : `"enableIvy": true` dans tsconfig
   - Typer `ModuleWithProviders<T>`
   - Retirer `entryComponents`
   - Tests approfondis (Ivy change le rendu)

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@9 @angular/core@9`
   - Activer Ivy
   - Adapter webpack si conflits

#### Codemods
- `scripts_outils_ia/codemods/migrate-module-with-providers.js`
- Migration Ivy officielle : `ng update @angular/core --migrate-only`

---

### Palier 5 : Angular 9.1 → 10.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v12-v14

#### Breaking Changes
- TypeScript 3.9+ requis
- Warnings sur les imports CommonJS

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@10 @angular/core@10`
   - Mettre à jour TypeScript → 3.9
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@10 @angular/core@10`

---

### Palier 6 : Angular 10.2 → 11.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v12-v14

#### Breaking Changes
- TypeScript 4.0+ requis
- Webpack 5 (optionnel)

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@11 @angular/core@11`
   - Mettre à jour TypeScript → 4.0
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@11 @angular/core@11`

---

### Palier 7 : Angular 11.2 → 12.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v12-v16

#### Breaking Changes
- Webpack 5 par défaut
- View Engine complètement supprimé
- Nullish coalescing dans templates

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@12 @angular/core@12`
   - Migrer vers Webpack 5
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@12 @angular/core@12`
   - Adapter webpack.config pour Webpack 5

---

### Palier 8 : Angular 12.2 → 13.3 (LTS)
**Durée** : 1 semaine  
**Node.js** : v12-v16

#### Breaking Changes
- TypeScript 4.4+ requis
- View Engine APIs supprimées
- `@angular/platform-server` changes

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@13 @angular/core@13`
   - Mettre à jour TypeScript → 4.4
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@13 @angular/core@13`

---

### Palier 9 : Angular 13.3 → 14.3 (LTS)
**Durée** : 1 semaine  
**Node.js** : v14-v18

#### Breaking Changes
- TypeScript 4.6+ requis
- Typed Forms (optionnel mais recommandé)
- Standalone Components preview

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@14 @angular/core@14`
   - Mettre à jour TypeScript → 4.6
   - Considérer Typed Forms
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@14 @angular/core@14`

---

### Palier 10 : Angular 14.3 → 15.2 (LTS)
**Durée** : 1-2 semaines  
**Node.js** : v14-v18

#### Breaking Changes
- Standalone Components stables
- Directive composition API
- `@angular/router` guards fonctionnels

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@15 @angular/core@15`
   - Migrer vers Standalone Components (optionnel)
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@15 @angular/core@15`

---

### Palier 11 : Angular 15.2 → 16.2 (LTS)
**Durée** : 1-2 semaines  
**Node.js** : v16-v18

#### Breaking Changes MAJEURS
- **Signals** introduits (nouvelle réactivité)
- TypeScript 4.9+ requis
- `ngcc` supprimé (toutes les libs doivent être Ivy)

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@16 @angular/core@16`
   - Mettre à jour TypeScript → 4.9
   - Considérer Signals pour nouveaux composants
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@16 @angular/core@16`

---

### Palier 12 : Angular 16.2 → 17.3 (LTS)
**Durée** : 1-2 semaines  
**Node.js** : v18-v20

#### Breaking Changes
- TypeScript 5.2+ requis
- Signals matures
- Control flow syntax (`@if`, `@for`, `@switch`)
- Deferrable views (`@defer`)

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@17 @angular/core@17`
   - Mettre à jour TypeScript → 5.2
   - Migrer vers control flow syntax (optionnel)
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@17 @angular/core@17`

#### Codemods
- `ng generate @angular/core:control-flow` (migration automatique)

---

### Palier 13 : Angular 17.3 → 18.2 (LTS)
**Durée** : 1 semaine  
**Node.js** : v18-v20

#### Breaking Changes
- TypeScript 5.4+ requis
- Zoneless change detection (expérimental)

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@18 @angular/core@18`
   - Mettre à jour TypeScript → 5.4
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@18 @angular/core@18`

---

### Palier 14 : Angular 18.2 → 19.0 (LTS)
**Durée** : 1 semaine  
**Node.js** : v18-v20

#### Breaking Changes
- TypeScript 5.5+ requis
- Améliorations Signals et Zoneless

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@19 @angular/core@19`
   - Mettre à jour TypeScript → 5.5
   - Tests

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@19 @angular/core@19`

---

### Palier 15 : Angular 19.0 → 20.0 (ACTUEL)
**Durée** : 1 semaine  
**Node.js** : v20+

#### Breaking Changes
- TypeScript 5.6+ requis
- Dernières optimisations

#### Actions
1. **pwc-ui-shared** :
   - `ng update @angular/cli@20 @angular/core@20`
   - Mettre à jour TypeScript → 5.6
   - Tests finaux

2. **pwc-ui** :
   - Mettre à jour `@pwc/shared`
   - `ng update @angular/cli@20 @angular/core@20`
   - Tests d'intégration complets

---

## 📊 Résumé

| Palier | Versions | Durée | Complexité | Node.js |
|--------|----------|-------|------------|---------|
| 0 | Validation + Playwright | 2 sem | Élevée (Gate) | v10 |
| 1 | 5→6 | 1-2 sem | Élevée (RxJS) | v10 |
| 2 | 6→7 | 1 sem | Moyenne | v10-v12 |
| 3 | 7→8 | 1 sem | Moyenne | v12 |
| 4 | 8→9 | 2 sem | Très Élevée (Ivy) | v12-v14 |
| 5 | 9→10 | 1 sem | Faible | v12-v14 |
| 6 | 10→11 | 1 sem | Faible | v12-v14 |
| 7 | 11→12 | 1 sem | Moyenne (Webpack 5) | v12-v16 |
| 8 | 12→13 | 1 sem | Faible | v12-v16 |
| 9 | 13→14 | 1 sem | Faible | v14-v18 |
| 10 | 14→15 | 1-2 sem | Moyenne (Standalone) | v14-v18 |
| 11 | 15→16 | 1-2 sem | Élevée (Signals) | v16-v18 |
| 12 | 16→17 | 1-2 sem | Moyenne | v18-v20 |
| 13 | 17→18 | 1 sem | Faible | v18-v20 |
| 14 | 18→19 | 1 sem | Faible | v18-v20 |
| 15 | 19→20 | 1 sem | Faible | v20+ |
| **TOTAL** | **5→20** | **10-14 sem** | - | - |

---

## 🎯 Jalons Critiques

1. **Palier 0** : Gate Playwright + Validation Infrastructure (bloquant pour tout le reste)
2. **Palier 1** : Migration RxJS (bloquant pour tout le reste)
2. **Palier 4** : Migration Ivy (changement architectural majeur)
3. **Palier 7** : Webpack 5 (impact sur build custom de pwc-ui)
4. **Palier 11** : Signals (nouveau paradigme de réactivité)
5. **Palier 12** : Control flow syntax (changement de syntaxe templates)

---

## ✅ Validation à Chaque Palier

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

1. **Build réussi** (`npm run build`)
2. **Tests unitaires passent** (`npm test`) → Seuil >95%
3. **🚦 GATE PLAYWRIGHT (BLOQUANT)** :
   ```bash
   # Terminal 1 : Lancer Shared sur port 4201
   C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

   # Terminal 2 : Tests E2E
   npm run test:e2e
   ```
   - [ ] **100% des tests Playwright passent (OBLIGATOIRE)**
   - [ ] Page d'accueil charge en <5s
   - [ ] Aucune erreur console critique
   - [ ] Tous les composants visibles
4. **Publication Nexus** (optionnel)
5. **Commit Git avec tag**

**🚫 SI GATE ÉCHOUE** : NE PAS passer à pwc-ui, corriger Shared d'abord

### Phase 2 : pwc-ui (APRÈS Gate Validé)

1. **Mise à jour dépendance** pwc-ui-shared
2. **Build réussi** (`npm run build`)
3. **Tests unitaires passent** (`npm test`)
4. **Application démarre** :
   ```bash
   C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat
   ```
   - Vérifier http://localhost:4200
5. **Fonctionnalités critiques testées manuellement**
6. **Commit Git avec tag**

**Documentation complète** : `.kiro/specs/10-workflow-tests-playwright.md`
