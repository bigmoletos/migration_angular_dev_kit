# 🎯 Guide de Gestion des Agents, MCP et Skills

## Optimisation du Context Window pour Kiro et Claude

> **Objectif** : Charger uniquement les outils nécessaires au prompt en cours  
> **Règle d'or** : Les MCP ne doivent pas dépasser 12% du context window  
> **Version** : 1.0.0

---

## 📊 Comprendre le Problème du Context Window

### Le Problème de la Saturation

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    CONTEXT WINDOW - 200K TOKENS                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   ┌────────────────────────────────────────────────────────────────────┐     ║
║   │ System Prompt (fixe)                                    ~5K tokens │     ║
║   ├────────────────────────────────────────────────────────────────────┤     ║
║   │ ⚠️ MCP Tools (100+ tools = 50K+ tokens)               ~25-40% ❌  │     ║
║   ├────────────────────────────────────────────────────────────────────┤     ║
║   │ ⚠️ Skills/Steering (chargés en bloc)                  ~10-20% ❌  │     ║
║   ├────────────────────────────────────────────────────────────────────┤     ║
║   │ Specs (auto-chargées)                                  ~5-15% ❌  │     ║
║   ├────────────────────────────────────────────────────────────────────┤     ║
║   │ Conversation History                                   ~10-30%    │     ║
║   ├────────────────────────────────────────────────────────────────────┤     ║
║   │ 🔴 ESPACE UTILE POUR LE TRAVAIL                        ~10-20%    │     ║
║   └────────────────────────────────────────────────────────────────────┘     ║
║                                                                              ║
║   PROBLÈME : 5 serveurs MCP = 50K+ tokens avant le premier prompt !          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Impact sur la Qualité

| Saturation | Symptômes |
|------------|-----------|
| > 70% | Réponses lentes, "context rot" |
| > 80% | Auto-summarization forcée |
| > 90% | Perte de contexte, hallucinations |
| 100% | Blocage complet |

---

## 🏗️ Architecture de Solution

### Principe : Lazy Loading Progressif

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    ARCHITECTURE OPTIMISÉE                                    ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   NIVEAU 0 : TOUJOURS CHARGÉ (~5%)                                          ║
║   ┌─────────────────────────────────────────────────────────────────────┐    ║
║   │ • System prompt minimal                                             │    ║
║   │ • AGENTS.md (instructions de base)                                  │    ║
║   │ • Tool Router (find-tools, list-agents)                             │    ║
║   └─────────────────────────────────────────────────────────────────────┘    ║
║                                                                              ║
║   NIVEAU 1 : METADATA SEULEMENT (~2-3%)                                     ║
║   ┌─────────────────────────────────────────────────────────────────────┐    ║
║   │ • Index des Skills (name + description)                             │    ║
║   │ • Index des MCP (name + description)                                │    ║
║   │ • Index des Agents disponibles                                      │    ║
║   └─────────────────────────────────────────────────────────────────────┘    ║
║                                                                              ║
║   NIVEAU 2 : CHARGÉ À LA DEMANDE (~10-15% max)                              ║
║   ┌─────────────────────────────────────────────────────────────────────┐    ║
║   │ • Skill spécifique quand activé par keyword                         │    ║
║   │ • MCP server quand tool nécessaire                                  │    ║
║   │ • Spec quand workflow déclenché                                     │    ║
║   └─────────────────────────────────────────────────────────────────────┘    ║
║                                                                              ║
║   NIVEAU 3 : CONTEXTE DE TRAVAIL (~60-70% disponible)                       ║
║   ┌─────────────────────────────────────────────────────────────────────┐    ║
║   │ • Conversation                                                      │    ║
║   │ • Fichiers de travail                                               │    ║
║   │ • Résultats d'outils                                                │    ║
║   └─────────────────────────────────────────────────────────────────────┘    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 📁 Structure de Fichiers Recommandée

### Organisation du Workspace

