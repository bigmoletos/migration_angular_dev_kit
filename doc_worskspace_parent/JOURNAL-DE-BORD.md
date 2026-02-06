# Journal de Bord - Migration Angular 5 → 20

## Format des entrées
```
## [Version] - Date - Responsable
### Actions
- Description des modifications
### Fichiers modifiés
- Liste des fichiers avec chemins complets
### Rollback
- Instructions pour revenir en arrière
```

---

## [v0.1.0] - 2026-01-31 - Franck Desmedt / Kiro

### Actions
- Configuration initiale Nexus selon modop_nexus.md
- Ajout des variables Nexus et Docker dans gradle.properties
- Modification des settings.gradle pour fallback sur gradle.properties
- Configuration npm avec authentification Nexus

### Fichiers modifiés

#### Repository pwc-ui (C:\repo_hps\pwc-ui\pwc-ui-v4-ia)
- `gradle.properties`
  - Ajout variables Nexus (NEXUS_URL, NEXUS_MVN_PUBLIC_URL, etc.)
  - Ajout credentials: NEXUS_USER=hps-user, NEXUS_PASSWORD=SjuVFa2NAaxr7UQPD3vH8Pn2
  - Ajout variables Docker (dockerRegistry, dockerFromImage, etc.)

- `settings.gradle`
  - Modification du bloc maven repository
  - Avant: `url System.getenv('NEXUS_MVN_PUBLIC_URL')`
  - Après: `url System.getenv('NEXUS_MVN_PUBLIC_URL') ?: System.getProperty('NEXUS_MVN_PUBLIC_URL')`
  - Idem pour username et password

- `.npmrc`
  - Ajout authentification npm pour Nexus
  - registry=https://nexus.pwcv4.com/repository/npm-public/
  - _auth avec credentials readonly (readonly:evy@gnx5vem.QCT0ahc)
  - always-auth=true

#### Repository pwc-ui-shared (C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia)
- `gradle.properties`
  - Mêmes modifications que pwc-ui

- `settings.gradle`
  - Mêmes modifications que pwc-ui

- `.npmrc`
  - Mêmes modifications que pwc-ui

### Rollback
Tous les fichiers modifiés contiennent les anciennes configurations en commentaire.

Pour revenir en arrière:
1. Ouvrir chaque fichier modifié
2. Décommenter les lignes marquées "# Original configuration"
3. Supprimer ou commenter les lignes ajoutées

**gradle.properties**: Supprimer toutes les lignes commençant par `systemProp.NEXUS_` et `systemProp.docker`

**settings.gradle**: 
```gradle
// Remplacer
url System.getenv('NEXUS_MVN_PUBLIC_URL') ?: System.getProperty('NEXUS_MVN_PUBLIC_URL')
// Par
url System.getenv('NEXUS_MVN_PUBLIC_URL')
```

**.npmrc**: Supprimer les lignes d'authentification, garder uniquement:
```
registry=https://nexus.pwcv4.com/repository/npm-public/
```

### Problèmes rencontrés
1. **Nexus inaccessible**: Le serveur nexus.pwcv4.com (57.128.112.109) ne répond pas
   - Test de connectivité échoué (port 443)
   - Possibles causes: VPN requis, firewall, serveur down
   
2. **Packages custom HPS**: 
   - `jspdf@2.1.1-hps` n'existe pas sur npmjs.org
   - `terrabrasilis-jsonix@2.4.2-hps` n'existe pas sur npmjs.org
   - Ces packages nécessitent l'accès au Nexus privé

3. **Tentatives d'authentification multiples**: 
   - Testé avec credentials hps-user (échec de connexion)
   - Testé avec credentials readonly (échec de connexion)
   - Possible blocage temporaire de l'IP

### Solutions temporaires appliquées
- Configuration .npmrc pour utiliser registry.npmjs.org (commenté, en attente résolution accès Nexus)
- Cache npm nettoyé: `npm cache clean --force`

### Actions requises
1. Vérifier connectivité VPN vers nexus.pwcv4.com
2. Contacter admin système si Nexus reste inaccessible
3. Vérifier si IP bloquée suite aux tentatives d'authentification
4. Une fois Nexus accessible, décommenter la config Nexus dans .npmrc

### Documentation créée
- `kiro_migration_angular/MIGRATION-NEXUS-CONFIGURATION.md`: Documentation complète de la migration Nexus

---

## [v0.3.0] - 2026-02-02 - Franck Desmedt / Kiro

### Actions
- Installation des dépendances npm pour pwc-ui (application principale)
- Résolution du problème de dépendance @pwc/shared
- Configuration pour utiliser un lien local vers pwc-ui-shared
- Création des scripts batch utilitaires

### Fichiers modifiés

#### pwc-ui (C:\repo_hps\pwc-ui\pwc-ui-v4-ia)

**package.json** - Modification de la dépendance @pwc/shared
```json
// AVANT (ligne 35)
"@pwc/shared": "2.6.23",

// APRÈS (ligne 35) - Lien local vers pwc-ui-shared
"@pwc/shared": "file:C:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/src/lib/shared",
```
**Raison** : @pwc/shared n'existe pas sur npmjs.org, il faut utiliser la version locale de pwc-ui-shared

**.npmrc** - Activation de la configuration Nexus
```properties
# AVANT (commenté)
# registry=https://nexus.pwcv4.com/repository/npm-public/
# //nexus.pwcv4.com/repository/npm-public/:_auth=cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==
# //nexus.pwcv4.com/repository/npm-public/:always-auth=true

# TEMPORARY: Using official npm registry (Nexus not accessible)
registry=https://registry.npmjs.org/

# APRÈS (décommenté)
registry=https://nexus.pwcv4.com/repository/npm-public/
//nexus.pwcv4.com/repository/npm-public/:_auth=cmVhZG9ubHk6ZXZ5QGdueDV2ZW0uUUNUMGFoYw==
//nexus.pwcv4.com/repository/npm-public/:always-auth=true

# TEMPORARY: Using official npm registry (Nexus not accessible)
# registry=https://registry.npmjs.org/
```
**Raison** : Les packages custom HPS (terrabrasilis-jsonix@2.4.2-hps) nécessitent le Nexus

### Résultats
- ✅ 2518 packages installés dans pwc-ui
- ✅ 957 dossiers dans node_modules
- ✅ Packages custom HPS téléchargés depuis Nexus
- ✅ Lien local vers @pwc/shared fonctionnel

### Scripts créés (kiro_migration_angular/outils_communs/)
1. **Use-Node10.bat** - Alias centralisé pour Node v10
2. **install-dependencies.bat** - Installation interactive
3. **start-pwc-ui-shared.bat** - Lance pwc-ui-shared (bibliothèque)
4. **start-pwc-ui.bat** - Lance pwc-ui (application principale)
5. **README.md** - Documentation complète

### Problèmes rencontrés

1. **@pwc/shared introuvable sur npmjs.org**
   - Symptôme : `404 Not Found - GET https://registry.npmjs.org/@pwc%2fshared`
   - Cause : Package interne non publié sur npmjs.org
   - Solution : Lien local `file:C:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/src/lib/shared`

2. **terrabrasilis-jsonix@2.4.2-hps introuvable**
   - Symptôme : `No matching version found for terrabrasilis-jsonix@2.4.2-hps`
   - Cause : .npmrc pointait vers npmjs.org au lieu de Nexus
   - Solution : Réactivation de la configuration Nexus dans .npmrc

3. **Suffixe -v4-ia dans les noms de dossiers**
   - Les repositories sont des forks avec suffixe `-v4-ia`
   - Chemins utilisés :
     - `C:\repo_hps\pwc-ui\pwc-ui-v4-ia`
     - `C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia`
   - Tous les scripts et configurations utilisent ces chemins

### Rollback

