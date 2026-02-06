---
inclusion: always
priority: 90
---

# Gestion des Versions - Raccourcis PowerShell

> **Contexte** : Assurer les bonnes versions de Node.js, npm, et autres outils pour chaque palier

---

## 🎯 Objectif

Utiliser des raccourcis PowerShell pour basculer rapidement entre les versions de Node.js requises pour chaque palier de migration Angular.

---

## 📋 Raccourcis PowerShell Disponibles

### Node.js

| Commande | Version Node | Angular Compatible | Usage |
|----------|--------------|-------------------|-------|
| `Use-Node10` | v10.24.1 | Angular 5-8 | Paliers 1-4 |
| `Use-Node12` | v12.22.12 | Angular 9-11 | Paliers 5-7 |
| `Use-Node14` | v14.21.3 | Angular 12 | Palier 8 |
| `Use-Node16` | v16.20.2 | Angular 13-14 | Paliers 9-10 |
| `Use-Node18` | v18.20.4 | Angular 15-17 | Paliers 11-13 |
| `Use-Node20` | v20.18.0 | Angular 18-19 | Palier 14 |
| `Use-Node22` | v22.11.0 | Angular 20 | Palier 15 |

### Vérification des Versions

```powershell
# Vérifier la version active de Node.js
node --version

# Vérifier npm
npm --version

# Vérifier Angular CLI
ng version

# Vérifier TypeScript
tsc --version

# Vérifier Python
python --version

# Vérifier pip
pip --version
```

---

## 🔄 Workflow par Palier

### Avant de Commencer un Palier

```powershell
# 1. Basculer vers la bonne version de Node.js
Use-Node10  # Pour Angular 5-8 (Paliers 1-4)

# 2. Vérifier que la version est active
node --version
# Doit afficher: v10.24.1

# 3. Vérifier npm
npm --version

# 4. Aller dans le repo
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# 5. Installer les dépendances si nécessaire
npm install
```

### Changement de Version Entre Paliers

```powershell
# Exemple : Passage du Palier 4 (Angular 8) au Palier 5 (Angular 9)

# 1. Basculer de Node 10 à Node 12
Use-Node12

# 2. Vérifier
node --version
# Doit afficher: v12.22.12

# 3. Nettoyer et réinstaller
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install
```

---

## 📊 Matrice Versions par Palier

| Palier | Angular | Node.js | npm | TypeScript | RxJS | Commande |
|--------|---------|---------|-----|------------|------|----------|
| 1 | 5→6 | v10 | 6.x | 2.6→3.1 | 5.5→6.0 | `Use-Node10` |
| 2 | 6→7 | v10 | 6.x | 3.1→3.2 | 6.0→6.3 | `Use-Node10` |
| 3 | 7→8 | v10 | 6.x | 3.2→3.4 | 6.3→6.5 | `Use-Node10` |
| 4 | 8→9 | v10 | 6.x | 3.4→3.7 | 6.5→6.6 | `Use-Node10` |
| 5 | 9→10 | v12 | 6.x | 3.7→3.9 | 6.6→6.6 | `Use-Node12` |
| 6 | 10→11 | v12 | 6.x | 3.9→4.0 | 6.6→6.6 | `Use-Node12` |
| 7 | 11→12 | v12 | 6.x | 4.0→4.3 | 6.6→7.4 | `Use-Node12` |
| 8 | 12→13 | v14 | 6.x | 4.3→4.6 | 7.4→7.5 | `Use-Node14` |
| 9 | 13→14 | v16 | 8.x | 4.6→4.8 | 7.5→7.8 | `Use-Node16` |
| 10 | 14→15 | v16 | 8.x | 4.8→5.0 | 7.8→7.8 | `Use-Node16` |
| 11 | 15→16 | v18 | 9.x | 5.0→5.2 | 7.8→7.8 | `Use-Node18` |
| 12 | 16→17 | v18 | 9.x | 5.2→5.4 | 7.8→7.8 | `Use-Node18` |
| 13 | 17→18 | v18 | 9.x | 5.4→5.5 | 7.8→7.8 | `Use-Node18` |
| 14 | 18→19 | v20 | 10.x | 5.5→5.6 | 7.8→7.8 | `Use-Node20` |
| 15 | 19→20 | v22 | 10.x | 5.6→5.7 | 7.8→7.8 | `Use-Node22` |

---

## 🛠️ Installation des Versions Node.js