```
repo_hps/
├── .kiro/
│   ├── AGENTS.md                    # Instructions minimales (toujours chargé)
│   │
│   ├── agents/                      # Agents spécialisés
│   │   ├── _index.json              # Index des agents (metadata)
│   │   ├── migration-agent.json     # Agent migration Angular
│   │   ├── audit-agent.json         # Agent audit code
│   │   └── devops-agent.json        # Agent DevOps
│   │
│   ├── steering/                    # Guidance (lazy loaded)
│   │   ├── _index.md                # Index des steering docs
│   │   ├── 01-always-loaded.md      # inclusion_mode: always (minimal)
│   │   ├── 02-angular-patterns.md   # inclusion_mode: file-pattern
│   │   └── 03-migration-guide.md    # inclusion_mode: manual
│   │
│   ├── skills/                      # Skills (lazy loaded)
│   │   ├── _index.json              # Index des skills (metadata only)
│   │   ├── angular-migration/
│   │   │   └── SKILL.md             # Chargé quand "migration" détecté
│   │   ├── code-audit/
│   │   │   └── SKILL.md             # Chargé quand "audit" détecté
│   │   └── rxjs-patterns/
│   │       └── SKILL.md             # Chargé quand "rxjs" détecté
│   │
│   ├── specs/                       # Specs exécutables
│   │   ├── _index.json              # Index des specs (metadata only)
│   │   └── *.md                     # Chargées explicitement
│   │
│   └── mcp/                         # Configuration MCP
│       ├── mcp.json                 # Config principale
│       └── profiles/                # Profils de chargement
│           ├── minimal.json         # Profil minimal (défaut)
│           ├── migration.json       # Profil migration
│           └── full.json            # Tous les MCP (debug)
│
├── docs_outils_ia/
│   └── TOOL-ROUTER.md               # Documentation du routeur
│
└── scripts_outils_ia/
    └── check-context-usage.sh       # Vérifier usage du contexte
```

---

## 🔧 Configuration du Tool Router

### Concept : MCP Dynamic Proxy

Au lieu de charger tous les MCP servers, on utilise un **proxy dynamique** qui expose seulement 3 outils de base :

```json
{
  "name": "tool-router",
  "description": "Routes vers les bons outils sans tout charger",
  "tools": [
    "find_tools",      // Cherche l'outil adapté au besoin
    "list_categories", // Liste les catégories disponibles
    "load_toolset"     // Charge un ensemble d'outils
  ]
}
```

### Configuration MCP Optimisée

**Fichier : `.kiro/mcp/mcp.json`**

```json
{
  "version": "1.0",
  "defaultProfile": "minimal",
  
  "profiles": {
    "minimal": {
      "description": "Chargement minimal - seulement le routeur",
      "servers": ["tool-router"]
    },
    "migration": {
      "description": "Outils pour migration Angular",
      "servers": ["tool-router", "filesystem", "git"]
    },
    "devops": {
      "description": "Outils DevOps complets",
      "servers": ["tool-router", "aws-cli", "terraform", "kubernetes"]
    },
    "full": {
      "description": "Tous les outils (debug uniquement)",
      "servers": ["*"]
    }
  },
  
  "mcpServers": {
    "tool-router": {
      "description": "Routeur intelligent vers les outils",
      "tags": ["core", "routing", "discovery"],
      "alwaysLoad": true,
      "command": "uvx",
      "args": ["mcp-dynamic-proxy"],
      "env": {
        "MCP_CONFIG_PATH": ".kiro/mcp/tools-catalog.json"
      }
    },
    
    "filesystem": {
      "description": "Opérations sur fichiers locaux",
      "tags": ["files", "code", "edit"],
      "tools": ["read_file", "write_file", "list_directory"],
      "loadOn": ["file", "code", "edit", "read", "write"],
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-filesystem"]
    },
    
    "git": {
      "description": "Opérations Git",
      "tags": ["git", "version", "commit", "branch"],
      "tools": ["git_status", "git_log", "git_diff"],
      "loadOn": ["git", "commit", "branch", "merge"],
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-git"]
    },
    
    "web-search": {
      "description": "Recherche web et documentation",
      "tags": ["search", "web", "documentation"],
      "loadOn": ["search", "find", "documentation", "how to"],
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-brave-search"]
    }
  }
}
```

