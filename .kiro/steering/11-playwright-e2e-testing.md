---
inclusion: auto
priority: 85
keywords: ["playwright", "e2e", "test", "gate", "validation"]
---

# Tests E2E Playwright - Gate de Validation

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-05  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-05) : Création initiale

---

## 🎯 Objectif

Valider que les applications fonctionnent correctement avant et après chaque palier de migration via des tests E2E Playwright.

---

## 🚦 Gate Playwright - Règle Bloquante

### Principe du Gate

```
pwc-ui-shared (port 4201)
    ↓
🚦 Tests Playwright (100% passent)
    ↓
✅ SI PASSÉ → Migrer pwc-ui
❌ SI ÉCHOUÉ → NE PAS migrer pwc-ui, corriger d'abord
```

**RÈGLE ABSOLUE** : Les tests Playwright de pwc-ui-shared DOIVENT passer à 100% avant de migrer pwc-ui.

---

## 📂 Architecture des Tests

### pwc-ui-shared (Bibliothèque - Port 4201)

```
pwc-ui-shared-v4-ia/
├── playwright.config.ts          # Config Playwright
├── e2e/
│   └── tests/
│       ├── demo-home.spec.ts     # Tests page accueil
│       ├── demo-forms.spec.ts    # Tests composants form
│       └── demo-navigation.spec.ts # Tests navigation
└── package.json                   # Scripts test:e2e
```

**Scripts disponibles** :
```bash
npm run test:e2e          # Exécuter les tests
npm run test:e2e:ui       # Mode UI interactif
npm run test:e2e:debug    # Mode debug
npm run test:e2e:report   # Voir le rapport
```

---

### pwc-ui (Application - Port 4200)

```
pwc-ui-v4-ia/
├── playwright.config.ts          # Config Playwright
├── e2e/
│   └── tests/
│       ├── app-home.spec.ts      # Tests page accueil
│       ├── app-forms.spec.ts     # Tests formulaires
│       └── app-navigation.spec.ts # Tests navigation
└── package.json                   # Scripts test:e2e
```

**Scripts disponibles** :
```bash
npm run test:e2e          # Exécuter les tests
npm run test:e2e:ui       # Mode UI interactif
npm run test:e2e:debug    # Mode debug
npm run test:e2e:report   # Voir le rapport
```

---

## 🔄 Workflow de Validation

### Palier 0 : Validation Initiale (Angular 5)

#### Étape 1 : Valider pwc-ui-shared
```powershell
# 1. Aller dans pwc-ui-shared
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# 2. Installer les dépendances (si nécessaire)
npm install

# 3. Démarrer l'application (terminal 1)
npm start
# → Application sur http://localhost:4201

# 4. Exécuter les tests Playwright (terminal 2)
npm run test:e2e

# 5. Vérifier les résultats
# ✅ Tous les tests passent → Continuer
# ❌ Des tests échouent → Corriger avant de continuer
```

#### Étape 2 : Valider pwc-ui (après gate passé)
```powershell
# 1. Aller dans pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# 2. Installer les dépendances (si nécessaire)
npm install

# 3. Démarrer l'application (terminal 1)
npm start
# → Application sur http://localhost:4200

# 4. Exécuter les tests Playwright (terminal 2)
npm run test:e2e

# 5. Vérifier les résultats
# ✅ Tous les tests passent → Palier 0 validé
# ❌ Des tests échouent → Corriger
```

---

### Paliers 1-15 : Validation Après Migration

#### Workflow Standard

```powershell
# 1. Migrer pwc-ui-shared vers Angular X
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
ng update @angular/cli@X @angular/core@X

# 2. Build OK
npm run build

# 3. Tests unitaires OK
npm test

# 4. 🚦 GATE : Tests Playwright
npm start  # Terminal 1
npm run test:e2e  # Terminal 2

# 5. ✅ SI GATE PASSÉ : Migrer pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm update @pwc/shared
ng update @angular/cli@X @angular/core@X

# 6. Tests pwc-ui
npm run build
npm test
npm start  # Terminal 1
npm run test:e2e  # Terminal 2
```

