# Design - Plan de Migration Angular 5 → 20

## Approche Technique

### Stratégie Globale

**Migration incrémentale par paliers** : Chaque version majeure Angular est un palier distinct, permettant de valider progressivement les changements et de limiter les risques.

### Architecture de Migration

```
Palier N (pwc-ui-shared)
    ↓
Validation (Build + Tests + Playwright Gate)
    ↓
Publication Nexus
    ↓
Palier N (pwc-ui)
    ↓
Validation (Build + Tests + App démarre)
    ↓
Palier N+1
```

## Décisions Techniques

### DT-1 : 15 Paliers Incrémentaux
**Décision** : Migrer version par version (5→6→7→...→20)  
**Justification** : Minimise les risques, facilite le debug, permet des rollbacks ciblés  
**Alternative rejetée** : Migration directe 5→20 (trop risqué)

### DT-2 : Ordre pwc-ui-shared → pwc-ui
**Décision** : Toujours migrer la bibliothèque avant l'application  
**Justification** : pwc-ui dépend de @pwc/shared, donc Shared doit être compatible en premier  
**Contrainte** : Publication Nexus obligatoire après chaque palier Shared

### DT-3 : Gate Playwright Bloquant
**Décision** : Tests E2E Playwright obligatoires à 100% pour pwc-ui-shared avant de passer à pwc-ui  
**Justification** : Garantit que la bibliothèque fonctionne correctement avant de migrer l'application  
**Implémentation** : Voir `.kiro/specs/10-workflow-tests-playwright.md`

### DT-4 : Utilisation de rxjs-compat (Palier 1)
**Décision** : Installer rxjs-compat temporairement pour le Palier 1  
**Justification** : Permet une migration progressive de RxJS 5→6  
**Retrait** : Palier 2 (Angular 6→7)

### DT-5 : Migration Ivy Progressive (Palier 4)
**Décision** : Activer Ivy au Palier 4 (Angular 8→9)  
**Justification** : Ivy devient le moteur par défaut, View Engine sera supprimé  
**Risque** : Changement architectural majeur, tests approfondis requis

### DT-6 : Webpack 5 (Palier 7)
**Décision** : Migrer vers Webpack 5 au Palier 7 (Angular 11→12)  
**Justification** : Webpack 5 devient le défaut, améliore les performances  
**Impact** : Adapter webpack.dev.config.js et webpack.prod.config.js pour pwc-ui

### DT-7 : Signals Optionnels (Palier 11)
**Décision** : Introduire Signals au Palier 11 (Angular 15→16) de manière optionnelle  
**Justification** : Nouveau paradigme de réactivité, coexiste avec RxJS  
**Recommandation** : Utiliser pour nouveaux composants uniquement

### DT-8 : Control Flow Syntax (Palier 12)
**Décision** : Migrer vers la nouvelle syntaxe @if/@for/@switch au Palier 12 (Angular 16→17)  
**Justification** : Syntaxe plus moderne et performante  
**Outil** : Codemod officiel `ng generate @angular/core:control-flow`

## Structure des Paliers

Chaque palier suit cette structure :

### Informations Générales
- Versions Angular (source → cible)
- Durée estimée
- Complexité (Faible/Moyenne/Élevée/Très Élevée)
- Versions Node.js compatibles

### Breaking Changes
Liste des changements incompatibles majeurs

### Actions pwc-ui-shared
1. Commandes ng update
2. Migrations spécifiques
3. Codemods à appliquer
4. Tests unitaires
5. Gate Playwright (bloquant)
6. Publication Nexus

### Actions pwc-ui
1. Mise à jour @pwc/shared
2. Commandes ng update
3. Adaptations webpack (si nécessaire)
4. Tests unitaires
5. Validation application

### Codemods
Liste des codemods disponibles (officiels ou custom)

## Paliers Critiques

### Palier 1 (5→6) : Migration RxJS
**Criticité** : 🔴 Très Élevée  
**Raison** : 2816 composants impactés, changement complet des imports RxJS  
**Mitigation** : rxjs-compat + codemod officiel `rxjs-5-to-6-migrate`

### Palier 4 (8→9) : Migration Ivy
**Criticité** : 🔴 Très Élevée  
**Raison** : Changement complet du moteur de rendu Angular  
**Mitigation** : Tests approfondis, migration progressive, codemod officiel

### Palier 7 (11→12) : Webpack 5
**Criticité** : 🟠 Moyenne  
**Raison** : Impact sur les configurations webpack custom de pwc-ui  
**Mitigation** : Adapter les configs ou migrer vers Angular CLI natif