### Catalogue des Outils

**Fichier : `.kiro/mcp/tools-catalog.json`**

```json
{
  "version": "1.0",
  "categories": {
    "file-operations": {
      "description": "Lecture, écriture, manipulation de fichiers",
      "keywords": ["file", "read", "write", "edit", "create", "delete"],
      "servers": ["filesystem"],
      "tokenCost": "~2000"
    },
    "version-control": {
      "description": "Git et gestion de versions",
      "keywords": ["git", "commit", "branch", "merge", "diff", "log"],
      "servers": ["git"],
      "tokenCost": "~3000"
    },
    "code-analysis": {
      "description": "Analyse et linting de code",
      "keywords": ["lint", "analyze", "audit", "quality", "eslint"],
      "servers": ["eslint", "typescript-analyzer"],
      "tokenCost": "~5000"
    },
    "angular-migration": {
      "description": "Outils spécifiques migration Angular",
      "keywords": ["angular", "migration", "ng update", "rxjs"],
      "servers": ["angular-cli", "rxjs-migrator"],
      "tokenCost": "~4000"
    },
    "documentation": {
      "description": "Recherche et génération de docs",
      "keywords": ["doc", "search", "readme", "api"],
      "servers": ["web-search", "doc-generator"],
      "tokenCost": "~3000"
    }
  },
  
  "tools": {
    "read_file": {
      "category": "file-operations",
      "description": "Lire le contenu d'un fichier",
      "server": "filesystem"
    },
    "git_status": {
      "category": "version-control", 
      "description": "État du repo Git",
      "server": "git"
    }
  }
}
```

---

## 📋 Configuration des Skills avec Lazy Loading

### Structure d'un Skill Optimisé

**Fichier : `.kiro/skills/angular-migration/SKILL.md`**

```yaml
---
name: "angular-migration"
description: "Guide expert pour migration Angular 5→20"
version: "1.0.0"

# LAZY LOADING CONFIG
loadOn:
  keywords:
    - "migration"
    - "angular"
    - "ng update"
    - "upgrade"
    - "rxjs"
  filePatterns:
    - "*.module.ts"
    - "angular.json"
  manual: "#angular-migration"

# ESTIMATION TOKENS
tokenEstimate: 8000
priority: high

# DÉPENDANCES (chargées ensemble si nécessaire)
requires:
  - "rxjs-patterns"
dependencies:
  mcp: ["filesystem", "git"]
---

# Angular Migration Skill

## Quand ce Skill s'Active

Ce skill se charge automatiquement quand :
- Le prompt contient "migration", "angular", "ng update"
- On travaille sur des fichiers *.module.ts ou angular.json
- L'utilisateur tape `#angular-migration` dans le chat

## Contenu du Skill

