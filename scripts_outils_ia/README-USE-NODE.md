# Scripts PowerShell Use-NodeXX

Scripts pour basculer rapidement entre les versions de Node.js nécessaires pour la migration Angular 5 → 20.

---

## 📋 Scripts Disponibles

| Script | Version Node | Angular Compatible | Paliers |
|--------|--------------|-------------------|---------|
| `Use-Node10.ps1` | v10.24.1 | Angular 5-8 | 1-4 |
| `Use-Node12.ps1` | v12.22.12 | Angular 9-11 | 5-7 |
| `Use-Node14.ps1` | v14.21.3 | Angular 12 | 8 |
| `Use-Node16.ps1` | v16.20.2 | Angular 13-14 | 9-10 |
| `Use-Node18.ps1` | v18.20.4 | Angular 15-17 | 11-13 |
| `Use-Node20.ps1` | v20.18.0 | Angular 18-19 | 14 |
| `Use-Node22.ps1` | v22.11.0 | Angular 20 | 15 |

---

## 🚀 Utilisation

### Basculer vers une version

```powershell
# Pour Angular 5-8 (Paliers 1-4)
.\Use-Node10.ps1
# ou simplement
Use-Node10

# Vérifier
node --version  # v10.24.1
npm --version
```

### Workflow Typique

```powershell
# 1. Basculer vers la bonne version
Use-Node10

# 2. Vérifier
node --version

# 3. Aller dans le repo
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# 4. Installer les dépendances
npm install

# 5. Commencer la migration
ng update @angular/cli@6 @angular/core@6
```

---

## 📦 Installation des Versions Node.js

### Emplacement Standard

Les scripts s'attendent à trouver les versions Node.js dans :

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

1. Aller sur https://nodejs.org/dist/
2. Télécharger les versions ZIP :
   - https://nodejs.org/dist/v10.24.1/node-v10.24.1-win-x64.zip
   - https://nodejs.org/dist/v12.22.12/node-v12.22.12-win-x64.zip
   - https://nodejs.org/dist/v14.21.3/node-v14.21.3-win-x64.zip
   - https://nodejs.org/dist/v16.20.2/node-v16.20.2-win-x64.zip
   - https://nodejs.org/dist/v18.20.4/node-v18.20.4-win-x64.zip
   - https://nodejs.org/dist/v20.18.0/node-v20.18.0-win-x64.zip
   - https://nodejs.org/dist/v22.11.0/node-v22.11.0-win-x64.zip

3. Extraire dans `C:\Users\<USERNAME>\dev\nodejs-versions\`

---

## 🔍 Vérification

### Vérifier toutes les versions installées

```powershell
Get-ChildItem "C:\Users\$env:USERNAME\dev\nodejs-versions" | ForEach-Object {
    $nodePath = Join-Path $_.FullName "node.exe"
    if (Test-Path $nodePath) {
        $version = & $nodePath --version
        Write-Host "$($_.Name): $version"
    }
}
```

### Script de diagnostic complet

```powershell
.\check-stack.ps1
```

---

## ⚠️ Problèmes Courants

### "Node.js vXX non trouvé"

Le script ne trouve pas la version Node.js. Vérifier :

1. Le dossier existe : `C:\Users\<USERNAME>\dev\nodejs-versions\node-vXX.XX.X-win-x64\`
2. Le fichier `node.exe` est présent dans ce dossier
3. Télécharger et extraire la version manquante

### "node --version" affiche une mauvaise version

Le PATH n'a pas été mis à jour correctement :

```powershell
# Recharger le profil PowerShell
. $PROFILE

# Ou redémarrer le terminal PowerShell
```

### Conflit avec une installation globale de Node.js

Si Node.js est installé globalement, il peut y avoir des conflits :

```powershell
# Vérifier le PATH
$env:PATH

# Les scripts Use-NodeXX ajoutent leur version en DÉBUT du PATH
# pour avoir la priorité
```

---

## 🎯 Exemple Complet : Migration Palier 1

```powershell
# 1. Basculer vers Node 10
Use-Node10

# 2. Vérifier
node --version  # v10.24.1
npm --version   # 6.x

# 3. Aller dans pwc-ui-shared
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# 4. Nettoyer (si changement de version Node)
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item package-lock.json -ErrorAction SilentlyContinue

# 5. Installer
npm install

# 6. Vérifier le build
npm run build

# 7. Commencer la migration
ng update @angular/cli@6 @angular/core@6
```

---

## 📚 Documentation

- Guide complet : `.kiro/steering/09-version-management.md`
- Règles de migration : `.kiro/steering/02-migration-angular-rules.md`
- Plan de migration : `.kiro/specs/02-plan-migration.md`

---

## ✅ Bonnes Pratiques

- ✅ Toujours exécuter `Use-NodeXX` au début de chaque session
- ✅ Vérifier `node --version` avant de commencer
- ✅ Nettoyer `node_modules` lors du changement de version Node
- ✅ Documenter la version utilisée dans les commits Git

---

## 🚫 À Éviter

- ❌ Ne PAS mélanger les versions Node.js entre les repos
- ❌ Ne PAS oublier de basculer de version entre les paliers
- ❌ Ne PAS ignorer les erreurs de version incompatible

