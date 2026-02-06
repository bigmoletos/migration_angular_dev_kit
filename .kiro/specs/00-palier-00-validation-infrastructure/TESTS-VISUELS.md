# 🎬 Tests Playwright Visuels - Mode Démonstration

> **Date** : 2026-02-05  
> **Objectif** : Voir Playwright en action avec le navigateur visible

---

## 🎯 Qu'est-ce qu'un Test Visuel ?

Un test visuel Playwright s'exécute avec le navigateur **visible** (mode `--headed`) et inclut des **pauses** (`page.pause()`) pour observer le comportement de l'application.

### Avantages

- ✅ **Voir l'application** : Le navigateur s'ouvre et vous voyez les pages
- ✅ **Comprendre les tests** : Chaque étape est visible
- ✅ **Débugger facilement** : Pause à chaque étape importante
- ✅ **Inspecter les éléments** : Utiliser les DevTools pendant les pauses

---

## 📁 Fichiers Créés

### Test Visuel

**Fichier** : `e2e/tests/demo-visual.spec.ts`

**Contenu** : 3 tests avec pauses visuelles
1. **Démonstration de navigation** : Parcourt plusieurs pages (/, /catalog, /date, /amount, /text)
2. **Exploration des éléments** : Compte les liens, boutons, inputs
3. **Test d'interaction** : Remplit un formulaire

### Script de Lancement

**Fichier** : `outils_communs/run-playwright-visual.bat`

**Fonction** : Lance les tests visuels automatiquement avec Node 10

---

## 🚀 Comment Lancer les Tests Visuels

### Méthode 1 : Script Batch (Recommandé)

**Double-cliquer** sur le fichier :
```
C:\repo_hps\outils_communs\run-playwright-visual.bat
```

Le script va :
1. Basculer vers Node 10
2. Aller dans pwc-ui-shared
3. Lancer les tests en mode headed

### Méthode 2 : Ligne de Commande

```powershell
# 1. Basculer vers Node 10
Use-Node10

# 2. Aller dans le repo
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# 3. Lancer les tests visuels
npx playwright test e2e/tests/demo-visual.spec.ts --headed --workers=1
```

### Méthode 3 : Mode UI Interactif (Le Plus Visuel)

```powershell
# 1. Basculer vers Node 10
Use-Node10

# 2. Aller dans le repo
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# 3. Lancer le mode UI
npx playwright test e2e/tests/demo-visual.spec.ts --ui
```

**Avantage** : Interface graphique complète avec timeline, screenshots, etc.

---

## 🎬 Déroulement d'un Test Visuel

### Test 1 : Démonstration de Navigation

```
1. 🚀 Démarrage du test
   ↓
2. 📍 Chargement de la page d'accueil (/)
   ↓
3. ⏸️  PAUSE - Vous voyez la page d'accueil
   ↓ (Cliquer sur "Resume" dans Playwright Inspector)
4. 📍 Navigation vers /catalog
   ↓
5. ⏸️  PAUSE - Vous voyez la page catalog
   ↓
6. 📍 Navigation vers /date
   ↓
7. ⏸️  PAUSE - Vous voyez le composant date
   ↓
8. 📍 Navigation vers /amount
   ↓
9. ⏸️  PAUSE - Vous voyez le composant amount
   ↓
10. 📍 Navigation vers /text
    ↓
11. ⏸️  PAUSE - Vous voyez le composant text
    ↓
12. ✅ Test terminé
```

### Pendant les Pauses

Quand le test est en pause, vous pouvez :
- **Observer** : Voir la page dans le navigateur
- **Inspecter** : Ouvrir les DevTools (F12)
- **Explorer** : Cliquer sur les éléments
- **Continuer** : Cliquer sur "Resume" dans Playwright Inspector

---

## 🛠️ Playwright Inspector

### Qu'est-ce que c'est ?

Une fenêtre qui s'ouvre automatiquement pendant les tests en mode `--headed` ou `--debug`.

### Fonctionnalités

| Bouton | Action |
|--------|--------|
| **Resume** | Continuer le test |
| **Step Over** | Exécuter la prochaine ligne |
| **Step Into** | Entrer dans une fonction |
| **Step Out** | Sortir d'une fonction |
| **Pause** | Mettre en pause |

