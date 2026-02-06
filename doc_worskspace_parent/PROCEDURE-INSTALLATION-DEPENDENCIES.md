# Procédure d'installation des dépendances

## Vue d'ensemble

Ce document explique comment installer les dépendances npm pour les projets pwc-ui et pwc-ui-shared qui utilisent Angular 5 et nécessitent l'accès au Nexus privé.

## Prérequis

### 1. Node.js version compatible
- **Version requise** : Node v10.24.1
- **Emplacement** : `C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\`
- **Raison** : Angular 5 n'est pas compatible avec les versions récentes de Node (v12+)

### 2. Accès Nexus
- **URL** : https://nexus.pwcv4.com
- **Credentials readonly** : 
  - User: `readonly`
  - Password: `evy@gnx5vem.QCT0ahc`
- **Test de connectivité** :
  ```powershell
  Test-NetConnection -ComputerName nexus.pwcv4.com -Port 443
  ```
  Le résultat doit afficher `TcpTestSucceeded : True`

### 3. Configuration .npmrc
Les fichiers `.npmrc` doivent être configurés avec :
```properties
registry=https://nexus.pwcv4.com/repository/npm-public/
//nexus.pwcv4.com/repository/npm-public/:_auth=cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==
//nexus.pwcv4.com/repository/npm-public/:always-auth=true
```

## Procédure d'installation

### Pour pwc-ui-shared

1. **Naviguer vers le répertoire du projet**
   ```powershell
   cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
   ```

2. **Nettoyer le cache npm (optionnel mais recommandé)**
   ```powershell
   npm cache clean --force
   ```

3. **Installer les dépendances**
   ```powershell
   C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install --legacy-peer-deps --ignore-scripts
   ```

4. **Vérifier l'installation**
   ```powershell
   # Vérifier que node_modules existe
   Test-Path node_modules
   
   # Compter les packages installés
   (Get-ChildItem node_modules -Directory).Count
   ```
   Résultat attendu : ~1144 packages

### Pour pwc-ui (Main Application)

Même procédure en changeant le répertoire :
```powershell
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install --legacy-peer-deps --ignore-scripts
```

## Explication des options

### `--legacy-peer-deps`
- **Pourquoi** : npm moderne (v6+) est plus strict sur les dépendances peer
- **Effet** : Ignore les conflits de versions peer dependencies
- **Exemple de conflit** : `@ng-idle/core@2.0.0-beta.12` requiert Angular 2 ou 4, mais le projet utilise Angular 5

### `--ignore-scripts`
- **Pourquoi** : Certains packages (node-sass) nécessitent Python 2.x pour compiler
- **Effet** : Ignore les scripts postinstall qui échouent
- **Impact** : node-sass ne sera pas compilé, mais ce n'est pas bloquant pour le développement
- **Note** : node-sass est deprecated et sera remplacé lors de la migration Angular 20

## Packages custom HPS

Les packages suivants sont hébergés uniquement sur le Nexus privé :
- `jspdf@2.1.1-hps` : Version patchée de jsPDF
- `terrabrasilis-jsonix@2.4.2-hps` : Bibliothèque XML custom

Ces packages ne sont **pas disponibles** sur npmjs.org public.

## Dépannage

### Problème : Nexus inaccessible

**Symptômes** :
```
npm http fetch GET 200 https://nexus.pwcv4.com/...
request to https://nexus.pwcv4.com/... failed
```

**Solutions** :
1. Vérifier la connectivité réseau
   ```powershell
   Test-NetConnection -ComputerName nexus.pwcv4.com -Port 443
   ```

2. Vérifier si un VPN est requis

3. Vérifier les credentials dans `.npmrc`

4. Nettoyer le cache npm
   ```powershell
   npm cache clean --force
   ```

### Problème : Erreur Python avec node-sass

**Symptômes** :
```
gyp ERR! stack SyntaxError: Missing parentheses in call to 'print'
```

**Cause** : node-sass nécessite Python 2.x mais Python 3.x est installé

**Solution** : Utiliser `--ignore-scripts` (déjà inclus dans la procédure)

### Problème : Version Node incompatible

**Symptômes** :
```
npm WARN notsup Unsupported engine
npm WARN EBADENGINE
```

**Solution** : Utiliser Node v10.24.1 comme indiqué dans la procédure

### Problème : Conflits de dépendances

**Symptômes** :
```
npm ERR! code ERESOLVE
npm ERR! ERESOLVE unable to resolve dependency tree
```

**Solution** : Utiliser `--legacy-peer-deps` (déjà inclus dans la procédure)

## Commandes utiles

### Vérifier la version de Node utilisée
```powershell
node --version
```

### Vérifier la configuration npm
```powershell
npm config list
```

### Lister les packages installés
```powershell
npm list --depth=0
```

### Réinstaller complètement
```powershell
# Supprimer node_modules et package-lock.json
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json

# Réinstaller
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install --legacy-peer-deps --ignore-scripts
```

## Notes importantes

1. **Ne pas commiter node_modules** : Ce dossier est dans `.gitignore`

2. **package-lock.json** : Peut être committé pour figer les versions

3. **Versions Node** : 
   - Angular 5 : Node v8-10
   - Angular 20 : Node v18-20
   - Lors de la migration, il faudra changer de version Node

4. **Nexus vs npmjs.org** :
   - Nexus sert de proxy/cache pour npmjs.org
   - Nexus héberge aussi les packages custom `-hps`
   - Sans accès Nexus, impossible d'installer les packages custom

## Références

- [Journal de bord](./JOURNAL-DE-BORD.md) : Historique des modifications
- [Configuration Nexus](./modop_nexus.md) : Documentation Nexus complète
- [Migration Nexus](../kiro_migration_angular/MIGRATION-NEXUS-CONFIGURATION.md) : Détails de la configuration

## Historique

| Version | Date | Auteur | Description |
|---------|------|--------|-------------|
| 1.0.0 | 2026-02-02 | Franck Desmedt / Kiro | Création initiale |
