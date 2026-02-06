# Design - Palier 0 : Validation Infrastructure

## Approche Technique

### Stratégie Globale

**Validation préventive** : Identifier et résoudre les problèmes AVANT de commencer la migration réelle.

### Architecture de Validation

```
Tâche 1: Gate Playwright
    ↓
Tâche 2: Test Codemods
    ↓
Tâche 3: Analyse Webpack
    ↓
Tâche 4: Libs Obsolètes
    ↓
Tâche 5: Matrice Criticité
    ↓
Tâche 6: Stratégie Rollback
    ↓
Tâche 7: Dry-Run Palier 1
    ↓
Validation Globale → GO/NO-GO Palier 1
```

## Décisions Techniques

### DT-1 : Playwright comme Gate Bloquant
**Décision** : Utiliser Playwright pour tests E2E de pwc-ui-shared  
**Justification** : Tests E2E garantissent que la bibliothèque fonctionne réellement  
**Configuration** : Port 4201, Chromium uniquement, 3 tests minimum

### DT-2 : Tests Codemods sur Fichiers Isolés
**Décision** : Tester les codemods sur des fichiers dans `.kiro/temp/`  
**Justification** : Évite de modifier le code source, permet des tests répétables  
**Codemods** : rxjs-5-to-6-migrate (officiel) + codemods custom

### DT-3 : Analyse Webpack Sans Modification
**Décision** : Analyser les configs webpack sans les modifier  
**Justification** : Évaluation uniquement, modifications au Palier 7  
**Livrables** : Rapport d'analyse + recommandation

### DT-4 : Stratégie Libs Obsolètes Par Palier
**Décision** : Assigner chaque lib obsolète à un palier spécifique  
**Justification** : Évite de tout migrer d'un coup, réduit les risques  
**Priorité** : Libs critiques en premier (PrimeNG, NgRx)

### DT-5 : Matrice Criticité 20/30/50
**Décision** : Classifier composants en 3 catégories (20% critiques, 30% importants, 50% secondaires)  
**Justification** : Priorisation des tests et corrections  
**Critères** : Fréquence d'utilisation, impact métier

### DT-6 : Rollback Git + Nexus + Snapshots
**Décision** : Documenter rollback Git, Nexus ET Snapshots  
**Justification** : Rollback complet nécessaire en cas de problème, snapshots pour fichiers individuels  
**Procédures** : Git reset + npm unpublish/republish + rollback-snapshot.ps1

### DT-7 : Dry-Run Non Destructif
**Décision** : Dry-run sur branche temporaire, rollback complet après  
**Justification** : Évaluation sans risque  
**Commande** : `ng update --dry-run` (ne modifie rien)

## Détails d'Implémentation

### Tâche 1 : Gate Playwright (3 jours)

**Installation** :
```bash
npm install -D @playwright/test@^1.40.0
npx playwright install chromium
```

**Configuration** : `playwright.config.ts`
- baseURL: http://localhost:4201
- timeout: 30s
- retries: 2
- workers: 1
- reporter: html + json + list

**Tests** :
1. `demo-home.spec.ts` : Titre, logo, menu, erreurs console
2. `demo-forms.spec.ts` : Composants form visibles et interactifs
3. `demo-navigation.spec.ts` : Navigation fonctionne (optionnel)

**Scripts npm** :
- `test:e2e` : Exécution normale
- `test:e2e:ui` : Mode UI (debug)
- `test:e2e:debug` : Mode debug
- `test:e2e:report` : Afficher rapport

### Tâche 2 : Test Codemods (1 jour)

**Fichiers de test** :
- `.kiro/temp/test-codemod-rxjs.ts` : Imports RxJS 5, opérateurs
- `.kiro/temp/test-codemod-module.ts` : ModuleWithProviders

**Codemods à tester** :
1. `rxjs-5-to-6-migrate` (officiel)
2. `scripts_outils_ia/codemods/rxjs-imports.js` (custom)
3. `scripts_outils_ia/codemods/module-with-providers.js` (custom)

**Rapport** : `.kiro/temp/rapport-test-codemods.md`
- Statut : ✅ Fonctionne / ❌ Échoue
- Cas testés
- Cas qui échouent
- Recommandation