---

## 📋 Tests Playwright - Contenu

### pwc-ui-shared : Tests de la Démo

#### demo-home.spec.ts
- Affichage du titre
- Affichage de la page d'accueil
- Présence du header/menu
- Absence d'erreurs console critiques
- Chargement des ressources
- Structure HTML valide

#### demo-forms.spec.ts
- Affichage des composants de formulaire
- Inputs interactifs
- Boutons cliquables
- Navigation vers pages de démo
- Labels de formulaire

#### demo-navigation.spec.ts
- Navigation vers catalog
- Navigation vers composants (date, text, amount)
- Gestion des routes invalides
- Navigation entre plusieurs pages
- Chargement des modules lazy-loaded

---

### pwc-ui : Tests de l'Application

#### app-home.spec.ts
- Affichage du titre
- Affichage de la page d'accueil
- Structure de navigation
- Absence d'erreurs console critiques
- Chargement des ressources
- Structure HTML valide

#### app-forms.spec.ts
- Affichage des éléments de formulaire
- Inputs interactifs
- Boutons

#### app-navigation.spec.ts
- Chargement de la page d'accueil
- Navigation de base
- Liens de navigation
- Modules lazy-loaded

---

## 🛠️ Configuration Playwright

### playwright.config.ts (pwc-ui-shared)

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e/tests',
  timeout: 30000,
  retries: 2,
  workers: 1,

  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['list']
  ],

  use: {
    baseURL: 'http://localhost:4201',  // Port 4201
    actionTimeout: 10000,
    navigationTimeout: 30000,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  webServer: {
    command: 'npm start',
    port: 4201,
    timeout: 120000,
    reuseExistingServer: !process.env.CI,
  },
});
```

### playwright.config.ts (pwc-ui)

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e/tests',
  timeout: 30000,
  retries: 2,
  workers: 1,

  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['list']
  ],

  use: {
    baseURL: 'http://localhost:4200',  // Port 4200
    actionTimeout: 10000,
    navigationTimeout: 30000,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  webServer: {
    command: 'npm start',
    port: 4200,
    timeout: 120000,
    reuseExistingServer: !process.env.CI,
  },
});
```

---

## 📊 Interprétation des Résultats

### Résultat Attendu (Succès)

```
Running 9 tests using 1 worker

  ✓ demo-home.spec.ts:5:3 › devrait afficher le titre (1.2s)
  ✓ demo-home.spec.ts:10:3 › devrait afficher la page d'accueil (0.8s)
  ✓ demo-home.spec.ts:20:3 › devrait avoir un header (0.5s)
  ✓ demo-forms.spec.ts:5:3 › devrait afficher des composants (0.9s)
  ✓ demo-forms.spec.ts:15:3 › devrait avoir des inputs (1.1s)
  ✓ demo-navigation.spec.ts:5:3 › devrait naviguer vers catalog (1.5s)
  ✓ demo-navigation.spec.ts:15:3 › devrait naviguer vers date (1.3s)
  ✓ demo-navigation.spec.ts:25:3 › devrait naviguer vers text (1.2s)
  ✓ demo-navigation.spec.ts:35:3 › devrait naviguer vers amount (1.4s)

  9 passed (10.9s)
```

**Action** : ✅ Gate validé, passer à pwc-ui

---

### Résultat Échec (Exemple)

```
Running 9 tests using 1 worker

  ✓ demo-home.spec.ts:5:3 › devrait afficher le titre (1.2s)
  ✗ demo-home.spec.ts:10:3 › devrait afficher la page d'accueil (0.8s)
    Error: Timeout 30000ms exceeded
  ✓ demo-home.spec.ts:20:3 › devrait avoir un header (0.5s)
  ✓ demo-forms.spec.ts:5:3 › devrait afficher des composants (0.9s)
  ✗ demo-forms.spec.ts:15:3 › devrait avoir des inputs (1.1s)
    Error: Element not found
  ✓ demo-navigation.spec.ts:5:3 › devrait naviguer vers catalog (1.5s)
  ✓ demo-navigation.spec.ts:15:3 › devrait naviguer vers date (1.3s)
  ✓ demo-navigation.spec.ts:25:3 › devrait naviguer vers text (1.2s)
  ✓ demo-navigation.spec.ts:35:3 › devrait naviguer vers amount (1.4s)

  7 passed, 2 failed (10.9s)
```

