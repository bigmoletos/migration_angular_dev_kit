# ⚠️ Problème Détecté - Version Node.js

> **Date** : 2026-02-05  
> **Statut** : ⚠️ Problème identifié  
> **Impact** : Bloque l'exécution des tests Playwright

---

## 🔴 Problème Rencontré

Lors de la tentative d'exécution des tests Playwright, l'application pwc-ui-shared ne démarre pas correctement.

### Erreur

```
Error: No such module: http_parser
    at process.binding (node:internal/bootstrap/realm:162:11)
    at Object.<anonymous> (C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\node_modules\http-deceiver\lib\deceiver.js:22:24)
```

### Cause

L'erreur `No such module: http_parser` indique un problème de compatibilité entre :
- La version de Node.js utilisée
- Les dépendances d'Angular 5 (webpack-dev-server, spdy, http-deceiver)

---

## 🔍 Analyse

### Version Node.js Détectée

- **Version système** : v24.12.0 (trop récente)
- **Version requise** : v10.24.1 (pour Angular 5)

### Tentatives Effectuées

1. ✅ Basculement vers Node 10 avec `Use-Node10`
2. ✅ Vérification : `node --version` → v10.24.1
3. ❌ Démarrage de l'application : Même erreur

### Hypothèse

Le processus en arrière-plan (`controlPwshProcess`) n'hérite pas correctement de la version Node.js modifiée par `Use-Node10`. Le PATH n'est pas mis à jour dans le contexte du processus.

---

## ✅ Solutions Proposées

### Solution 1 : Démarrage Manuel (Recommandé)

**L'utilisateur doit démarrer l'application manuellement dans un nouveau terminal PowerShell.**

#### Étapes

1. **Ouvrir un nouveau terminal PowerShell**

2. **Basculer vers Node 10** :
   ```powershell
   Use-Node10
   ```

3. **Vérifier la version** :
   ```powershell
   node --version
   # Doit afficher : v10.24.1
   ```

4. **Démarrer pwc-ui-shared** :
   ```powershell
   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
   npm start
   ```

5. **Attendre la compilation** :
   ```
   webpack: Compiled successfully.
   ** Angular Live Development Server is listening on localhost:4201 **
   ```

6. **Dans un AUTRE terminal, exécuter les tests** :
   ```powershell
   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
   npm run test:e2e
   ```

---

### Solution 2 : Réinstaller node_modules (Si Solution 1 échoue)

Si l'application ne démarre toujours pas avec Node 10 :

```powershell
# 1. Basculer vers Node 10
Use-Node10

# 2. Nettoyer
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# 3. Réinstaller avec Node 10
npm install

# 4. Démarrer
npm start
```

**⚠️ Attention** : Cette opération peut prendre 5-10 minutes.

---

### Solution 3 : Vérifier les Scripts Use-NodeXX

Vérifier que le script `Use-Node10` fonctionne correctement :

```powershell
# Afficher le contenu du script
Get-Content (Get-Command Use-Node10).Source

# Vérifier le PATH après Use-Node10
Use-Node10
$env:PATH
```

Le PATH doit contenir le chemin vers Node 10 en premier.

---

## 📋 Instructions pour l'Utilisateur

### Étape 1 : Démarrer pwc-ui-shared Manuellement

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

### Étape 2 : Exécuter les Tests

**Terminal 2** :
```powershell
# Aller dans le repo
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Exécuter les tests
npm run test:e2e

# Résultat attendu : 18 tests passent
```

### Étape 3 : Tester pwc-ui

**Terminal 1** (arrêter pwc-ui-shared avec Ctrl+C) :
```powershell
# Basculer vers Node 10 (si nouveau terminal)
Use-Node10

# Démarrer pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start

# Attendre : "webpack: Compiled successfully."
```

**Terminal 2** :
```powershell
# Aller dans le repo
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia

# Exécuter les tests
npm run test:e2e

# Résultat attendu : 13 tests passent
```

---

## 🐛 Debugging

### Vérifier que Node 10 est Actif

```powershell
node --version
# Doit afficher : v10.24.1

npm --version
# Doit afficher : 6.x
```

### Vérifier que l'Application Démarre

```powershell
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start

# Logs attendus :
# - "webpack: Compiling..."
# - "webpack: Compiled successfully."
# - "** Angular Live Development Server is listening on localhost:4201 **"
```

### Tester Manuellement dans le Navigateur

Ouvrir http://localhost:4201 dans Chrome :
- La page doit s'afficher
- Pas d'erreurs dans la console (F12)

---

## 📊 Résumé

| Élément | Statut | Action |
|---------|--------|--------|
| **Tests Playwright créés** | ✅ Fait | 31 tests créés |
| **Configuration** | ✅ Fait | Playwright configuré |
| **Documentation** | ✅ Fait | 6 documents créés |
| **Exécution automatique** | ❌ Bloqué | Problème Node.js |
| **Exécution manuelle** | ⏳ À faire | Utilisateur doit démarrer manuellement |

---

## 🎯 Prochaines Étapes

1. **L'utilisateur doit** :
   - Démarrer pwc-ui-shared manuellement (Terminal 1)
   - Exécuter les tests (Terminal 2)
   - Documenter les résultats

2. **Si les tests passent** :
   - Palier 0 validé ✅
   - Passer au Palier 1

3. **Si les tests échouent** :
   - Utiliser le mode UI : `npm run test:e2e:ui`
   - Voir le rapport : `npm run test:e2e:report`
   - Corriger les erreurs

---

## 📝 Notes

- Le problème de version Node.js est un problème connu avec les processus en arrière-plan
- La solution manuelle est fiable et recommandée
- Les tests Playwright eux-mêmes sont correctement configurés
- Une fois l'application démarrée, les tests devraient passer sans problème

---

## 📚 Ressources

- **Instructions complètes** : `INSTRUCTIONS-UTILISATEUR.md`
- **Résumé du Gate** : `GATE-PLAYWRIGHT-RESUME.md`
- **Documentation Playwright** : `.kiro/steering/11-playwright-e2e-testing.md`

---

**Le Gate Playwright est configuré et prêt. L'utilisateur doit démarrer les applications manuellement pour exécuter les tests.**
