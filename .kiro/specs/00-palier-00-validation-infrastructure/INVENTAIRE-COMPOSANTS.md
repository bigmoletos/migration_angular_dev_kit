# 📦 Système d'Inventaire des Composants

> **Version** : 1.0.0  
> **Date** : 2026-02-05  
> **Auteur** : Kiro

---

## 🎯 Objectif

Le système d'inventaire permet de **cataloguer automatiquement tous les composants** de la démo pwc-ui-shared et de les utiliser dans les tests Playwright.

---

## 📊 Fonctionnalités

### 1. Exploration Automatique

Le test d'inventaire explore automatiquement:
- ✅ Tous les menus et sous-menus
- ✅ Tous les composants disponibles
- ✅ Tous les éléments de formulaire (inputs, buttons, selects, etc.)
- ✅ Les éléments custom Angular
- ✅ Prend des screenshots de chaque composant

### 2. Génération de Rapports

Génère automatiquement:
- 📄 **inventory.json** : Données brutes structurées
- 📄 **INVENTORY-REPORT.md** : Rapport lisible en Markdown
- 📸 **screenshots/** : Captures d'écran de chaque composant

### 3. Helper TypeScript

Fournit un helper pour:
- 🔍 Rechercher des composants par nom
- 📋 Filtrer par catégorie
- 🎯 Trouver les composants avec formulaires
- 📊 Obtenir des statistiques
- 🔧 Générer des tests automatiquement

---

## 🚀 Utilisation

### Étape 1 : Générer l'Inventaire

#### Option A : Script Batch (Recommandé)

```powershell
# Depuis n'importe où
C:\repo_hps\outils_communs\run-inventory.bat
```

#### Option B : Commande Manuelle

```powershell
# 1. Démarrer l'application
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start  # Port 4201

# 2. Dans un autre terminal, lancer l'inventaire
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npx playwright test e2e/tests/demo-inventory.spec.ts --headed --workers=1
```

### Étape 2 : Consulter les Résultats

#### Fichier JSON (Données Brutes)

```powershell
code e2e\inventory.json
```

Structure du fichier:
```json
{
  "generatedAt": "2026-02-05T10:30:00.000Z",
  "baseUrl": "http://localhost:4201",
  "totalCategories": 5,
  "totalComponents": 50,
  "categories": [
    {
      "category": "catalog",
      "components": [
        {
          "name": "FormInput",
          "url": "/catalog/form-input",
          "selector": "#form-input-link",
          "hasForm": true,
          "inputs": ["password_password", "simple_input"],
          "buttons": ["submit-button", "reset-button"],
          "selects": [],
          "textareas": [],
          "checkboxes": [],
          "radios": [],
          "customElements": ["pwc-form-input", "pwc-button"],
          "screenshots": ["e2e/screenshots/inventory/FormInput.png"]
        }
      ]
    }
  ]
}
```

#### Rapport Markdown (Lisible)

```powershell
code e2e\INVENTORY-REPORT.md
```

Contient:
- 📊 Statistiques globales
- 📋 Liste complète des composants par catégorie
- 🔍 Détails de chaque composant (inputs, buttons, etc.)

#### Screenshots

```powershell
explorer e2e\screenshots\inventory
```

---

## 🔧 Utiliser l'Inventaire dans les Tests

### Exemple 1 : Rechercher un Composant

```typescript
import { inventoryHelper } from '../utils/inventory-helper';

test('Tester le composant Email', async ({ page }) => {
  // Rechercher le composant
  const component = inventoryHelper.findComponent('Email');
  
  if (component) {
    // Naviguer vers le composant
    await page.goto(`http://localhost:4201${component.url}`);
    
    // Utiliser les informations de l'inventaire
    for (const inputId of component.inputs) {
      await page.locator(`#${inputId}`).fill('test@example.com');
    }
  }
});
```

### Exemple 2 : Tester Tous les Composants avec Formulaires

```typescript
test('Tester tous les formulaires', async ({ page }) => {
  const formComponents = inventoryHelper.getFormComponents();
  
  for (const component of formComponents) {
    await page.goto(`http://localhost:4201${component.url}`);
    
    // Tester les inputs
    for (const inputId of component.inputs) {
      await page.locator(`#${inputId}`).fill('test');
    }
  }
});
```

### Exemple 3 : Rechercher par Mot-Clé

```typescript
test('Tester les composants de date', async ({ page }) => {
  const dateComponents = inventoryHelper.searchComponents('date');
  
  console.log(`Trouvé ${dateComponents.length} composants de date`);
  
  for (const component of dateComponents) {
    await page.goto(`http://localhost:4201${component.url}`);
    // Tests...
  }
});
```

### Exemple 4 : Obtenir des Statistiques

```typescript
test('Afficher les statistiques', async () => {
  // Résumé global
  console.log(inventoryHelper.getSummary());
  
  // Statistiques d'un composant
  console.log(inventoryHelper.getComponentStats('FormInput'));
  
  // Composants par catégorie
  const categories = inventoryHelper.getCategories();
  for (const category of categories) {
    const components = inventoryHelper.getComponentsByCategory(category);
    console.log(`${category}: ${components.length} composants`);
  }
});
```

---

## 📋 API du Helper

### Méthodes Principales

| Méthode | Description | Retour |
|---------|-------------|--------|
| `loadInventory()` | Charge l'inventaire depuis le fichier JSON | `Inventory` |
| `findComponent(name)` | Recherche un composant par nom exact | `ComponentInfo \| null` |
| `searchComponents(term)` | Recherche par nom partiel | `ComponentInfo[]` |
| `getComponentsByCategory(category)` | Obtient tous les composants d'une catégorie | `ComponentInfo[]` |
| `getFormComponents()` | Obtient les composants avec formulaires | `ComponentInfo[]` |
| `getComponentsWithInputs()` | Obtient les composants avec inputs | `ComponentInfo[]` |
| `getComponentsWithButtons()` | Obtient les composants avec boutons | `ComponentInfo[]` |
| `getAllComponents()` | Obtient tous les composants | `ComponentInfo[]` |
| `getCategories()` | Obtient toutes les catégories | `string[]` |
| `getSummary()` | Génère un résumé textuel | `string` |
| `getComponentStats(name)` | Obtient les stats d'un composant | `string \| null` |
| `printInventory()` | Affiche l'inventaire dans la console | `void` |

### Types TypeScript

```typescript
interface ComponentInfo {
  name: string;              // Nom du composant
  url: string;               // URL relative (/catalog/form-input)
  selector: string;          // Sélecteur CSS (#form-input-link)
  hasForm: boolean;          // Contient un formulaire ?
  inputs: string[];          // IDs des inputs
  buttons: string[];         // IDs/textes des boutons
  selects: string[];         // IDs des selects
  textareas: string[];       // IDs des textareas
  checkboxes: string[];      // IDs des checkboxes
  radios: string[];          // IDs des radios
  customElements: string[];  // Classes des éléments custom
  screenshots?: string[];    // Chemins des screenshots
}

interface MenuCategory {
  category: string;          // Nom de la catégorie
  components: ComponentInfo[]; // Composants de la catégorie
}

interface Inventory {
  generatedAt: string;       // Date de génération
  baseUrl: string;           // URL de base
  totalCategories: number;   // Nombre de catégories
  totalComponents: number;   // Nombre de composants
  categories: MenuCategory[]; // Catégories et composants
}
```

---

## 🎯 Cas d'Usage

### 1. Tests de Régression Automatiques

```typescript
test('Vérifier que tous les composants se chargent', async ({ page }) => {
  const allComponents = inventoryHelper.getAllComponents();
  
  for (const component of allComponents) {
    await page.goto(`http://localhost:4201${component.url}`);
    await expect(page).toHaveURL(new RegExp(component.url));
  }
});
```

### 2. Tests de Formulaires Exhaustifs

```typescript
test('Tester tous les inputs de tous les formulaires', async ({ page }) => {
  const formComponents = inventoryHelper.getFormComponents();
  
  for (const component of formComponents) {
    await page.goto(`http://localhost:4201${component.url}`);
    
    for (const inputId of component.inputs) {
      const input = page.locator(`#${inputId}`);
      if (await input.isVisible()) {
        await input.fill('test');
        const value = await input.inputValue();
        expect(value).toBe('test');
      }
    }
  }
});
```

### 3. Génération de Documentation

```typescript
test('Générer la documentation des composants', async () => {
  const allComponents = inventoryHelper.getAllComponents();
  
  let doc = '# Documentation des Composants\n\n';
  
  for (const component of allComponents) {
    doc += `## ${component.name}\n\n`;
    doc += `- **URL**: ${component.url}\n`;
    doc += `- **Formulaire**: ${component.hasForm ? 'Oui' : 'Non'}\n`;
    doc += `- **Inputs**: ${component.inputs.length}\n`;
    doc += `- **Buttons**: ${component.buttons.length}\n\n`;
  }
  
  fs.writeFileSync('COMPONENTS-DOC.md', doc);
});
```

### 4. Tests de Performance

```typescript
test('Mesurer le temps de chargement de chaque composant', async ({ page }) => {
  const allComponents = inventoryHelper.getAllComponents();
  const timings: { name: string; time: number }[] = [];
  
  for (const component of allComponents) {
    const start = Date.now();
    await page.goto(`http://localhost:4201${component.url}`);
    await page.waitForLoadState('networkidle');
    const end = Date.now();
    
    timings.push({ name: component.name, time: end - start });
  }
  
  // Afficher les résultats
  timings.sort((a, b) => b.time - a.time);
  console.log('Composants les plus lents:');
  timings.slice(0, 10).forEach(t => {
    console.log(`  ${t.name}: ${t.time}ms`);
  });
});
```

---

## 📊 Statistiques Typiques

Exemple de résultats attendus:

```
📦 Inventaire des Composants
═══════════════════════════════

Généré le: 05/02/2026 10:30:00
URL de base: http://localhost:4201

📊 Statistiques:
  - Catégories: 8
  - Composants: 75
  - Composants avec formulaires: 45
  - Composants avec inputs: 52
  - Composants avec boutons: 68

📋 Catégories:
  - catalog: 25 composants
  - forms: 18 composants
  - tables: 12 composants
  - navigation: 8 composants
  - dialogs: 6 composants
  - charts: 4 composants
  - utils: 2 composants
```

---

## ⚠️ Limitations et Précautions

### Limitations

1. **Éléments Dynamiques** : Les éléments chargés dynamiquement après interaction peuvent ne pas être détectés
2. **Composants Cachés** : Les composants dans des onglets ou accordéons fermés peuvent être manqués
3. **Timeout** : Les composants très lents à charger peuvent causer des timeouts

### Précautions

1. **Application en Cours** : L'application DOIT tourner sur le port 4201
2. **Temps d'Exécution** : L'inventaire complet peut prendre 5-10 minutes
3. **Espace Disque** : Les screenshots peuvent occuper plusieurs MB

---

## 🔄 Mise à Jour de l'Inventaire

### Quand Régénérer ?

Régénérer l'inventaire après:
- ✅ Ajout de nouveaux composants
- ✅ Modification de composants existants
- ✅ Changement de structure de navigation
- ✅ Migration vers une nouvelle version Angular

### Commande Rapide

```powershell
# Régénérer l'inventaire
C:\repo_hps\outils_communs\run-inventory.bat
```

---

## 📚 Fichiers Créés

| Fichier | Description | Emplacement |
|---------|-------------|-------------|
| **demo-inventory.spec.ts** | Test d'inventaire principal | `e2e/tests/` |
| **inventory-helper.ts** | Helper TypeScript | `e2e/utils/` |
| **demo-using-inventory.spec.ts** | Exemples d'utilisation | `e2e/tests/` |
| **inventory.json** | Données brutes (généré) | `e2e/` |
| **INVENTORY-REPORT.md** | Rapport lisible (généré) | `e2e/` |
| **screenshots/inventory/** | Captures d'écran (générées) | `e2e/screenshots/` |
| **run-inventory.bat** | Script de lancement | `outils_communs/` |

---

## ✅ Checklist d'Utilisation

### Première Utilisation

- [ ] Application pwc-ui-shared démarre sur port 4201
- [ ] Lancer `run-inventory.bat`
- [ ] Vérifier que `inventory.json` est créé
- [ ] Consulter `INVENTORY-REPORT.md`
- [ ] Vérifier les screenshots

### Utilisation dans les Tests

- [ ] Importer `inventoryHelper`
- [ ] Charger l'inventaire avec `loadInventory()`
- [ ] Utiliser les méthodes de recherche
- [ ] Tester les composants trouvés

### Maintenance

- [ ] Régénérer après modifications
- [ ] Vérifier les nouveaux composants
- [ ] Mettre à jour les tests si nécessaire

---

## 🎯 Avantages

| Avantage | Description |
|----------|-------------|
| **Automatisation** | Plus besoin de lister manuellement les composants |
| **Exhaustivité** | Tous les composants sont catalogués |
| **Maintenabilité** | Facile de mettre à jour l'inventaire |
| **Réutilisabilité** | L'inventaire peut être utilisé dans tous les tests |
| **Documentation** | Génère automatiquement la documentation |
| **Tests Dynamiques** | Permet de générer des tests automatiquement |

---

## 🚀 Prochaines Étapes

1. **Générer l'inventaire initial** : `run-inventory.bat`
2. **Consulter les résultats** : `INVENTORY-REPORT.md`
3. **Utiliser dans les tests** : Importer `inventoryHelper`
4. **Créer des tests automatiques** : Utiliser les exemples fournis

---

## 📞 Support

### Problèmes Courants

**Erreur : "Inventaire non trouvé"**
→ Exécuter d'abord `run-inventory.bat`

**Erreur : "Application non accessible"**
→ Vérifier que l'application tourne sur le port 4201

**Timeout pendant l'inventaire**
→ Augmenter le timeout dans le test ou exclure les composants lents

### Documentation Complémentaire

- **Tests Playwright** : `.kiro/steering/11-playwright-e2e-testing.md`
- **Gate Playwright** : `.kiro/specs/00-palier-00-validation-infrastructure/GATE-PLAYWRIGHT-RESUME.md`
- **Tests Visuels** : `.kiro/specs/00-palier-00-validation-infrastructure/TESTS-VISUELS.md`

---

**Le système d'inventaire est maintenant prêt à être utilisé ! 🎉**

