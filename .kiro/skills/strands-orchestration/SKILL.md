---
name: strands-orchestration
displayName: Strands Agent Orchestration
description: Orchestration multi-agents stateful avec Strands Agent SDK d'Amazon
version: 1.0.0

# LAZY LOADING CONFIG
loadOn:
  keywords:
    - strands
    - orchestrate
    - orchestration
    - multi-agent
    - coordinate
    - workflow
    - stateful
    - resume
    - checkpoint
    - rollback
  manual: "#strands"

# TOKEN ESTIMATION
tokenEstimate: 6000
priority: high

# DEPENDENCIES
requires: []
mcpNeeds:
  - strands-orchestrator
---

# 🎭 Strands Agent Orchestration Skill

## Activation

Ce skill se charge automatiquement quand :
- Le prompt contient : "strands", "orchestrate", "multi-agent", "coordinate"
- On demande une reprise de session : "resume", "reprendre"
- On parle de workflows : "workflow", "checkpoint", "rollback"
- L'utilisateur tape : `#strands`

---

## 🎯 Objectif

Strands Agent permet d'**orchestrer plusieurs agents Kiro** de manière **stateful** :
- Coordonner la migration lib + client
- Reprendre une migration interrompue
- Créer des points de sauvegarde (checkpoints)
- Rollback en cas d'erreur

---

## 📐 Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     STRANDS ORCHESTRATOR                                │
│                     (Stateful Controller)                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   State Store (.kiro/state/strands-state.json)                          │
│   ┌───────────────────────────────────────────────────────────────┐     │
│   │ • workflow.status: "in_progress"                              │     │
│   │ • workflow.currentStep: "7-to-8-lib"                          │     │
│   │ • agents.migration-lib.status: "running"                      │     │
│   │ • progress.completed: [5→6, 6→7]                              │     │
│   │ • checkpoints: ["angular-6", "angular-7"]                     │     │
│   └───────────────────────────────────────────────────────────────┘     │
│                                                                         │
│   Agents Contrôlés                                                      │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
│   │ migration-lib   │  │ migration-client│  │ audit-agent     │        │
│   │ Angular lib     │→│ Angular app     │→│ Validation      │        │
│   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Commandes Disponibles

### Gestion des Workflows

| Commande | Description |
|----------|-------------|
| `#strands start --from 5 --to 20` | Démarrer migration |
| `#strands resume` | Reprendre migration interrompue |
| `#strands status` | État actuel |
| `#strands pause` | Mettre en pause |
| `#strands abort` | Abandonner |

### Gestion des Checkpoints

| Commande | Description |
|----------|-------------|
| `#strands checkpoint create "description"` | Créer checkpoint |
| `#strands checkpoint list` | Lister checkpoints |
| `#strands rollback --to <checkpoint-id>` | Restaurer |

### Gestion des Agents

| Commande | Description |
|----------|-------------|
| `#strands agents` | Lister agents et statuts |
| `#strands agent <name> status` | Statut d'un agent |
| `#strands agent <name> reset` | Réinitialiser un agent |

---

## 📊 Structure de l'État

```json
{
  "workflow": {
    "name": "angular-migration-5-to-20",
    "status": "in_progress|paused|completed|failed",
    "currentStep": "7-to-8-lib",
    "startedAt": "2026-01-29T10:00:00Z"
  },
  
  "agents": {
    "migration-lib": {
      "status": "running|idle|waiting|error",
      "currentTask": "ng update @angular/core@8",
      "context": {
        "repo": "pwc-ui-shared-v4-ia",
        "version": "7.2.0"
      }
    },
    "migration-client": {
      "status": "waiting",
      "waitingFor": "migration-lib >= 8.0.0"
    }
  },
  
  "progress": {
    "completed": ["5-to-6-lib", "5-to-6-client", "6-to-7-lib", "6-to-7-client"],
    "current": "7-to-8-lib",
    "pending": ["7-to-8-client", "8-to-9-lib", "..."],
    "percentComplete": 26.67
  },
  
  "checkpoints": [
    {"id": "angular-6", "timestamp": "...", "canRollbackTo": true},
    {"id": "angular-7", "timestamp": "...", "canRollbackTo": true}
  ]
}
```

---