[... contenu détaillé de la migration ...]
```

### Index des Skills

**Fichier : `.kiro/skills/_index.json`**

```json
{
  "version": "1.0",
  "description": "Index des skills disponibles - SEUL CE FICHIER EST CHARGÉ AU DÉMARRAGE",
  
  "skills": [
    {
      "name": "angular-migration",
      "path": "angular-migration/SKILL.md",
      "description": "Migration Angular 5→20 avec breaking changes",
      "keywords": ["migration", "angular", "ng update", "upgrade"],
      "tokenEstimate": 8000,
      "priority": "high"
    },
    {
      "name": "code-audit",
      "path": "code-audit/SKILL.md", 
      "description": "Audit qualité et sécurité du code",
      "keywords": ["audit", "quality", "security", "lint"],
      "tokenEstimate": 5000,
      "priority": "medium"
    },
    {
      "name": "rxjs-patterns",
      "path": "rxjs-patterns/SKILL.md",
      "description": "Patterns RxJS et migration 5→6→7",
      "keywords": ["rxjs", "observable", "subscribe", "pipe"],
      "tokenEstimate": 4000,
      "priority": "medium"
    }
  ],
  
  "totalTokensIfAllLoaded": 17000,
  "recommendedMaxLoaded": 2
}
```

---

## 🤖 Configuration des Agents Spécialisés

### Index des Agents

**Fichier : `.kiro/agents/_index.json`**

```json
{
  "version": "1.0",
  "description": "Index des agents - chargé au démarrage",
  
  "agents": [
    {
      "name": "migration-agent",
      "displayName": "Agent Migration Angular",
      "description": "Spécialisé dans la migration Angular 5→20",
      "activationKeywords": ["migrate", "migration", "upgrade", "angular"],
      "file": "migration-agent.json"
    },
    {
      "name": "audit-agent",
      "displayName": "Agent Audit Code",
      "description": "Analyse qualité, sécurité et patterns",
      "activationKeywords": ["audit", "analyze", "quality", "security"],
      "file": "audit-agent.json"
    },
    {
      "name": "coordinator-agent",
      "displayName": "Agent Coordinateur",
      "description": "Coordonne les actions entre repos",
      "activationKeywords": ["coordinate", "sync", "multi-repo"],
      "file": "coordinator-agent.json"
    }
  ],
  
  "defaultAgent": "coordinator-agent"
}
```

### Agent Spécialisé : Migration

**Fichier : `.kiro/agents/migration-agent.json`**

```json
{
  "name": "migration-agent",
  "description": "Agent spécialisé migration Angular 5→20",
  "version": "1.0.0",
  
  "model": "claude-sonnet-4",
  
  "resources": [
    "file://.kiro/steering/01-always-loaded.md",
    "skill://.kiro/skills/angular-migration/SKILL.md",
    "skill://.kiro/skills/rxjs-patterns/SKILL.md"
  ],
  
  "mcpProfile": "migration",
  
  "contextBudget": {
    "maxTokens": 40000,
    "warningThreshold": 32000,
    "skills": 15000,
    "mcp": 10000,
    "conversation": 15000
  },
  
  "hooks": {
    "agentSpawn": [
      {
        "command": "echo 'Migration Agent activé'"
      }
    ],
    "preToolUse": [
      {
        "matcher": "ng_update",
        "command": "git stash"
      }
    ]
  },
  
  "systemPrompt": "Tu es un expert en migration Angular. Tu migres TOUJOURS la bibliothèque AVANT le client. Tu respectes la séquence des paliers."
}
```

---

## 📊 AGENTS.md Optimisé pour le Routage

**Fichier : `.kiro/AGENTS.md`**

```markdown
# AGENTS.md - Routeur Intelligent

> Ce fichier est TOUJOURS chargé. Il doit rester MINIMAL (<500 tokens).

## 🎯 Principe de Fonctionnement

**Tu ne charges PAS tout au démarrage.**

1. **Identifie** le besoin du prompt
2. **Consulte** l'index approprié (_index.json)
3. **Charge** uniquement ce qui est nécessaire
4. **Exécute** avec le contexte minimal

## 📋 Index Disponibles

| Index | Chemin | Contenu |
|-------|--------|---------|
| Skills | `.kiro/skills/_index.json` | Compétences spécialisées |
| Agents | `.kiro/agents/_index.json` | Agents spécialisés |
| MCP | `.kiro/mcp/tools-catalog.json` | Outils disponibles |
| Specs | `.kiro/specs/_index.json` | Workflows exécutables |

## 🔄 Workflow de Routage

