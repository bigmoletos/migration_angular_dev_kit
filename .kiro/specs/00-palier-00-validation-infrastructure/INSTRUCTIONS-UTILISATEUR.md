# 📋 Instructions Utilisateur - Gate Playwright Palier 0

> **Date** : 2026-02-05  
> **Durée estimée** : 30-45 minutes

---

## 🎯 Ce que vous devez faire

Valider que les applications fonctionnent correctement sur Angular 5 actuel en exécutant les tests Playwright.

---

## ⚡ Actions Rapides (TL;DR)

```powershell
# 1. Installer Playwright dans pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm install --save-dev @playwright/test@^1.40.0 --legacy-peer-deps

# 2. Tester pwc-ui-shared (Terminal 1)
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start

# 3. Tester pwc-ui-shared (Terminal 2)
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm run test:e2e

# 4. Si tests OK, tester pwc-ui (Terminal 1)
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start

# 5. Tester pwc-ui (Terminal 2)
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm run test:e2e
```

---

## 📝 Instructions Détaillées

### Étape 1 : Installer Playwright dans pwc-ui

```powershell
# Ouvrir PowerShell
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Installer Playwright
npm install --save-dev @playwright/test@^1.40.0 --legacy-peer-deps
```

**Durée** : 2-5 minutes

**Résultat attendu** :
```
added 1 package, and audited X packages in Ys
```

---

### Étape 2 : Tester pwc-ui-shared

#### 2.1 Démarrer l'application (Terminal 1)

```powershell
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start
```

**Attendre** : L'application démarre sur http://localhost:4201

**Résultat attendu** :
```
webpack: Compiled successfully.
```

**⚠️ Laisser ce terminal ouvert**

#### 2.2 Exécuter les tests (Terminal 2)

```powershell
# Ouvrir un NOUVEAU terminal PowerShell
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm run test:e2e
```

**Durée** : 1-2 minutes

**Résultat attendu** :
```
Running 18 tests using 1 worker

  ✓ demo-home.spec.ts:... (6 tests)
  ✓ demo-forms.spec.ts:... (5 tests)
  ✓ demo-navigation.spec.ts:... (7 tests)

  18 passed (XXs)
```

**🚦 GATE** :
- ✅ **Si 18 tests passent** : Continuer à l'étape 3
- ❌ **Si des tests échouent** : Voir section "Que faire si les tests échouent ?"

---

### Étape 3 : Tester pwc-ui

#### 3.1 Arrêter pwc-ui-shared

Dans le Terminal 1 (où tourne pwc-ui-shared) :
- Appuyer sur `Ctrl+C` pour arrêter l'application

#### 3.2 Démarrer pwc-ui (Terminal 1)

```powershell
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start
```

**Attendre** : L'application démarre sur http://localhost:4200

**Résultat attendu** :
```
webpack: Compiled successfully.
```

**⚠️ Laisser ce terminal ouvert**

#### 3.3 Exécuter les tests (Terminal 2)

```powershell
# Dans le Terminal 2
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm run test:e2e
```

**Durée** : 1-2 minutes

**Résultat attendu** :
```
Running 13 tests using 1 worker

  ✓ app-home.spec.ts:... (6 tests)
  ✓ app-forms.spec.ts:... (3 tests)
  ✓ app-navigation.spec.ts:... (4 tests)

  13 passed (XXs)
```

**Résultat** :
- ✅ **Si 13 tests passent** : Palier 0 validé ! 🎉
- ❌ **Si des tests échouent** : Voir section "Que faire si les tests échouent ?"

---

## 🐛 Que faire si les tests échouent ?

### Option 1 : Mode UI Interactif (Recommandé)

```powershell
npm run test:e2e:ui
```

**Avantages** :
- Interface graphique
- Voir les tests en temps réel
- Inspecter les éléments
- Rejouer les tests facilement

### Option 2 : Voir le Rapport HTML

```powershell
npm run test:e2e:report
```

**Contenu** :
- Screenshots des échecs
- Vidéos des échecs
- Logs console
- Traces d'exécution

### Option 3 : Analyser les Logs

Les logs des tests affichent :
- Quel test a échoué
- L'erreur exacte
- Le fichier et la ligne

**Exemple** :
```
✗ demo-home.spec.ts:10:3 › devrait afficher la page d'accueil
  Error: Timeout 30000ms exceeded
```

### Problèmes Courants

#### Problème 1 : Port déjà utilisé

**Erreur** : `Port 4201 is already in use`

**Solution** :
```powershell
# Trouver le processus
netstat -ano | findstr :4201

# Tuer le processus (remplacer <PID> par le numéro)
taskkill /PID <PID> /F
```

#### Problème 2 : Application ne démarre pas

**Erreur** : Erreurs de compilation

**Solution** :
```powershell
# Nettoyer et réinstaller
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install
```

#### Problème 3 : Tests timeout

**Erreur** : `Timeout 30000ms exceeded`

**Solution** :
- Vérifier que l'application est bien démarrée
- Vérifier qu'il n'y a pas d'erreurs console
- Augmenter le timeout dans `playwright.config.ts` si nécessaire

---

## 📊 Résultats Attendus

### pwc-ui-shared