#### Pour pwc-ui/package.json
```json
// Remplacer
"@pwc/shared": "file:C:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/src/lib/shared",
// Par
"@pwc/shared": "2.6.23",
```
Puis réinstaller : `npm install --legacy-peer-deps --ignore-scripts`

#### Pour pwc-ui/.npmrc
Commenter les lignes Nexus et décommenter registry.npmjs.org

### Points d'attention pour d'autres repositories

1. **Dépendances internes** : Vérifier si le projet a des dépendances vers d'autres packages internes
2. **Packages custom** : Identifier les packages avec suffixes custom (-hps, etc.)
3. **Configuration Nexus** : S'assurer que .npmrc pointe vers le bon registry
4. **Versions Node** : Utiliser la version Node compatible avec la version Angular
5. **Suffixes de fork** : Adapter les chemins si le repository a un suffixe différent

### Commande d'installation finale
```powershell
# Avec Node v10.24.1
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install --legacy-peer-deps --ignore-scripts
```

### Prochaines étapes
1. Lancer pwc-ui (pas pwc-ui-shared) : `start-pwc-ui.bat`
2. Tester l'IHM sur http://localhost:4200
3. Vérifier la connexion au backend si nécessaire

---

## [v0.2.0] - 2026-02-02 - Franck Desmedt / Kiro

### Actions
- Résolution du problème d'accès Nexus
- Installation réussie des node_modules pour pwc-ui-shared
- Configuration npm avec Node v10.24.1 (compatible Angular 5)

### Résultats
- **Nexus accessible** : Test de connectivité réussi (TcpTestSucceeded: True)
- **node_modules installés** : 1144 packages dans pwc-ui-shared-v4-ia
- Packages custom HPS téléchargés depuis Nexus :
  - jspdf@2.1.1-hps ✓
  - terrabrasilis-jsonix@2.4.2-hps ✓

### Commande utilisée
```powershell
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install --legacy-peer-deps --ignore-scripts
```

### Problèmes rencontrés et solutions
1. **Conflit de versions npm** : npm v11 trop strict
   - Solution : Utiliser `--legacy-peer-deps`

2. **node-sass compilation** : Nécessite Python 2.x mais Python 3.11 installé
   - Solution : Utiliser `--ignore-scripts` pour ignorer les scripts de build
   - Note : node-sass est deprecated, sera remplacé lors de la migration Angular 20

3. **Version Node incompatible** : Node v24 trop récent pour Angular 5
   - Solution : Utiliser Node v10.24.1 (compatible avec Angular 5)

### Configuration Nexus validée
- URL : https://nexus.pwcv4.com/repository/npm-public/
- Credentials : readonly / evy@gnx5vem.QCT0ahc
- Authentification : _auth en Base64
- Statut : ✓ Opérationnel

### Prochaines étapes
1. Tester le build du projet : `npm run build`
2. Tester le serveur de dev : `npm start`
3. Répéter l'installation pour pwc-ui (main application)

---

## [v0.8.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Ajout des commentaires de traçabilité dans tous les fichiers modifiés des deux repos
- Documentation de 4 nouvelles modifications (mod-009 à mod-012)
- Application du système de traçabilité sur les fichiers existants
- Identification des fichiers temporaires à supprimer avant commit

### Fichiers modifiés avec commentaires ajoutés (7 fichiers)

#### pwc-ui (5 fichiers)
- `.npmrc` (mod-003) - ✅ Commentaires MODIFIED ajoutés
- `package.json` (mod-007, mod-008) - ✅ Commentaires MODIFIED + NEW ajoutés
- `tsconfig.json` (mod-009) - ✅ Commentaires MODIFIED ajoutés
- `src/app/app.module.ts` (mod-011) - ✅ Commentaires TEMPORARY ajoutés
- `src/environments/environment.ts` (mod-012) - ✅ Commentaires TEMPORARY ajoutés

#### pwc-ui-shared (2 fichiers)
- `.npmrc` (mod-006) - ✅ Commentaires MODIFIED ajoutés
- `src/app/app.module.ts` (mod-010) - ✅ Commentaires DEPRECATED ajoutés

### Nouvelles Modifications Enregistrées

#### mod-009 : tsconfig.json (pwc-ui)
- **Type** : modification
- **Description** : Configuration TypeScript pour @pwc/shared
- **Raison** : Ajout des chemins et inclusion de node_modules/@pwc/shared
- **Version** : v0.8.0

#### mod-010 : app.module.ts (pwc-ui-shared)
- **Type** : deprecation
- **Description** : Suppression TreeDemoModule
- **Raison** : Tests locaux sans TreeDemoModule
- **Version** : v0.8.0

#### mod-011 : app.module.ts + mock files (pwc-ui)
- **Type** : addition (TEMPORARY)
- **Description** : Import mock providers
- **Raison** : Tests frontend sans backend
- **Version** : v0.4.0
- **⚠️ À SUPPRIMER** : Avant commit en production

#### mod-012 : environment.ts (pwc-ui)
- **Type** : modification (TEMPORARY)
- **Description** : Activation mode mock
- **Raison** : Dev frontend sans backend
- **Version** : v0.4.0
- **⚠️ À SUPPRIMER** : Mettre mock: false avant commit

### Format des Commentaires Appliqués

#### MODIFIED (Modification)
```typescript
// ORIGINAL: <ligne originale>
// MODIFIED: 2026-02-03 - Kiro - Description (mod-XXX)
<nouvelle ligne>
```

#### NEW (Ajout)
```typescript
// NEW: 2026-02-03 - Kiro - Description (mod-XXX)
<nouvelle ligne>
```

#### DEPRECATED (Suppression)
```typescript
// DEPRECATED: 2026-02-03 - Kiro - Description (mod-XXX)
// <ancienne ligne commentée>
```

#### TEMPORARY (Temporaire)
```typescript
// TEMPORARY: 2026-02-03 - Kiro - Description (mod-XXX)
// WARNING: A SUPPRIMER avant commit en production
<ligne temporaire>
```

### Fichiers Temporaires Identifiés

⚠️ **À SUPPRIMER avant commit** :
- `pwc-ui/src/app/core/config/mock.config.ts`
- `pwc-ui/src/app/core/interceptors/mock-http.interceptor.ts`

Ces fichiers sont pour tests frontend uniquement et ne doivent PAS être commités.

### Rollback

#### Pour supprimer les commentaires
```powershell
# Restaurer depuis les backups
.\scripts_outils_ia\rollback.ps1 -Date "2026-02-03"

# Ou restaurer depuis Git
git checkout pwc-ui/.npmrc
git checkout pwc-ui/package.json
git checkout pwc-ui/tsconfig.json
git checkout pwc-ui/src/app/app.module.ts
git checkout pwc-ui/src/environments/environment.ts
git checkout pwc-ui-shared/.npmrc
git checkout pwc-ui-shared/src/app/app.module.ts
```

### Prochaines Étapes

1. ✅ Commentaires ajoutés dans tous les fichiers
2. ⏳ Vérifier avec `.\scripts_outils_ia\verify-comments.ps1`
3. ⏳ Supprimer les fichiers temporaires (mock)
4. ⏳ Mettre `mock: false` dans environment.ts
5. ⏳ Commit avec message détaillé incluant les IDs de modification
6. ⏳ Push vers le repo

### Métriques

- Fichiers modifiés : 7
- Commentaires ajoutés : 12
- Modifications enregistrées : 4 nouvelles (mod-009 à mod-012)
- Total modifications : 12 (mod-001 à mod-012)
- Fichiers temporaires : 2
- Temps de documentation : ~2 heures

### Leçons Apprises

- Les commentaires de traçabilité facilitent grandement le rollback
- Les modifications temporaires doivent être clairement marquées avec WARNING
- Le format MODIFIED/NEW/DEPRECATED/TEMPORARY est clair et cohérent
- L'ID de modification permet de lier le code au journal de bord
- Les fichiers temporaires doivent être identifiés dès leur création

