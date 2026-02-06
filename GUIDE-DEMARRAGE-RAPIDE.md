# 🚀 Guide de Démarrage Rapide - Kiro Workspace Migration Angular

> **Version** : 3.3  
> **Date** : 2026-01-30  
> **Workspace** : `C:\repo_hps\`

---

## 📦 Contenu du Package v3.3

| Élément | Description | État |
|---------|-------------|------|
| `install.bat` | Script d'installation automatique | ✅ Prêt |
| `check-stack.ps1` | Diagnostic complet de la stack | ✅ **NOUVEAU** |
| `install-dependencies.ps1` | Installation dépendances (sans admin) | ✅ **NOUVEAU** |
| 4 Codemods | rxjs, viewchild, module-with-providers, console-to-logger | ✅ **NOUVEAU** |
| 6 Skills | angular-migration, codemods, strands, validation, audit, rxjs | ✅ Prêts |
| Strands Agent | Orchestration multi-agents stateful | ✅ Prêt |
| Configs enfants | lib + client avec héritage | ✅ Prêts |

---

## 📁 Structure Cible

```
C:\repo_hps\                              ← Workspace parent (ouvrir dans Kiro)
├── .kiro\                                ← Config parent
│   ├── skills\                           ← 6 skills
│   ├── strands\                          ← Config orchestration
│   └── ...
├── docs_outils_ia\                       ← Documentation
├── scripts_outils_ia\                    ← Scripts utilitaires
│   ├── codemods\                         ← 4 codemods fonctionnels
│   │   ├── rxjs-imports.js
│   │   ├── viewchild-static.js
│   │   ├── module-with-providers.js
│   │   └── console-to-logger.js
│   ├── check-stack.ps1                   ← Diagnostic
│   └── install-dependencies.ps1          ← Installation
│
├── pwc-ui-shared\
│   └── pwc-ui-shared-v4-ia\
│       └── .kiro\                        ← Config enfant LIB
│
└── pwc-ui\
    └── pwc-ui-v4-ia\
        └── .kiro\                        ← Config enfant CLIENT
```

---

## 📋 Installation Complète

### Étape 1 : Extraire et Installer

```powershell
# 1. Extraire le ZIP n'importe où
Expand-Archive kiro-workspace-parent-v3.3.zip -DestinationPath .

# 2. Lancer l'installation (double-clic ou ligne de commande)
cd kiro-workspace-parent
.\install.bat
```

Le script `install.bat` copie automatiquement tous les fichiers aux bons endroits.

---

### Étape 2 : Diagnostic Stack

```powershell
# Vérifier que tout est prêt
cd C:\repo_hps\scripts_outils_ia
.\check-stack.ps1
```

Ce script vérifie :
- ✅ Node.js (toutes les versions via fnm/Use-NodeXX)
- ✅ npm, Angular CLI, TypeScript
- ✅ Python, pip, Strands Agents
- ✅ jscodeshift
- ✅ Git
- ✅ Chemins des projets

---

### Étape 3 : Installer les Dépendances Manquantes

```powershell
# Si le diagnostic montre des manques
.\install-dependencies.ps1

# Options disponibles :
.\install-dependencies.ps1 -SkipStrands   # Sans Strands
.\install-dependencies.ps1 -SkipNpm       # Sans npm packages
```

**Note** : Tout s'installe en mode utilisateur (pas besoin de droits admin).

---

### Étape 4 : Configurer Node.js pour Angular 5

```powershell
# Utiliser Node 10 pour Angular 5
Use-Node10

# Vérifier
node --version  # Devrait afficher v10.x.x
```

---

## 🎯 Premier Lancement Kiro

### 1. Ouvrir le Workspace

```
File > Open Folder > C:\repo_hps
```

### 2. Prompt d'Initialisation

Copier-coller ce prompt dans Kiro :

```
# Initialisation Workspace Migration Angular

Tu viens d'être configuré avec :
- 6 skills (angular-migration, codemods-refactoring, strands-orchestration, validation-formelle, code-audit, rxjs-patterns)
- Strands Agent pour orchestration multi-agents stateful
- 4 codemods fonctionnels dans scripts_outils_ia/codemods/

## Structure du workspace
- Parent : C:\repo_hps\
- Lib : C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\
- Client : C:\repo_hps\pwc-ui\pwc-ui-v4-ia\
- Migration Angular 5 → 20 prévue
- Node.js actif : v10 (pour Angular 5)

## Actions à effectuer :

1. **Vérifie l'héritage** :
   - Lis .kiro/skills/_index.json et confirme les 6 skills
   - Lis pwc-ui-shared/pwc-ui-shared-v4-ia/.kiro/config.json et vérifie le champ "inheritance.parent"
   - Confirme que tu peux accéder aux skills du parent depuis les enfants

2. **Analyse les repos réels** :
   - Scanne les package.json pour détecter les versions Angular, RxJS, TypeScript
   - Compte les composants, services, modules dans chaque repo

3. **Génère les specs personnalisées** :
   - .kiro/specs/01-etat-actuel.md (versions détectées)
   - .kiro/specs/02-plan-migration.md (paliers 5→6→7→...→20)
   - .kiro/specs/03-risques-identifies.md

4. **Initialise l'état Strands** :
   - Crée .kiro/state/strands-state.json avec l'état initial
   - Premier checkpoint "pre-migration"

