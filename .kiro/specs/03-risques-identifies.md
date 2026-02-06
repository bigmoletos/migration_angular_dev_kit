# Risques Identifiés - Migration Angular 5 → 20

**Date** : 2026-02-03  
**Criticité** : 🔴 Critique | 🟠 Élevée | 🟡 Moyenne | 🟢 Faible

---

## 🔴 Risques Critiques

### 1. Dépendance Circulaire pwc-ui ↔ pwc-ui-shared
**Impact** : Bloquant  
**Probabilité** : Élevée

**Description** :
- `pwc-ui` dépend de `@pwc/shared@2.6.23`
- Si `pwc-ui-shared` est migré mais pas publié, `pwc-ui` ne peut pas être testé

**Mitigation** :
1. Utiliser `npm link` pour tester localement avant publication
2. Publier `pwc-ui-shared` sur Nexus après chaque palier validé
3. Mettre à jour `pwc-ui` immédiatement après publication

**Actions** :
```bash
# Dans pwc-ui-shared après migration d'un palier
npm run build
npm publish

# Dans pwc-ui
npm update @pwc/shared
npm install
```

---

### 2. Migration RxJS 5 → 6 (Palier 1)
**Impact** : Bloquant  
**Probabilité** : Certaine

**Description** :
- 2816 composants utilisent RxJS
- Changement de tous les opérateurs : `.map()` → `pipe(map())`
- Imports changent : `rxjs/add/operator/map` → `rxjs/operators`

**Patterns à migrer** :
```typescript
// AVANT (RxJS 5)
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';

observable
  .map(x => x * 2)
  .filter(x => x > 10)
  .catch(err => Observable.of(null));

// APRÈS (RxJS 6)
import { map, filter, catchError } from 'rxjs/operators';
import { of } from 'rxjs';

observable.pipe(
  map(x => x * 2),
  filter(x => x > 10),
  catchError(err => of(null))
);
```

