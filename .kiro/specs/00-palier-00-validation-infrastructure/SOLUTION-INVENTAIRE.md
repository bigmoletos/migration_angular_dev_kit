# 🎯 Solution au Problème d'Inventaire

> **Date** : 2026-02-05  
> **Problème** : Timeout sur tous les clics (0/69 composants trouvés)  
> **Solution** : Clics JavaScript via `page.evaluate()`

---

## 🔴 Problème Identifié

### Erreur Observée

```
Error: locator.click: Timeout 10000ms exceeded.
- <a id="complextechnical" class="ng-star-inserted">…</a> intercepts pointer events
- <a id="forminputwrapper" class="ng-star-inserted">…</a> intercepts pointer events
```

### Cause Racine

Les éléments `<span>` dans l'arbre de navigation sont **interceptés** par des éléments `<a>` qui se trouvent devant eux dans le DOM. Playwright ne peut pas cliquer sur les `<span>` car les `<a>` bloquent les événements de clic.

**Structure DOM problématique** :
```html
<a id="complextechnical">
  <span>● Amount</span>  <!-- Playwright ne peut pas cliquer ici -->
</a>
```

---

## ✅ Solution Implémentée

### Approche : Clics JavaScript

Au lieu d'utiliser `.click()` de Playwright (qui simule un vrai clic utilisateur), on utilise `page.evaluate()` pour cliquer **directement via JavaScript**, contournant ainsi le problème d'interception.

### Code de la Solution

```typescript
// Chercher et cliquer sur le composant avec JavaScript
const clicked = await page.evaluate((name) => {
  // Chercher tous les spans contenant le nom
  const spans = Array.from(document.querySelectorAll('span'));
  const targetSpan = spans.find(span => {
    const text = span.textContent?.trim() || '';
    return text === `● ${name}` || text === name;
  });

  if (targetSpan) {
    // Cliquer directement via JavaScript (contourne l'interception)
    targetSpan.click();
    return true;
  }
  return false;
}, compName);
```

### Pourquoi ça Fonctionne ?

| Méthode | Comportement | Problème |
|---------|--------------|----------|
| **`.click()` Playwright** | Simule un vrai clic utilisateur | ❌ Bloqué par les éléments qui interceptent |
| **`.click()` JavaScript** | Déclenche l'événement directement | ✅ Ignore les éléments qui interceptent |

---

## 📁 Fichiers Créés

### 1. Test d'Inventaire avec JS Click

**Fichier** : `e2e/tests/demo-inventory-js-click.spec.ts`

**Fonctionnalités** :
- ✅ Clics JavaScript pour contourner l'interception
- ✅ Recherche via `#searchInput` pour trouver les composants
- ✅ Capture des inputs, buttons, selects, textareas, checkboxes, radios
- ✅ Capture des éléments custom (classes `pwc-`, `shared-`, `ui-`)
- ✅ Screenshots de chaque composant
- ✅ Génération de `inventory.json` et `INVENTORY-REPORT.md`

### 2. Script de Lancement

**Fichier** : `C:\repo_hps\outils_communs\run-inventory-js-click.bat`

**Usage** :
```batch
# Double-cliquer sur le fichier .bat
# Ou lancer depuis PowerShell :
C:\repo_hps\outils_communs\run-inventory-js-click.bat
```

---

## 🚀 Comment Lancer le Test

### Prérequis

1. **Application en cours d'exécution** sur `http://localhost:4201`
   ```powershell
   # Lancer avec le raccourci
   pwc3
   
   # Ou manuellement
   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
   npm start
   ```

2. **Node.js version 10** activée
   ```powershell
   Use-Node10
   node --version  # Doit afficher v10.24.1
   ```

### Lancement du Test

**Option 1 : Script Batch (Recommandé)**
```batch
C:\repo_hps\outils_communs\run-inventory-js-click.bat
```

**Option 2 : Commande Manuelle**
```powershell
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npx playwright test e2e/tests/demo-inventory-js-click.spec.ts --headed --workers=1 --timeout=600000
```

### Paramètres du Test

- `--headed` : Mode visible (voir le navigateur)
- `--workers=1` : Un seul worker (évite les conflits)
- `--timeout=600000` : Timeout de 10 minutes (69 composants à explorer)

---

## 📊 Résultats Attendus

### Fichiers Générés