```
PROMPT REÇU
    │
    ▼
ANALYSE DES KEYWORDS
    │
    ├── "migration" → Charger migration-agent + angular-migration skill
    ├── "audit" → Charger audit-agent + code-audit skill  
    ├── "git" → Charger git MCP server
    └── autre → Demander clarification
```

## ⚠️ Règles Critiques

1. **Ne jamais charger plus de 2 skills simultanément**
2. **Ne jamais charger plus de 3 MCP servers**
3. **Toujours vérifier le budget tokens avant chargement**
4. **Si saturation > 70%, décharger les ressources inutilisées**

## 📞 Commandes de Routage

- `#list-skills` → Affiche les skills disponibles
- `#list-agents` → Affiche les agents disponibles  
- `#list-tools` → Affiche les catégories d'outils
- `#context-status` → Affiche l'usage du contexte
- `#unload [name]` → Décharge une ressource
```

---

## 🔧 Scripts de Gestion

### Vérification de l'Usage du Contexte

**Fichier : `scripts_outils_ia/check-context-usage.sh`**

```bash
#!/bin/bash
#
# check-context-usage.sh
# Estime l'usage du context window
#

echo "═══════════════════════════════════════════════════════════════"
echo "         ESTIMATION USAGE CONTEXT WINDOW                        "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Compteur de tokens (approximation : 1 token ≈ 4 caractères)
count_tokens() {
    local file=$1
    if [ -f "$file" ]; then
        local chars=$(wc -c < "$file")
        echo $((chars / 4))
    else
        echo 0
    fi
}

TOTAL=0

# AGENTS.md
if [ -f ".kiro/AGENTS.md" ]; then
    AGENTS_TOKENS=$(count_tokens ".kiro/AGENTS.md")
    echo "AGENTS.md              : ~$AGENTS_TOKENS tokens"
    TOTAL=$((TOTAL + AGENTS_TOKENS))
fi