---

## [v0.7.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Création d'un système complet de gestion des modifications avec backup et rollback
- Mise en place d'un index de traçabilité de toutes les modifications
- Création de scripts PowerShell pour backup, rollback et vérification
- Documentation complète des règles de modification
- Import des modifications existantes depuis le journal de bord

### Fichiers créés (12 nouveaux fichiers)

#### Steering
- `.kiro/steering/12-modification-rules.md` - Règles complètes de modification et rollback

#### Index et Backups
- `.kiro/state/modifications-index.json` - Index de toutes les modifications
- `.kiro-backup/backup/README.md` - Documentation du système de backup

#### Scripts PowerShell (9 fichiers)
- `scripts_outils_ia/backup-file.ps1` - Créer un backup avant modification
- `scripts_outils_ia/register-modification.ps1` - Enregistrer une modification dans l'index
- `scripts_outils_ia/rollback.ps1` - Effectuer un rollback
- `scripts_outils_ia/list-modifications.ps1` - Lister les modifications
- `scripts_outils_ia/verify-backups.ps1` - Vérifier que tous les backups existent
- `scripts_outils_ia/verify-comments.ps1` - Vérifier que les fichiers ont des commentaires
- `scripts_outils_ia/cleanup-backups.ps1` - Nettoyer les anciens backups
- `scripts_outils_ia/import-existing-modifications.ps1` - Importer les modifications existantes
- `scripts_outils_ia/README-MODIFICATION-SYSTEM.md` - Documentation complète du système

### Règles de Modification

#### 1. Ne JAMAIS Supprimer de Lignes
```javascript
// ❌ INTERDIT
// Code supprimé sans trace

// ✅ OBLIGATOIRE
// DEPRECATED: 2026-02-03 - Kiro - Raison (mod-001)
// const oldFunction = () => { };
```

#### 2. Toujours Commenter les Modifications
```json
{
  // ORIGINAL: "value": "old"
  // MODIFIED: 2026-02-03 - Kiro - Description (mod-001)
  "value": "new"
}
```

#### 3. Toujours Créer un Backup
```powershell
.\scripts_outils_ia\backup-file.ps1 -File "path/to/file"
```

#### 4. Toujours Enregistrer dans l'Index
```powershell
.\scripts_outils_ia\register-modification.ps1 `
    -File "path/to/file" `
    -Type "modification" `
    -Description "Description"
```

### Workflow de Modification

```
1. Backup
   ↓
2. Enregistrer dans l'index
   ↓
3. Modifier avec commentaires
   ↓
4. Vérifier
```

### Commandes Principales

#### Créer un Backup
```powershell
.\scripts_outils_ia\backup-file.ps1 -File "path/to/file"
```

#### Enregistrer une Modification
```powershell
.\scripts_outils_ia\register-modification.ps1 `
    -File "path/to/file" `
    -Type "modification" `
    -Description "Description" `
    -Reason "Raison" `
    -RelatedJournalEntry "v0.7.0"
```

#### Rollback
```powershell
# Par ID
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"

# Par fichier
.\scripts_outils_ia\rollback.ps1 -File "package.json"

# Par date
.\scripts_outils_ia\rollback.ps1 -Date "2026-02-03"

# Par version du journal
.\scripts_outils_ia\rollback.ps1 -JournalVersion "v0.4.0"
```

#### Lister les Modifications
```powershell
# Toutes
.\scripts_outils_ia\list-modifications.ps1

# Détaillé
.\scripts_outils_ia\list-modifications.ps1 -Detailed

# Par fichier
.\scripts_outils_ia\list-modifications.ps1 -File "package.json"
```

#### Vérifier
```powershell
# Vérifier les backups
.\scripts_outils_ia\verify-backups.ps1

# Vérifier les commentaires
.\scripts_outils_ia\verify-comments.ps1
```

### Import des Modifications Existantes

```powershell
# Importer les modifications depuis le journal de bord
.\scripts_outils_ia\import-existing-modifications.ps1
```

Cela importe automatiquement les 8 modifications des versions v0.1.0 à v0.4.0 :
- 6 modifications Nexus (gradle.properties, settings.gradle, .npmrc)
- 2 modifications package.json (@pwc/shared, json-ignore)

### Avantages du Système

1. **Traçabilité Complète** : Chaque modification est enregistrée avec ID unique
2. **Rollback Sans Git** : Possibilité de rollback sans dépendre de Git
3. **Backups Automatiques** : Backup créé avant chaque modification
4. **Vérification** : Scripts pour vérifier l'intégrité des backups et commentaires
5. **Nettoyage** : Suppression automatique des anciens backups (30 jours)
6. **Documentation** : Lien avec le journal de bord via `relatedJournalEntry`

### Structure de l'Index

```json
{
  "id": "mod-001",
  "date": "2026-02-03T14:30:00Z",
  "author": "Kiro",
  "file": "path/to/file",
  "type": "modification",
  "description": "Description",
  "reason": "Raison",
  "backup": ".kiro-backup/backup/2026-02-03/mod-001-file.bak",
  "rollbackCommand": "Copy-Item ... -Force",
  "changes": [],
  "relatedJournalEntry": "v0.7.0",
  "status": "applied"
}
```

### Rollback

#### Pour supprimer le système
```powershell
# Supprimer les fichiers
Remove-Item .kiro/steering/12-modification-rules.md
Remove-Item .kiro/state/modifications-index.json
Remove-Item .kiro-backup -Recurse -Force
Remove-Item scripts_outils_ia/backup-file.ps1
Remove-Item scripts_outils_ia/register-modification.ps1
Remove-Item scripts_outils_ia/rollback.ps1
Remove-Item scripts_outils_ia/list-modifications.ps1
Remove-Item scripts_outils_ia/verify-backups.ps1
Remove-Item scripts_outils_ia/verify-comments.ps1
Remove-Item scripts_outils_ia/cleanup-backups.ps1
Remove-Item scripts_outils_ia/import-existing-modifications.ps1
Remove-Item scripts_outils_ia/README-MODIFICATION-SYSTEM.md
```

### Prochaines Étapes

1. Importer les modifications existantes : `.\scripts_outils_ia\import-existing-modifications.ps1`
2. Vérifier les backups : `.\scripts_outils_ia\verify-backups.ps1`
3. Vérifier les commentaires : `.\scripts_outils_ia\verify-comments.ps1`
4. Utiliser le système pour toutes les futures modifications

### Métriques

- Fichiers créés : 12
- Scripts PowerShell : 9
- Règles documentées : 4 principales
- Modifications importées : 8 (depuis v0.1.0 à v0.4.0)
- Temps de création : ~4 heures

### Leçons Apprises

- Un système de rollback indépendant de Git est essentiel
- Les commentaires dans le code garantissent la traçabilité
- Les backups automatiques évitent les pertes de données
- L'index JSON permet une gestion programmatique des modifications
- Le lien avec le journal de bord assure la cohérence

---

## [v0.6.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Intégration complète des scripts batch dans les specs et workflows
- Ajout du gate Playwright BLOQUANT dans le processus de migration
- Mise à jour de tous les fichiers de specs pour utiliser les scripts batch
- Documentation du workflow complet avec gate de validation E2E
- Création de scripts batch pour lancement des applications sur ports dédiés

### Fichiers modifiés (7 fichiers)

#### Specs
- `.kiro/specs/04-palier-01-angular-5-to-6.md`
  - Nouvelle étape 1.9 : "🚦 GATE PLAYWRIGHT - Tests E2E Demo (BLOQUANT)"
  - Installation Playwright avec script batch `start-pwc-ui-shared-4201.bat`
  - Validation du gate à 100% obligatoire avant pwc-ui
  - Étape 2.11 : Lancement de pwc-ui avec script batch `start-pwc-ui.bat`

