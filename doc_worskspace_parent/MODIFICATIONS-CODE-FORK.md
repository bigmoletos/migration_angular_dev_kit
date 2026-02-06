# Modifications de code pour fork -v4-ia

## Vue d'ensemble

Ce document liste **toutes les modifications de code** effectuées sur les repositories forkés avec suffixe `-v4-ia`. Ces modifications sont nécessaires pour faire fonctionner les projets en local sans accès au Nexus privé complet.

## Principe

- ✅ **Commenter** l'ancien code (ne jamais supprimer)
- ✅ **Documenter** la raison de chaque modification
- ✅ **Minimiser** les changements pour faciliter l'application à d'autres forks
- ✅ **Réversible** : Possibilité de revenir en arrière facilement

---

## Modification 1 : pwc-ui/package.json

### Fichier
`C:\repo_hps\pwc-ui\pwc-ui-v4-ia\package.json`

### Ligne modifiée
Ligne 35 (dans la section `dependencies`)

### Code AVANT
```json
{
  "dependencies": {
    "@pwc/shared": "2.6.23",
  }
}
```

### Code APRÈS
```json
{
  "dependencies": {
    // ORIGINAL: "@pwc/shared": "2.6.23",
    // MODIFIED for local development (fork -v4-ia)
    // Reason: @pwc/shared not available on npmjs.org, using local link
    "@pwc/shared": "file:C:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/src/lib/shared",
  }
}
```

### Raison
- `@pwc/shared` est un package interne qui n'existe pas sur npmjs.org
- Il doit être publié sur Nexus privé ou utilisé en lien local
- Le lien local permet de travailler sans publier sur Nexus

### Pour d'autres repositories
Adapter le chemin selon le nom du fork :
```json
"@pwc/shared": "file:C:/repo_hps/pwc-ui-shared/[NOM-DU-FORK]/src/lib/shared",
```

### Rollback
```json
"@pwc/shared": "2.6.23",
```
Puis `npm install --legacy-peer-deps --ignore-scripts`

---

## Modification 2 : pwc-ui/.npmrc

### Fichier
`C:\repo_hps\pwc-ui\pwc-ui-v4-ia\.npmrc`

### Code AVANT
```properties
# Original configuration
# registry=https://nexus.pwcv4.com/repository/npm-public/

# Modified configuration with authentication (modop_nexus.md)
# npm-public for installing dependencies, npm-private is only for publishing
# Using readonly credentials for public access
# registry=https://nexus.pwcv4.com/repository/npm-public/
# //nexus.pwcv4.com/repository/npm-public/:_auth=cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==
# //nexus.pwcv4.com/repository/npm-public/:always-auth=true

# TEMPORARY: Using official npm registry (Nexus not accessible)
registry=https://registry.npmjs.org/
```

### Code APRÈS
```properties
# Original configuration
# registry=https://nexus.pwcv4.com/repository/npm-public/

# Modified configuration with authentication (modop_nexus.md)
# npm-public for installing dependencies, npm-private is only for publishing
# Using readonly credentials for public access
registry=https://nexus.pwcv4.com/repository/npm-public/
//nexus.pwcv4.com/repository/npm-public/:_auth=cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==
//nexus.pwcv4.com/repository/npm-public/:always-auth=true

# TEMPORARY: Using official npm registry (Nexus not accessible)
# registry=https://registry.npmjs.org/
```

### Raison
- Les packages custom HPS (ex: `terrabrasilis-jsonix@2.4.2-hps`) n'existent que sur Nexus
- npmjs.org ne peut pas fournir ces packages
- Nexus doit être accessible avec les bons credentials

### Pour d'autres repositories
Aucune modification nécessaire si le Nexus et les credentials sont les mêmes

### Rollback
Commenter les lignes Nexus, décommenter `registry=https://registry.npmjs.org/`

---

## Modification 3 : pwc-ui-shared/.npmrc

### Fichier
`C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\.npmrc`

### Modification identique à pwc-ui/.npmrc
Voir "Modification 2" ci-dessus

---

## Modifications Gradle (déjà effectuées)

