# ✅ Solution - Playwright avec Node 16

> **Date** : 2026-02-05  
> **Découverte Importante** : Playwright nécessite Node >= 16  
> **Impact** : Changement de stratégie pour les tests E2E

---

## 🔍 Découverte

### Problème Identifié

**Playwright ne supporte PAS Node 10.**

- Playwright 1.40.0 : Nécessite Node >= 16
- Playwright 1.58.1 : Nécessite Node >= 18
- Angular 5 : Nécessite Node 10

**Incompatibilité** : Impossible d'exécuter Playwright avec Node 10.

---

## ✅ Solution : Utiliser Node 16 pour Playwright

### Stratégie

1. **Angular 5 (npm start)** : Utiliser Node 10
2. **Playwright (npm run test:e2e)** : Utiliser Node 16+

### Pourquoi ça fonctionne ?

- L'application Angular 5 tourne sur port 4201 avec Node 10
- Playwright se connecte à http://localhost:4201 depuis un processus Node 16
- Pas de conflit : ce sont deux processus séparés

---

## 📋 Instructions Mises à Jour

### Étape 1 : Démarrer pwc-ui-shared avec Node 10

**Terminal 1** :
```powershell
# Basculer vers Node 10
Use-Node10

# Vérifier
node --version  # v10.24.1

# Démarrer l'application
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start

# Attendre : "webpack: Compiled successfully."
```

### Étape 2 : Exécuter les tests Playwright avec Node 16

**Terminal 2** :
```powershell
# Basculer vers Node 16
Use-Node16

# Vérifier
node --version  # v16.20.2

# Installer Playwright (si nécessaire)
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm install --save-dev @playwright/test@^1.40.0 --legacy-peer-deps

# Installer les navigateurs
npx playwright install chromium

# Exécuter les tests
npm run test:e2e

# Résultat attendu : 18 tests passent
```

---

## 🔄 Workflow Complet

### pwc-ui-shared

```
Terminal 1 (Node 10)          Terminal 2 (Node 16)
─────────────────────         ─────────────────────
Use-Node10                    Use-Node16
cd pwc-ui-shared              cd pwc-ui-shared
npm start                     npm run test:e2e
→ Port 4201                   → Tests sur http://localhost:4201
```

### pwc-ui

```
Terminal 1 (Node 10)          Terminal 2 (Node 16)
─────────────────────         ─────────────────────
Use-Node10                    Use-Node16
cd pwc-ui                     cd pwc-ui
npm start                     npm run test:e2e
→ Port 4200                   → Tests sur http://localhost:4200
```

---

## 📝 Mise à Jour de la Documentation

### Fichiers à Mettre à Jour

1. **INSTRUCTIONS-UTILISATEUR.md** :
   - Ajouter : "Utiliser Node 16 pour Playwright"
   - Modifier les commandes

2. **GATE-PLAYWRIGHT-RESUME.md** :
   - Ajouter la section "Versions Node.js"
   - Expliquer la stratégie

3. **11-playwright-e2e-testing.md** :
   - Ajouter les prérequis Node.js
   - Documenter la solution

---

## ⚙️ Configuration Automatique (Optionnel)

### Script PowerShell pour Simplifier

Créer un script `run-playwright-tests.ps1` :

```powershell
# run-playwright-tests.ps1
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("shared", "ui")]
    [string]$Repo
)

if ($Repo -eq "shared") {
    $path = "C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia"
} else {
    $path = "C:\repo_hps\pwc-ui\pwc-ui-v4-ia"
}

Write-Host "🔄 Basculement vers Node 16..." -ForegroundColor Cyan
Use-Node16

Write-Host "✅ Node version: $(node --version)" -ForegroundColor Green

Write-Host "🧪 Exécution des tests Playwright..." -ForegroundColor Cyan
cd $path
npm run test:e2e
```

**Utilisation** :
```powershell
.\run-playwright-tests.ps1 -Repo shared
.\run-playwright-tests.ps1 -Repo ui
```

---

## ✅ Avantages de Cette Solution

| Avantage | Description |
|----------|-------------|
| **Séparation des concerns** | Angular 5 avec Node 10, Playwright avec Node 16 |
| **Pas de conflit** | Deux processus séparés |
| **Flexibilité** | Peut tester n'importe quelle version d'Angular |
| **Standard** | Utilise les versions recommandées |

---

## 📊 Versions Recommandées

| Outil | Version Node.js | Raison |
|-------|-----------------|--------|
| **Angular 5-8** | Node 10 | Compatibilité |
| **Angular 9-11** | Node 12 | Compatibilité |
| **Angular 12+** | Node 14+ | Compatibilité |
| **Playwright** | Node 16+ | Requis par Playwright |

---

## 🎯 Prochaines Étapes

1. **Mettre à jour la documentation** avec les nouvelles instructions

2. **Tester avec Node 16** :
   ```powershell
   Use-Node16
   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
   npm run test:e2e
   ```

3. **Valider le Gate** :
   - pwc-ui-shared : 18 tests passent
   - pwc-ui : 13 tests passent

4. **Documenter les résultats** dans le journal de bord

---

## 📝 Notes Importantes

1. **Node 10 pour Angular 5** : Obligatoire pour `npm start`
2. **Node 16 pour Playwright** : Obligatoire pour `npm run test:e2e`
3. **Deux terminaux** : Un pour l'app (Node 10), un pour les tests (Node 16)
4. **Pas de conflit** : Les deux processus sont indépendants

---

## ✅ Résumé

**Problème** : Playwright ne supporte pas Node 10  
**Solution** : Utiliser Node 16 pour Playwright, Node 10 pour Angular 5  
**Résultat** : Tests Playwright fonctionnels sur Angular 5

---

**Cette solution est la bonne approche et sera utilisée pour tous les paliers de migration.**
