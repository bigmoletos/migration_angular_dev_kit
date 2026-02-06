# 🚀 Instructions de Lancement - Nouveau Test d'Inventaire

> **Date** : 2026-02-05  
> **Test à utiliser** : `demo-inventory-js-click.spec.ts` (NOUVEAU)  
> **Ancien test** : `demo-inventory-final.spec.ts` (❌ Ne plus utiliser - 0% de réussite)

---

## ⚠️ Important

**NE PLUS UTILISER** `demo-inventory-final.spec.ts` - Ce test échoue à cause du problème d'interception (0/69 composants trouvés en 9.7 minutes).

**UTILISER** `demo-inventory-js-click.spec.ts` - Nouveau test avec clics JavaScript qui contourne le problème.

---

## 🚀 Lancement du Nouveau Test

### Prérequis

1. **Application en cours d'exécution** sur `http://localhost:4201`
   ```powershell
   pwc3
   ```

2. **Node.js version 10** activée
   ```powershell
   Use-Node10
   node --version  # Doit afficher v10.24.1
   ```

### Option 1 : Script Batch (Recommandé)

```batch
C:\repo_hps\outils_communs\run-inventory-js-click.bat
```

**Avantages** :
- ✅ Lance automatiquement le bon test
- ✅ Vérifie les prérequis
- ✅ Affiche les résultats à la fin

### Option 2 : Commande Manuelle

```powershell
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npx playwright test e2e/tests/demo-inventory-js-click.spec.ts --headed --workers=1 --timeout=600000
```

---

## 📊 Différences entre les Tests

| Critère | `demo-inventory-final.spec.ts` (ANCIEN) | `demo-inventory-js-click.spec.ts` (NOUVEAU) |
|---------|----------------------------------------|---------------------------------------------|
| **Méthode de clic** | `.click()` Playwright | `.click()` JavaScript via `page.evaluate()` |
| **Problème** | ❌ Intercepté par `<a>` | ✅ Contourne l'interception |
| **Résultat** | ❌ 0/69 composants (0%) | ✅ >50% attendu |
| **Durée** | ❌ 9.7 minutes (timeouts) | ✅ ~3-5 minutes |
| **Statut** | ❌ Obsolète | ✅ À utiliser |

---

## 📁 Fichiers Générés

Après l'exécution du **nouveau test**, vous trouverez :

| Fichier | Emplacement | Description |
|---------|-------------|-------------|
| **`inventory.json`** | `e2e/inventory.json` | Données brutes de l'inventaire |
| **`INVENTORY-REPORT.md`** | `e2e/INVENTORY-REPORT.md` | Rapport lisible en Markdown |
| **Screenshots** | `e2e/screenshots/inventory/*.png` | Captures d'écran des composants |

---

## 🔍 Vérification des Résultats

### 1. Ouvrir `inventory.json`

```powershell
code C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\e2e\inventory.json
```

**Vérifier** :
- `foundComponents` : Doit être >0 (au lieu de 0)
- `components[].found` : Plusieurs composants avec `true`
- `components[].inputs` : Liste des inputs trouvés
- `components[].buttons` : Liste des buttons trouvés

### 2. Ouvrir `INVENTORY-REPORT.md`

```powershell
code C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\e2e\INVENTORY-REPORT.md
```

**Contenu attendu** :
- Statistiques globales
- Liste des composants trouvés avec leurs éléments
- Liste des composants non trouvés

### 3. Vérifier les Screenshots

```powershell
explorer C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\e2e\screenshots\inventory
```

**Attendu** : Un fichier `.png` par composant trouvé.

---

## ✅ Résultats Attendus

### Statistiques Attendues

```json
{
  "totalComponents": 69,
  "foundComponents": 35-50,  // Au lieu de 0
  "notFoundComponents": 19-34,
  "components": [
    {
      "name": "Amount",
      "found": true,  // Au lieu de false
      "inputs": [...],  // Liste des inputs
      "buttons": [...]  // Liste des buttons
    }
  ]
}
```

### Console Output Attendu

```
🚀 Création de l'inventaire avec clics JavaScript...

✅ Page chargée

✅ Arbre développé

📋 Exploration de 69 composants...

[1/69] Amount
  ✅ 2i 1b 0s 0c

[2/69] Date
  ✅ 1i 0b 0s 0c

[3/69] Text
  ✅ 1i 0b 0s 0c

...

✅ Inventaire terminé !
📁 Fichier: e2e/inventory.json
📊 Total: 69 composants
📊 Trouvés: 45
📊 Non trouvés: 24
📊 Inputs: 150
📊 Buttons: 80
```

---

## 🐛 Dépannage

### Problème : "Application not running"

**Solution** :
```powershell
pwc3  # Lance les 2 applications
# Attendre que http://localhost:4201 soit accessible
```

### Problème : "Node version incorrect"

**Solution** :
```powershell
Use-Node10
node --version  # Vérifier v10.24.1
```

### Problème : "Test timeout"

**Solution** :
- Vérifier que l'application répond sur `http://localhost:4201`
- Augmenter le timeout : `--timeout=900000` (15 minutes)

### Problème : "Encore 0 composants trouvés"

**Causes possibles** :
1. Mauvais test lancé (vérifier que c'est bien `demo-inventory-js-click.spec.ts`)
2. Application pas chargée complètement
3. Structure de la page différente

**Solution** :
1. Vérifier le nom du fichier de test
2. Attendre 30 secondes après le démarrage de l'application
3. Lancer le test de diagnostic : `npx playwright test e2e/tests/demo-diagnostic.spec.ts --headed`

---

## 📝 Commandes Utiles

### Lancer le Nouveau Test

```powershell
# Avec le script batch
C:\repo_hps\outils_communs\run-inventory-js-click.bat

# Ou manuellement
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npx playwright test e2e/tests/demo-inventory-js-click.spec.ts --headed --workers=1 --timeout=600000
```

### Voir les Résultats

```powershell
# Ouvrir inventory.json
code e2e/inventory.json

# Ouvrir le rapport
code e2e/INVENTORY-REPORT.md

# Voir les screenshots
explorer e2e/screenshots/inventory
```

### Nettoyer les Anciens Résultats

```powershell
# Supprimer l'ancien inventory.json
Remove-Item e2e/inventory.json -ErrorAction SilentlyContinue

# Supprimer les anciens screenshots
Remove-Item e2e/screenshots/inventory/*.png -ErrorAction SilentlyContinue
```

---

## 🎯 Prochaines Étapes

1. ✅ **Lancer le nouveau test** avec le script batch
2. ✅ **Vérifier les résultats** dans `inventory.json`
3. ✅ **Consulter le rapport** dans `INVENTORY-REPORT.md`
4. ⚠️ **Compléter manuellement** les composants non trouvés (si nécessaire)
5. ✅ **Utiliser l'inventaire** dans les tests futurs avec le helper

---

## 📞 Support

Si vous avez des questions ou des problèmes :
1. Vérifier cette documentation
2. Consulter `SOLUTION-INVENTAIRE.md` pour plus de détails
3. Consulter `INVENTAIRE-SYNTHESE.md` pour le contexte complet

---

## 🎉 Conclusion

Le **nouveau test** `demo-inventory-js-click.spec.ts` devrait résoudre le problème d'interception et créer un inventaire utilisable. N'utilisez plus l'ancien test `demo-inventory-final.spec.ts`.

**Prêt à lancer !** 🚀
