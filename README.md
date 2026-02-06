# Migration Angular Dev Kit

Infrastructure et outils pour la migration Angular 5 → 20 des repositories `pwc-ui-shared` et `pwc-ui`.

## 📋 Vue d'Ensemble

Ce repository contient:
- **Infrastructure Kiro** : Système de gestion de migration avec steering files, specs et hooks
- **Gate Playwright** : Tests E2E automatisés pour valider chaque palier de migration
- **Scripts d'Outils** : Utilitaires PowerShell pour gestion des versions Node.js, snapshots, etc.
- **Documentation** : Guides complets pour chaque palier de migration

## 🏗️ Architecture

```
migration_angular_dev_kit/
├── .kiro/                          # Infrastructure Kiro
│   ├── steering/                   # Règles et guides (chargés automatiquement)
│   ├── specs/                      # Spécifications détaillées par palier
│   ├── agents/                     # Agents personnalisés
│   ├── skills/                     # Compétences techniques
│   ├── hooks/                      # Hooks automatiques
│   └── state/                      # État de migration
├── outils_communs/                 # Scripts et outils partagés
│   ├── start-pwc-ui-shared-4201.bat
│   ├── start-pwc-ui.bat
│   └── run-playwright-visual.bat
├── scripts_outils_ia/              # Scripts PowerShell
│   ├── Use-Node*.ps1               # Basculer versions Node.js
│   ├── check-stack.ps1             # Vérifier la stack
│   └── codemods/                   # Codemods de migration
├── Documentation/                  # Journal de bord
└── .gitignore                      # Ignore pwc-ui-shared et pwc-ui

```

## 🚀 Démarrage Rapide

### 1. Cloner le Repository

```bash
git clone https://github.com/bigmoletos/migration_angular_dev_kit.git
cd migration_angular_dev_kit
```

### 2. Ajouter les Repos Bitbucket

Les deux repos Bitbucket (`pwc-ui-shared` et `pwc-ui`) doivent être clonés séparément:

```bash
# Cloner pwc-ui-shared
git clone <bitbucket-url-pwc-ui-shared> pwc-ui-shared

# Cloner pwc-ui
git clone <bitbucket-url-pwc-ui> pwc-ui
```

### 3. Configurer Node.js

```powershell
# Basculer vers Node v10 (Angular 5)
Use-Node10

# Vérifier
node --version  # v10.24.1
```

### 4. Lancer les Applications

```powershell
# Terminal 1 : pwc-ui-shared sur port 4201
.\outils_communs\start-pwc-ui-shared-4201.bat

# Terminal 2 : pwc-ui sur port 4200
.\outils_communs\start-pwc-ui.bat
```

### 5. Lancer les Tests Playwright

```powershell
# Tests visuels avec --headed
.\outils_communs\run-playwright-visual.bat

# Ou directement
cd pwc-ui-shared/pwc-ui-shared-v4-ia
npx playwright test e2e/tests/components-from-inventory.spec.ts --headed
```

## 📚 Documentation

### Steering Files (Règles Automatiques)

| Fichier | Sujet | Priorité |
|---------|-------|----------|
| `00-agent-router.md` | Routage intelligent | 100 |
| `01-project-overview.md` | Vue d'ensemble projet | 95 |
| `02-migration-angular-rules.md` | Règles migration Angular | 95 |
| `03-rxjs-migration-patterns.md` | Patterns RxJS | 90 |
| `04-ivy-migration-guide.md` | Guide migration Ivy | 85 |
| `08-workspace-hygiene.md` | Hygiène du workspace | 90 |
| `09-version-management.md` | Gestion versions Node | 90 |
| `10-local-dev-config.md` | Config développement local | 75 |
| `11-playwright-e2e-testing.md` | Tests E2E Playwright | 75 |
| `12-modification-rules.md` | Règles de modification | 95 |
| `13-versioning-rules.md` | Règles de versioning | 95 |