# Steering files (always loaded)
echo ""
echo "Steering (always loaded):"
STEERING_TOTAL=0
for file in .kiro/steering/*.md; do
    if [ -f "$file" ] && grep -q "inclusion_mode: always" "$file" 2>/dev/null; then
        tokens=$(count_tokens "$file")
        name=$(basename "$file")
        echo "  $name: ~$tokens tokens"
        STEERING_TOTAL=$((STEERING_TOTAL + tokens))
    fi
done
echo "  TOTAL: ~$STEERING_TOTAL tokens"
TOTAL=$((TOTAL + STEERING_TOTAL))

# Skills index
echo ""
echo "Skills (metadata only):"
if [ -f ".kiro/skills/_index.json" ]; then
    INDEX_TOKENS=$(count_tokens ".kiro/skills/_index.json")
    echo "  _index.json: ~$INDEX_TOKENS tokens"
    TOTAL=$((TOTAL + INDEX_TOKENS))
fi

# MCP Config
echo ""
echo "MCP Config:"
if [ -f ".kiro/mcp/mcp.json" ]; then
    MCP_TOKENS=$(count_tokens ".kiro/mcp/mcp.json")
    echo "  mcp.json: ~$MCP_TOKENS tokens"
    TOTAL=$((TOTAL + MCP_TOKENS))
fi

# Résumé
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "TOTAL CHARGÉ AU DÉMARRAGE : ~$TOTAL tokens"
echo ""

# Calcul pourcentage (context window = 200K)
CONTEXT_SIZE=200000
PERCENT=$((TOTAL * 100 / CONTEXT_SIZE))

if [ $PERCENT -lt 10 ]; then
    echo "✅ Usage: $PERCENT% - EXCELLENT"
elif [ $PERCENT -lt 20 ]; then
    echo "✅ Usage: $PERCENT% - BON"
elif [ $PERCENT -lt 30 ]; then
    echo "⚠️  Usage: $PERCENT% - ATTENTION"
else
    echo "🔴 Usage: $PERCENT% - TROP ÉLEVÉ"
fi

echo ""
echo "Recommandation: Garder < 15% pour le chargement initial"
echo "═══════════════════════════════════════════════════════════════"
```

---

## 📊 Stratégies de Déchargement

### Quand Décharger ?

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    STRATÉGIES DE DÉCHARGEMENT                                ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   DÉCLENCHEUR                        ACTION                                  ║
║   ───────────────────────────────────────────────────────────────────────    ║
║   Context > 70%                      Résumer conversation ancienne           ║
║   Context > 80%                      Décharger skills non utilisés           ║
║   Context > 90%                      Décharger MCP non actifs                ║
║   Changement de tâche                Décharger ressources précédentes        ║
║   Inactivité skill > 5 messages      Marquer pour déchargement               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Implémentation dans l'Agent

```json
{
  "contextManagement": {
    "strategy": "aggressive-unload",
    
    "thresholds": {
      "warningPercent": 70,
      "unloadSkillsPercent": 80,
      "unloadMcpPercent": 90,
      "criticalPercent": 95
    },
    
    "unloadRules": [
      {
        "condition": "skill_unused_for_messages > 5",
        "action": "unload_skill"
      },
      {
        "condition": "mcp_unused_for_messages > 3",
        "action": "unload_mcp"
      },
      {
        "condition": "context_percent > 80",
        "action": "summarize_old_conversation"
      }
    ],
    
    "protectedResources": [
      "AGENTS.md",
      "tool-router"
    ]
  }
}
```

---

## 🎯 Bonnes Pratiques

### DO ✅

```markdown
1. **Garder AGENTS.md minimal** (<500 tokens)
   - Instructions de routage uniquement
   - Pas de documentation détaillée

2. **Utiliser les index**
   - _index.json pour chaque catégorie
   - Metadata seulement (name, description, keywords)

3. **Définir des keywords précis**
   - Chaque skill/agent a ses déclencheurs
   - Éviter les keywords trop génériques

4. **Créer des profils MCP**
   - minimal (défaut)
   - par domaine (migration, devops, etc.)
   - full (debug uniquement)

5. **Estimer les tokens**
   - Chaque skill documente son tokenEstimate
   - Vérifier avant chargement
```

### DON'T ❌

```markdown
1. **Ne pas charger tous les MCP au démarrage**
   - 5 servers = 50K+ tokens perdus

2. **Ne pas mettre inclusion_mode: always partout**
   - Réserver aux fichiers critiques (<3)

3. **Ne pas ignorer les seuils de saturation**
   - >70% = dégradation qualité

4. **Ne pas oublier de décharger**
   - Les ressources s'accumulent

5. **Ne pas mélanger les domaines dans un agent**
   - Un agent = une spécialité
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle

- [Kiro Skills Documentation](https://kiro.dev/docs/steering/)
- [MCP Dynamic Discovery](https://modelcontextprotocol.io/specification/server/tools)
- [Kiro Powers](https://kiro.dev/blog/introducing-powers/)

### Outils Recommandés

- **mcp-dynamic-proxy** : Proxy MCP avec lazy loading
- **Kiro Powers** : Packages skill+MCP unifiés

---

## 📦 Package Prêt à l'Emploi

Ce guide fait partie du package `kiro-context-optimizer.zip` qui contient :

```
kiro-context-optimizer/
├── .kiro/
│   ├── AGENTS.md                    # Routeur minimal
│   ├── agents/
│   │   ├── _index.json
│   │   └── *.json
│   ├── skills/
│   │   ├── _index.json
│   │   └── */SKILL.md
│   ├── mcp/
│   │   ├── mcp.json
│   │   ├── tools-catalog.json
│   │   └── profiles/*.json
│   └── steering/
│       ├── _index.md
│       └── *.md
├── docs_outils_ia/
│   └── GUIDE-CONTEXT-OPTIMIZER.md
└── scripts_outils_ia/
    └── check-context-usage.sh
```

---

*Ce guide est optimisé pour maintenir l'usage MCP < 12% du context window.*