### Fichiers modifiés
- `pwc-ui/gradle.properties`
- `pwc-ui/settings.gradle`
- `pwc-ui-shared/gradle.properties`
- `pwc-ui-shared/settings.gradle`

### Détails
Voir `MIGRATION-NEXUS-CONFIGURATION.md` pour les détails complets

---

## Checklist pour appliquer à un nouveau fork

### Étape 1 : Identifier le fork
- [ ] Noter le nom du fork (ex: `-v4-ia`, `-v5-test`, etc.)
- [ ] Vérifier les chemins des repositories

### Étape 2 : Modifications npm
- [ ] Modifier `pwc-ui/package.json` : Adapter le chemin de `@pwc/shared`
- [ ] Vérifier `pwc-ui/.npmrc` : S'assurer que Nexus est configuré
- [ ] Vérifier `pwc-ui-shared/.npmrc` : S'assurer que Nexus est configuré

### Étape 3 : Modifications Gradle (si nécessaire)
- [ ] Ajouter variables Nexus dans `gradle.properties`
- [ ] Modifier `settings.gradle` pour fallback

### Étape 4 : Scripts utilitaires
- [ ] Créer/adapter `Use-Node10.bat` avec le bon chemin Node
- [ ] Créer/adapter les scripts start et install
- [ ] Adapter les chemins dans les scripts selon le nom du fork

### Étape 5 : Installation
- [ ] Installer pwc-ui-shared : `npm install --legacy-peer-deps --ignore-scripts`
- [ ] Installer pwc-ui : `npm install --legacy-peer-deps --ignore-scripts`
- [ ] Vérifier que les deux ont leurs node_modules

### Étape 6 : Test
- [ ] Lancer `start-pwc-ui.bat`
- [ ] Vérifier http://localhost:4200
- [ ] Vérifier la console navigateur (F12)

---

## Packages custom HPS identifiés

Ces packages nécessitent le Nexus privé :

1. **jspdf@2.1.1-hps**
   - Utilisé dans : pwc-ui-shared
   - Version officielle : jspdf@2.x existe sur npmjs.org
   - Différence : Version patchée HPS

2. **terrabrasilis-jsonix@2.4.2-hps**
   - Utilisé dans : pwc-ui-shared, pwc-ui
   - Version officielle : N/A
   - Différence : Package complètement custom HPS

---

## Problèmes connus et solutions