- `.kiro/specs/02-plan-migration.md`
  - Section "Validation à Chaque Palier" complètement réécrite
  - Phase 1 : pwc-ui-shared avec gate Playwright intégré
  - Phase 2 : pwc-ui (après gate validé uniquement)
  - Commandes avec scripts batch documentées

- `.kiro/specs/00-resume-executif.md`
  - Section "Prochaines Étapes" mise à jour
  - Palier 1 : pwc-ui-shared avec gate Playwright
  - Palier 1 : pwc-ui avec note "Seulement si Gate Validé"
  - Validation Palier 1 avec gate en critère BLOQUANT

- `.kiro/specs/README.md`
  - Scripts batch ajoutés dans la section outils
  - Checklist mise à jour avec scripts batch

#### Steering
- `.kiro/steering/11-playwright-e2e-testing.md`
  - Scripts batch intégrés dans toutes les commandes
  - Section "Lancer les Applications" avec scripts batch
  - Avantages des scripts documentés

- `.kiro/specs/10-workflow-tests-playwright.md`
  - Workflow complet avec scripts batch
  - Tableau récapitulatif des scripts
  - Options 1 (script batch) et 2 (manuel)

- `.kiro/steering/10-local-dev-config.md`
  - Scripts batch pour configuration dev local
  - Ports dédiés documentés

### Scripts Batch Créés

#### Pour pwc-ui-shared
- `start-pwc-ui-shared-4201.bat` - Lance pwc-ui-shared sur port 4201 (pour tests E2E)

#### Pour pwc-ui
- `start-pwc-ui.bat` - Lance pwc-ui sur port 4200 (application principale)

### Workflow Complet Intégré

```
┌──────────────────────────────────────────────────────────┐
│ 1. pwc-ui-shared                                          │
│    ├─ Migration Angular                                   │
│    ├─ npm run build                                       │
│    ├─ npm test (>95%)                                     │
│    ├─ 🚦 GATE PLAYWRIGHT :                               │
│    │  ├─ start-pwc-ui-shared-4201.bat (Terminal 1)      │
│    │  └─ npm run test:e2e (Terminal 2) → 100% ✅        │
│    └─ npm publish (si gate OK)                           │
└──────────────────────────────────────────────────────────┘
         ↓
    ✅ GATE VALIDÉ
         ↓
┌──────────────────────────────────────────────────────────┐
│ 2. pwc-ui (APRÈS GATE VALIDÉ)                            │
│    ├─ npm install pwc-ui-shared@latest                   │
│    ├─ Migration Angular                                   │
│    ├─ npm run build                                       │
│    ├─ npm test                                            │
│    └─ start-pwc-ui.bat → http://localhost:4200          │
└──────────────────────────────────────────────────────────┘
```

### Gate Playwright - Critères BLOQUANTS

**Règle d'Or** : Le gate Playwright doit passer à 100% avant de migrer pwc-ui

1. **Lancement** : `start-pwc-ui-shared-4201.bat` (Terminal 1)
2. **Tests E2E** : `npm run test:e2e` (Terminal 2)
3. **Validation** : 100% des tests doivent passer ✅
4. **Blocage** : Si gate échoue, NE PAS passer à pwc-ui

### Avantages de l'Intégration

1. **Simplicité** : Scripts batch prêts à l'emploi
2. **Ports dédiés** : Évite les conflits (4201 pour tests, 4200 pour app)
3. **Sécurité** : Gate bloquant garantit la qualité
4. **Documentation** : Workflow clair dans toutes les specs
5. **Traçabilité** : Chaque palier suit le même processus

### Rollback

#### Pour restaurer les specs
```powershell
git checkout .kiro/specs/04-palier-01-angular-5-to-6.md
git checkout .kiro/specs/02-plan-migration.md
git checkout .kiro/specs/00-resume-executif.md
git checkout .kiro/specs/README.md
```

#### Pour restaurer les steering
```powershell
git checkout .kiro/steering/11-playwright-e2e-testing.md
git checkout .kiro/specs/10-workflow-tests-playwright.md
git checkout .kiro/steering/10-local-dev-config.md
```

### Prochaines Étapes

1. Tester les scripts batch avant le Palier 1
2. Valider que le gate Playwright fonctionne à 100%
3. Suivre le workflow documenté pour chaque palier
4. Ne jamais passer à pwc-ui si le gate échoue

### Métriques

- Fichiers modifiés : 7 (4 specs + 3 steering)
- Scripts batch créés : 2
- Gate ajouté : 1 (Playwright E2E)
- Workflow documenté : 100%
- Temps de documentation : ~3 heures

### Leçons Apprises

- Un gate bloquant garantit la qualité à chaque palier
- Les scripts batch simplifient l'exécution pour tous les développeurs
- La documentation dans les specs assure que le processus est suivi
- Les ports dédiés évitent les conflits lors des tests E2E

---

## [v0.5.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Création d'un système complet de gestion des versions Node.js avec raccourcis PowerShell
- Création de 7 scripts PowerShell Use-NodeXX pour basculer entre les versions Node.js
- Documentation complète de la matrice versions Node.js par palier Angular
- Mise à jour de toutes les specs et steerings pour utiliser les nouveaux raccourcis
- Création d'un guide d'utilisation des scripts PowerShell

### Fichiers créés (9 nouveaux fichiers)

#### Steering
- `.kiro/steering/09-version-management.md` - Guide complet de gestion des versions avec matrice par palier

#### Scripts PowerShell (7 fichiers)
- `scripts_outils_ia/Use-Node10.ps1` - Node v10.24.1 (Angular 5-8, Paliers 1-4)
- `scripts_outils_ia/Use-Node12.ps1` - Node v12.22.12 (Angular 9-11, Paliers 5-7)
- `scripts_outils_ia/Use-Node14.ps1` - Node v14.21.3 (Angular 12, Palier 8)
- `scripts_outils_ia/Use-Node16.ps1` - Node v16.20.2 (Angular 13-14, Paliers 9-10)
- `scripts_outils_ia/Use-Node18.ps1` - Node v18.20.4 (Angular 15-17, Paliers 11-13)
- `scripts_outils_ia/Use-Node20.ps1` - Node v20.18.0 (Angular 18-19, Palier 14)
- `scripts_outils_ia/Use-Node22.ps1` - Node v22.11.0 (Angular 20, Palier 15)

#### Documentation
- `scripts_outils_ia/README-USE-NODE.md` - Guide d'utilisation des scripts Use-NodeXX

### Fichiers modifiés (4 fichiers)

#### Specs
- `.kiro/specs/README.md` - Ajout du steering 09 et référence aux scripts Use-NodeXX
- `.kiro/specs/00-resume-executif.md` - Remplacement des commandes `node -v` par `Use-NodeXX`

#### Steering
- `.kiro/steering/02-migration-angular-rules.md` - Ajout des commandes Use-NodeXX dans les workflows

#### Documentation
- `.kiro/MIGRATION-COMPLETE-SETUP.md` - Mise à jour avec les nouveaux scripts et matrice versions

### Matrice Versions Node.js par Palier

| Palier | Angular | Node.js | Commande |
|--------|---------|---------|----------|
| 1-4 | 5→8 | v10.24.1 | `Use-Node10` |
| 5-7 | 9→11 | v12.22.12 | `Use-Node12` |
| 8 | 12 | v14.21.3 | `Use-Node14` |
| 9-10 | 13→14 | v16.20.2 | `Use-Node16` |
| 11-13 | 15→17 | v18.20.4 | `Use-Node18` |
| 14 | 18→19 | v20.18.0 | `Use-Node20` |
| 15 | 20 | v22.11.0 | `Use-Node22` |

### Workflow Typique