### Palier 11 (15→16) : Signals
**Criticité** : 🟠 Élevée  
**Raison** : Nouveau paradigme de réactivité  
**Mitigation** : Introduction progressive, coexistence avec RxJS

### Palier 12 (16→17) : Control Flow
**Criticité** : 🟡 Moyenne  
**Raison** : Nouvelle syntaxe de templates  
**Mitigation** : Codemod officiel, migration automatique disponible

## Validation par Palier

### Phase 1 : pwc-ui-shared

1. **Build** : `npm run build` → Succès obligatoire
2. **Tests unitaires** : `npm test` → >95% passent
3. **🚦 Gate Playwright** (BLOQUANT) :
   - Lancer app sur port 4201
   - Exécuter `npm run test:e2e`
   - 100% des tests doivent passer
4. **Publication** : `npm publish` sur Nexus
5. **Tag Git** : `git tag palier-N-shared-angular-X`

### Phase 2 : pwc-ui (Après Gate Validé)

1. **Mise à jour** : `npm update @pwc/shared`
2. **Build** : `npm run build` → Succès obligatoire
3. **Tests unitaires** : `npm test` → >95% passent
4. **Application** : Démarrage sur port 4200 sans erreurs
5. **Tests manuels** : Fonctionnalités critiques validées
6. **Tag Git** : `git tag palier-N-ui-angular-X`

## Outils et Ressources

### Codemods Disponibles
- `rxjs-5-to-6-migrate` (officiel RxJS)
- `scripts_outils_ia/codemods/migrate-rxjs.js` (custom)
- `scripts_outils_ia/codemods/add-static-flag.js` (custom)
- `scripts_outils_ia/codemods/migrate-module-with-providers.js` (custom)
- `ng generate @angular/core:control-flow` (officiel Angular)

### Scripts PowerShell
- `Use-Node10`, `Use-Node12`, `Use-Node14`, `Use-Node16`, `Use-Node18`, `Use-Node20`, `Use-Node22`
- `check-stack.ps1` : Vérification de la stack
- `start-pwc-ui-shared-4201.bat` : Lancer Shared sur port 4201
- `start-pwc-ui.bat` : Lancer UI sur port 4200

### Documentation
- `.kiro/steering/02-migration-angular-rules.md` : Règles de migration
- `.kiro/steering/03-rxjs-migration-patterns.md` : Patterns RxJS
- `.kiro/steering/04-ivy-migration-guide.md` : Guide Ivy
- `.kiro/steering/05-webpack-custom-migration.md` : Migration Webpack
- `.kiro/steering/09-version-management.md` : Gestion versions Node.js
- `.kiro/specs/10-workflow-tests-playwright.md` : Workflow Playwright

## Matrice Récapitulative

| Palier | Versions | Durée | Complexité | Node.js | Criticité |
|--------|----------|-------|------------|---------|-----------|
| 1 | 5→6 | 1-2 sem | Élevée | v10 | 🔴 RxJS |
| 2 | 6→7 | 1 sem | Moyenne | v10-v12 | 🟢 |
| 3 | 7→8 | 1 sem | Moyenne | v12 | 🟢 |
| 4 | 8→9 | 2 sem | Très Élevée | v12-v14 | 🔴 Ivy |
| 5 | 9→10 | 1 sem | Faible | v12-v14 | 🟢 |
| 6 | 10→11 | 1 sem | Faible | v12-v14 | 🟢 |
| 7 | 11→12 | 1 sem | Moyenne | v12-v16 | 🟠 Webpack 5 |
| 8 | 12→13 | 1 sem | Faible | v12-v16 | 🟢 |
| 9 | 13→14 | 1 sem | Faible | v14-v18 | 🟢 |
| 10 | 14→15 | 1-2 sem | Moyenne | v14-v18 | 🟢 |
| 11 | 15→16 | 1-2 sem | Élevée | v16-v18 | 🟠 Signals |
| 12 | 16→17 | 1-2 sem | Moyenne | v18-v20 | 🟡 Control Flow |
| 13 | 17→18 | 1 sem | Faible | v18-v20 | 🟢 |
| 14 | 18→19 | 1 sem | Faible | v18-v20 | 🟢 |
| 15 | 19→20 | 1 sem | Faible | v20+ | 🟢 |

**Durée totale estimée** : 8-12 semaines

## Risques et Mitigations

Voir `.kiro/specs/03-risques-identifies.md` pour la liste complète des risques par palier.

## Évolutions Futures

- **Standalone Components** : Migration progressive à partir du Palier 10
- **Zoneless Change Detection** : Expérimental au Palier 13, production au Palier 15
- **Signals** : Adoption progressive à partir du Palier 11