| Fichier | Description | Emplacement |
|---------|-------------|-------------|
| **`inventory.json`** | Données brutes de l'inventaire | `e2e/inventory.json` |
| **`INVENTORY-REPORT.md`** | Rapport lisible en Markdown | `e2e/INVENTORY-REPORT.md` |
| **Screenshots** | Captures d'écran de chaque composant | `e2e/screenshots/inventory/*.png` |

### Structure de `inventory.json`

```json
{
  "generatedAt": "2026-02-05T...",
  "baseUrl": "http://localhost:4201",
  "totalComponents": 69,
  "foundComponents": 45,  // Attendu : >50%
  "notFoundComponents": 24,
  "components": [
    {
      "name": "Amount",
      "found": true,
      "hasForm": true,
      "inputs": [
        { "id": "amount1", "type": "text", "placeholder": "" }
      ],
      "buttons": [
        { "id": "submit", "text": "Validate" }
      ],
      "selects": [],
      "textareas": [],
      "checkboxes": [],
      "radios": [],
      "customElements": ["pwc-amount", "ui-inputtext"],
      "screenshot": "e2e/screenshots/inventory/Amount.png"
    }
  ]
}
```

### Statistiques Attendues

- **Total composants** : 69
- **Trouvés** : >50% (au lieu de 0%)
- **Inputs** : ~150
- **Buttons** : ~80
- **Screenshots** : Un par composant trouvé

---

## 🔍 Analyse des Résultats

### Après l'Exécution

1. **Ouvrir `inventory.json`** pour voir les données brutes
2. **Ouvrir `INVENTORY-REPORT.md`** pour le rapport lisible
3. **Vérifier les screenshots** dans `e2e/screenshots/inventory/`

### Composants Non Trouvés

Si certains composants ne sont pas trouvés, c'est normal :
- Ils peuvent ne pas être dans l'arbre de navigation
- Ils peuvent avoir un nom différent dans l'interface
- Ils peuvent être dans une catégorie non développée

**Solution** : Compléter manuellement l'inventaire pour ces composants.

---

## 📝 Utilisation de l'Inventaire

### Avec le Helper TypeScript

```typescript
import { inventoryHelper } from '../utils/inventory-helper';

test('Tester Amount', async ({ page }) => {
  // Charger le composant depuis l'inventaire
  const component = inventoryHelper.findComponent('Amount');
  
  if (component && component.found) {
    await page.goto('http://localhost:4201');
    
    // Utiliser les inputs de l'inventaire
    for (const input of component.inputs) {
      await page.locator(`#${input.id}`).fill('123.45');
    }
    
    // Utiliser les buttons de l'inventaire
    for (const button of component.buttons) {
      await page.locator(`#${button.id}`).click();
    }
  }
});
```

### Tester Tous les Composants avec Formulaires

```typescript
test('Tester tous les formulaires', async ({ page }) => {
  const inventory = inventoryHelper.loadInventory();
  const formComponents = inventory.components.filter(c => c.hasForm);
  
  console.log(`Found ${formComponents.length} components with forms`);
  
  for (const comp of formComponents) {
    console.log(`Testing: ${comp.name}`);
    // Tests...
  }
});
```

---

## ✅ Avantages de cette Solution

| Critère | Ancienne Méthode | Nouvelle Méthode |
|---------|------------------|------------------|
| **Clics réussis** | ❌ 0% (timeout) | ✅ >50% attendu |
| **Vitesse** | ❌ Lent (timeouts) | ✅ Rapide (pas d'attente) |
| **Fiabilité** | ❌ Bloqué par interception | ✅ Contourne l'interception |
| **Maintenance** | ❌ Difficile | ✅ Facile |

---

## 🎯 Prochaines Étapes

1. **Lancer le test** avec le script batch
2. **Analyser les résultats** dans `inventory.json`
3. **Vérifier le rapport** dans `INVENTORY-REPORT.md`
4. **Compléter manuellement** les composants non trouvés (si nécessaire)
5. **Utiliser l'inventaire** dans les tests futurs avec le helper

---

## 📞 Support

Si le test échoue encore :
1. Vérifier que l'application tourne sur `http://localhost:4201`
2. Vérifier que Node.js v10 est activé (`Use-Node10`)
3. Vérifier les logs du test pour identifier les erreurs
4. Consulter les screenshots pour voir ce qui a été capturé

---

## 🎉 Conclusion

La solution avec **clics JavaScript** devrait résoudre le problème d'interception et permettre de créer un inventaire complet des composants pwc-ui-shared. Cet inventaire sera ensuite utilisable pour tous les tests Playwright futurs, facilitant grandement l'automatisation des tests E2E.

**Prêt à lancer le test !** 🚀
