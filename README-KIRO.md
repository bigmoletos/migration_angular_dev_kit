# 🎯 Workspace de Coordination - Migration Angular 5 → 20

> **Objectif** : Coordonner la migration de deux repos interdépendants avec optimisation du contexte  
> **Workspace** : `repo_hps`  
> **Repos** : `pwc-ui-shared-v4-ia` (lib) + `pwc-ui-v4-ia` (client)

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Installation](#installation)
3. [Architecture du Système](#architecture-du-système)
4. [Optimisation du Contexte](#optimisation-du-contexte)
5. [Utilisation](#utilisation)
6. [Documentation](#documentation)
7. [Limitations Connues](#limitations-connues)

---

## Vue d'Ensemble

### Le Problème

Vous avez **deux repos qui dépendent l'un de l'autre** :

```
pwc-ui-shared-v4-ia    ────────────►    pwc-ui-v4-ia
     (bibliothèque)         @pwc/shared      (application)
        MIGRER                               MIGRER
       EN PREMIER                           APRÈS
```

### La Solution

Ce workspace fournit :
1. **Coordination** - Une vue globale sur les deux repos
2. **Lazy Loading** - Chargement des outils à la demande
3. **Skills** - Expertise spécialisée chargée au besoin
4. **Agents** - Spécialistes dédiés par domaine

### Résultat Attendu

```
AVANT (sans optimisation)     →     APRÈS (avec optimisation)
──────────────────────────────────────────────────────────────
Context: 70% utilisé au         →     Context: 12% utilisé au
         démarrage                             démarrage

MCP: 5 servers = 50K tokens     →     MCP: Tool Router = 2K tokens
                                            + chargement à la demande

Skills: Tous chargés = 30K      →     Skills: Index seul = 1.5K
                                              + chargement si besoin
```

---

## Installation

### Structure Attendue

```bash
repo_hps/                              # Workspace parent
├── .kiro/                             # Config parent
├── docs_outils_ia/                    # Documentation
├── scripts_outils_ia/                 # Scripts
├── pwc-ui-shared-v4-ia/               # Repo lib (à cloner)
│   └── .kiro/                         # Config enfant lib
└── pwc-ui-v4-ia/                      # Repo client (à cloner)
    └── .kiro/                         # Config enfant client
```

### Étapes d'Installation

```bash
# 1. Créer le dossier workspace
mkdir repo_hps && cd repo_hps

# 2. Cloner les deux repos
git clone <url-lib> pwc-ui-shared-v4-ia
git clone <url-client> pwc-ui-v4-ia

# 3. Extraire la configuration Kiro
unzip kiro-workspace-parent.zip
cp -r kiro-workspace-parent/.kiro .
cp -r kiro-workspace-parent/docs_outils_ia .
cp -r kiro-workspace-parent/scripts_outils_ia .

# 4. Installer les configs enfants
cp -r kiro-workspace-parent/pwc-ui-shared-v4-ia/.kiro pwc-ui-shared-v4-ia/
cp -r kiro-workspace-parent/pwc-ui-v4-ia/.kiro pwc-ui-v4-ia/

# 5. Valider l'installation
chmod +x scripts_outils_ia/*.sh
./scripts_outils_ia/validate-system.sh

# 6. Ouvrir dans Kiro
# File > Open Folder > repo_hps
```

---

## Architecture du Système

### Niveaux de Configuration

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        HIÉRARCHIE DES CONFIGS                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   NIVEAU 0: WORKSPACE PARENT (repo_hps/.kiro)                           │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ • AGENTS.md (routeur minimal)                                   │   │
│   │ • skills/ (expertise partagée)                                  │   │
│   │ • agents/ (spécialistes)                                        │   │
│   │ • mcp/ (configuration outils)                                   │   │
│   │ • steering/ (standards communs)                                 │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                     │                     │                             │
│                     │  HÉRITE            │  HÉRITE                      │
│                     ▼                     ▼                             │
│   ┌─────────────────────────┐   ┌─────────────────────────┐            │
│   │ NIVEAU 1: LIB           │   │ NIVEAU 1: CLIENT        │            │
│   │ pwc-ui-shared/.kiro     │   │ pwc-ui-v4-ia/.kiro      │            │
│   │                         │   │                         │            │
│   │ • AGENTS.md (contexte)  │   │ • AGENTS.md (contexte)  │            │
│   │ • config.json (héritage)│   │ • config.json (héritage)│            │
│   │ • specs/ (locales)      │   │ • specs/ (locales)      │            │
│   └─────────────────────────┘   └─────────────────────────┘            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Composants Clés

| Composant | Rôle | Fichier |
|-----------|------|---------|
| **AGENTS.md** | Routeur intelligent | `.kiro/AGENTS.md` |
| **Skills** | Expertise à la demande | `.kiro/skills/*/SKILL.md` |
| **Agents** | Spécialistes dédiés | `.kiro/agents/*.json` |
| **MCP** | Outils externes | `.kiro/mcp/mcp.json` |
| **Tool Router** | Découverte dynamique | Via mcp.json |

---

## Optimisation du Contexte

### Règle des 12%

```
╔══════════════════════════════════════════════════════════════════╗
║  BUDGET CONTEXT WINDOW (200K tokens)                             ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  MCP Tools           : MAX 12% = 24K tokens                      ║
║  Skills actifs       : MAX 2 simultanés                          ║
║  Steering (always)   : < 2K tokens                               ║
║  AGENTS.md           : < 500 tokens                              ║
║                                                                  ║
║  TOTAL AU DÉMARRAGE  : < 15% = 30K tokens                        ║
║  DISPONIBLE          : > 85% = 170K tokens                       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Lazy Loading

```
DÉMARRAGE          →     PROMPT REÇU      →     EXÉCUTION
────────────────────────────────────────────────────────────
Index seuls             Analyse keywords        Skills chargés
(~5K tokens)            Match skill/agent       MCP activés
                        Décision chargement     (~25K total)
```

---

## Utilisation

### Commandes Chat

| Commande | Action |
|----------|--------|
| `#list-skills` | Affiche les skills disponibles |
| `#list-agents` | Affiche les agents |
| `#context-status` | État du contexte |
| `#migration-agent` | Active l'agent migration |
| `#audit-agent` | Active l'agent audit |

### Workflow Migration

```bash
# 1. Vérifier l'état
./scripts_outils_ia/check-sync.sh

# 2. Ouvrir le workspace dans Kiro
# File > Open Folder > repo_hps

# 3. Demander la migration
# "Migre le projet vers Angular 6"
# → Kiro charge automatiquement les bons skills et outils

# 4. Suivre la séquence
# Lib d'abord → Validation → Client ensuite
```

---

## Documentation

### Fichiers Principaux

| Document | Contenu |
|----------|---------|
| `docs_outils_ia/GUIDE-SKILLS-ACP-FINDTOOLS.md` | Explication détaillée du système |
| `docs_outils_ia/GUIDE-CONTEXT-OPTIMIZER.md` | Optimisation du contexte |
| `docs_outils_ia/ANALYSE-CRITIQUE-SYSTEME.md` | Limitations et améliorations |
| `docs_outils_ia/ETAT-MIGRATION.md` | État actuel de la migration |

### Scripts

| Script | Usage |
|--------|-------|
| `validate-system.sh` | Valider la cohérence du système |
| `check-context-usage.sh` | Estimer l'usage du contexte |
| `check-sync.sh` | Vérifier synchronisation des repos |
| `quick-audit.sh` | Audit rapide du code |

---

## Limitations Connues

### ⚠️ Points d'Attention

1. **Lazy Loading Théorique** - Le comportement exact de Kiro n'est pas documenté
2. **Keywords Simplistes** - Le matching peut avoir des faux positifs
3. **Pas de Validation Runtime** - Impossible de vérifier le contexte réel
4. **Index Manuels** - Les _index.json doivent être maintenus à jour

### 📋 Avant Utilisation

1. Lire `ANALYSE-CRITIQUE-SYSTEME.md` pour comprendre les risques
2. Exécuter `validate-system.sh` pour vérifier la cohérence
3. Commencer par des tâches simples pour valider le comportement

---

## Support

Pour les questions de coordination multi-repos, contacter l'équipe Architecture.

---

*Ce workspace fait partie du projet de migration Angular 5→20 pour l'écosystème Powercard.*
