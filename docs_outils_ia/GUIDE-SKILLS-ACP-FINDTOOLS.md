# 📚 Guide Complet : Skills, ACP et Find-Tools

> **Objectif** : Comprendre en profondeur le fonctionnement et les objectifs de chaque composant  
> **Version** : 1.0.0  
> **Date** : 2026-01-29

---

## 📖 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Skills : Compétences Spécialisées](#skills--compétences-spécialisées)
3. [MCP et Tool Router](#mcp-et-tool-router)
4. [Find-Tools : Découverte Dynamique](#find-tools--découverte-dynamique)
5. [ACP : Agent Communication Protocol](#acp--agent-communication-protocol)
6. [Flux de Fonctionnement Complet](#flux-de-fonctionnement-complet)
7. [Exemples Concrets](#exemples-concrets)

---

## Vue d'Ensemble

### Le Problème qu'on Résout

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                     SANS OPTIMISATION                                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Context Window (200K tokens)                                               ║
║   ┌────────────────────────────────────────────────────────────────────┐     ║
║   │██████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│     ║
║   │       70% GASPILLÉ                      30% UTILE                  │     ║
║   └────────────────────────────────────────────────────────────────────┘     ║
║                                                                              ║
║   - 5 MCP servers = 50K tokens (25%)                                         ║
║   - Tous les skills = 30K tokens (15%)                                       ║
║   - Steering docs = 20K tokens (10%)                                         ║
║   - Specs auto-chargées = 40K tokens (20%)                                   ║
║   ────────────────────────────────────────                                   ║
║   TOTAL GASPILLÉ : 140K tokens (70%)                                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

╔══════════════════════════════════════════════════════════════════════════════╗
║                     AVEC OPTIMISATION                                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Context Window (200K tokens)                                               ║
║   ┌────────────────────────────────────────────────────────────────────┐     ║
║   │██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│     ║
║   │  15%                       85% DISPONIBLE                          │     ║
║   └────────────────────────────────────────────────────────────────────┘     ║
║                                                                              ║
║   - AGENTS.md minimal = 400 tokens (0.2%)                                    ║
║   - Index (metadata) = 3K tokens (1.5%)                                      ║
║   - Tool Router = 2K tokens (1%)                                             ║
║   - 1-2 skills actifs = 12K tokens (6%)                                      ║
║   - MCP nécessaires = 8K tokens (4%)                                         ║
║   ────────────────────────────────────────                                   ║
║   TOTAL UTILISÉ : 25K tokens (12.5%)                                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Les Composants du Système

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ARCHITECTURE DU SYSTÈME                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                            ┌─────────────┐                                  │
│                            │   PROMPT    │                                  │
│                            │  Utilisateur │                                  │
│                            └──────┬──────┘                                  │
│                                   │                                         │
│                                   ▼                                         │
│   ┌───────────────────────────────────────────────────────────────┐         │
│   │                      AGENTS.md (Routeur)                      │         │
│   │  • Analyse le prompt                                          │         │
│   │  • Identifie les keywords                                     │         │
│   │  • Route vers le bon composant                                │         │
│   └───────────────────────────────────────────────────────────────┘         │
│                    │              │              │                          │
│                    ▼              ▼              ▼                          │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │     SKILLS      │  │   FIND-TOOLS    │  │     AGENTS      │            │
│   │  (Compétences)  │  │  (Découverte)   │  │  (Spécialistes) │            │
│   └────────┬────────┘  └────────┬────────┘  └────────┬────────┘            │
│            │                    │                    │                      │
│            └────────────────────┼────────────────────┘                      │
│                                 │                                           │
│                                 ▼                                           │
│   ┌───────────────────────────────────────────────────────────────┐         │
│   │                    MCP SERVERS (Outils)                       │         │
│   │  • filesystem, git, npm, web-search...                        │         │
│   │  • Chargés à la demande via profils                           │         │
│   └───────────────────────────────────────────────────────────────┘         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Skills : Compétences Spécialisées

### Qu'est-ce qu'un Skill ?

Un **Skill** est un package de connaissances spécialisées qui peut être chargé à la demande. C'est comme un "expert consultant" qu'on fait venir uniquement quand on a besoin de son expertise.

### Structure d'un Skill

```
.kiro/skills/
├── _index.json                    # Catalogue (TOUJOURS chargé)
│
├── angular-migration/             # Skill 1
│   └── SKILL.md                   # Contenu (LAZY LOADED)
│
├── code-audit/                    # Skill 2
│   └── SKILL.md
│
└── rxjs-patterns/                 # Skill 3
    └── SKILL.md
```

### Anatomie d'un SKILL.md

```yaml
---
# FRONTMATTER (Metadata - lu par l'index)
name: angular-migration
displayName: Angular Migration Expert
description: Guide complet pour migration Angular 5→20
version: 1.0.0

# CONFIGURATION DU LAZY LOADING
loadOn:
  keywords:           # Mots qui déclenchent le chargement
    - migration
    - angular
    - ng update
  filePatterns:       # Fichiers qui déclenchent le chargement
    - "*.module.ts"
    - "angular.json"
  manual: "#angular-migration"  # Commande manuelle

# ESTIMATION RESSOURCES
tokenEstimate: 8000   # Pour calculer le budget
priority: high        # Pour résolution des conflits

# DÉPENDANCES
requires:             # Autres skills à charger ensemble
  - rxjs-patterns
mcpNeeds:             # MCP servers nécessaires
  - filesystem
  - git
---

# CONTENU DU SKILL (Chargé à la demande)

## Expertise Angular Migration

[... contenu détaillé ...]
```

### Cycle de Vie d'un Skill

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     CYCLE DE VIE D'UN SKILL                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. DÉMARRAGE                                                           │
│     ┌─────────────────────────────────────┐                             │
│     │ Charger _index.json (metadata only) │ ← ~1500 tokens              │
│     │ • name, description, keywords       │                             │
│     │ • PAS le contenu des SKILL.md       │                             │
│     └─────────────────────────────────────┘                             │
│                                                                         │
│  2. PROMPT REÇU                                                         │
│     ┌─────────────────────────────────────┐                             │
│     │ Analyser le prompt                  │                             │
│     │ "Je veux migrer vers Angular 6"     │                             │
│     │         ↓                           │                             │
│     │ Match: "migrer" + "Angular"         │                             │
│     │         ↓                           │                             │
│     │ Skill identifié: angular-migration  │                             │
│     └─────────────────────────────────────┘                             │
│                                                                         │
│  3. CHARGEMENT À LA DEMANDE                                             │
│     ┌─────────────────────────────────────┐                             │
│     │ Charger angular-migration/SKILL.md  │ ← +8000 tokens              │
│     │ Charger dépendance: rxjs-patterns   │ ← +4000 tokens              │
│     │ Activer MCP: filesystem, git        │ ← +5000 tokens              │
│     └─────────────────────────────────────┘                             │
│                                                                         │
│  4. UTILISATION                                                         │
│     ┌─────────────────────────────────────┐                             │
│     │ Répondre avec l'expertise du skill  │                             │
│     │ Utiliser les outils MCP disponibles │                             │
│     └─────────────────────────────────────┘                             │
│                                                                         │
│  5. DÉCHARGEMENT (après N messages sans utilisation)                    │
│     ┌─────────────────────────────────────┐                             │
│     │ Si skill inutilisé depuis 5 msgs    │                             │
│     │ → Décharger pour libérer le context │                             │
│     └─────────────────────────────────────┘                             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### L'Index des Skills (_index.json)

```json
{
  "version": "1.0",
  "description": "Catalogue des skills - SEUL ce fichier est chargé au démarrage",
  
  "loadingStrategy": {
    "mode": "lazy",              // Ne charge que les metadata
    "maxSimultaneous": 2,        // Max 2 skills actifs en même temps
    "unloadAfterMessages": 5     // Décharge après 5 msgs sans utilisation
  },
  
  "skills": [
    {
      "name": "angular-migration",
      "path": "angular-migration/SKILL.md",
      "description": "Migration Angular 5→20",
      "keywords": ["migration", "angular", "ng update"],
      "tokenEstimate": 8000,
      "priority": "high"
    }
    // ... autres skills
  ],
  
  "statistics": {
    "totalSkills": 3,
    "totalTokensIfAllLoaded": 17000,  // Budget max si tout chargé
    "recommendedMaxLoaded": 2
  }
}
```

### Pourquoi les Skills sont Importants

| Sans Skills | Avec Skills |
|-------------|-------------|
| Toute la doc chargée = 50K tokens | Index seul = 1.5K tokens |
| Même expertise inutile présente | Expertise chargée à la demande |
| Context saturé rapidement | Context préservé |
| Réponses diluées | Réponses ciblées |

---

## MCP et Tool Router

### Qu'est-ce que MCP ?

**MCP (Model Context Protocol)** est un protocole standard pour connecter les LLMs à des outils externes (fichiers, git, APIs...).

### Le Problème avec MCP Natif

```
╔══════════════════════════════════════════════════════════════════╗
║ SANS OPTIMISATION : Tous les MCP servers chargés                 ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║ Server: filesystem                                               ║
║   Tools: read_file, write_file, list_dir, search...  (~3K)      ║
║                                                                  ║
║ Server: git                                                      ║
║   Tools: status, log, diff, branch, commit...        (~3K)      ║
║                                                                  ║
║ Server: npm                                                      ║
║   Tools: install, audit, outdated, publish...        (~2K)      ║
║                                                                  ║
║ Server: web-search                                               ║
║   Tools: search, fetch...                            (~2K)      ║
║                                                                  ║
║ Server: aws-cli                                                  ║
║   Tools: ec2, s3, lambda, iam... (100+ tools)       (~15K)      ║
║                                                                  ║
║ TOTAL : ~25K tokens AVANT le premier prompt !                    ║
║ C'est 12.5% du context gaspillé sur des outils peut-être inutiles║
╚══════════════════════════════════════════════════════════════════╝
```

### Solution : Le Tool Router (find-tools)

Le **Tool Router** est un meta-outil qui :
1. Expose seulement 3-4 outils légers
2. Permet de découvrir les autres outils à la demande
3. Charge les MCP servers uniquement quand nécessaire

```
╔══════════════════════════════════════════════════════════════════╗
║ AVEC TOOL ROUTER : Chargement progressif                         ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║ AU DÉMARRAGE (toujours chargé) :                                 ║
║ ┌──────────────────────────────────────────────────────────────┐ ║
║ │ Tool Router (~2K tokens)                                     │ ║
║ │   • find_tools(query) → Trouve l'outil adapté                │ ║
║ │   • list_categories() → Liste les catégories                 │ ║
║ │   • load_toolset(name) → Charge un ensemble d'outils         │ ║
║ │   • unload_toolset(name) → Décharge                          │ ║
║ └──────────────────────────────────────────────────────────────┘ ║
║                                                                  ║
║ À LA DEMANDE (quand nécessaire) :                                ║
║ ┌──────────────────────────────────────────────────────────────┐ ║
║ │ Prompt: "Montre le status git"                               │ ║
║ │    ↓                                                         │ ║
║ │ find_tools("git status")                                     │ ║
║ │    ↓                                                         │ ║
║ │ → Charge MCP "git" (+3K tokens)                              │ ║
║ │    ↓                                                         │ ║
║ │ → Utilise git_status()                                       │ ║
║ └──────────────────────────────────────────────────────────────┘ ║
║                                                                  ║
║ RÉSULTAT : 5K tokens au lieu de 25K                              ║
╚══════════════════════════════════════════════════════════════════╝
```

### Configuration MCP avec Profils

```json
// .kiro/mcp/mcp.json
{
  "defaultProfile": "minimal",
  
  "contextLimits": {
    "maxMcpTokensPercent": 12,    // Règle des 12%
    "maxMcpTokens": 24000         // Sur 200K context
  },
  
  "profiles": {
    "minimal": {
      "description": "Seulement le routeur",
      "servers": ["tool-router"],
      "estimatedTokens": 2000
    },
    "migration": {
      "description": "Pour migration Angular",
      "servers": ["tool-router", "filesystem", "git"],
      "estimatedTokens": 8000
    },
    "devops": {
      "description": "Outils DevOps complets",
      "servers": ["tool-router", "filesystem", "git", "npm", "aws-cli"],
      "estimatedTokens": 20000
    }
  },
  
  "mcpServers": {
    "tool-router": {
      "alwaysLoad": true,           // Toujours présent
      "tokenEstimate": 2000
    },
    "filesystem": {
      "alwaysLoad": false,          // Chargé à la demande
      "tokenEstimate": 3000,
      "loadOn": {
        "keywords": ["file", "read", "write", "edit"]
      }
    }
    // ... autres servers
  }
}
```

### Le Catalogue d'Outils (tools-catalog.json)

```json
// .kiro/mcp/tools-catalog.json
{
  "categories": {
    "file-operations": {
      "displayName": "📁 Fichiers",
      "description": "Lecture, écriture, recherche",
      "keywords": ["file", "read", "write", "edit"],
      "servers": ["filesystem"],
      "tokenCost": 3000
    },
    "version-control": {
      "displayName": "🔀 Git",
      "description": "Commits, branches, diff",
      "keywords": ["git", "commit", "branch"],
      "servers": ["git"],
      "tokenCost": 2500
    }
  },
  
  "tools": {
    "read_file": {
      "category": "file-operations",
      "description": "Lire un fichier",
      "server": "filesystem"
    },
    "git_status": {
      "category": "version-control",
      "description": "État du repo",
      "server": "git"
    }
  },
  
  "routingRules": [
    {
      "pattern": "lis|read|affiche|montre",
      "suggestCategory": "file-operations"
    },
    {
      "pattern": "git|commit|branch",
      "suggestCategory": "version-control"
    }
  ]
}
```

---

## Find-Tools : Découverte Dynamique

### Concept

**Find-Tools** est le mécanisme qui permet de découvrir les outils sans les charger tous.

### Comment ça Fonctionne

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     PROCESSUS FIND-TOOLS                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ÉTAPE 1 : Requête                                                      │
│  ┌───────────────────────────────────────┐                              │
│  │ User: "Je veux voir les fichiers"     │                              │
│  └───────────────────────────────────────┘                              │
│                     │                                                   │
│                     ▼                                                   │
│  ÉTAPE 2 : Analyse par le routeur                                       │
│  ┌───────────────────────────────────────┐                              │
│  │ find_tools("voir fichiers")           │                              │
│  │                                       │                              │
│  │ Analyse:                              │                              │
│  │ • "voir" → match "affiche|montre"     │                              │
│  │ • "fichiers" → match "file"           │                              │
│  │ → Catégorie: file-operations          │                              │
│  └───────────────────────────────────────┘                              │
│                     │                                                   │
│                     ▼                                                   │
│  ÉTAPE 3 : Retour des options                                           │
│  ┌───────────────────────────────────────┐                              │
│  │ Résultat:                             │                              │
│  │ {                                     │                              │
│  │   "category": "file-operations",      │                              │
│  │   "suggestedTools": [                 │                              │
│  │     "list_directory",                 │                              │
│  │     "read_file"                       │                              │
│  │   ],                                  │                              │
│  │   "requiredServer": "filesystem",     │                              │
│  │   "tokenCost": 3000                   │                              │
│  │ }                                     │                              │
│  └───────────────────────────────────────┘                              │
│                     │                                                   │
│                     ▼                                                   │
│  ÉTAPE 4 : Chargement conditionnel                                      │
│  ┌───────────────────────────────────────┐                              │
│  │ Si server "filesystem" pas chargé:    │                              │
│  │ → load_toolset("filesystem")          │                              │
│  │ → +3000 tokens au context             │                              │
│  └───────────────────────────────────────┘                              │
│                     │                                                   │
│                     ▼                                                   │
│  ÉTAPE 5 : Utilisation                                                  │
│  ┌───────────────────────────────────────┐                              │
│  │ list_directory("./src")               │                              │
│  │ → Résultat affiché à l'utilisateur    │                              │
│  └───────────────────────────────────────┘                              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Implémentation du Tool Router

```json
// Définition du tool-router dans mcp.json
{
  "tool-router": {
    "description": "Routeur intelligent - découverte d'outils à la demande",
    "alwaysLoad": true,
    "tokenEstimate": 1500,
    
    "tools": [
      {
        "name": "find_tools",
        "description": "Trouve les outils adaptés à une tâche",
        "inputSchema": {
          "type": "object",
          "properties": {
            "query": {
              "type": "string",
              "description": "Description de ce que vous voulez faire"
            }
          },
          "required": ["query"]
        }
      },
      {
        "name": "list_categories",
        "description": "Liste toutes les catégories d'outils disponibles"
      },
      {
        "name": "load_toolset",
        "description": "Charge un ensemble d'outils",
        "inputSchema": {
          "type": "object",
          "properties": {
            "category": {
              "type": "string",
              "description": "Catégorie à charger"
            }
          }
        }
      },
      {
        "name": "unload_toolset",
        "description": "Décharge un ensemble d'outils pour libérer le context"
      }
    ]
  }
}
```

---

## ACP : Agent Communication Protocol

### Qu'est-ce que ACP ?

**ACP** (dans notre contexte) désigne le protocole de communication entre agents spécialisés. C'est ce qui permet à plusieurs agents de collaborer sur une tâche.

### Architecture Multi-Agents

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     COMMUNICATION ENTRE AGENTS                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                         ┌─────────────────────┐                         │
│                         │  COORDINATOR-AGENT  │                         │
│                         │  (Agent Principal)  │                         │
│                         └──────────┬──────────┘                         │
│                                    │                                    │
│              ┌─────────────────────┼─────────────────────┐              │
│              │                     │                     │              │
│              ▼                     ▼                     ▼              │
│   ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐      │
│   │ MIGRATION-AGENT │   │  AUDIT-AGENT    │   │  DEVOPS-AGENT   │      │
│   │                 │   │                 │   │                 │      │
│   │ Skills:         │   │ Skills:         │   │ Skills:         │      │
│   │ • angular-mig   │   │ • code-audit    │   │ • ci-cd         │      │
│   │ • rxjs-patterns │   │                 │   │ • docker        │      │
│   │                 │   │                 │   │                 │      │
│   │ MCP:            │   │ MCP:            │   │ MCP:            │      │
│   │ • filesystem    │   │ • filesystem    │   │ • docker        │      │
│   │ • git           │   │                 │   │ • kubernetes    │      │
│   └─────────────────┘   └─────────────────┘   └─────────────────┘      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Configuration d'un Agent

```json
// .kiro/agents/migration-agent.json
{
  "name": "migration-agent",
  "displayName": "Agent Migration Angular",
  "description": "Expert en migration Angular 5→20",
  "version": "1.0.0",
  
  "model": "claude-sonnet-4",
  
  "resources": [
    "file://.kiro/steering/01-always-loaded.md",
    "skill://.kiro/skills/angular-migration/SKILL.md",
    "skill://.kiro/skills/rxjs-patterns/SKILL.md"
  ],
  
  "mcpProfile": "migration",
  
  "contextBudget": {
    "maxTokens": 50000,
    "warningThreshold": 40000,
    "breakdown": {
      "steering": 5000,
      "skills": 15000,
      "mcp": 10000,
      "conversation": 20000
    }
  },
  
  "delegationRules": [
    {
      "keywords": ["audit", "security"],
      "delegateTo": "audit-agent",
      "reason": "Audit requires specialized knowledge"
    }
  ],
  
  "systemPrompt": "Tu es un expert en migration Angular..."
}
```

### Flux de Délégation

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     DÉLÉGATION ENTRE AGENTS                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. USER: "Migre Angular et fais un audit de sécurité"                  │
│                                                                         │
│  2. COORDINATOR-AGENT analyse:                                          │
│     • "migre Angular" → migration-agent                                 │
│     • "audit sécurité" → audit-agent                                    │
│                                                                         │
│  3. SÉQUENCE DE DÉLÉGATION:                                             │
│                                                                         │
│     ┌─────────────────┐                                                 │
│     │ coordinator     │                                                 │
│     └────────┬────────┘                                                 │
│              │                                                          │
│              │ delegate("migration-agent", "Migrer Angular")            │
│              ▼                                                          │
│     ┌─────────────────┐                                                 │
│     │ migration-agent │ ← Charge ses skills + MCP                       │
│     │ Exécute migration│                                                 │
│     │ Retourne résultat│                                                 │
│     └────────┬────────┘                                                 │
│              │                                                          │
│              │ delegate("audit-agent", "Audit sécurité")                │
│              ▼                                                          │
│     ┌─────────────────┐                                                 │
│     │ audit-agent     │ ← Charge ses skills + MCP                       │
│     │ Exécute audit   │                                                 │
│     │ Retourne résultat│                                                 │
│     └────────┬────────┘                                                 │
│              │                                                          │
│              ▼                                                          │
│     ┌─────────────────┐                                                 │
│     │ coordinator     │ ← Synthétise les résultats                      │
│     │ Répond à l'user │                                                 │
│     └─────────────────┘                                                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Flux de Fonctionnement Complet

### Scénario : "Migre le composant UserList vers Angular 6"

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     FLUX COMPLET                                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  T0: ÉTAT INITIAL                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ Context utilisé: ~5K tokens (2.5%)                              │    │
│  │ • AGENTS.md: 400 tokens                                         │    │
│  │ • _index.json (skills): 1500 tokens                             │    │
│  │ • _index.json (agents): 800 tokens                              │    │
│  │ • tool-router: 2000 tokens                                      │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  T1: PROMPT REÇU                                                        │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ "Migre le composant UserList vers Angular 6"                    │    │
│  │                                                                 │    │
│  │ ANALYSE:                                                        │    │
│  │ • "Migre" → keyword match: migration                            │    │
│  │ • "Angular 6" → keyword match: angular                          │    │
│  │ • "composant" → file pattern: *.component.ts                    │    │
│  │                                                                 │    │
│  │ DÉCISION:                                                       │    │
│  │ → Activer migration-agent                                       │    │
│  │ → Charger skill: angular-migration                              │    │
│  │ → Charger skill: rxjs-patterns (dépendance)                     │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  T2: CHARGEMENT                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ Chargement angular-migration/SKILL.md: +8000 tokens             │    │
│  │ Chargement rxjs-patterns/SKILL.md: +4000 tokens                 │    │
│  │ Activation profil MCP "migration": +8000 tokens                 │    │
│  │ (filesystem: 3000, git: 2500, tool-router: déjà chargé)         │    │
│  │                                                                 │    │
│  │ Context utilisé: ~25K tokens (12.5%) ✅ DANS LE BUDGET          │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  T3: EXÉCUTION                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ migration-agent avec angular-migration skill:                   │    │
│  │                                                                 │    │
│  │ 1. read_file("src/app/user-list/user-list.component.ts")       │    │
│  │ 2. Analyse le code avec expertise du skill                      │    │
│  │ 3. Applique les patterns de migration Angular 5→6               │    │
│  │ 4. Convertit les imports RxJS (grâce à rxjs-patterns)          │    │
│  │ 5. write_file() avec le code migré                              │    │
│  │ 6. git_status() pour vérifier les changements                   │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  T4: APRÈS 5 MESSAGES SUR AUTRE SUJET                                   │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │ Skills angular-migration et rxjs-patterns non utilisés          │    │
│  │ → DÉCHARGEMENT automatique                                      │    │
│  │ → Context libéré: -12000 tokens                                 │    │
│  │                                                                 │    │
│  │ Context utilisé: ~13K tokens (6.5%)                             │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Exemples Concrets

### Exemple 1 : Simple Question

```
USER: "Qu'est-ce que RxJS ?"

TRAITEMENT:
• Pas de keyword d'action (pas de "migre", "audit", etc.)
• Question générale de connaissance
• → Pas besoin de charger de skill
• → Réponse directe depuis les connaissances de base

CONTEXT UTILISÉ: 5K tokens (état initial)
```

### Exemple 2 : Tâche Migration

```
USER: "Migre tous les services vers la nouvelle syntaxe RxJS"

TRAITEMENT:
• Keywords: "migre", "RxJS", "syntaxe"
• Match: angular-migration + rxjs-patterns
• → Charge les 2 skills
• → Active profil MCP "migration"

CONTEXT UTILISÉ: 25K tokens
```

### Exemple 3 : Tâche Multi-Domaine

```
USER: "Migre le code et fais un audit de sécurité"

TRAITEMENT:
• Keywords: "migre" → migration-agent
• Keywords: "audit", "sécurité" → audit-agent
• → Coordinator délègue aux deux agents
• → Chaque agent charge ses skills

CONTEXT UTILISÉ: ~35K tokens (mais géré séquentiellement)
```

---

## Résumé des Objectifs

| Composant | Objectif Principal | Bénéfice |
|-----------|-------------------|----------|
| **Skills** | Expertise à la demande | Contexte préservé, réponses ciblées |
| **Tool Router** | Découverte dynamique | MCP chargés au besoin |
| **Find-Tools** | Matching intelligent | Bon outil pour la tâche |
| **Agents** | Spécialisation | Expertise dédiée par domaine |
| **Index** | Catalogue léger | Metadata sans contenu |
| **Profils MCP** | Présets cohérents | Configuration simplifiée |

---

*Ce guide fait partie du package kiro-workspace-parent et doit être lu en conjonction avec ANALYSE-CRITIQUE-SYSTEME.md pour une compréhension complète des forces et limitations du système.*