```powershell
# 1. Basculer vers la bonne version
Use-Node10

# 2. Vérifier
node --version  # v10.24.1

# 3. Aller dans le repo
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# 4. Installer les dépendances
npm install

# 5. Commencer la migration
ng update @angular/cli@6 @angular/core@6
```

### Rollback

#### Pour supprimer les scripts Use-NodeXX
```powershell
# Supprimer les 7 scripts PowerShell
Remove-Item scripts_outils_ia/Use-Node*.ps1

# Supprimer le README
Remove-Item scripts_outils_ia/README-USE-NODE.md

# Supprimer le steering
Remove-Item .kiro/steering/09-version-management.md
```

#### Pour restaurer les fichiers modifiés
```powershell
# Restaurer les versions originales depuis Git
git checkout .kiro/specs/README.md
git checkout .kiro/specs/00-resume-executif.md
git checkout .kiro/steering/02-migration-angular-rules.md
git checkout .kiro/MIGRATION-COMPLETE-SETUP.md
```

### Avantages du Système

1. **Simplicité** : Une seule commande pour basculer de version (`Use-Node10`)
2. **Cohérence** : Garantit la bonne version pour chaque palier
3. **Rapidité** : Pas besoin de chercher quelle version utiliser
4. **Sécurité** : Évite les erreurs de version incompatible
5. **Documentation** : Chaque script indique les paliers compatibles
6. **Traçabilité** : Matrice complète versions/paliers dans le steering

### Installation Requise

Les 7 versions de Node.js doivent être téléchargées et extraites dans :
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

### Prochaines Étapes

1. Installer les 7 versions de Node.js
2. Tester `Use-Node10` avant de commencer le Palier 1
3. Vérifier avec `node --version` que la version est correcte
4. Utiliser les raccourcis dans tous les workflows de migration

### Métriques

- Fichiers créés : 9
- Fichiers modifiés : 4
- Total fichiers du projet : 31 (22 + 9 nouveaux)
- Temps de création : ~2 heures
- Versions Node.js supportées : 7

### Leçons Apprises

- Les raccourcis PowerShell simplifient grandement la gestion des versions
- Une matrice claire versions/paliers évite les erreurs
- La documentation centralisée dans un steering facilite la maintenance
- Les scripts doivent être testés avant utilisation en production

---

## [Template pour prochaines entrées]

## [vX.X.X] - YYYY-MM-DD - Nom du responsable

### Actions
- 

### Fichiers modifiés
- 

### Rollback
- 

### Problèmes rencontrés
- 

### Solutions appliquées
- 

---

## Notes importantes

### Credentials Nexus (selon modop_nexus.md)
- **Admin**: hps-user / SjuVFa2NAaxr7UQPD3vH8Pn2
- **Readonly**: readonly / evy@gnx5vem.QCT0ahc
- **Docker**: hps-user / uWz7^x0^D5VoLUw9

### URLs Nexus
- Base: https://nexus.pwcv4.com
- Maven Public: https://nexus.pwcv4.com/repository/maven-public/
- Maven Releases: https://nexus.pwcv4.com/repository/maven-releases/
- Maven Snapshots: https://nexus.pwcv4.com/repository/maven-snapshots/
- NPM Public: https://nexus.pwcv4.com/repository/npm-public/
- NPM Private: https://nexus.pwcv4.com/repository/npm-private/

### Packages custom HPS à surveiller
- jspdf@2.1.1-hps
- terrabrasilis-jsonix@2.4.2-hps

Ces packages devront être vérifiés/mis à jour lors de la migration Angular 20.


## [v0.4.0] - 2026-02-02 - Franck Desmedt / Kiro

### Actions
- Résolution du problème "Cannot find module 'json-ignore'"
- Ajout de json-ignore dans les dépendances de pwc-ui
- Création d'un système de mock HTTP pour tests frontend sans backend
- Identification du problème de chargement IHM (backend manquant)

### Fichiers modifiés

#### pwc-ui (C:\repo_hps\pwc-ui\pwc-ui-v4-ia)

**package.json** - Ajout de la dépendance json-ignore
```json
// AVANT (ligne 41)
"fp-ts": "1.14.4",
"fullpage.js": "^2.9.7",
"htmllint": "~0.7.0",

// APRÈS (ligne 41-43)
"fp-ts": "1.14.4",
"fullpage.js": "^2.9.7",
"json-ignore": "^0.4.0",
"htmllint": "~0.7.0",
```
**Raison** : json-ignore est utilisé par @pwc/shared mais n'était pas déclaré dans pwc-ui

**Installation** :
```powershell
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64\npm.cmd install json-ignore --legacy-peer-deps --ignore-scripts
```
**Résultat** : json-ignore@0.4.0 installé avec succès

### Fichiers créés (TEMPORAIRES - À SUPPRIMER)

⚠️ **ATTENTION** : Ces fichiers sont temporaires pour tests frontend uniquement

**src/app/core/interceptors/mock-http.interceptor.ts**
- Intercepteur HTTP pour mocker les appels API
- Simule les réponses backend (auth, traductions, config)
- Active uniquement si `environment.mock = true`

**src/app/core/config/mock.config.ts**
- Configuration du provider HTTP mock
- Exporte MOCK_PROVIDERS pour injection dans app.module

**src/environments/environment.ts** - Ajout variable mock
```typescript
export const environment = {
    production: false,
    name: 'UAT',
    appName: null,
    apiUrl: '/rest/',
    mock: true, // AJOUT: Active le mode mock pour dev frontend sans backend
    // ... reste inchangé
```

**src/app/app.module.ts** - Ajout du provider mock
```typescript
// AJOUT import
import { MOCK_PROVIDERS } from './core/config/mock.config';

// AJOUT dans providers
providers: [
    // ... providers existants
    ...MOCK_PROVIDERS // AJOUT: Active l'intercepteur mock si environment.mock = true
]
```

### Documentation créée

**Documentation/TODO-NETTOYAGE-MOCK.md**
- Consignes de nettoyage des fichiers mock temporaires
- Commandes de rollback pour restaurer les fichiers modifiés
- ⚠️ À consulter AVANT de committer dans Git

### Problèmes identifiés

1. **Module json-ignore manquant**
   - Symptôme : `Cannot find module 'json-ignore'` lors de la compilation
   - Cause : json-ignore utilisé dans @pwc/shared mais pas dans pwc-ui/package.json
   - Solution : Ajout de json-ignore@^0.4.0 dans les dependencies

2. **IHM bloquée sur "Please wait loading"**
   - Symptôme : Page reste indéfiniment sur l'écran de chargement
   - Cause : Application attend les réponses API du backend (apiUrl: '/rest/')
   - Backend requis : pwc-backend-v4 (non cloné)
   - Solution temporaire : Système de mock HTTP créé

3. **Dépendances circulaires (warnings)**
   - Symptôme : Warnings dans la console sur circular dependencies
   - Impact : Non bloquant, existait déjà dans le code original
   - Action : Aucune (sera traité lors de la migration Angular 20)

4. **node_modules invisibles dans l'explorateur Windows**
   - Symptôme : Dossiers node_modules non visibles dans l'explorateur
   - Vérification : Existent bien (pwc-ui: 958 dossiers, pwc-ui-shared: 1142 dossiers)
   - Cause : Indexation Windows ou antivirus
   - Solution : Rafraîchir l'explorateur (F5) ou ouvrir via PowerShell

### Architecture identifiée

**Frontend** : pwc-ui (Angular 5)
- Port : 4200
- API : /rest/ (relatif)
- Dépend de : @pwc/shared (pwc-ui-shared)

**Backend** : pwc-backend-v4 (non cloné)
- Requis pour : Authentification, données, API REST
- Sans backend : IHM bloquée sur écran de chargement

**Bibliothèque** : pwc-ui-shared
- Contient : Composants, services, store NGRX
- Utilisée par : pwc-ui via lien local

### Rollback

