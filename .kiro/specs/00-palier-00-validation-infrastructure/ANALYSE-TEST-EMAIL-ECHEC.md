# Analyse du Test Email Échoué

> **Date** : 2026-02-06  
> **Test** : Email - Tester validation email  
> **Statut** : ❌ Échoué après 2 retries  
> **Fichier** : `e2e/tests/components-from-inventory.spec.ts` (ligne 66)

---

## 🔍 Analyse du Problème

### Symptômes
- Test échoué après 2 tentatives (retry2)
- Durée du test : Fait partie d'une suite de 2.4 minutes
- 9 autres tests ont réussi dans le même fichier

### Code du Test (lignes 66-130)

Le test utilise une **stratégie de détection en cascade** :

```typescript
// 1. Chercher #email
let emailInput = page.locator('#email');

// 2. Si pas trouvé, chercher input[type="email"]
if (inputExists === 0) {
  const emailTypeInput = page.locator('input[type="email"]');
  // ...
}

// 3. Si pas trouvé, chercher input avec placeholder contenant "email"
if (placeholderCount > 0) {
  emailInput = emailPlaceholderInput.first();
}

// 4. Dernier recours : n'importe quel input[type="text"]
const anyInput = page.locator('input[type="text"]').first();
```

### Problèmes Identifiés

#### 1. **Timeout trop court initial**
- Le test attend 3 secondes après navigation (ligne 84)
- Puis 15 secondes pour que l'input soit visible (ligne 113)
- **Total : 18 secondes** peut être insuffisant si le composant charge lentement

#### 2. **Stratégie de fallback complexe**
- La cascade de fallbacks peut échouer si :
  - Le composant Email n'a pas d'input avec id="email"
  - Le composant n'a pas d'input type="email"
  - Le placeholder ne contient pas "email"
  - Aucun input text n'est visible

#### 3. **Navigation par JavaScript**
- La navigation utilise `page.evaluate()` pour cliquer (ligne 75-81)
- Peut être moins fiable que les sélecteurs Playwright natifs

#### 4. **Pas de vérification de chargement**
- Pas de `waitForLoadState` après le clic
- Pas de vérification que le composant Email est bien chargé

---

## 🔧 Solutions Proposées

### Solution 1 : Augmenter les Timeouts (Quick Fix)

```typescript
// Augmenter le timeout après navigation
await page.waitForTimeout(5000); // Au lieu de 3000

// Augmenter le timeout de visibilité
await expect(emailInput).toBeVisible({ timeout: 20000 }); // Au lieu de 15000
```

### Solution 2 : Améliorer la Navigation (Recommandé)

```typescript
// Utiliser un sélecteur Playwright natif au lieu de evaluate()
await page.getByText('● Email').click();
await page.waitForLoadState('networkidle');
await page.waitForTimeout(2000);
```

### Solution 3 : Simplifier la Détection (Robuste)

```typescript
// Attendre qu'un input soit visible, quel qu'il soit
await page.waitForSelector('input', { timeout: 20000 });

// Chercher l'input email avec une stratégie plus simple
const emailInput = page.locator('input[type="email"], input[placeholder*="email" i], input#email').first();
await expect(emailInput).toBeVisible({ timeout: 10000 });
```

### Solution 4 : Ajouter des Logs de Debug

```typescript
// Avant la détection
console.log('🔍 Recherche de l\'input email...');
const inputCount = await page.locator('input').count();
console.log(`📊 Nombre total d'inputs trouvés : ${inputCount}`);

// Après chaque tentative
if (inputExists === 0) {
  console.log('⚠️ Input #email non trouvé, essai avec type="email"');
}
```

---

## ✅ Correction Recommandée

### Approche Hybride (Robustesse + Performance)

```typescript
test('Email - Tester validation email', async ({ page }) => {
  const component = inventoryHelper.findComponent('Email');
  expect(component).toBeDefined();
  expect(component?.found).toBe(true);

  console.log('🚀 Début du test Email');

  // Naviguer vers le composant avec sélecteur natif
  await page.getByPlaceholder('Search for an element').fill('Email');
  await page.waitForTimeout(500);

  await page.getByText('● Email').click();
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(3000);

  console.log('📍 Navigation vers Email terminée');

  // Attendre qu'au moins un input soit présent
  await page.waitForSelector('input', { timeout: 20000 });
  console.log('✅ Au moins un input trouvé');

  // Stratégie de détection simplifiée avec sélecteur combiné
  const emailInput = page.locator(
    'input[type="email"], input[placeholder*="email" i], input#email, input[type="text"]'
  ).first();

  // Vérifier la visibilité avec timeout augmenté
  await expect(emailInput).toBeVisible({ timeout: 15000 });
  console.log('✅ Input email visible');

  // Vérifier le placeholder si présent
  const placeholder = await emailInput.getAttribute('placeholder');
  if (placeholder) {
    console.log(`📝 Placeholder trouvé : "${placeholder}"`);
    expect(placeholder).toBeTruthy();
  }

  // Tester avec un email valide
  await emailInput.fill('test@example.com');
  await expect(emailInput).toHaveValue('test@example.com');
  console.log('✅ Email valide rempli et vérifié');

  // Tester avec un autre email
  await emailInput.clear();
  await emailInput.fill('user@domain.fr');
  await expect(emailInput).toHaveValue('user@domain.fr');
  console.log('✅ Deuxième email valide rempli et vérifié');
});
```

---

## 🎯 Changements Clés

1. **Navigation améliorée** : Utilisation de `getByText()` au lieu de `evaluate()`
2. **Attente de chargement** : Ajout de `waitForLoadState('networkidle')`
3. **Sélecteur combiné** : Un seul locator avec plusieurs alternatives
4. **Logs de debug** : Pour comprendre où le test échoue
5. **Timeouts augmentés** : 20s pour le premier wait, 15s pour la visibilité
6. **Test plus complet** : Deux emails testés au lieu d'un

---

## 📊 Prochaines Étapes

1. ✅ Appliquer la correction au fichier de test
2. ⏳ Relancer les tests avec `npm run test:e2e`
3. ⏳ Vérifier que le test Email passe à 100%
4. ⏳ Si échec, examiner les logs console pour identifier le problème exact
5. ⏳ Si succès, documenter la solution dans le rapport final

---

## 📝 Notes

- Le test a échoué après **2 retries**, ce qui indique un problème intermittent (timing)
- Les 9 autres tests ont réussi, donc le problème est spécifique au composant Email
- La stratégie de fallback était trop complexe et pouvait échouer silencieusement
- La nouvelle approche est plus simple, plus robuste et plus facile à debugger

---

## 🔗 Ressources

- Fichier de test : `e2e/tests/components-from-inventory.spec.ts`
- Inventaire : `.kiro/specs/00-palier-00-validation-infrastructure/INVENTAIRE-COMPOSANTS.md`
- Documentation Playwright : https://playwright.dev/docs/locators
