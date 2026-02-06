# Spec Palier 0 : Validation Infrastructure

**Durée estimée** : 2 semaines  
**Complexité** : 🟡 Moyenne  
**Criticité** : 🔴 BLOQUANT pour tous les paliers suivants

---

## 🎯 Objectif

Valider que l'infrastructure de migration est **opérationnelle** avant de commencer le Palier 1. Ce palier est **obligatoire** et **bloquant**.

**Principe** : "Fail Fast" - Découvrir les problèmes maintenant, quand ils sont faciles à corriger.

---

## 📋 Tâches du Palier 0

### Tâche 1 : Implémenter Gate Playwright (3 jours)

#### 1.1 : Installation Playwright
```bash
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Installer Playwright
npm install -D @playwright/test@^1.40.0

# Installer les navigateurs
npx playwright install chromium
```

**Validation** :
- [ ] `@playwright/test` dans devDependencies
- [ ] Navigateur Chromium installé

---

#### 1.2 : Créer Configuration Playwright
**Fichier** : `pwc-ui-shared/playwright.config.ts`

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
    baseURL: 'http://localhost:4201',
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

**Validation** :
- [ ] Fichier créé
- [ ] Configuration valide

---

#### 1.3 : Créer Tests Playwright
**Créer** : `pwc-ui-shared/e2e/tests/demo-home.spec.ts`

```typescript
import { test, expect } from '@playwright/test';

test.describe('Demo Shared - Page Accueil', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });
  
  test('devrait afficher le titre PowerCARD Sandbox', async ({ page }) => {
    await expect(page).toHaveTitle(/PWC.*Shared|PowerCARD/i);
    const welcome = page.locator('text=/PowerCARD|Sandbox|Welcome/i');
    await expect(welcome.first()).toBeVisible();
  });
  
  test('devrait afficher le logo HPS', async ({ page }) => {
    const logo = page.locator('img[alt*="HPS"], img[src*="logo"], .logo');
    await expect(logo.first()).toBeVisible();
  });
  
  test('devrait avoir un menu de navigation', async ({ page }) => {
    const menu = page.locator('button[aria-label*="menu"], .menu-icon, nav, .navbar');
    await expect(menu.first()).toBeVisible();
  });
  
  test('devrait charger sans erreurs console critiques', async ({ page }) => {
    const errors: string[] = [];
    
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    const criticalErrors = errors.filter(error =>
      !error.includes('favicon') &&
      !error.includes('external') &&
      !error.includes('404')
    );
    
    expect(criticalErrors).toHaveLength(0);
  });
});
```

**Créer** : `pwc-ui-shared/e2e/tests/demo-forms.spec.ts`

```typescript
import { test, expect } from '@playwright/test';

test.describe('Demo Shared - Composants Form', () => {
  
  test('devrait afficher des composants de formulaire', async ({ page }) => {
    await page.goto('/');
    
    // Chercher n'importe quel composant form
    const formElements = page.locator('input, textarea, select, button[type="submit"]');
    const count = await formElements.count();
    
    expect(count).toBeGreaterThan(0);
  });
  
  test('devrait pouvoir interagir avec un input', async ({ page }) => {
    await page.goto('/');
    
    // Trouver le premier input visible
    const input = page.locator('input[type="text"], input:not([type])').first();
    
    if (await input.isVisible()) {
      await input.fill('Test Value');
      await expect(input).toHaveValue('Test Value');
    }
  });
});
```

**Validation** :
- [ ] Tests créés
- [ ] Syntaxe TypeScript valide

---

#### 1.4 : Ajouter Scripts package.json
**Modifier** : `pwc-ui-shared/package.json`

```json
{
  "scripts": {
    "start": "ng serve --port 4201",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:report": "playwright show-report"
  }
}
```

**Validation** :
- [ ] Scripts ajoutés

---

#### 1.5 : Tester Gate Playwright sur Angular 5 Actuel
```bash
# Terminal 1 : Lancer l'app
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start -- --port 4201

# Terminal 2 : Lancer les tests
npm run test:e2e
```

**Validation** :
- [ ] Application démarre sur port 4201
- [ ] Tests Playwright s'exécutent
- [ ] Au moins 1 test passe
- [ ] Rapport HTML généré

**Si tests échouent** : Ajuster les sélecteurs pour correspondre à l'app réelle.