### Tâche 3 : Analyse Webpack (1 jour)

**Fichiers à analyser** :
- `pwc-ui/webpack.dev.config.js`
- `pwc-ui/webpack.prod.config.js`

**Éléments à identifier** :
- Loaders (ts-loader, sass-loader, file-loader, url-loader)
- Plugins (HtmlWebpackPlugin, MiniCssExtractPlugin, etc.)
- Configurations custom

**Évaluation compatibilité Webpack 5** :
- file-loader → asset/resource
- url-loader → asset/inline
- Plugins compatibles ?

**Recommandation** :
- ✅ Migration Webpack 5 possible
- ⚠️ Migration avec ajustements
- ❌ Migration CLI natif recommandée

### Tâche 4 : Libs Obsolètes (1 jour)

**Commande** : `npm outdated`

**Libs à documenter** :
- primeng 5.2.4 → 17.x
- ng2-file-upload → ngx-file-upload
- angular2-text-mask → ngx-mask
- ng2-charts 1.6.0 → 4.x
- ng2-pdf-viewer 5.2.3 → 9.x
- @ngrx/store 4.1.1 → 18.x

**Document** : `.kiro/specs/11-deprecated-libraries-strategy.md`
- Version actuelle
- Dernière version
- Statut (obsolète/déprécié)
- Remplacement
- Stratégie (palier de migration)
- Risque

### Tâche 5 : Matrice Criticité (1 jour)

**Classification** :

**Critiques (20%)** - Doivent fonctionner à 100% :
- FormInputComponent, DateComponent, AmountComponent
- HttpService, AuthService
- DataTableComponent, AdvancedGridComponent
- LoginComponent, DashboardComponent

**Importants (30%)** - Doivent fonctionner à 95% :
- CheckboxComponent, RadioButtonComponent, ListboxComponent
- DateRangeComponent, AmountRangeComponent

**Secondaires (50%)** - Bugs temporaires acceptables :
- Composants spécifiques métier
- Indicateurs
- Composants rarement utilisés

**Document** : `.kiro/temp/matrice-criticite-composants.md`

### Tâche 6 : Stratégie Rollback (1 jour)

**Critères Go/No-Go** :
- ✅ Build réussi
- ✅ Tests >95%
- ✅ Gate Playwright 100%
- ✅ App démarre
- ✅ Composants critiques OK
- ✅ Aucune régression perf
- ✅ Aucun bug bloquant

**Procédure Rollback Git** :
```bash
git tag -l
git reset --hard palier-X-angular-Y
rm -rf node_modules package-lock.json
npm install
npm run build
npm test
```

**Procédure Rollback Snapshots** (fichiers individuels) :
```powershell
# Lister les modifications
.\scripts_outils_ia\list-modifications.ps1

# Rollback d'un fichier spécifique
.\scripts_outils_ia\rollback-snapshot.ps1 -ModificationId "mod-XXXXXX"

# Ou par fichier
.\scripts_outils_ia\rollback-snapshot.ps1 -File "package.json"
```

**Avantages du système de snapshots** :
- Fichiers restent propres (pas de commentaires)
- Rollback précis par fichier
- Traçabilité centralisée
- Compatible avec tous les formats (JSON, YAML, etc.)

**Procédure Rollback Nexus** :
```bash
npm unpublish @pwc/shared@X.Y.Z
# OU
npm version patch
npm publish
```

**Template Email** : Communication avec équipes clientes

**Document** : `.kiro/specs/12-rollback-strategy.md`

### Tâche 7 : Dry-Run Palier 1 (2 jours)

**Branche temporaire** :
```bash
git checkout -b test-palier-1-dry-run
git tag test-dry-run-start
```

**Dry-run** :
```bash
ng update @angular/cli@6 @angular/core@6 --dry-run
```

**Analyse** :
- Changements prévus (.angular-cli.json → angular.json, package.json)
- Problèmes potentiels
- Temps estimé ajusté

**Rollback** :
```bash
git reset --hard test-dry-run-start
git checkout dev_vibecoding
git branch -D test-palier-1-dry-run
```