#### Pour supprimer json-ignore (si nécessaire)
```json
// Dans package.json, supprimer la ligne
"json-ignore": "^0.4.0",
```
Puis : `npm uninstall json-ignore`

#### Pour nettoyer les fichiers mock
**Consulter** : `Documentation/TODO-NETTOYAGE-MOCK.md`

**Commande rapide** :
```powershell
# Restaurer les fichiers modifiés
git checkout src/environments/environment.ts
git checkout src/app/app.module.ts

# Supprimer les fichiers créés
Remove-Item src/app/core/interceptors/mock-http.interceptor.ts
Remove-Item src/app/core/config/mock.config.ts
```

### Prochaines étapes

1. **Tester le mock HTTP**
   - Relancer : `npm start`
   - Vérifier : http://localhost:4200
   - Attendu : IHM se charge avec données mockées

2. **Décision backend**
   - Option A : Cloner pwc-backend-v4 pour tests complets
   - Option B : Continuer avec mock pour migration Angular

3. **Migration Angular 5 → 20**
   - Commencer par pwc-ui-shared (bibliothèque)
   - Puis migrer pwc-ui (application)
   - Tests avec backend après migration

### Notes importantes

⚠️ **Fichiers mock = TEMPORAIRES**
- Ne JAMAIS committer dans Git
- Supprimer après validation IHM
- Consulter TODO-NETTOYAGE-MOCK.md

⚠️ **Fork vs Branche**
- pwc-ui-v4-ia : Branche du repo hps-dops/pwc-ui-v4-ia (PAS un fork)
- Jenkins voit les commits car c'est le repo principal
- Pour fork isolé : Créer un vrai fork sur Bitbucket

### Commandes utiles

```powershell
# Vérifier node_modules
Get-ChildItem node_modules -Directory | Measure-Object

# Lancer le serveur
npm start

# Nettoyer les mocks
git checkout src/environments/environment.ts src/app/app.module.ts
Remove-Item src/app/core/interceptors/mock-http.interceptor.ts -ErrorAction SilentlyContinue
Remove-Item src/app/core/config/mock.config.ts -ErrorAction SilentlyContinue
```

## [v0.9.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Désactivation du mode mock dans environment.ts (mock: false)
- Désactivation des imports mock dans app.module.ts
- Suppression des fichiers temporaires mock (mock.config.ts, mock-http.interceptor.ts)
- Commits Git des modifications avec traçabilité complète
- Application du hook rules-reminder avant commit

### Fichiers modifiés (5 fichiers)

#### pwc-ui (3 fichiers)
- `src/environments/environment.ts` (mod-012)
  - AVANT: `mock: true`
  - APRÈS: `mock: false`
  - Commentaire MODIFIED ajouté

- `src/app/app.module.ts` (mod-011)
  - Import MOCK_PROVIDERS commenté (DEPRECATED)
  - Spread operator ...MOCK_PROVIDERS commenté (DEPRECATED)

#### Fichiers supprimés (2 fichiers)
- `src/app/core/config/mock.config.ts` - ✅ Supprimé
- `src/app/core/interceptors/mock-http.interceptor.ts` - ✅ Supprimé

### Commits Git Effectués

#### pwc-ui-shared (commit 3a5191bf4)
```
feat: [mod-006,mod-010] Configuration Nexus et suppression TreeDemoModule

Modifications appliquees:

mod-006 (MODIFIED) - .npmrc
  - Configuration authentification Nexus
  - Raison: Acces aux packages custom HPS
  - Date: 2026-01-31

mod-010 (DEPRECATED) - src/app/app.module.ts
  - Suppression TreeDemoModule pour tests locaux
  - Raison: Module de demo non necessaire pour migration
  - Date: 2026-02-03

Fichiers modifies:
  - .npmrc (configuration Nexus)
  - package.json (dependances)
  - src/app/app.module.ts (suppression TreeDemoModule)

Tracabilite: Voir .kiro/state/modifications-index.json
Journal: Documentation/JOURNAL-DE-BORD.md v0.8.0
```

#### pwc-ui (commit fa503fe07e)
```
feat: [mod-003,mod-007,mod-008,mod-009,mod-011,mod-012] Configuration Nexus, lien local @pwc/shared, tsconfig

Modifications appliquees:

mod-003 (MODIFIED) - .npmrc
  - Configuration authentification Nexus
  - Raison: Acces aux packages custom HPS
  - Date: 2026-01-31

mod-007 (MODIFIED) - package.json
  - Lien local vers @pwc/shared
  - Raison: @pwc/shared n'existe pas sur npmjs.org
  - Date: 2026-02-02

mod-008 (NEW) - package.json
  - Ajout de json-ignore
  - Raison: json-ignore utilise par @pwc/shared mais non declare
  - Date: 2026-02-02

mod-009 (MODIFIED) - tsconfig.json
  - Ajout du chemin vers @pwc/shared pour resolution des imports
  - Ajout de node_modules/@pwc/shared pour compilation TypeScript
  - Exclusion de node_modules sauf @pwc/shared
  - Date: 2026-02-03

mod-011 (DEPRECATED) - src/app/app.module.ts
  - Import mock providers desactive pour commit
  - Fichiers temporaires mock supprimes
  - Date: 2026-02-03

mod-012 (MODIFIED) - src/environments/environment.ts
  - Mode mock desactive (mock: false)
  - Date: 2026-02-03

Fichiers modifies:
  - .npmrc (configuration Nexus)
  - package.json (lien local @pwc/shared + json-ignore)
  - tsconfig.json (paths et includes)
  - src/app/app.module.ts (mock desactive)
  - src/environments/environment.ts (mock: false)

Fichiers temporaires supprimes:
  - src/app/core/config/mock.config.ts
  - src/app/core/interceptors/mock-http.interceptor.ts

Tracabilite: Voir .kiro/state/modifications-index.json
Journal: Documentation/JOURNAL-DE-BORD.md v0.8.0
```

### Hook Rules-Reminder Exécuté

Le hook `.kiro/hooks/rules-reminder.json` a été lu avant les commits pour rappeler les règles critiques :
- ✅ Rester sur branche `dev_vibecoding`
- ✅ Ne jamais créer/supprimer de branches
- ✅ Ne jamais faire de Pull Request
- ✅ Règle d'or migration : pwc-ui-shared → pwc-ui
- ✅ Propreté workspace : fichiers temporaires supprimés

### Rollback

#### Pour annuler les commits
```powershell
# pwc-ui-shared
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia
git reset --soft HEAD~1

# pwc-ui
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia
git reset --soft HEAD~1
```

#### Pour restaurer les fichiers mock
```powershell
# Restaurer depuis Git (avant suppression)
git checkout HEAD~1 -- src/app/core/config/mock.config.ts
git checkout HEAD~1 -- src/app/core/interceptors/mock-http.interceptor.ts
```

#### Pour réactiver le mode mock
```powershell
# Restaurer environment.ts
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-012"

# Restaurer app.module.ts
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-011"
```

### Statut Git Après Commits

#### pwc-ui-shared
```
On branch dev_vibecoding
Untracked files:
  .kiro/
  package.json.backup

nothing to commit (working tree clean)
```

#### pwc-ui
```
On branch dev_vibecoding
Untracked files:
  .kiro/

nothing to commit (working tree clean)
```

### Prochaines Étapes

1. ✅ Commits effectués sur les deux repos
2. ⏳ Push vers le remote (si nécessaire)
3. ⏳ Vérifier que les applications démarrent correctement
4. ⏳ Commencer le Palier 1 de la migration Angular

### Métriques

- Fichiers modifiés : 5
- Fichiers supprimés : 2
- Commits effectués : 2
- Modifications tracées : 6 (mod-003, mod-006, mod-007, mod-008, mod-009, mod-010, mod-011, mod-012)
- Temps de commit : ~30 minutes

### Leçons Apprises