---

### Tâche 2 : Tester Codemods (1 jour)

#### 2.1 : Créer Fichiers de Test
**Créer** : `.kiro/temp/test-codemod-rxjs.ts`

```typescript
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/of';

export class TestService {
  getData(): Observable<any> {
    return Observable.of([1, 2, 3])
      .map(x => x * 2)
      .filter(x => x > 5)
      .catch(err => Observable.of([]));
  }
}
```

**Créer** : `.kiro/temp/test-codemod-module.ts`

```typescript
import { NgModule, ModuleWithProviders } from '@angular/core';

@NgModule({})
export class TestModule {
  static forRoot(): ModuleWithProviders {
    return {
      ngModule: TestModule,
      providers: []
    };
  }
}
```

**Validation** :
- [ ] Fichiers créés

---

#### 2.2 : Tester Codemod RxJS
```bash
cd C:\repo_hps

# Tester le codemod officiel
npx rxjs-tslint -p .kiro/temp/test-codemod-rxjs.ts

# OU tester le codemod custom
node scripts_outils_ia/codemods/rxjs-imports.js .kiro/temp/test-codemod-rxjs.ts
```

**Validation** :
- [ ] Codemod s'exécute sans erreur
- [ ] Fichier transformé correctement
- [ ] Imports RxJS mis à jour

---

#### 2.3 : Tester Codemod ModuleWithProviders
```bash
node scripts_outils_ia/codemods/module-with-providers.js .kiro/temp/test-codemod-module.ts
```

**Validation** :
- [ ] Codemod s'exécute sans erreur
- [ ] `ModuleWithProviders<TestModule>` ajouté

---

#### 2.4 : Documenter Résultats
**Créer** : `.kiro/temp/rapport-test-codemods.md`

```markdown
# Rapport Test Codemods

## Codemod RxJS
- **Statut** : ✅ Fonctionne / ❌ Échoue
- **Cas testés** : map, filter, catch, Observable.of
- **Cas qui échouent** : [Liste]
- **Recommandation** : Utiliser / Ne pas utiliser

## Codemod ModuleWithProviders
- **Statut** : ✅ Fonctionne / ❌ Échoue
- **Cas testés** : forRoot()
- **Cas qui échouent** : [Liste]
- **Recommandation** : Utiliser / Ne pas utiliser
```

**Validation** :
- [ ] Rapport créé
- [ ] Résultats documentés

---

### Tâche 3 : Analyser Webpack Custom (1 jour)

#### 3.1 : Lire Configurations Webpack
```bash
# Lire les fichiers webpack
cat pwc-ui/pwc-ui-v4-ia/webpack.dev.config.js
cat pwc-ui/pwc-ui-v4-ia/webpack.prod.config.js
```

**Identifier** :
- Loaders utilisés
- Plugins utilisés
- Configurations custom

**Validation** :
- [ ] Fichiers lus
- [ ] Loaders identifiés
- [ ] Plugins identifiés

---

#### 3.2 : Vérifier Compatibilité Webpack 5
**Créer** : `.kiro/temp/analyse-webpack.md`

```markdown
# Analyse Webpack Custom

## Loaders Utilisés
- [ ] ts-loader : Compatible Webpack 5
- [ ] sass-loader : Compatible Webpack 5
- [ ] file-loader : Remplacé par asset/resource en Webpack 5
- [ ] url-loader : Remplacé par asset/inline en Webpack 5

## Plugins Utilisés
- [ ] HtmlWebpackPlugin : Compatible Webpack 5
- [ ] MiniCssExtractPlugin : Compatible Webpack 5
- [ ] [Autre plugin] : Compatible / Incompatible

## Recommandation
- ✅ Migration vers Webpack 5 possible
- ⚠️ Migration vers Webpack 5 avec ajustements
- ❌ Migration vers Angular CLI natif recommandée
```

**Validation** :
- [ ] Analyse créée
- [ ] Compatibilité évaluée

---

### Tâche 4 : Analyser Dépendances Obsolètes (1 jour)

#### 4.1 : Lister Dépendances Obsolètes
```bash
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Vérifier les versions
npm outdated
```

**Créer** : `.kiro/specs/11-deprecated-libraries-strategy.md`