**Rapport** : `.kiro/temp/rapport-dry-run-palier-1.md`

## Livrables

1. `pwc-ui-shared/playwright.config.ts`
2. `pwc-ui-shared/e2e/tests/*.spec.ts`
3. `.kiro/temp/rapport-test-codemods.md`
4. `.kiro/temp/analyse-webpack.md`
5. `.kiro/specs/11-deprecated-libraries-strategy.md`
6. `.kiro/temp/matrice-criticite-composants.md`
7. `.kiro/specs/12-rollback-strategy.md`
8. `.kiro/temp/rapport-dry-run-palier-1.md`

## Validation Globale

**SI TOUTES LES TÂCHES VALIDÉES** :
- ✅ Passer au Palier 1 avec confiance
- ✅ Estimations ajustées
- ✅ Risques identifiés et mitigés

**SI UNE TÂCHE ÉCHOUE** :
- ❌ Corriger avant de passer au Palier 1
- ❌ Ne pas commencer la migration sans validation complète

## Planning

**Semaine 1** :
- Lundi-Mercredi : Tâche 1 (Playwright)
- Jeudi : Tâche 2 (Codemods)
- Vendredi : Tâche 3 (Webpack)

**Semaine 2** :
- Lundi : Tâche 4 (Libs obsolètes)
- Mardi : Tâche 5 (Matrice criticité)
- Mercredi : Tâche 6 (Rollback)
- Jeudi-Vendredi : Tâche 7 (Dry-run)


---

## 🚦 Gate Playwright - Configuration Complète

> **Statut** : ✅ Configuré  
> **Date** : 2026-02-05  
> **Version** : 1.0.0

### Architecture des Tests E2E

```
┌─────────────────────────────────────────────────────────────┐
│                    GATE PLAYWRIGHT                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  pwc-ui-shared (Port 4201)                                  │
│  ├── playwright.config.ts                                   │
│  ├── e2e/tests/                                             │
│  │   ├── demo-home.spec.ts        (6 tests)                 │
│  │   ├── demo-forms.spec.ts       (5 tests)                 │
│  │   └── demo-navigation.spec.ts  (7 tests)                 │
│  └── Scripts: npm run test:e2e                              │
│                                                             │
│  🚦 GATE : 100% des tests DOIVENT passer                    │
│                                                             │
│  ✅ SI PASSÉ → Migrer pwc-ui                                │
│  ❌ SI ÉCHOUÉ → NE PAS migrer pwc-ui                        │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  pwc-ui (Port 4200)                                         │
│  ├── playwright.config.ts                                   │
│  ├── e2e/tests/                                             │
│  │   ├── app-home.spec.ts         (6 tests)                 │
│  │   ├── app-forms.spec.ts        (3 tests)                 │
│  │   └── app-navigation.spec.ts   (4 tests)                 │
│  └── Scripts: npm run test:e2e                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Fichiers Créés

#### pwc-ui-shared
- ✅ `playwright.config.ts` (existait déjà)
- ✅ `e2e/tests/demo-home.spec.ts` (amélioré)
- ✅ `e2e/tests/demo-forms.spec.ts` (amélioré)
- ✅ `e2e/tests/demo-navigation.spec.ts` (créé)
- ✅ Scripts npm ajoutés dans package.json

#### pwc-ui
- ✅ `playwright.config.ts` (créé)
- ✅ `e2e/tests/app-home.spec.ts` (créé)
- ✅ `e2e/tests/app-forms.spec.ts` (créé)
- ✅ `e2e/tests/app-navigation.spec.ts` (créé)
- ✅ Scripts npm ajoutés dans package.json

### Scripts Disponibles

```bash
# pwc-ui-shared
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm run test:e2e          # Exécuter les tests
npm run test:e2e:ui       # Mode UI interactif
npm run test:e2e:debug    # Mode debug
npm run test:e2e:report   # Voir le rapport

# pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm run test:e2e          # Exécuter les tests
npm run test:e2e:ui       # Mode UI interactif
npm run test:e2e:debug    # Mode debug
npm run test:e2e:report   # Voir le rapport
```

### Workflow de Validation

#### Étape 1 : Valider pwc-ui-shared (GATE)

```powershell
# Terminal 1 : Démarrer l'application
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start
# → http://localhost:4201