**Mitigation** :
1. Installer `rxjs-compat` temporairement (compatibilité RxJS 5/6)
2. Utiliser codemod officiel : `rxjs-5-to-6-migrate`
3. Migrer par modules (pas tout d'un coup)
4. Tests unitaires après chaque module migré
5. Retirer `rxjs-compat` au Palier 2

**Codemod disponible** :
```bash
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json
```

---

### 3. Migration Ivy (Palier 4 : Angular 8 → 9)
**Impact** : Bloquant  
**Probabilité** : Certaine

**Description** :
- Ivy change complètement le moteur de rendu
- View Engine déprécié
- Comportements subtils peuvent changer
- `entryComponents` devient obsolète
- `ModuleWithProviders` doit être typé

**Breaking changes** :
```typescript
// AVANT
@NgModule({
  entryComponents: [MyDialogComponent] // Obsolète avec Ivy
})

static forRoot(): ModuleWithProviders { // Erreur TypeScript
  return { ngModule: MyModule };
}

// APRÈS
@NgModule({
  // entryComponents supprimé (Ivy le détecte automatiquement)
})

static forRoot(): ModuleWithProviders<MyModule> { // Typé
  return { ngModule: MyModule };
}
```

**Mitigation** :
1. Activer Ivy progressivement (d'abord en mode test)
2. Utiliser `ng update @angular/core --migrate-only` pour migrations automatiques
3. Tests approfondis (Ivy peut changer le rendu)
4. Vérifier les composants dynamiques
5. Codemod : `scripts_outils_ia/codemods/migrate-module-with-providers.js`

---

### 4. Webpack Custom (pwc-ui uniquement)
**Impact** : Bloquant pour pwc-ui  
**Probabilité** : Élevée

**Description** :
- `pwc-ui` utilise `webpack.dev.config.js` et `webpack.prod.config.js`
- Angular CLI 12+ impose Webpack 5
- Configurations custom peuvent être incompatibles

**Fichiers concernés** :
- `webpack.dev.config.js`
- `webpack.prod.config.js`
- `@ngtools/webpack@1.10.2` (très ancien)

**Mitigation** :
1. Migrer vers Angular CLI natif (recommandé)
2. OU adapter les configs pour Webpack 5
3. Tester le build après chaque palier
4. Documenter les changements de config

**Alternative** :
```bash
# Migrer vers angular.json (CLI natif)
ng update @angular/cli --migrate-only --from=1 --to=12
```

---

## 🟠 Risques Élevés

### 5. Bibliothèques Tierces Obsolètes
**Impact** : Bloquant partiel  
**Probabilité** : Élevée

**Bibliothèques à risque** :

| Bibliothèque | Version Actuelle | Compatible Angular 20 ? | Action |
|--------------|------------------|-------------------------|--------|
| `primeng` | 5.2.4 | ❌ Non (v18+ requis) | Migrer progressivement |
| `angular-tree-component` | 7.0.2 | ⚠️ À vérifier | Tester ou remplacer |
| `ng-block-ui` | 2.0.0 | ⚠️ À vérifier | Tester ou remplacer |
| `ng2-codemirror` | 1.1.3 | ❌ Non (Angular 2) | Remplacer par `ngx-codemirror` |
| `angular2-markdown` | 2.2.3 | ❌ Non (Angular 2) | Remplacer par `ngx-markdown` |
| `@ngrx/store` | 4.1.1 | ❌ Non (v18+ requis) | Migrer progressivement |

**Mitigation** :
1. Identifier les alternatives modernes
2. Migrer les bibliothèques en parallèle des paliers Angular
3. Créer des wrappers pour isoler les dépendances
4. Tests de régression après chaque remplacement

**Plan de migration bibliothèques** :
- **Palier 1-3** : Mettre à jour PrimeNG, NgRx
- **Palier 7-9** : Remplacer `ng2-*` par `ngx-*`
- **Palier 10+** : Vérifier compatibilité finale

---

### 6. Tests Unitaires (2816 composants)
**Impact** : Bloquant qualité  
**Probabilité** : Certaine

**Description** :
- Karma/Jasmine peuvent nécessiter des mises à jour
- Tests peuvent casser à cause de changements Ivy
- `TestBed` change entre versions

**Mitigation** :
1. Exécuter tests après chaque palier
2. Fixer les tests cassés avant de continuer
3. Considérer migration vers Jest (optionnel, plus rapide)
4. Utiliser `ng test --code-coverage` pour vérifier la couverture

---

### 7. TypeScript : 2.5 → 5.6 (10 versions)
**Impact** : Bloquant compilation  
**Probabilité** : Certaine

**Breaking changes TypeScript** :
- **3.0** : `unknown` type, tuples optionnels
- **3.7** : Optional chaining (`?.`), nullish coalescing (`??`)
- **4.0** : Variadic tuple types
- **4.1** : Template literal types
- **4.4** : Control flow analysis amélioré
- **5.0** : Decorators standard
- **5.2** : `using` keyword

**Mitigation** :
1. Mettre à jour TypeScript progressivement (suit Angular)
2. Activer `strict: true` progressivement
3. Fixer les erreurs de compilation à chaque palier
4. Utiliser `tsc --noEmit` pour vérifier sans compiler

---

## 🟡 Risques Moyens

### 8. Node.js : v10 → v20
**Impact** : Environnement  
**Probabilité** : Certaine

**Description** :
- Node.js v10 est EOL (End of Life)
- Angular 20 requiert Node.js v20+

**Plan de migration Node.js** :
- **Palier 1-4** : Node.js v10-v12
- **Palier 5-7** : Node.js v12-v14
- **Palier 8-10** : Node.js v14-v16
- **Palier 11-13** : Node.js v16-v18
- **Palier 14-15** : Node.js v18-v20

**Mitigation** :
1. Utiliser `nvm` (Node Version Manager) pour gérer les versions
2. Tester le build avec chaque nouvelle version Node.js
3. Mettre à jour les scripts CI/CD

```bash
# Installer nvm (Windows)
# https://github.com/coreybutler/nvm-windows

nvm install 20
nvm use 20
```

---

### 9. Gradle Build (Backend ?)
**Impact** : Intégration  
**Probabilité** : Moyenne

**Description** :
- `build.gradle` présent dans les deux repos
- Peut être lié à un backend Java
- Peut nécessiter des ajustements

**Mitigation** :
1. Identifier le rôle de Gradle
2. Tester le build Gradle après chaque palier
3. Adapter les scripts si nécessaire

---

### 10. Nexus Registry Custom
**Impact** : Publication  
**Probabilité** : Moyenne

**Description** :
- `pwc-ui-shared` publie sur `https://nexus.pwcv4.com/repository/npm-private/`
- Authentification requise
- Peut nécessiter des ajustements

**Mitigation** :
1. Vérifier les credentials Nexus
2. Tester la publication après chaque palier
3. Documenter le processus de publication

---

## 🟢 Risques Faibles

### 11. Zone.js : 0.8 → 0.14
**Impact** : Faible (géré par Angular)  
**Probabilité** : Faible

**Description** :
- Zone.js est mis à jour automatiquement avec Angular
- Peu de breaking changes

**Mitigation** :
- Suivre les mises à jour Angular

---

### 12. Polyfills (core-js)
**Impact** : Faible  
**Probabilité** : Faible

**Description** :
- `core-js@2.5.5` est ancien
- Angular 12+ gère mieux les polyfills

**Mitigation** :
1. Mettre à jour `core-js` si nécessaire
2. Vérifier `polyfills.ts` après chaque palier

---

## 📊 Matrice des Risques

| Risque | Criticité | Probabilité | Impact | Palier Concerné |
|--------|-----------|-------------|--------|-----------------|
| Dépendance circulaire | 🔴 | Élevée | Bloquant | Tous |
| Migration RxJS | 🔴 | Certaine | Bloquant | 1-2 |
| Migration Ivy | 🔴 | Certaine | Bloquant | 4 |
| Webpack custom | 🔴 | Élevée | Bloquant | 7 |
| Bibliothèques tierces | 🟠 | Élevée | Partiel | 1-10 |
| Tests unitaires | 🟠 | Certaine | Qualité | Tous |
| TypeScript | 🟠 | Certaine | Compilation | Tous |
| Node.js | 🟡 | Certaine | Environnement | Tous |
| Gradle | 🟡 | Moyenne | Intégration | Tous |
| Nexus | 🟡 | Moyenne | Publication | Tous |
| Zone.js | 🟢 | Faible | Faible | Tous |
| Polyfills | 🟢 | Faible | Faible | Tous |

---

## ✅ Plan de Mitigation Global

### Avant de Commencer
1. ✅ Backup complet des repos
2. ✅ Créer une branche `migration-angular-20`
3. ✅ Configurer Git tags pour chaque palier
4. ✅ Documenter l'état actuel (fait)
5. ✅ Préparer les codemods

### Pendant la Migration
1. ✅ Suivre l'ordre : `pwc-ui-shared` → `pwc-ui`
2. ✅ Valider chaque palier avant de continuer
3. ✅ Publier `pwc-ui-shared` après chaque palier
4. ✅ Exécuter tests unitaires systématiquement
5. ✅ Documenter les problèmes rencontrés

### Après Chaque Palier
1. ✅ Build réussi
2. ✅ Tests passent
3. ✅ Application démarre
4. ✅ Commit + Tag Git
5. ✅ Publication (si pwc-ui-shared)

### Rollback
Si un palier échoue :
1. `git reset --hard <tag-precedent>`
2. Analyser les erreurs
3. Ajuster la stratégie
4. Réessayer

---

## 🎯 Indicateurs de Succès

| Indicateur | Cible |
|------------|-------|
| Build réussi | 100% |
| Tests unitaires passent | >95% |
| Couverture de code | >80% |
| Temps de build | <10 min |
| Temps de tests | <5 min |
| Erreurs de compilation | 0 |
| Warnings critiques | 0 |

---

## 📞 Contacts & Ressources

### Documentation Officielle
- [Angular Update Guide](https://update.angular.io/)
- [RxJS Migration Guide](https://rxjs.dev/guide/v6/migration)
- [Ivy Migration Guide](https://angular.io/guide/ivy)

### Outils
- `ng update` (migrations automatiques)
- `rxjs-5-to-6-migrate` (codemod RxJS)
- `scripts_outils_ia/codemods/` (codemods custom)

### Support
- Équipe migration : À définir
- Slack/Teams : À définir