**Action** : ❌ Gate échoué, NE PAS passer à pwc-ui, corriger les erreurs

---

## 🔍 Debugging des Tests

### Mode UI Interactif

```powershell
npm run test:e2e:ui
```

Permet de :
- Voir les tests en temps réel
- Inspecter les éléments
- Rejouer les tests
- Voir les screenshots/vidéos

### Mode Debug

```powershell
npm run test:e2e:debug
```

Permet de :
- Mettre des breakpoints
- Exécuter pas à pas
- Inspecter les variables

### Voir le Rapport HTML

```powershell
npm run test:e2e:report
```

Ouvre un rapport HTML détaillé avec :
- Screenshots des échecs
- Vidéos des échecs
- Traces d'exécution
- Logs console

---

## ⚠️ Problèmes Courants

### Problème 1 : Port déjà utilisé

**Erreur** : `Port 4201 is already in use`

**Solution** :
```powershell
# Trouver le processus
netstat -ano | findstr :4201

# Tuer le processus
taskkill /PID <PID> /F

# Ou redémarrer l'application
```

---

### Problème 2 : Timeout

**Erreur** : `Timeout 30000ms exceeded`

**Solution** :
- Augmenter le timeout dans `playwright.config.ts`
- Vérifier que l'application démarre correctement
- Vérifier les erreurs console

---

### Problème 3 : Element not found

**Erreur** : `Element not found: button`

**Solution** :
- Vérifier que l'élément existe dans l'application
- Adapter le sélecteur
- Attendre le chargement avec `waitForLoadState`

---

### Problème 4 : Tests passent localement mais échouent en CI

**Solution** :
- Vérifier les timeouts
- Vérifier les chemins relatifs
- Vérifier les variables d'environnement

---

## ✅ Checklist Gate Playwright

### Avant Chaque Palier

- [ ] Tests Playwright existent
- [ ] Configuration Playwright à jour
- [ ] Application démarre sur le bon port
- [ ] Tests passent à 100% sur version actuelle

### Après Migration pwc-ui-shared

- [ ] Build réussi
- [ ] Tests unitaires passent (>95%)
- [ ] Application démarre sans erreurs
- [ ] 🚦 **Tests Playwright passent à 100% (BLOQUANT)**
- [ ] Publié sur Nexus (si applicable)

### Après Migration pwc-ui (gate validé)

- [ ] Dépendance @pwc/shared mise à jour
- [ ] Build réussi
- [ ] Tests unitaires passent (>95%)
- [ ] Application démarre sans erreurs
- [ ] Tests Playwright passent à 100%

---

## 📚 Ressources

- [Playwright Documentation](https://playwright.dev/)
- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [Playwright Debugging](https://playwright.dev/docs/debug)
- Stratégie de tests : `.kiro/steering/06-testing-strategy.md`

---

## 🎯 Objectif Final

Avoir une suite de tests E2E Playwright qui :
- Valide les fonctionnalités critiques
- Détecte les régressions
- Passe à 100% à chaque palier
- Sert de gate bloquant pour pwc-ui

---

## 📝 Notes Importantes

1. **Gate Bloquant** : Les tests Playwright de pwc-ui-shared sont un gate BLOQUANT pour pwc-ui
2. **100% Requis** : Tous les tests doivent passer, pas de tolérance
3. **Ports Fixes** : pwc-ui-shared sur 4201, pwc-ui sur 4200
4. **Ordre Strict** : Toujours tester pwc-ui-shared AVANT pwc-ui
5. **Documentation** : Documenter les échecs et les corrections dans le journal de bord
