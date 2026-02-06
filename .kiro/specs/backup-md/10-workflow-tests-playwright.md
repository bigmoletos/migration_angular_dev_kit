# Workflow de Tests avec Gate Playwright

**Date** : 2026-02-03
**Statut** : ✅ Actif pour tous les paliers

---

## 🎯 Objectif

Établir un processus de validation rigoureux avec un **gate Playwright** qui bloque la migration de `pwc-ui` tant que `pwc-ui-shared` ne passe pas 100% des tests E2E automatisés.

---

## 🏗️ Architecture des Ports

### Configuration

```
┌──────────────────────────────────────────────────────────┐
│                                                            │
│  pwc-ui-shared-v4-ia                                      │
│  └─ Port 4201                                             │
│     └─ Tests Playwright (GATE BLOQUANT)                   │
│        └─ Écran demo PowerCARD Sandbox                    │
│                                                            │
│  pwc-ui-v4-ia                                             │
│  └─ Port 4200                                             │
│     └─ Application principale                             │
│        └─ Seulement après gate validé                     │
│                                                            │
└──────────────────────────────────────────────────────────┘
```

### Configuration package.json

#### pwc-ui-shared-v4-ia/package.json
```json
{
  "scripts": {
    "start": "ng serve --port 4201",
    "start:demo": "ng serve --port 4201 --open",
    "test": "ng test",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:report": "playwright show-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.40.0"
  }
}
```

#### pwc-ui-v4-ia/package.json
```json
{
  "scripts": {
    "start": "ng serve --port 4200",
    "test": "ng test"
  }
}
```

---

## 🚦 Workflow Complet avec Gate

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────┐
│ PALIER N : Migration Angular X → Y                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1 : pwc-ui-shared                                      │
├─────────────────────────────────────────────────────────────┤
│ 1. Migration Angular                                         │
│ 2. Build (npm run build)                                    │
│ 3. Tests Unitaires (npm test) → Seuil >95%                 │
│ 4. 🚦 GATE PLAYWRIGHT                                       │
│    ├─ Lancer app demo sur port 4201                         │
│    ├─ Lancer tests Playwright (npm run test:e2e)           │
│    └─ Validation : 100% des tests doivent passer           │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    ┌───────┴────────┐
                    │                │
              ✅ GATE PASSÉ    ❌ GATE ÉCHOUÉ
                    │                │
                    ↓                ↓
┌───────────────────────┐   ┌──────────────────┐
│ PHASE 2 : pwc-ui      │   │ 🚫 STOP           │
├───────────────────────┤   │                   │
│ 1. Mettre à jour dep  │   │ NE PAS continuer  │
│ 2. Migration Angular  │   │ Corriger Shared   │
│ 3. Build              │   │ Relancer gate     │
│ 4. Tests              │   └──────────────────┘
│ 5. Validation         │
└───────────────────────┘
```

---

## 📝 Étapes Détaillées

### PHASE 1 : Migration pwc-ui-shared

#### Étape 1.1 : Préparation
```bash
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Vérifier la branche
git branch  # Doit être sur dev_vibecoding

# Vérifier l'état
git status
```

#### Étape 1.2 : Migration Angular
```bash
# Exemple pour palier 1 (Angular 5 → 6)
ng update @angular/core@6 @angular/cli@6

# Suivre les instructions de la spec du palier
```

#### Étape 1.3 : Build
```bash
# Build de la lib
npm run build

# Vérifier qu'il n'y a pas d'erreurs
# Si erreurs : corriger avant de continuer
```

#### Étape 1.4 : Tests Unitaires
```bash
# Lancer les tests unitaires
npm test

# Vérifier le taux de succès
# Seuil requis : >95%
# Si < 95% : corriger les tests avant de continuer
```

#### Étape 1.5 : 🚦 GATE PLAYWRIGHT

##### Installation Playwright (première fois seulement)
```bash
# Installer Playwright
npm install -D @playwright/test

# Installer les navigateurs
npx playwright install

# Copier la configuration Playwright depuis .kiro/steering/11-playwright-e2e-testing.md
```

##### Lancer l'Application Demo
```bash
# Terminal 1 : Lancer l'app demo sur port 4201

# Option 1 : Utiliser le script batch (RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Option 2 : Manuel
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start -- --port 4201

# Attendre que l'app soit prête
# Vérifier dans le navigateur : http://localhost:4201
```

**Avantages du script batch** :
- ✅ Active automatiquement Node v10 (Use-Node10.bat)
- ✅ Vérifie que node_modules existe
- ✅ Configure le port 4201 automatiquement

##### Lancer les Tests Playwright
```bash
# Terminal 2 : Lancer les tests E2E
npm run test:e2e

