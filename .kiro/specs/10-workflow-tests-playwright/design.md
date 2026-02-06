# Design - Workflow de Tests avec Gate Playwright

## Architecture

### Vue d'Ensemble du Workflow

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

### Architecture des Ports

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

## Configuration Playwright

### playwright.config.ts

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e/tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  
  use: {
    baseURL: 'http://localhost:4201',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],

  webServer: {
    command: 'npm start',
    url: 'http://localhost:4201',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
```

## Tests Playwright

### Test 1 : Page d'Accueil

```typescript
// e2e/tests/demo-home.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Page d\'accueil demo', () => {
  test('devrait afficher le titre principal', async ({ page }) => {
    await page.goto('/');
    
    // Titre principal
    await expect(page.locator('h1')).toContainText('PWC 3.5 Shared Documentation');
  });

  test('devrait afficher le message de bienvenue', async ({ page }) => {
    await page.goto('/');
    
    // Message de bienvenue
    await expect(page.locator('text=Welcome to PowerCARD Sandbox')).toBeVisible();
  });

  test('devrait afficher le logo HPS', async ({ page }) => {
    await page.goto('/');
    
    // Logo
    const logo = page.locator('img[alt*="HPS"]');
    await expect(logo).toBeVisible();
  });

  test('devrait afficher la carte du monde', async ({ page }) => {
    await page.goto('/');
    
    // Carte du monde PowerCARD
    const worldMap = page.locator('.world-map, #world-map, [class*="map"]');
    await expect(worldMap).toBeVisible();
  });

  test('devrait avoir un menu de navigation', async ({ page }) => {
    await page.goto('/');
    
    // Menu de navigation
    const nav = page.locator('nav, .navigation, [role="navigation"]');
    await expect(nav).toBeVisible();
  });

  test('ne devrait pas avoir d\'erreurs console critiques', async ({ page }) => {
    const errors: string[] = [];
    
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Filtrer les erreurs non critiques
    const criticalErrors = errors.filter(err => 
      !err.includes('favicon') && 
      !err.includes('404')
    );
    
    expect(criticalErrors).toHaveLength(0);
  });
});
```

### Test 2 : Composants Form

```typescript
// e2e/tests/demo-forms.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Composants Form', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/components/forms');
  });

  test('devrait afficher la documentation Form Input', async ({ page }) => {
    await expect(page.locator('text=Form Input Component')).toBeVisible();
  });

  test('devrait afficher les champs Simple et SimpleRW', async ({ page }) => {
    await expect(page.locator('label:has-text("Simple")')).toBeVisible();
    await expect(page.locator('label:has-text("SimpleRW")')).toBeVisible();
  });

  test('devrait afficher le champ Password avec toggle', async ({ page }) => {
    const passwordField = page.locator('input[type="password"]');
    await expect(passwordField).toBeVisible();
    
    // Toggle visibility
    const toggleButton = page.locator('button[aria-label*="password"]');
    await expect(toggleButton).toBeVisible();
  });

  test('devrait afficher le champ TextArea', async ({ page }) => {
    await expect(page.locator('textarea')).toBeVisible();
  });

  test('devrait afficher le champ Number', async ({ page }) => {
    await expect(page.locator('input[type="number"]')).toBeVisible();
  });

  test('devrait afficher periodPicker', async ({ page }) => {
    await expect(page.locator('text=1200 H Min')).toBeVisible();
  });

  test('devrait permettre d\'interagir avec les inputs', async ({ page }) => {
    const input = page.locator('input[type="text"]').first();
    await input.fill('Test value');
    await expect(input).toHaveValue('Test value');
  });

  test('devrait afficher les exemples de code', async ({ page }) => {
    await expect(page.locator('code:has-text("pwc-input")')).toBeVisible();
  });
});
```

### Test 3 : Navigation

```typescript
// e2e/tests/demo-navigation.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Navigation', () => {
  test('devrait naviguer entre les sections', async ({ page }) => {
    await page.goto('/');
    
    // Cliquer sur un lien de navigation
    await page.click('a:has-text("Components")');
    
    // Vérifier que l'URL a changé
    await expect(page).toHaveURL(/components/);
  });

  test('devrait être responsive sur mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    // Vérifier que le contenu est visible
    await expect(page.locator('h1')).toBeVisible();
  });

  test('devrait être responsive sur tablet', async ({ page }) => {
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.goto('/');
    
    // Vérifier que le contenu est visible
    await expect(page.locator('h1')).toBeVisible();
  });
});
```

## Scripts Batch

### start-pwc-ui-shared-4201.bat

```batch
@echo off
echo ========================================
echo Lancement pwc-ui-shared sur port 4201
echo ========================================

REM Activer Node v10
call Use-Node10.bat

REM Aller dans le repo
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

REM Vérifier node_modules
if not exist "node_modules" (
    echo node_modules non trouvé, installation...
    npm install
)

REM Lancer l'app sur port 4201
echo Lancement de l'app sur http://localhost:4201
npm start -- --port 4201

pause
```

### start-pwc-ui.bat

```batch
@echo off
echo ========================================
echo Lancement pwc-ui sur port 4200
echo ========================================

REM Activer Node v10
call Use-Node10.bat

REM Aller dans le repo
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

REM Vérifier node_modules
if not exist "node_modules" (
    echo node_modules non trouvé, installation...
    npm install
)

REM Lancer l'app sur port 4200
echo Lancement de l'app sur http://localhost:4200
npm start

pause
```

## Gestion des Erreurs

### Erreur 1 : Port Déjà Utilisé

```bash
# Sur Windows
netstat -ano | findstr :4201
taskkill /PID <PID> /F
```

### Erreur 2 : Tests Flaky

```typescript
// Augmenter les timeouts dans playwright.config.ts
timeout: 60000,  // 60s au lieu de 30s
retries: 3,      // 3 au lieu de 2

// Ajouter des waitFor explicites
await page.waitForLoadState('networkidle');
await page.waitForSelector('.my-element', { state: 'visible' });
```

### Erreur 3 : Playwright Non Installé

```bash
npm install -D @playwright/test
npx playwright install
```

## Métriques de Validation

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

## Documentation

### Fichiers à Mettre à Jour
- `.kiro/state/strands-state.json` : Résultats gate
- `Documentation/JOURNAL-DE-BORD.md` : Problèmes gate
- `playwright-report/` : Rapports automatiques

### Informations à Documenter
- Résultats des tests Playwright
- Temps d'exécution des tests
- Screenshots des échecs (si applicable)
- Décisions prises suite aux résultats