### Problème 1 : "Unexpected value 'undefined' imported by the module"
**Cause** : Lancement de pwc-ui-shared au lieu de pwc-ui  
**Solution** : Lancer pwc-ui (l'application principale)

### Problème 2 : "404 Not Found - @pwc/shared"
**Cause** : Lien local non configuré dans package.json  
**Solution** : Appliquer Modification 1

### Problème 3 : "No matching version found for xxx-hps"
**Cause** : .npmrc pointe vers npmjs.org au lieu de Nexus  
**Solution** : Appliquer Modification 2 et 3

### Problème 4 : "Please wait loading" infini
**Cause** : Backend non accessible ou erreur JavaScript  
**Solution** : Vérifier console navigateur (F12) et configuration environment.ts

---

## Notes importantes

### Suffixes de fork
- Le suffixe `-v4-ia` est utilisé dans tous les chemins
- Pour un autre fork, remplacer `-v4-ia` par le nouveau suffixe
- Vérifier tous les scripts batch et fichiers de configuration

### Versions Node
- Angular 5 : Node v10.24.1
- Angular 20 : Node v18-20
- Toujours utiliser la version compatible

### Nexus
- URL : https://nexus.pwcv4.com
- Credentials readonly : `readonly:evy@gnx5vem.QCT0ahc`
- _auth Base64 : `cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==`

---

## Historique

| Version | Date | Auteur | Description |
|---------|------|--------|-------------|
| 1.0.0 | 2026-02-02 | Franck Desmedt / Kiro | Création initiale |


---

## Modification 4 : pwc-ui/package.json - Ajout json-ignore

### Fichier
`C:\repo_hps\pwc-ui\pwc-ui-v4-ia\package.json`

### Ligne modifiée
Ligne 43 (dans la section `dependencies`)

### Code AVANT
```json
{
  "dependencies": {
    "fp-ts": "1.14.4",
    "fullpage.js": "^2.9.7",
    "htmllint": "~0.7.0",
  }
}
```

### Code APRÈS
```json
{
  "dependencies": {
    "fp-ts": "1.14.4",
    "fullpage.js": "^2.9.7",
    "json-ignore": "^0.4.0",
    "htmllint": "~0.7.0",
  }
}
```

### Raison
- `json-ignore` est utilisé par `@pwc/shared` mais n'était pas déclaré dans pwc-ui
- Erreur de compilation : `Cannot find module 'json-ignore'`
- Le module existe dans pwc-ui-shared mais pas dans pwc-ui

### Installation
```powershell
npm install json-ignore --legacy-peer-deps --ignore-scripts
```

### Pour d'autres repositories
Vérifier si json-ignore est déjà dans package.json. Si erreur similaire, ajouter :
```json
"json-ignore": "^0.4.0",
```

### Rollback
```json
// Supprimer la ligne
"json-ignore": "^0.4.0",
```
Puis `npm uninstall json-ignore`

---

## Modification 5 : TEMPORAIRE - Mock HTTP (À SUPPRIMER)

⚠️ **ATTENTION** : Ces modifications sont **TEMPORAIRES** pour tests frontend sans backend

### Fichiers créés (NOUVEAUX)

#### 5.1 - src/app/core/interceptors/mock-http.interceptor.ts
**Fichier** : `C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\app\core\interceptors\mock-http.interceptor.ts`

**Contenu** : Intercepteur HTTP qui mock les appels API
- Simule les réponses backend (auth, traductions, config)
- Active uniquement si `environment.mock = true`
- Retourne des données statiques pour débloquer l'IHM

**Raison** : Permettre de tester l'IHM sans avoir le backend pwc-backend-v4

#### 5.2 - src/app/core/config/mock.config.ts
**Fichier** : `C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\app\core\config\mock.config.ts`

**Contenu** : Configuration du provider HTTP mock
```typescript
export const MOCK_PROVIDERS = environment['mock'] ? [
  {
    provide: HTTP_INTERCEPTORS,
    useClass: MockHttpInterceptor,
    multi: true
  }
] : [];
```

**Raison** : Injection conditionnelle de l'intercepteur mock

### Fichiers modifiés (TEMPORAIRE)

#### 5.3 - src/environments/environment.ts
**Fichier** : `C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\environments\environment.ts`

**Code AVANT**
```typescript
export const environment = {
    production: false,
    name: 'UAT',
    appName: null,
    apiUrl: '/rest/',
    cachedParameterTables: [...],
```

**Code APRÈS**
```typescript
export const environment = {
    production: false,
    name: 'UAT',
    appName: null,
    apiUrl: '/rest/',
    mock: true, // AJOUT: Active le mode mock pour dev frontend sans backend
    cachedParameterTables: [...],
```

**Raison** : Variable de configuration pour activer/désactiver le mock

#### 5.4 - src/app/app.module.ts
**Fichier** : `C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\app\app.module.ts`

**Code AVANT**
```typescript
import {environment} from "../environments/environment";
import {OidcService} from "@pwc/shared/service/oidc/oidc.service";

// ...

providers: [
    OidcService,
    // ... autres providers
]
```

**Code APRÈS**
```typescript
import {environment} from "../environments/environment";
import {OidcService} from "@pwc/shared/service/oidc/oidc.service";
import { MOCK_PROVIDERS } from './core/config/mock.config'; // AJOUT

// ...

providers: [
    OidcService,
    // ... autres providers
    ...MOCK_PROVIDERS // AJOUT: Active l'intercepteur mock si environment.mock = true
]
```

**Raison** : Injection du provider mock dans le module principal

### ⚠️ ROLLBACK OBLIGATOIRE

**Ces modifications DOIVENT être supprimées avant tout commit Git !**

Consulter : `Documentation/TODO-NETTOYAGE-MOCK.md`

**Commande rapide** :
```powershell
# Restaurer les fichiers modifiés
git checkout src/environments/environment.ts
git checkout src/app/app.module.ts

# Supprimer les fichiers créés
Remove-Item src/app/core/interceptors/mock-http.interceptor.ts
Remove-Item src/app/core/config/mock.config.ts
```

### Pour d'autres repositories

**NE PAS appliquer ces modifications à d'autres forks !**

Ces modifications sont spécifiques au contexte de développement sans backend.

**Alternative recommandée** : Cloner et lancer le backend correspondant (ex: pwc-backend-v4)

---

## Checklist mise à jour

### Étape 1 : Identifier le fork
- [ ] Noter le nom du fork (ex: `-v4-ia`, `-v5-test`, etc.)
- [ ] Vérifier les chemins des repositories

### Étape 2 : Modifications npm
- [ ] Modifier `pwc-ui/package.json` : Adapter le chemin de `@pwc/shared`
- [ ] **NOUVEAU** : Ajouter `json-ignore` dans `pwc-ui/package.json` si nécessaire
- [ ] Vérifier `pwc-ui/.npmrc` : S'assurer que Nexus est configuré
- [ ] Vérifier `pwc-ui-shared/.npmrc` : S'assurer que Nexus est configuré

### Étape 3 : Modifications Gradle (si nécessaire)
- [ ] Ajouter variables Nexus dans `gradle.properties`
- [ ] Modifier `settings.gradle` pour fallback

### Étape 4 : Scripts utilitaires
- [ ] Créer/adapter `Use-Node10.bat` avec le bon chemin Node
- [ ] Créer/adapter les scripts start et install
- [ ] Adapter les chemins dans les scripts selon le nom du fork

### Étape 5 : Installation
- [ ] Installer pwc-ui-shared : `npm install --legacy-peer-deps --ignore-scripts`
- [ ] Installer pwc-ui : `npm install --legacy-peer-deps --ignore-scripts`
- [ ] Vérifier que les deux ont leurs node_modules

### Étape 6 : Test
- [ ] Lancer `start-pwc-ui.bat`
- [ ] Vérifier http://localhost:4200
- [ ] Vérifier la console navigateur (F12)

### Étape 7 : Backend (optionnel)
- [ ] Cloner le backend correspondant (ex: pwc-backend-v4)
- [ ] Lancer le backend
- [ ] **OU** Utiliser le système de mock HTTP (temporaire)

---

## Problèmes connus et solutions (mise à jour)

### Problème 1 : "Unexpected value 'undefined' imported by the module"
**Cause** : Lancement de pwc-ui-shared au lieu de pwc-ui  
**Solution** : Lancer pwc-ui (l'application principale)

### Problème 2 : "404 Not Found - @pwc/shared"
**Cause** : Lien local non configuré dans package.json  
**Solution** : Appliquer Modification 1

### Problème 3 : "No matching version found for xxx-hps"
**Cause** : .npmrc pointe vers npmjs.org au lieu de Nexus  
**Solution** : Appliquer Modification 2 et 3

### Problème 4 : "Cannot find module 'json-ignore'"
**Cause** : json-ignore manquant dans pwc-ui/package.json  
**Solution** : Appliquer Modification 4

### Problème 5 : "Please wait loading" infini
**Cause** : Backend non accessible  
**Solutions** :
- Option A : Cloner et lancer pwc-backend-v4
- Option B : Utiliser le système de mock HTTP (Modification 5 - temporaire)
- Vérifier console navigateur (F12) pour erreurs JavaScript

### Problème 6 : node_modules invisibles dans l'explorateur Windows
**Cause** : Indexation Windows ou antivirus  
**Solution** : 
- Rafraîchir l'explorateur (F5)
- Ouvrir via PowerShell : `explorer node_modules`
- Vérifier existence : `Test-Path node_modules`

---

## Historique (mise à jour)

| Version | Date | Auteur | Description |
|---------|------|--------|-------------|
| 1.0.0 | 2026-02-02 | Franck Desmedt / Kiro | Création initiale |
| 1.1.0 | 2026-02-02 | Franck Desmedt / Kiro | Ajout json-ignore et système mock HTTP |