# OU avec interface UI pour voir les tests
npm run test:e2e:ui
```

##### Critères de Validation du Gate
| Critère | Seuil | Blocant ? |
|---------|-------|-----------|
| Tests Playwright passants | **100%** | ✅ **OUI** |
| Page d'accueil charge | < 5s | ✅ OUI |
| Aucune erreur console critique | 0 | ✅ OUI |
| Composants form visibles | 100% | ✅ OUI |
| Navigation fonctionne | 100% | ✅ OUI |

##### Résultat du Gate

**✅ SI TOUS LES TESTS PASSENT** :
```bash
# Arrêter l'app demo (Ctrl+C dans Terminal 1)

# Commiter les changements
git add .
git commit -m "Palier N: Migration pwc-ui-shared Angular X→Y - Gate Playwright OK"

# Passer à la phase 2 (pwc-ui)
```

**❌ SI AU MOINS UN TEST ÉCHOUE** :
```bash
# Arrêter l'app demo (Ctrl+C dans Terminal 1)

# Analyser les erreurs
npx playwright show-report

# Corriger les problèmes dans pwc-ui-shared
# Relancer depuis l'étape 1.3 (Build)

# NE PAS passer à pwc-ui
```

---

### PHASE 2 : Migration pwc-ui (Seulement Après Gate Validé)

#### Étape 2.1 : Mise à Jour Dépendance Shared
```bash
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Mettre à jour vers la version de shared que vous venez de migrer
npm install pwc-ui-shared@latest

# OU si vous utilisez npm link local
npm link pwc-ui-shared
```

#### Étape 2.2 : Migration Angular
```bash
# Même version que Shared
ng update @angular/core@6 @angular/cli@6
```

#### Étape 2.3 : Build
```bash
npm run build
```

#### Étape 2.4 : Tests
```bash
# Tests unitaires
npm test

# Lancer l'app sur port 4200
npm start

# Tests manuels
```

#### Étape 2.5 : Validation
```bash
# Vérifier l'app dans le navigateur
# http://localhost:4200

# Valider les fonctionnalités critiques
```

#### Étape 2.6 : Lancer et Tester l'Application UI
```bash
# Lancer l'app UI sur port 4200

# Option 1 : Utiliser le script batch (RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat

# Option 2 : Manuel
npm start

# Vérifier dans le navigateur : http://localhost:4200
```

#### Étape 2.7 : Commit
```bash
git add .
git commit -m "Palier N: Migration pwc-ui Angular X→Y - Integration avec Shared OK"
```

---

## 🧪 Contenu des Tests Playwright

### Tests Couverts

#### 1. Page d'Accueil Demo (demo-home.spec.ts)
- Titre "PWC 3.5 Shared Documentation" visible
- Texte "Welcome to PowerCARD Sandbox" visible
- Logo HPS visible
- Carte du monde PowerCARD visible
- Menu de navigation présent
- Aucune erreur console critique

#### 2. Composants Form (demo-forms.spec.ts)
- Documentation "Form Input Component" visible
- Champs Simple et SimpleRW affichés
- Champ Password avec toggle visible
- Champ TextArea visible
- Champ Number visible
- periodPicker (1200 H Min) visible
- Possibilité d'interagir avec les inputs
- Exemples de code (pwc-input) visibles

#### 3. Navigation (demo-navigation.spec.ts)
- Navigation entre sections fonctionne
- Responsive mobile (375x667)
- Responsive tablet (768x1024)

---

## 📊 Métriques et Reporting

### Métriques du Gate

À chaque palier, documenter :

```markdown
## Palier N - Gate Playwright

**Date** : YYYY-MM-DD
**Migration** : Angular X → Y

### Résultats pwc-ui-shared

| Métrique | Valeur | Seuil | Statut |
|----------|--------|-------|--------|
| Build | ✅ Succès | Succès | ✅ |
| Tests unitaires | 98% | >95% | ✅ |
| Tests Playwright | 100% | 100% | ✅ |
| Page accueil charge | 2.3s | <5s | ✅ |
| Erreurs console | 0 | 0 | ✅ |

### Gate Playwright : ✅ VALIDÉ