### Console

Affiche les logs du test :
```
🚀 Démarrage du test visuel...
📍 Étape 1 : Chargement de la page d'accueil
⏸️  PAUSE - Regardez la page d'accueil
```

---

## 📊 Logs Console

Les tests visuels affichent des logs détaillés :

```
🚀 Démarrage du test visuel...
📍 Étape 1 : Chargement de la page d'accueil
⏸️  PAUSE - Regardez la page d'accueil
📍 Étape 2 : Navigation vers /catalog
⏸️  PAUSE - Regardez la page catalog
📍 Étape 3 : Navigation vers /date
⏸️  PAUSE - Regardez le composant date
📍 Étape 4 : Navigation vers /amount
⏸️  PAUSE - Regardez le composant amount
📍 Étape 5 : Navigation vers /text
⏸️  PAUSE - Regardez le composant text
✅ Test visuel terminé !
```

---

## 🎯 Cas d'Usage

### 1. Démonstration

Montrer comment Playwright fonctionne à quelqu'un :
```powershell
# Lancer le test visuel
run-playwright-visual.bat
```

### 2. Debugging

Comprendre pourquoi un test échoue :
```powershell
# Mode debug avec pauses
npx playwright test e2e/tests/demo-visual.spec.ts --debug
```

### 3. Développement

Créer de nouveaux tests en voyant le résultat :
```powershell
# Mode UI pour développer
npx playwright test e2e/tests/demo-visual.spec.ts --ui
```

---

## 🔧 Personnalisation

### Ajouter des Pauses

Dans n'importe quel test, ajoutez :
```typescript
await page.pause();
```

### Ajouter des Logs

```typescript
console.log('🔍 Recherche d\'un élément...');
console.log('✅ Élément trouvé !');
console.log('⏸️  PAUSE pour observer');
```

### Ralentir l'Exécution

```powershell
# Ralentir de 1000ms entre chaque action
npx playwright test --headed --slow-mo=1000
```

---

## 📋 Checklist Avant de Lancer

- [ ] Application pwc-ui-shared démarrée sur port 4201
- [ ] Node 10 actif (`Use-Node10`)
- [ ] Playwright installé (`npm install`)
- [ ] Navigateur Chrome/Edge disponible

---

## ⚠️ Problèmes Courants

### Problème 1 : Application non démarrée

**Erreur** : `Error: page.goto: net::ERR_CONNECTION_REFUSED`

**Solution** :
```powershell
# Terminal 1 : Démarrer l'application
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start
```

### Problème 2 : Navigateur ne s'ouvre pas

**Erreur** : Tests s'exécutent mais pas de navigateur visible

**Solution** : Vérifier que `--headed` est bien dans la commande :
```powershell
npx playwright test --headed
```

### Problème 3 : Playwright Inspector ne s'ouvre pas

**Solution** : Utiliser `--debug` au lieu de `--headed` :
```powershell
npx playwright test --debug
```

---

## 🎓 Apprendre Playwright

### Commandes Utiles

```powershell
# Mode headed (navigateur visible)
npx playwright test --headed

# Mode debug (avec Inspector)
npx playwright test --debug

# Mode UI (interface complète)
npx playwright test --ui

# Ralenti
npx playwright test --headed --slow-mo=1000

# Un seul test
npx playwright test demo-visual.spec.ts --headed

# Avec rapport
npx playwright test --headed --reporter=html
```

### Documentation

- **Playwright Docs** : https://playwright.dev/
- **Debugging Guide** : https://playwright.dev/docs/debug
- **Inspector** : https://playwright.dev/docs/inspector

---

## 🎉 Résumé

Les tests visuels permettent de :
- ✅ **Voir** Playwright en action
- ✅ **Comprendre** comment les tests fonctionnent
- ✅ **Débugger** facilement
- ✅ **Démontrer** les capacités de Playwright

**Lancez le test visuel maintenant** :
```
C:\repo_hps\outils_communs\run-playwright-visual.bat
```

---

**Amusez-vous bien avec Playwright ! 🚀**
