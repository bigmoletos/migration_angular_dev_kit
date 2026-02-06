---
inclusion: always
priority: 100
---

# Résumé Exécutif - Migration Angular 5 → 20

**Date** : 2026-02-03  
**Workspace** : `repo_hps`  
**Statut** : ✅ Initialisation complète

---

## 📊 État Actuel

### Versions Détectées

| Repo | Angular | RxJS | TypeScript | Node.js | Composants |
|------|---------|------|------------|---------|------------|
| **pwc-ui-shared** | 5.2.0 | 5.5.6 | 2.6.2 | v10 | 447 |
| **pwc-ui** | 5.2.10 | 5.5.6 | 2.5.3 | v10 | 2369 |
| **TOTAL** | - | - | - | - | **2816** |

### Complexité
- **Services** : 160
- **Modules** : 690
- **Complexité globale** : Très Élevée

---

## 🎯 Objectif

Migrer vers **Angular 20** avec :
- TypeScript 5.6+
- RxJS 7.8+
- Node.js v20+
- Standalone Components (optionnel)
- Signals (optionnel)

---

## 📋 Plan de Migration

### Stratégie
Migration incrémentale par **15 paliers** (5→6→7→...→20)

### Durée Estimée
**8-12 semaines**

### Ordre Impératif
```
pwc-ui-shared (lib) → pwc-ui (client)
   MIGRER AVANT          MIGRER APRÈS
```

---

## 🚀 Paliers Critiques

| Palier | Versions | Complexité | Durée | Raison |
|--------|----------|------------|-------|--------|
| **1** | 5→6 | 🔴 Élevée | 1-2 sem | Migration RxJS 5→6 (bloquant) |
| **4** | 8→9 | 🔴 Très Élevée | 2 sem | Migration Ivy (changement architectural) |
| **7** | 11→12 | 🟠 Moyenne | 1 sem | Webpack 5 (impact build custom) |
| **11** | 15→16 | 🟠 Élevée | 1-2 sem | Signals (nouveau paradigme) |
| **12** | 16→17 | 🟡 Moyenne | 1-2 sem | Control flow syntax (templates) |

---

## ⚠️ Risques Majeurs

### 🔴 Critiques
1. **Dépendance circulaire** : `pwc-ui` dépend de `@pwc/shared@2.6.23`
   - **Mitigation** : Publier `pwc-ui-shared` sur Nexus après chaque palier

2. **Migration RxJS 5→6** (Palier 1)
   - 2816 composants impactés
   - **Mitigation** : Utiliser `rxjs-compat` + codemod officiel

3. **Migration Ivy** (Palier 4)
   - Changement complet du moteur de rendu
   - **Mitigation** : Tests approfondis + migration progressive

4. **Webpack custom** (pwc-ui uniquement)
   - Configurations custom incompatibles avec Webpack 5
   - **Mitigation** : Migrer vers Angular CLI natif OU adapter configs

### 🟠 Élevés
- Bibliothèques tierces obsolètes (PrimeNG, NgRx, ng2-*)
- Tests unitaires (2816 composants à valider)
- TypeScript 2.5 → 5.6 (10 versions)

---

## 🛠️ Outils Disponibles

### Skills Kiro
- ✅ `angular-migration` (migration par paliers)
- ✅ `codemods-refactoring` (refactoring automatique)
- ✅ `strands-orchestration` (orchestration multi-agents)
- ✅ `validation-formelle` (validation types)
- ✅ `code-audit` (audit qualité/sécurité)
- ✅ `rxjs-patterns` (patterns RxJS modernes)

### Codemods
- `rxjs-5-to-6-migrate` (officiel)
- `scripts_outils_ia/codemods/migrate-rxjs.js`
- `scripts_outils_ia/codemods/add-static-flag.js`
- `scripts_outils_ia/codemods/migrate-module-with-providers.js`

### État Strands
- ✅ `.kiro/state/strands-state.json` (suivi de progression)
- Checkpoint initial : `pre-migration`

---

## 📂 Documents Générés

| Document | Description |
|----------|-------------|
| `00-resume-executif.md` | Ce document |
| `01-etat-actuel.md` | Versions détectées, dépendances, complexité |
| `02-plan-migration.md` | 15 paliers détaillés avec breaking changes |
| `03-risques-identifies.md` | Risques, mitigations, matrice |
| `.kiro/state/strands-state.json` | État Strands pour orchestration |