### Specs (Spécifications Détaillées)

- `00-palier-00-validation-infrastructure/` : Gate Playwright et validation
- `02-plan-migration.md` : Plan complet de migration
- `04-palier-01-angular-5-to-6.md` : Palier 1 (Angular 5→6)
- `05-palier-04-angular-8-to-9-ivy.md` : Palier 4 (Ivy)
- `06-palier-07-angular-11-to-12-webpack5.md` : Palier 7 (Webpack 5)
- Et plus...

## 🔴 RÈGLE D'OR

```
pwc-ui-shared-v4-ia (lib)  →  pwc-ui-v4-ia (client)
       MIGRER AVANT               MIGRER APRÈS
```

**TOUJOURS** migrer la bibliothèque partagée en premier, puis valider avant de migrer le client.

## 🎯 Paliers de Migration

```
5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17 → 18 → 19 → 20
```

### Palier 0 : Gate Playwright (Validation)
- ✅ Infrastructure Playwright configurée
- ✅ 31 tests E2E créés (18 shared + 13 ui)
- ✅ Tests visuels avec `page.pause()`
- ✅ Inventaire des composants généré

### Palier 1 : Angular 5→6 (RxJS)
- Migration RxJS 5→6 (opérateurs pipeable)
- Installation rxjs-compat
- Codemod automatique disponible

### Palier 4 : Angular 8→9 (Ivy)
- Activation du nouveau moteur de rendu
- Migration ModuleWithProviders
- Suppression entryComponents

### Palier 7 : Angular 11→12 (Webpack 5)
- Migration Webpack 4→5
- Adaptation webpack.config.js

### Palier 12 : Angular 16→17 (Control Flow)
- Nouvelle syntaxe : `@if`, `@for`, `@switch`
- Migration automatique disponible

### Palier 15 : Angular 19→20 (Final)
- Dernière version stable
- Validation complète

## 🛠️ Scripts Utiles

### Gestion des Versions Node.js

```powershell
# Basculer vers une version
Use-Node10   # v10.24.1 (Angular 5-8)
Use-Node12   # v12.22.12 (Angular 9-11)
Use-Node14   # v14.21.3 (Angular 12)
Use-Node16   # v16.20.2 (Angular 13-14)
Use-Node18   # v18.20.4 (Angular 15-17)
Use-Node20   # v20.18.0 (Angular 18-19)
Use-Node22   # v22.11.0 (Angular 20)

# Vérifier la version active
node --version
```

### Vérifier la Stack

```powershell
.\scripts_outils_ia\check-stack.ps1
```

### Créer un Snapshot

```powershell
.\scripts_outils_ia\snapshot-file.ps1 -File "path/to/file"
```

### Rollback

```powershell
.\scripts_outils_ia\rollback-snapshot.ps1 -SnapshotId "mod-001"
```

## 📊 État de Migration

Voir `.kiro/state/strands-state.json` pour l'état actuel de la migration.

## 📝 Journal de Bord

Voir `Documentation/JOURNAL-DE-BORD.md` pour l'historique des changements.

## 🔗 Ressources

- [Angular Update Guide](https://update.angular.io/)
- [RxJS Migration Guide](https://rxjs.dev/guide/v6/migration)
- [Ivy Migration Guide](https://angular.io/guide/ivy)
- [Playwright Documentation](https://playwright.dev/)

## 📞 Support

Pour des questions ou problèmes:
1. Consulter les steering files pertinents
2. Vérifier les specs du palier concerné
3. Consulter le journal de bord pour les problèmes connus

## 📄 Licence

Propriétaire - PwC

## 🤝 Contribution

Ce repository est géré par l'équipe de migration Angular. Les modifications doivent suivre les règles définies dans `.kiro/steering/12-modification-rules.md`.

---

**Dernière mise à jour** : 2026-02-06  
**Version** : 1.0.0  
**Statut** : Palier 0 - Gate Playwright ✅