## 🔄 Workflow de Migration

### Séquence Normale

```
ÉTAPE 1: Migration Lib (Palier N → N+1)
─────────────────────────────────────
  [migration-lib] ng update @angular/cli@N+1 @angular/core@N+1
  [migration-lib] Appliquer codemods
  [migration-lib] npm run build
  [migration-lib] npm run test
  [ORCHESTRATOR] Marquer lib comme "version N+1"

ÉTAPE 2: Migration Client (Palier N → N+1)  
─────────────────────────────────────
  [ORCHESTRATOR] Vérifier: lib >= N+1 ? ✅
  [migration-client] rm -rf node_modules && npm install
  [migration-client] ng update @angular/cli@N+1 @angular/core@N+1
  [migration-client] Appliquer codemods
  [migration-client] npm run build
  [migration-client] npm run test
  [ORCHESTRATOR] Marquer client comme "version N+1"

ÉTAPE 3: Validation
─────────────────────────────────────
  [audit-agent] Valider la migration
  [ORCHESTRATOR] Créer checkpoint "angular-N+1"

RÉPÉTER JUSQU'À VERSION CIBLE
```

### Gestion des Erreurs

```
SI ERREUR DÉTECTÉE:
─────────────────────────────────────
  1. Pause automatique
  2. Notification utilisateur
  3. Options:
     a) Corriger manuellement → #strands resume
     b) Rollback → #strands rollback --to <checkpoint>
     c) Abandonner → #strands abort
```

---

## 💾 Mode Stateful - Avantages

| Scénario | Sans Stateful | Avec Stateful |
|----------|---------------|---------------|
| Interruption réseau | Tout perdu | Reprise auto |
| Pause volontaire | Recommencer | Continue |
| Erreur palier 12 | Revenir à 0 | Rollback palier 11 |
| Nouveau jour | Où j'en étais ? | État complet |

---

## 📋 Exemple de Session

```
> #strands start --from 5 --to 8

[STRANDS] 🚀 Démarrage workflow: angular-migration-5-to-8
[STRANDS] 3 paliers à migrer (5→6, 6→7, 7→8)
[STRANDS] 6 étapes au total (lib + client × 3)

[migration-lib] 📦 Palier 5→6
  ng update @angular/cli@6 @angular/core@6
  ✅ Build OK (2m 34s)
  ✅ Tests OK (1m 12s)

[migration-client] 📦 Palier 5→6
  Prérequis: lib >= 6.0.0 ✅
  rm -rf node_modules && npm install
  ng update @angular/cli@6 @angular/core@6
  ✅ Build OK (4m 56s)
  ✅ Tests OK (3m 22s)

[STRANDS] 💾 Checkpoint créé: "angular-6-complete"
[STRANDS] Progression: 33% (2/6 étapes)

[migration-lib] 📦 Palier 6→7
  ng update @angular/cli@7 @angular/core@7
  ...

---

[INTERRUPTION]

---

> #strands resume

[STRANDS] 🔄 Reprise détectée
[STRANDS] Dernier état: Palier 6→7 (lib) - 45% complété
[STRANDS] Reprise en cours...

[migration-lib] 📦 Palier 6→7 (reprise)
  ✅ Continuation du ng update
  ...
```

---

## ⚙️ Configuration MCP

Dans `.kiro/mcp/mcp.json` :

```json
{
  "mcpServers": {
    "strands-orchestrator": {
      "command": "python3",
      "args": ["-m", "strands.mcp_server"],
      "env": {
        "STRANDS_STATE_PATH": ".kiro/state/strands-state.json"
      },
      "tokenEstimate": 5000,
      "loadOn": {
        "keywords": ["strands", "orchestrate", "resume"]
      }
    }
  }
}
```

---

## 📚 Ressources

- [MODOP Strands Agent](../modops/MODOP-STRANDS-AGENT.md) - Guide complet d'installation
- [Strands Agent SDK](https://github.com/strands-agents/strands-agents-sdk)
- [AWS Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)

---

## ⚠️ Limitations

1. **Nécessite Python 3.10+** pour le SDK
2. **État local uniquement** (pas de sync cloud par défaut)
3. **Rollback = perte des modifications** post-checkpoint
4. **Un workflow à la fois** par workspace