```
Running 18 tests using 1 worker

  ✓ demo-home.spec.ts:7:3 › devrait afficher le titre PowerCARD Sandbox
  ✓ demo-home.spec.ts:12:3 › devrait afficher la page d'accueil
  ✓ demo-home.spec.ts:23:3 › devrait avoir un header ou menu de navigation
  ✓ demo-home.spec.ts:29:3 › devrait charger sans erreurs console critiques
  ✓ demo-home.spec.ts:50:3 › devrait charger les ressources principales
  ✓ demo-home.spec.ts:56:3 › devrait avoir une structure HTML valide
  
  ✓ demo-forms.spec.ts:9:3 › devrait afficher des composants de formulaire
  ✓ demo-forms.spec.ts:17:3 › devrait avoir des inputs interactifs
  ✓ demo-forms.spec.ts:42:3 › devrait avoir des boutons cliquables
  ✓ demo-forms.spec.ts:53:3 › devrait naviguer vers une page de démo
  ✓ demo-forms.spec.ts:70:3 › devrait afficher des labels de formulaire
  
  ✓ demo-navigation.spec.ts:9:3 › devrait naviguer vers la page catalog
  ✓ demo-navigation.spec.ts:17:3 › devrait naviguer vers une page de composant (date)
  ✓ demo-navigation.spec.ts:28:3 › devrait naviguer vers une page de composant (text)
  ✓ demo-navigation.spec.ts:39:3 › devrait naviguer vers une page de composant (amount)
  ✓ demo-navigation.spec.ts:50:3 › devrait gérer les routes invalides
  ✓ demo-navigation.spec.ts:57:3 › devrait permettre la navigation entre plusieurs pages
  ✓ demo-navigation.spec.ts:73:3 › devrait charger les modules lazy-loaded

  18 passed (10-15s)
```

### pwc-ui

```
Running 13 tests using 1 worker

  ✓ app-home.spec.ts:9:3 › devrait afficher le titre de l'application
  ✓ app-home.spec.ts:13:3 › devrait afficher la page d'accueil
  ✓ app-home.spec.ts:24:3 › devrait avoir une structure de navigation
  ✓ app-home.spec.ts:30:3 › devrait charger sans erreurs console critiques
  ✓ app-home.spec.ts:51:3 › devrait charger les ressources principales
  ✓ app-home.spec.ts:57:3 › devrait avoir une structure HTML valide
  
  ✓ app-forms.spec.ts:9:3 › devrait afficher des éléments de formulaire
  ✓ app-forms.spec.ts:17:3 › devrait avoir des inputs interactifs
  ✓ app-forms.spec.ts:43:3 › devrait avoir des boutons
  
  ✓ app-navigation.spec.ts:9:3 › devrait charger la page d'accueil
  ✓ app-navigation.spec.ts:17:3 › devrait permettre la navigation de base
  ✓ app-navigation.spec.ts:29:3 › devrait avoir des liens de navigation
  ✓ app-navigation.spec.ts:37:3 › devrait charger les modules lazy-loaded

  13 passed (8-12s)
```

---

## 📝 Documenter les Résultats

### Mettre à jour le Journal de Bord

Ouvrir `Documentation/JOURNAL-DE-BORD.md` et ajouter :

```markdown
## 2026-02-05 - Palier 0 - Gate Playwright

**Contexte** : Validation de l'infrastructure de tests E2E

**Actions** :
- Installation de Playwright dans pwc-ui
- Création de 31 tests E2E (18 pour shared, 13 pour ui)
- Exécution des tests sur Angular 5 actuel

**Résultats** :
- pwc-ui-shared : 18/18 tests passent ✅
- pwc-ui : 13/13 tests passent ✅

**Problèmes** : [Décrire les problèmes rencontrés]

**Solutions** : [Décrire les solutions appliquées]

**Temps** : XX minutes

---
```

---

## ✅ Checklist Finale

- [ ] Playwright installé dans pwc-ui
- [ ] pwc-ui-shared : 18 tests passent à 100%
- [ ] pwc-ui : 13 tests passent à 100%
- [ ] Rapports HTML générés
- [ ] Résultats documentés dans le journal de bord
- [ ] Screenshots/vidéos sauvegardés (si échecs)

---

## 🎉 Félicitations !

Si tous les tests passent, le **Palier 0 est validé** ! Vous êtes prêt à commencer la migration Angular 5 → 6 (Palier 1).

---

## 📚 Ressources

- **Documentation complète** : `.kiro/steering/11-playwright-e2e-testing.md`
- **Résumé du Gate** : `.kiro/specs/00-palier-00-validation-infrastructure/GATE-PLAYWRIGHT-RESUME.md`
- **Design Palier 0** : `.kiro/specs/00-palier-00-validation-infrastructure/design.md`

---

## 🆘 Besoin d'Aide ?

Si vous rencontrez des problèmes :

1. Consulter la section "Que faire si les tests échouent ?"
2. Utiliser le mode UI interactif : `npm run test:e2e:ui`
3. Voir le rapport HTML : `npm run test:e2e:report`
4. Demander à Kiro : "J'ai un problème avec les tests Playwright"

---

**Bonne chance ! 🚀**