### Action : ✅ Passage à pwc-ui autorisé
```

---

## ⚠️ Points d'Attention

### 1. Images de Référence (v3.5)

Les images fournies (`ecran_demo_shared_accueil.png`, `ecran_demo_shared2.png`) sont de la **v3.5**.

**Différences possibles avec v4** :
- Layout légèrement différent
- Styles CSS modifiés
- Textes différents

**Solution** :
- Les tests ne doivent PAS être basés sur des comparaisons de screenshots pixel-perfect
- Tester la **présence et la fonctionnalité** des éléments, pas l'apparence exacte

### 2. Tests Flaky

Si un test échoue de manière intermittente :
```typescript
// Augmenter les timeouts dans playwright.config.ts
timeout: 60000,  // 60s au lieu de 30s

// Augmenter les retries
retries: 3,  // 3 au lieu de 2

// Ajouter des waitFor explicites
await page.waitForLoadState('networkidle');
await page.waitForSelector('.my-element', { state: 'visible' });
```

### 3. Port Déjà Utilisé

Si le port 4201 est occupé :
```bash
# Sur Windows
netstat -ano | findstr :4201
taskkill /PID <PID> /F
```

### 4. Playwright Non Installé

Si Playwright n'est pas installé :
```bash
npm install -D @playwright/test
npx playwright install
```

---

## 📋 Checklists

### Checklist Gate Playwright (pwc-ui-shared)

**AVANT de passer à pwc-ui** :

- [ ] pwc-ui-shared buildé avec succès (npm run build)
- [ ] Tests unitaires passent >95% (npm test)
- [ ] Playwright installé (`@playwright/test` dans devDependencies)
- [ ] Navigateurs Playwright installés (npx playwright install)
- [ ] Configuration playwright.config.ts créée
- [ ] Tests E2E créés dans `e2e/tests/`
- [ ] App demo lance sur port 4201 (npm start)
- [ ] **🚦 100% des tests Playwright passent (npm run test:e2e)**
- [ ] Page d'accueil charge en <5s
- [ ] Aucune erreur console critique
- [ ] Composants form s'affichent correctement
- [ ] Navigation fonctionne
- [ ] Screenshots/vidéos des tests disponibles (playwright-report/)
- [ ] Changements committés

### Checklist Migration pwc-ui (Après Gate Validé)

**SEULEMENT SI GATE PASSÉ** :

- [ ] Dépendance pwc-ui-shared mise à jour
- [ ] Migration Angular effectuée (même version que Shared)
- [ ] Build réussi (npm run build)
- [ ] Tests unitaires passent >95%
- [ ] App lance sur port 4200 (npm start)
- [ ] Tests manuels OK
- [ ] Fonctionnalités critiques validées
- [ ] Changements committés

---

## 🛠️ Commandes Utiles

### Shared (Port 4201)
```bash
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Build
npm run build

# Tests unitaires
npm test

# Lancer app demo (Option 1 - RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Lancer app demo (Option 2 - Manuel)
npm start -- --port 4201

# Tests Playwright
npm run test:e2e
npm run test:e2e:ui
npm run test:e2e:debug
npm run test:e2e:report
```

### UI (Port 4200)
```bash
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Mettre à jour shared
npm install pwc-ui-shared@latest

# Build
npm run build

# Tests unitaires
npm test

# Lancer app (Option 1 - RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat

# Lancer app (Option 2 - Manuel)
npm start
```

### Scripts Batch Disponibles

**Localisation** : `C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\`

| Script | Description | Port |
|--------|-------------|------|
| `start-pwc-ui-shared-4201.bat` | Lance Shared avec Node v10 | 4201 |
| `start-pwc-ui.bat` | Lance UI avec Node v10 | 4200 |
| `Use-Node10.bat` | Active Node v10 (appelé par les scripts ci-dessus) | - |

---

## 🎯 Résumé

### Règle Absolue

```
🚦 GATE PLAYWRIGHT = BLOQUANT

Shared Migration → Build OK → Tests Unitaires >95% → 🚦 Playwright 100%
                                                              ↓
                                                         ✅ → UI
                                                         ❌ → STOP
```

### Points Clés

1. **Port 4201** : pwc-ui-shared (avec tests Playwright obligatoires)
2. **Port 4200** : pwc-ui (seulement après gate validé)
3. **100% des tests Playwright doivent passer** pour débloquer UI
4. **Pas d'exceptions** : Si un test échoue, corriger Shared avant de passer à UI

### Documentation Complète

- Steering Playwright : `.kiro/steering/11-playwright-e2e-testing.md`
- Stratégie Tests : `.kiro/steering/06-testing-strategy.md`
- README : `.kiro/specs/README.md`