5. **Affiche un résumé** avec :
   - Versions détectées
   - Nombre de composants/services
   - Premier palier recommandé
   - Codemods à exécuter pour ce palier

Commence par la vérification de l'héritage.
```

---

## 🔧 Utilisation des Codemods

### Ordre d'Exécution par Palier

| Palier | Angular | Codemod | Commande |
|--------|---------|---------|----------|
| 5→6 | RxJS 5→6 | `rxjs-imports.js` | Voir ci-dessous |
| 7→8 | ViewChild | `viewchild-static.js` | Voir ci-dessous |
| 9→10 | ModuleWithProviders | `module-with-providers.js` | Voir ci-dessous |
| Tous | Console→Logger | `console-to-logger.js` | Optionnel |

### Commandes

```powershell
# Depuis le repo lib ou client
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# 1. Dry-run (prévisualisation sans modification)
npx jscodeshift -t ..\..\..\scripts_outils_ia\codemods\rxjs-imports.js src\**\*.ts --parser=ts --dry

# 2. Exécution réelle
npx jscodeshift -t ..\..\..\scripts_outils_ia\codemods\rxjs-imports.js src\**\*.ts --parser=ts

# 3. Vérifier le build
npm run build
```

---

## 🎮 Commandes Kiro

### Migration avec Strands

```bash
#strands start --from 5 --to 6    # Démarrer migration orchestrée
#strands status                    # État actuel
#strands resume                    # Reprendre après interruption
#strands rollback --to <checkpoint> # Rollback
```

### Skills

```bash
#angular-migration    # Charger expertise migration
#codemods            # Charger expertise refactoring
#validation-formelle # Charger validation types
#code-audit          # Charger audit qualité
```

---

## 🔄 Workflow de Migration

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     WORKFLOW MIGRATION COMPLET                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PRÉPARATION                                                            │
│  ───────────                                                            │
│  1. Use-Node10                    # Activer Node.js 10                  │
│  2. .\check-stack.ps1             # Vérifier la stack                   │
│  3. Ouvrir Kiro sur C:\repo_hps   # Ouvrir le workspace                 │
│  4. Prompt d'initialisation       # Générer specs et état               │
│                                                                         │
│  MIGRATION PALIER N → N+1                                               │
│  ────────────────────────                                               │
│  1. [LIB] ng update @angular/core@N+1 @angular/cli@N+1                 │
│  2. [LIB] Exécuter codemods appropriés                                  │
│  3. [LIB] npm run build && npm run test                                │
│  4. [LIB] git commit -m "chore: migrate lib to Angular N+1"            │
│                                                                         │
│  5. [CLIENT] rm -rf node_modules && npm install                        │
│  6. [CLIENT] ng update @angular/core@N+1 @angular/cli@N+1              │
│  7. [CLIENT] Exécuter codemods appropriés                               │
│  8. [CLIENT] npm run build && npm run test                             │
│  9. [CLIENT] git commit -m "chore: migrate client to Angular N+1"      │
│                                                                         │
│  10. #strands checkpoint create angular-N+1                             │
│  11. Passer au palier suivant (Use-NodeXX si nécessaire)               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Matrice Node.js / Angular

| Angular | Node.js | Commande |
|---------|---------|----------|
| 5-8 | 10.x | `Use-Node10` |
| 9-11 | 12.x | `Use-Node12` |
| 12 | 14.x | `Use-Node14` |
| 13-14 | 16.x | `Use-Node16` |
| 15-17 | 18.x | `Use-Node18` |
| 18-19 | 20.x | `Use-Node20` |
| 20 | 22.x | `Use-Node22` |

---

## ⚠️ Points d'Attention

1. **Toujours la lib AVANT le client** - Strands enforce cette règle
2. **Committer avant chaque palier** - Permet le rollback
3. **Dry-run les codemods** - Vérifier avant d'appliquer
4. **Vérifier le build** après chaque codemod
5. **Changer de Node.js** selon les paliers

---

## 📚 Documentation Complète

| Document | Chemin |
|----------|--------|
| MODOP Strands | `docs_outils_ia\modops\MODOP-STRANDS-AGENT.md` |
| Guide Codemods | `scripts_outils_ia\codemods\README.md` |
| Guide Skills/MCP | `docs_outils_ia\GUIDE-SKILLS-ACP-FINDTOOLS.md` |
| Analyse Critique | `docs_outils_ia\ANALYSE-CRITIQUE-SYSTEME.md` |

---

## ✅ Checklist Complète

### Installation
- [ ] ZIP extrait
- [ ] `install.bat` exécuté avec succès
- [ ] `.\check-stack.ps1` sans erreurs bloquantes
- [ ] `.\install-dependencies.ps1` si nécessaire

### Configuration
- [ ] `Use-Node10` activé
- [ ] Workspace `C:\repo_hps` ouvert dans Kiro
- [ ] Prompt d'initialisation exécuté
- [ ] Héritage Kiro vérifié (skills accessibles depuis enfants)
- [ ] Specs générées et validées

### Prêt pour Migration
- [ ] État initial documenté
- [ ] Checkpoint "pre-migration" créé
- [ ] Premier `#strands status` OK
- [ ] Prêt pour `#strands start --from 5 --to 6` 🚀

---

*Bonne migration !*