```markdown
# Stratégie Migration Librairies Obsolètes

## Librairies Identifiées

### primeng 5.2.4
- **Version actuelle** : 5.2.4
- **Dernière version** : 17.x
- **Statut** : Obsolète depuis 2018
- **Utilisé dans** : [À identifier]
- **Stratégie** : Migrer vers primeng 17.x au Palier 3.5
- **Risque** : Moyen (breaking changes majeurs)

### ng2-file-upload 1.3.0
- **Version actuelle** : 1.3.0
- **Statut** : Déprécié
- **Remplacement** : ngx-file-upload
- **Stratégie** : Migrer au Palier 6.5
- **Risque** : Faible

### angular2-text-mask 8.0.4
- **Version actuelle** : 8.0.4
- **Statut** : Déprécié
- **Remplacement** : ngx-mask
- **Stratégie** : Migrer au Palier 6.5
- **Risque** : Faible

### ng2-charts 1.6.0
- **Version actuelle** : 1.6.0
- **Dernière version** : 4.x
- **Statut** : Obsolète
- **Stratégie** : Migrer vers ng2-charts 4.x au Palier 6.5
- **Risque** : Moyen

### ng2-pdf-viewer 5.2.3
- **Version actuelle** : 5.2.3
- **Dernière version** : 9.x
- **Statut** : Obsolète
- **Stratégie** : Migrer vers ng2-pdf-viewer 9.x au Palier 6.5
- **Risque** : Faible
```

**Validation** :
- [ ] Document créé
- [ ] Toutes les libs obsolètes listées
- [ ] Stratégie définie pour chaque lib

---

### Tâche 5 : Créer Matrice de Criticité Composants (1 jour)

#### 5.1 : Identifier Composants Critiques
**Créer** : `.kiro/temp/matrice-criticite-composants.md`

```markdown
# Matrice de Criticité des Composants

## Composants CRITIQUES (20%) - Doivent fonctionner à 100%

### pwc-ui-shared
- [ ] FormInputComponent (utilisé partout)
- [ ] DateComponent (utilisé partout)
- [ ] AmountComponent (utilisé partout)
- [ ] HttpService (service central)
- [ ] AuthService (service central)
- [ ] DataTableComponent (très utilisé)
- [ ] AdvancedGridComponent (très utilisé)
- [ ] PopupComponent (très utilisé)

### pwc-ui
- [ ] LoginComponent
- [ ] DashboardComponent
- [ ] NavigationComponent

## Composants IMPORTANTS (30%) - Doivent fonctionner à 95%

### pwc-ui-shared
- [ ] CheckboxComponent
- [ ] RadioButtonComponent
- [ ] ListboxComponent
- [ ] DateRangeComponent
- [ ] AmountRangeComponent

## Composants SECONDAIRES (50%) - Bugs temporaires acceptables

### pwc-ui-shared
- [ ] EurekaStaticListComponent
- [ ] FraudChargebackPercentageIndicator
- [ ] NetworkPurchasesIndicator
- [ ] [Autres composants spécifiques]
```

**Validation** :
- [ ] Matrice créée
- [ ] Composants classés par criticité

---

### Tâche 6 : Créer Stratégie de Rollback (1 jour)

#### 6.1 : Documenter Procédure de Rollback
**Créer** : `.kiro/specs/12-rollback-strategy.md`

```markdown
# Stratégie de Rollback

## Critères de Go/No-Go

### Pour passer au palier suivant
✅ Build réussi
✅ Tests unitaires >95%
✅ Tests Playwright 100%
✅ Application démarre
✅ Composants critiques testés manuellement
✅ Aucune régression de performance
✅ Aucun bug bloquant

### Si UN critère échoue
🚫 NE PAS passer au palier suivant
🔄 Rollback au tag précédent
📝 Analyser et corriger
🔁 Relancer le palier

## Procédure de Rollback Git

\`\`\`bash
# 1. Identifier le tag précédent
git tag -l

# 2. Rollback
git reset --hard palier-X-angular-Y

# 3. Nettoyer
rm -rf node_modules package-lock.json
npm install

# 4. Vérifier
npm run build
npm test
\`\`\`

## Procédure de Rollback Nexus

\`\`\`bash
# 1. Unpublish (si possible)
npm unpublish @pwc/shared@2.7.0

# 2. OU publier une version de rollback
npm version patch
npm publish
\`\`\`

## Communication avec Équipes Clientes

### Template Email
\`\`\`
Objet : [URGENT] Rollback @pwc/shared version X.Y.Z

Bonjour,

Suite à un problème critique identifié dans la version X.Y.Z de @pwc/shared,
nous effectuons un rollback vers la version X.Y.Z-1.

Actions requises :
1. NE PAS mettre à jour vers X.Y.Z
2. Si déjà mis à jour, revenir à X.Y.Z-1

Merci de votre compréhension.
\`\`\`
```