### Emplacement Standard

```
C:\Users\<USERNAME>\dev\nodejs-versions\
├── node-v10.24.1-win-x64\
├── node-v12.22.12-win-x64\
├── node-v14.21.3-win-x64\
├── node-v16.20.2-win-x64\
├── node-v18.20.4-win-x64\
├── node-v20.18.0-win-x64\
└── node-v22.11.0-win-x64\
```

### Téléchargement

```powershell
# Télécharger depuis nodejs.org
# https://nodejs.org/dist/v10.24.1/node-v10.24.1-win-x64.zip
# https://nodejs.org/dist/v12.22.12/node-v12.22.12-win-x64.zip
# etc.

# Extraire dans C:\Users\<USERNAME>\dev\nodejs-versions\
```

### Alternative : fnm (Fast Node Manager)

```powershell
# Installer fnm
winget install Schniz.fnm

# Installer les versions
fnm install 10
fnm install 12
fnm install 14
fnm install 16
fnm install 18
fnm install 20
fnm install 22

# Utiliser une version
fnm use 10
```

---

## 🔍 Vérification de la Stack

### Script de Diagnostic

```powershell
# Exécuter le script de vérification
.\scripts_outils_ia\check-stack.ps1

# Avec détails
.\scripts_outils_ia\check-stack.ps1 -Verbose
```

### Vérification Manuelle

```powershell
# Vérifier toutes les versions installées
Get-ChildItem "C:\Users\$env:USERNAME\dev\nodejs-versions" | ForEach-Object {
    $nodePath = Join-Path $_.FullName "node.exe"
    if (Test-Path $nodePath) {
        $version = & $nodePath --version
        Write-Host "$($_.Name): $version"
    }
}
```

---

## ⚠️ Problèmes Courants

### Node.js Non Trouvé Après Use-NodeXX

```powershell
# Vérifier le PATH
$env:PATH

# Recharger le profil PowerShell
. $PROFILE

# Ou redémarrer le terminal
```

### Conflit de Versions npm

```powershell
# Nettoyer le cache npm
npm cache clean --force

# Supprimer node_modules et package-lock.json
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# Réinstaller
npm install
```

### Erreur "Module Not Found"

```powershell
# Vérifier que Node.js est bien dans le PATH
node --version

# Vérifier npm
npm --version

# Réinstaller les dépendances globales si nécessaire
npm install -g @angular/cli
npm install -g jscodeshift
```

---

## 📋 Checklist Avant Chaque Palier

- [ ] Exécuter `Use-NodeXX` pour la bonne version
- [ ] Vérifier `node --version`
- [ ] Vérifier `npm --version`
- [ ] Aller dans le bon repo (pwc-ui-shared EN PREMIER)
- [ ] Nettoyer `node_modules` et `package-lock.json` si changement de version Node
- [ ] Exécuter `npm install`
- [ ] Vérifier que le build fonctionne : `npm run build`

---

## 🎯 Exemple Complet : Palier 1

```powershell
# 1. Basculer vers Node 10
Use-Node10

# 2. Vérifier
node --version  # v10.24.1
npm --version   # 6.x

# 3. Aller dans pwc-ui-shared
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# 4. Installer les dépendances
npm install

# 5. Vérifier le build
npm run build

# 6. Commencer la migration
ng update @angular/cli@6 @angular/core@6
```

---

## 🔗 Ressources

- Script de vérification : `scripts_outils_ia/check-stack.ps1`
- Scripts Use-NodeXX : `scripts_outils_ia/Use-Node*.ps1`
- Documentation Node.js : https://nodejs.org/
- fnm (Fast Node Manager) : https://github.com/Schniz/fnm

---

## ✅ Bonnes Pratiques

- ✅ Toujours vérifier la version active avec `node --version` avant de commencer
- ✅ Utiliser `Use-NodeXX` au début de chaque session de travail
- ✅ Nettoyer `node_modules` lors du changement de version Node.js
- ✅ Documenter la version utilisée dans les commits Git
- ✅ Tester le build après chaque changement de version

---

## 🚫 À Éviter

- ❌ Ne PAS mélanger les versions Node.js entre les repos
- ❌ Ne PAS oublier de basculer de version entre les paliers
- ❌ Ne PAS utiliser `npm install -g` avec des versions différentes sans vérifier
- ❌ Ne PAS ignorer les erreurs de version incompatible