- Le hook rules-reminder est utile pour rappeler les règles avant commit
- Les fichiers temporaires doivent être supprimés avant commit
- Les messages de commit détaillés avec IDs de modification facilitent la traçabilité
- Le mode mock doit être désactivé pour les commits en production
- Les commentaires DEPRECATED dans le code permettent de garder l'historique

### Validation

- ✅ Tous les commentaires de traçabilité sont présents
- ✅ Tous les fichiers temporaires sont supprimés
- ✅ Le mode mock est désactivé
- ✅ Les commits sont sur la branche `dev_vibecoding`
- ✅ Les messages de commit contiennent les IDs de modification
- ✅ Le journal de bord est mis à jour

---

## [v0.10.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Exécution du hook cleanup-and-journal pour nettoyage du workspace
- Création des règles de versioning pour tous les fichiers .kiro
- Création du script de vérification du versioning
- Vérification de l'absence de fichiers temporaires dans les repos

### Fichiers créés (3 nouveaux fichiers)

#### Steering
- `.kiro/steering/13-versioning-rules.md` (v1.0.0)
  - Règles complètes de versioning pour fichiers Markdown, JSON, PowerShell
  - Format de numérotation sémantique (MAJOR.MINOR.PATCH)
  - Workflow de modification avec mise à jour de version
  - Checklist et exemples complets

#### Scripts
- `scripts_outils_ia/verify-versioning.ps1` (v1.0.0)
  - Vérifie que tous les fichiers .kiro ont un versioning
  - Supporte Markdown, JSON, PowerShell
  - Mode Fix pour correction automatique (à implémenter)
  - Rapport détaillé avec erreurs et avertissements

#### Rapports
- `.kiro/temp/cleanup-report-2026-02-03.md`
  - Rapport complet du nettoyage du workspace
  - État des fichiers temporaires
  - Métriques et recommandations

### Règles de Versioning

#### Format pour Markdown
```markdown
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale
```

#### Format pour JSON
```json
{
  "metadata": {
    "version": "1.0.0",
    "lastUpdate": "2026-02-03",
    "author": "Kiro",
    "changelog": [...]
  }
}
```

#### Format pour PowerShell
```powershell
<#
.VERSION
    1.0.0

.LAST UPDATE
    2026-02-03

.CHANGELOG
    v1.0.0 (2026-02-03) : Création initiale
#>
```

### Fichiers Concernés par le Versioning

**Obligatoire** :
- `.kiro/steering/*.md`
- `.kiro/specs/*.md`
- `.kiro/hooks/*.json`
- `.kiro/templates/*.md`
- `scripts_outils_ia/*.ps1`

**Optionnel** :
- `.kiro/state/*.json` (si modifications manuelles)
- `.kiro/agents/*.md`
- `.kiro/skills/*.md`

**Exclus** :
- `.kiro/temp/*` (fichiers temporaires)
- Fichiers générés automatiquement

### Vérification du Workspace

#### Fichiers Temporaires
- ✅ pwc-ui : Aucun fichier temporaire trouvé
- ✅ pwc-ui-shared : Aucun fichier temporaire trouvé
- ✅ .kiro/temp/ : Propre (uniquement .gitignore et rapports)

#### Fichiers Mock
- ✅ Supprimés lors du commit v0.9.0
- ✅ Mode mock désactivé dans environment.ts

#### État Git
- ✅ pwc-ui : Commit fa503fe07e (2 commits en avance)
- ✅ pwc-ui-shared : Commit 3a5191bf4 (3 commits en avance)
- ⏳ Fichiers non trackés : `.kiro/`, `package.json.backup`

### Rollback

#### Pour supprimer les règles de versioning
```powershell
# Supprimer les fichiers
Remove-Item .kiro/steering/13-versioning-rules.md
Remove-Item scripts_outils_ia/verify-versioning.ps1
Remove-Item .kiro/temp/cleanup-report-2026-02-03.md
```

#### Pour restaurer depuis Git
```powershell
git checkout HEAD -- .kiro/steering/13-versioning-rules.md
git checkout HEAD -- scripts_outils_ia/verify-versioning.ps1
```

### Prochaines Étapes

1. ✅ Règles de versioning créées
2. ✅ Script de vérification créé
3. ⏳ Exécuter `verify-versioning.ps1` pour vérifier les fichiers existants
4. ⏳ Ajouter le versioning aux fichiers .kiro existants
5. ⏳ Implémenter le mode Fix dans verify-versioning.ps1
6. ⏳ Créer un hook pour vérifier le versioning avant commit

### Métriques

- Fichiers créés : 3
- Fichiers temporaires trouvés : 0
- Fichiers temporaires supprimés : 0
- Règles documentées : 1 (versioning)
- Scripts créés : 1 (verify-versioning.ps1)
- Temps de nettoyage : ~15 minutes

### Leçons Apprises

- Le hook cleanup-and-journal est utile pour maintenir un workspace propre
- Les règles de versioning facilitent le suivi des modifications des fichiers .kiro
- Un script de vérification automatique garantit la cohérence du versioning
- Les fichiers temporaires doivent être nettoyés régulièrement
- Le dossier .kiro/temp/ doit contenir uniquement des rapports temporaires

### Validation

- ✅ Aucun fichier temporaire dans les repos principaux
- ✅ .kiro/temp/ propre
- ✅ Règles de versioning documentées
- ✅ Script de vérification créé
- ✅ Rapport de nettoyage créé
- ✅ Journal de bord mis à jour

---

## [v0.11.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Correction du chargement des fichiers .kiro au démarrage de Kiro
- Modification des stratégies de chargement dans les fichiers d'index
- Configuration de 6 fichiers en chargement automatique (2 specs + 4 steering)
- Création de la documentation de synchronisation des index (avec Claude)

### Problème Résolu

**Symptôme** : Les fichiers .kiro (specs, steering, hooks) n'étaient pas reconnus par Kiro à l'ouverture

**Cause** : 
- Specs en mode `explicit` (chargement uniquement sur demande)
- Tous les steering avec `alwaysLoaded: false`
- Résultat : Aucun fichier chargé automatiquement au démarrage

### Solution Appliquée

#### Specs (_index.json)
- **Mode** : `explicit` → `hybrid`
- **Fichiers toujours chargés** (2) :
  - `00-resume-executif.md` (1 776 tokens)
  - `02-plan-migration.md` (2 598 tokens)

#### Steering (_index.json)
- **Fichiers toujours chargés** (4) :
  - `01-project-overview.md` (1 369 tokens)
  - `02-migration-angular-rules.md` (2 143 tokens)
  - `12-modification-rules.md` (2 015 tokens)
  - `13-versioning-rules.md` (2 348 tokens)

### Fichiers Créés (avec Claude - Synchronisation)

#### Scripts de Synchronisation (5 fichiers)
1. `.kiro/scripts/sync-specs-index.js` - Synchronise l'index des specs
2. `.kiro/scripts/sync-steering-index.js` - Synchronise l'index des steering
3. `.kiro/scripts/sync-all-indexes.js` - Script principal
4. `.kiro/scripts/sync-all.bat` - Script batch Windows
5. `.kiro/scripts/README.md` - Documentation des scripts

#### Hook et Documentation (3 fichiers)
6. `.kiro/hooks/sync-kiro-indexes.json` - Hook automatique en fin de session
7. `.kiro/SYNCHRONISATION.md` - Documentation complète du système
8. `.kiro/temp/fix-index-loading-2026-02-03.md` - Documentation de la correction

### Fichiers Modifiés (2 fichiers)

#### Index Mis à Jour
- `.kiro/specs/_index.json` - Mode hybrid + 2 fichiers alwaysLoaded
- `.kiro/steering/_index.json` - 4 fichiers alwaysLoaded

### Impact sur le Budget Contexte