**Validation** :
- [ ] Document créé
- [ ] Procédures documentées

---

### Tâche 7 : Dry-Run Palier 1 (2 jours)

#### 7.1 : Créer Branche de Test
```bash
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Créer branche de test
git checkout -b test-palier-1-dry-run

# Tag de sauvegarde
git tag test-dry-run-start
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé

---

#### 7.2 : Tenter Migration Angular 5→6
```bash
# Dry-run (ne pas appliquer)
ng update @angular/cli@6 @angular/core@6 --dry-run

# Noter les changements prévus
```

**Validation** :
- [ ] Dry-run exécuté
- [ ] Changements notés

---

#### 7.3 : Identifier Problèmes Potentiels
**Créer** : `.kiro/temp/rapport-dry-run-palier-1.md`

```markdown
# Rapport Dry-Run Palier 1

## Changements Prévus
- [ ] .angular-cli.json → angular.json
- [ ] package.json mis à jour
- [ ] [Autres changements]

## Problèmes Identifiés
- [ ] [Problème 1]
- [ ] [Problème 2]

## Temps Estimé Réel
- **Estimation initiale** : 1-2 semaines
- **Estimation après dry-run** : X semaines
- **Facteurs d'ajustement** : [Liste]
```

**Validation** :
- [ ] Rapport créé
- [ ] Problèmes identifiés

---

#### 7.4 : Rollback Branche de Test
```bash
# Revenir à l'état initial
git reset --hard test-dry-run-start

# Supprimer la branche de test
git checkout dev_vibecoding
git branch -D test-palier-1-dry-run
```

**Validation** :
- [ ] Rollback effectué
- [ ] Branche supprimée

---

## 📊 Critères de Validation du Palier 0

### Validation Globale

- [ ] **Tâche 1** : Gate Playwright opérationnel (100% des tests passent)
- [ ] **Tâche 2** : Codemods testés et documentés
- [ ] **Tâche 3** : Webpack analysé et stratégie définie
- [ ] **Tâche 4** : Libs obsolètes identifiées et stratégie créée
- [ ] **Tâche 5** : Matrice de criticité composants créée
- [ ] **Tâche 6** : Stratégie de rollback documentée
- [ ] **Tâche 7** : Dry-run Palier 1 effectué et problèmes identifiés

### Critères de Succès

✅ **SI TOUTES LES TÂCHES VALIDÉES** :
- Passer au Palier 1 avec confiance
- Estimations ajustées
- Risques identifiés et mitigés

❌ **SI UNE TÂCHE ÉCHOUE** :
- Corriger avant de passer au Palier 1
- Ne pas commencer la migration sans validation complète

---

## 🎯 Livrables du Palier 0

1. `.kiro/specs/11-deprecated-libraries-strategy.md`
2. `.kiro/specs/12-rollback-strategy.md`
3. `.kiro/temp/matrice-criticite-composants.md`
4. `.kiro/temp/analyse-webpack.md`
5. `.kiro/temp/rapport-test-codemods.md`
6. `.kiro/temp/rapport-dry-run-palier-1.md`
7. `pwc-ui-shared/e2e/tests/` (tests Playwright)
8. `pwc-ui-shared/playwright.config.ts`

---

## 📅 Planning Détaillé

### Semaine 1
- **Lundi-Mercredi** : Tâche 1 (Gate Playwright)
- **Jeudi** : Tâche 2 (Codemods)
- **Vendredi** : Tâche 3 (Webpack)

### Semaine 2
- **Lundi** : Tâche 4 (Libs obsolètes)
- **Mardi** : Tâche 5 (Matrice criticité)
- **Mercredi** : Tâche 6 (Rollback)
- **Jeudi-Vendredi** : Tâche 7 (Dry-run)

---

## ✅ Prochaine Étape

Une fois le Palier 0 validé, passer au **Palier 1 : Angular 5 → 6** avec une base solide.