# Terminal 2 : Exécuter les tests Playwright
npm run test:e2e

# Résultat attendu : 18 tests passent (100%)
# ✅ SI PASSÉ → Continuer vers pwc-ui
# ❌ SI ÉCHOUÉ → Corriger avant de continuer
```

#### Étape 2 : Valider pwc-ui (après gate)

```powershell
# Terminal 1 : Démarrer l'application
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start
# → http://localhost:4200

# Terminal 2 : Exécuter les tests Playwright
npm run test:e2e

# Résultat attendu : 13 tests passent (100%)
# ✅ SI PASSÉ → Palier 0 validé
# ❌ SI ÉCHOUÉ → Corriger
```

### Couverture des Tests

#### pwc-ui-shared (18 tests)

**demo-home.spec.ts** (6 tests) :
- Affichage du titre
- Affichage de la page d'accueil
- Présence du header/menu
- Absence d'erreurs console critiques
- Chargement des ressources
- Structure HTML valide

**demo-forms.spec.ts** (5 tests) :
- Affichage des composants de formulaire
- Inputs interactifs
- Boutons cliquables
- Navigation vers pages de démo
- Labels de formulaire

**demo-navigation.spec.ts** (7 tests) :
- Navigation vers catalog
- Navigation vers date
- Navigation vers text
- Navigation vers amount
- Gestion des routes invalides
- Navigation entre plusieurs pages
- Chargement des modules lazy-loaded

#### pwc-ui (13 tests)

**app-home.spec.ts** (6 tests) :
- Affichage du titre
- Affichage de la page d'accueil
- Structure de navigation
- Absence d'erreurs console critiques
- Chargement des ressources
- Structure HTML valide

**app-forms.spec.ts** (3 tests) :
- Affichage des éléments de formulaire
- Inputs interactifs
- Boutons

**app-navigation.spec.ts** (4 tests) :
- Chargement de la page d'accueil
- Navigation de base
- Liens de navigation
- Modules lazy-loaded

### Prochaines Étapes

1. **Installer Playwright dans pwc-ui** (si pas déjà fait) :
   ```powershell
   cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
   npm install --save-dev @playwright/test@^1.40.0 --legacy-peer-deps
   ```

2. **Exécuter les tests sur Angular 5 actuel** :
   - Valider que tous les tests passent
   - Documenter les résultats
   - Créer un baseline de référence

3. **Documenter dans le journal de bord** :
   - Nombre de tests créés
   - Résultats de validation
   - Problèmes rencontrés

4. **Passer au Palier 1** (après validation complète)

### Documentation Complète

Voir : `.kiro/steering/11-playwright-e2e-testing.md` pour la documentation complète du Gate Playwright.

---

## ✅ Checklist Palier 0

### Configuration Playwright
- [x] Playwright installé dans pwc-ui-shared
- [x] Playwright configuré dans pwc-ui-shared
- [x] Tests E2E créés pour pwc-ui-shared (18 tests)
- [x] Configuration Playwright créée pour pwc-ui
- [x] Tests E2E créés pour pwc-ui (13 tests)
- [ ] Playwright installé dans pwc-ui (à faire manuellement)

### Validation
- [ ] Tests pwc-ui-shared passent à 100% sur Angular 5
- [ ] Tests pwc-ui passent à 100% sur Angular 5
- [ ] Documentation du baseline dans le journal de bord
- [ ] Gate Playwright validé

### Documentation
- [x] Steering file Playwright créé (11-playwright-e2e-testing.md)
- [x] Design mis à jour avec configuration Gate
- [ ] Journal de bord mis à jour avec résultats

---

## 📝 Notes

- **Gate Bloquant** : Les tests Playwright de pwc-ui-shared sont un gate BLOQUANT pour pwc-ui
- **100% Requis** : Tous les tests doivent passer, pas de tolérance
- **Ports Fixes** : pwc-ui-shared sur 4201, pwc-ui sur 4200
- **Ordre Strict** : Toujours tester pwc-ui-shared AVANT pwc-ui