---

## ✅ Prochaines Étapes

### 1. Préparation (Avant de commencer)
```powershell
# Basculer vers Node.js v10 (Angular 5-8)
Use-Node10

# Vérifier la version
node --version  # Doit afficher v10.24.1
npm --version

# Backup complet
git checkout -b migration-angular-20
```

### 2. Palier 1 : Angular 5 → 6 (RxJS)
**Commencer par pwc-ui-shared** :
```powershell
# Basculer vers Node 10
Use-Node10

# Vérifier
node --version  # v10.24.1
npm --version

# Aller dans le repo
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Installer rxjs-compat
npm install rxjs-compat --save

# Mettre à jour Angular
ng update @angular/cli@6 @angular/core@6

# Migrer RxJS avec codemod
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Tests unitaires
npm test

# Build
npm run build

# 🚦 GATE PLAYWRIGHT (BLOQUANT) - Terminal 1
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Terminal 2 : Tests E2E
npm run test:e2e

# ✅ SI GATE VALIDÉ : Publier sur Nexus
npm publish
```

**🚦 IMPORTANT** : Les tests Playwright doivent passer à 100% avant de passer à pwc-ui.

**Puis pwc-ui (Seulement si Gate Validé)** :
```powershell
# Basculer vers Node 10
Use-Node10

# Aller dans le repo
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia

# Mettre à jour @pwc/shared
npm update @pwc/shared
npm install

# Installer rxjs-compat
npm install rxjs-compat --save

# Mettre à jour Angular
ng update @angular/cli@6 @angular/core@6

# Migrer RxJS
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Tests
npm test

# Build
npm run build

# Lancer l'app UI sur port 4200
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat
```

### 3. Validation Palier 1

#### pwc-ui-shared
- [ ] Build réussi
- [ ] Tests unitaires passent (>95%)
- [ ] 🚦 **Tests Playwright passent (100% - BLOQUANT)**
- [ ] Publication Nexus OK

#### pwc-ui (Après Gate Validé)
- [ ] Build réussi
- [ ] Tests unitaires passent
- [ ] Application démarre sur port 4200
- [ ] Build réussi (pwc-ui)
- [ ] Tests passent (pwc-ui)
- [ ] Application démarre sans erreurs
- [ ] Commit + Tag Git : `git tag palier-1-angular-6`

### 4. Continuer avec Palier 2
Voir `02-plan-migration.md` pour les détails.

---

## 🎯 Commandes Utiles

### Vérifier l'état
```powershell
# Basculer vers la bonne version Node
Use-Node10  # Pour Angular 5-8

# Vérifier les versions
node --version
npm --version
ng version

# Tests
npm test

# Build
npm run build

# Audit dépendances
npm audit
```

### Strands (orchestration)
```bash
# Charger le skill strands-orchestration
#strands-orchestration

# Vérifier l'état
cat .kiro/state/strands-state.json
```

### Rollback si problème
```bash
git reset --hard palier-0-angular-5
```

---

## 📞 Support

### Documentation
- [Angular Update Guide](https://update.angular.io/)
- [RxJS Migration Guide](https://rxjs.dev/guide/v6/migration)
- [Ivy Migration Guide](https://angular.io/guide/ivy)

### Skills Kiro
- `#angular-migration` : Migration Angular
- `#codemods-refactoring` : Refactoring automatique
- `#strands-orchestration` : Orchestration multi-agents
- `#code-audit` : Audit qualité/sécurité

---

## 📈 Indicateurs de Succès

| Indicateur | Cible | Actuel |
|------------|-------|--------|
| Paliers complétés | 15/15 | 0/15 |
| Build réussi | 100% | - |
| Tests passent | >95% | - |
| Couverture code | >80% | - |
| Temps build | <10 min | - |
| Temps tests | <5 min | - |

---

## 🎉 Félicitations !

L'initialisation est complète. Vous disposez maintenant de :
- ✅ 6 skills Kiro configurés
- ✅ 4 agents spécialisés
- ✅ 4 codemods fonctionnels
- ✅ État Strands initialisé
- ✅ Plan de migration détaillé (15 paliers)
- ✅ Risques identifiés et mitigations
- ✅ Documentation complète

**Prêt à commencer le Palier 1 !** 🚀