**Avant** :
- Specs chargées : 0
- Steering chargés : 0
- Total tokens : 0

**Après** :
- Specs chargées : 2 (4 374 tokens)
- Steering chargés : 4 (7 875 tokens)
- **Total tokens** : 12 249 tokens (~6% du budget contexte)

**Budget disponible** : 11 751 tokens (marge confortable)

### État Actuel des Ressources

**Specs** : 11 fichiers (27 235 tokens)
- 2 chargées automatiquement
- 9 chargées sur demande explicite

**Steering** : 14 fichiers (28 134 tokens)
- 4 chargés automatiquement
- 10 chargés contextuellement (selon fichiers modifiés)

**Hooks** : 3 fichiers
- `cleanup-and-journal.json` - Nettoyage en fin de session
- `rules-reminder.json` - Rappel des règles périodique
- `sync-kiro-indexes.json` - Synchronisation des index

### Synchronisation Automatique

**Script batch** : `C:\repo_hps\.kiro\scripts\sync-all.bat`
- Synchronise automatiquement les index specs et steering
- Détecte les fichiers ajoutés/supprimés
- Met à jour les statistiques (nombre de fichiers, tokens)

**Hook automatique** : Se déclenche en fin de session Kiro
- Vérifie si les index sont à jour
- Synchronise si nécessaire
- Transparent pour l'utilisateur

### Rollback

#### Pour restaurer les index originaux
```powershell
git checkout .kiro/specs/_index.json
git checkout .kiro/steering/_index.json
```

#### Pour supprimer les scripts de synchronisation
```powershell
Remove-Item -Recurse -Force .kiro/scripts
Remove-Item .kiro/hooks/sync-kiro-indexes.json
Remove-Item .kiro/SYNCHRONISATION.md
```

### Prochaines Étapes

1. ✅ Index corrigés et synchronisés
2. ✅ Scripts de synchronisation créés
3. ✅ Hook automatique configuré
4. ⏳ Tester le chargement au démarrage de Kiro
5. ⏳ Corriger le fichier vide `08-nodejs-version-management.md`
6. ⏳ Corriger le versioning des 48 fichiers identifiés
7. ⏳ Commencer le Palier 1 de la migration Angular

### Métriques

- Fichiers créés : 8 (5 scripts + 3 docs)
- Fichiers modifiés : 2 (index)
- Fichiers chargés automatiquement : 6 (2 specs + 4 steering)
- Budget contexte utilisé : 12 249 tokens (6%)
- Temps de correction : ~30 minutes

### Leçons Apprises

- Les fichiers d'index doivent avoir une stratégie de chargement adaptée
- Le mode `hybrid` permet un équilibre entre chargement automatique et économie de contexte
- Les règles critiques doivent être `alwaysLoaded: true`
- Les guides techniques peuvent rester contextuels pour économiser le contexte
- La synchronisation automatique évite les désynchronisations

### Validation

- ✅ Index corrigés avec stratégies de chargement appropriées
- ✅ 6 fichiers configurés en chargement automatique
- ✅ Budget contexte respecté (6% utilisé, 12% max recommandé)
- ✅ Scripts de synchronisation créés et testés
- ✅ Hook automatique configuré
- ✅ Documentation complète créée

---


---

## [v0.12.0] - 2026-02-03 - Franck Desmedt / Kiro

### Actions
- Création d'une spec complète pour corriger le versioning des 48 fichiers .kiro
- Utilisation du workflow requirements-first pour structurer le travail
- Synchronisation des index après création de la spec

### Spec Créée

**Nom** : fix-kiro-versioning  
**Emplacement** : `.kiro/specs/fix-kiro-versioning/`

**Fichiers créés** :
- `requirements.md` - 7 requirements avec 38 acceptance criteria
- `design.md` - Architecture complète avec 7 correctness properties
- `tasks.md` - 12 tâches principales avec 35 sous-tâches

### Contenu de la Spec

#### Requirements (7)
1. Add Versioning to Markdown Files (14 steering + 12 specs)
2. Add Versioning to JSON Hook Files (3 hooks)
3. Add Versioning to PowerShell Scripts (19 scripts)
4. Preserve File Content and Formatting
5. Process Files in Priority Order (Phase 1: hooks/steering/specs, Phase 2: scripts)
6. Validate Versioning Compliance
7. Handle Special Cases (YAML front-matter, shebangs, empty files)

#### Design Highlights
- **Architecture** : Batch processing avec 3 processeurs (Markdown, JSON, PowerShell)
- **Components** : 5 composants (MarkdownProcessor, JSONProcessor, PowerShellProcessor, BatchProcessor, Validator)
- **Properties** : 7 correctness properties pour property-based testing
- **Error Handling** : Gestion gracieuse des erreurs (skip and report)

#### Tasks (12 principales)
1. Set up project structure and utilities
2. Implement Markdown processor (5 sous-tâches)
3. Implement JSON processor (5 sous-tâches)
4. Implement PowerShell processor (5 sous-tâches)
5. Checkpoint - Ensure all processor tests pass
6. Implement batch processor and orchestration (6 sous-tâches)
7. Implement validator (4 sous-tâches)
8. Create main execution script (3 sous-tâches)
9. Checkpoint - Ensure all tests pass
10. Execute versioning fix on actual files (3 sous-tâches)
11. Final validation and cleanup (3 sous-tâches)
12. Final checkpoint - Ensure all tests pass

### Fichiers à Corriger (48 total)

#### Phase 1 : Fichiers Critiques (29)
- **Hooks** (3) : cleanup-and-journal.json, rules-reminder.json, sync-kiro-indexes.json
- **Steering** (14) : 01-project-overview.md → 13-versioning-rules.md
- **Specs** (12) : 00-resume-executif.md → README.md

#### Phase 2 : Scripts PowerShell (19)
- Scripts de traçabilité : add-traceability-comments.ps1, backup-file.ps1, etc.
- Scripts Use-NodeXX : Use-Node10.ps1 → Use-Node22.ps1
- Scripts de vérification : verify-backups.ps1, verify-comments.ps1

### Format de Versioning

#### Markdown
```markdown
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale

---
```

#### JSON
```json
{
  "metadata": {
    "version": "1.0.0",
    "lastUpdate": "2026-02-03",
    "author": "Kiro",
    "changelog": [
      {
        "version": "1.0.0",
        "date": "2026-02-03",
        "changes": "Création initiale"
      }
    ]
  }
}
```

#### PowerShell
```powershell
<#
.VERSION
    1.0.0

.LAST UPDATE
    2026-02-03

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-03) : Création initiale
#>
```

### Rollback

#### Pour supprimer la spec
```powershell
Remove-Item .kiro/specs/fix-kiro-versioning -Recurse -Force
```

#### Pour restaurer l'index
```powershell
node .kiro\scripts\sync-all-indexes.js
```

### Prochaines Étapes

1. ⏳ Exécuter les tâches de la spec fix-kiro-versioning
2. ⏳ Implémenter les processeurs (Markdown, JSON, PowerShell)
3. ⏳ Exécuter le batch processing sur les 48 fichiers
4. ⏳ Vérifier avec verify-versioning.ps1 (0 erreurs attendues)
5. ⏳ Commencer le Palier 1 de la migration Angular

### Métriques

- Spec créée : 1 (fix-kiro-versioning)
- Requirements : 7
- Acceptance criteria : 38
- Correctness properties : 7
- Tâches principales : 12
- Sous-tâches : 35
- Fichiers à corriger : 48
- Temps de création : ~30 minutes (via subagent)

### Leçons Apprises

- Le workflow requirements-first structure efficacement le travail
- Les correctness properties garantissent la qualité du code
- Le property-based testing valide les propriétés universelles
- La séparation en phases (hooks → steering → specs → scripts) priorise les fichiers critiques
- L'utilisation d'un subagent accélère la création de specs complexes

---
