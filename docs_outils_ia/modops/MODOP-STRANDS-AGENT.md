# 📘 MODOP : Strands Agent pour Orchestration Multi-Agents Stateful

> **Version** : 1.0.0  
> **Date** : 2026-01-29  
> **Objectif** : Orchestrer les agents Kiro avec Strands Agent d'Amazon en mode stateful

---

## 📋 Table des Matières

1. [Présentation de Strands Agent](#1-présentation-de-strands-agent)
2. [Architecture d'Intégration](#2-architecture-dintégration)
3. [Installation et Configuration](#3-installation-et-configuration)
4. [Mode Stateful](#4-mode-stateful)
5. [Orchestration des Agents Kiro](#5-orchestration-des-agents-kiro)
6. [Exemples de Workflows](#6-exemples-de-workflows)
7. [Bonnes Pratiques](#7-bonnes-pratiques)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Présentation de Strands Agent

### 1.1 Qu'est-ce que Strands Agent ?

**Strands Agent** (anciennement Strands Agents SDK) est un framework d'Amazon AWS pour construire et orchestrer des agents IA. Il offre :

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     STRANDS AGENT - CAPACITÉS                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  🔄 ORCHESTRATION                                                       │
│     • Coordination multi-agents                                         │
│     • Délégation de tâches                                              │
│     • Gestion du cycle de vie                                           │
│                                                                         │
│  💾 STATEFUL                                                            │
│     • Persistance d'état entre sessions                                 │
│     • Mémoire conversationnelle                                         │
│     • Contexte partagé entre agents                                     │
│                                                                         │
│  🔧 INTÉGRATION                                                         │
│     • AWS Bedrock (Claude, Titan, etc.)                                 │
│     • Tools/Functions personnalisés                                     │
│     • MCP (Model Context Protocol)                                      │
│                                                                         │
│  📊 OBSERVABILITÉ                                                       │
│     • Traces et métriques                                               │
│     • Logging structuré                                                 │
│     • Debugging intégré                                                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Pourquoi Strands Agent pour notre projet ?

| Besoin | Solution Strands |
|--------|-----------------|
| Coordonner lib + client | Orchestrateur multi-agents |
| Reprendre une migration | État stateful persisté |
| Suivre l'avancement | Métriques et traces |
| Gérer les erreurs | Recovery automatique |

---

## 2. Architecture d'Intégration

### 2.1 Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     ARCHITECTURE STRANDS + KIRO                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                         ┌─────────────────────┐                         │
│                         │   STRANDS AGENT     │                         │
│                         │   ORCHESTRATOR      │                         │
│                         │   (Stateful)        │                         │
│                         └──────────┬──────────┘                         │
│                                    │                                    │
│              ┌─────────────────────┼─────────────────────┐              │
│              │                     │                     │              │
│              ▼                     ▼                     ▼              │
│   ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐      │
│   │  KIRO AGENT 1   │   │  KIRO AGENT 2   │   │  KIRO AGENT 3   │      │
│   │  migration-lib  │   │ migration-client│   │   audit-agent   │      │
│   │                 │   │                 │   │                 │      │
│   │ Skills:         │   │ Skills:         │   │ Skills:         │      │
│   │ • angular-mig   │   │ • angular-mig   │   │ • code-audit    │      │
│   │ • codemods      │   │ • codemods      │   │ • validation    │      │
│   └────────┬────────┘   └────────┬────────┘   └────────┬────────┘      │
│            │                     │                     │                │
│            └─────────────────────┼─────────────────────┘                │
│                                  │                                      │
│                                  ▼                                      │
│                    ┌─────────────────────────┐                          │
│                    │      STATE STORE        │                          │
│                    │   (DynamoDB / Redis)    │                          │
│                    │                         │                          │
│                    │ • Migration progress    │                          │
│                    │ • Agent states          │                          │
│                    │ • Error history         │                          │
│                    └─────────────────────────┘                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Composants

| Composant | Rôle | Technologie |
|-----------|------|-------------|
| **Strands Orchestrator** | Contrôleur central | Strands Agent SDK |
| **Kiro Agents** | Exécuteurs spécialisés | Kiro IDE + Claude |
| **State Store** | Persistance | DynamoDB / Redis / Local JSON |
| **Event Bus** | Communication | AWS EventBridge / Local |

---

## 3. Installation et Configuration

### 3.1 Prérequis

```bash
# Node.js 18+
node --version  # v18.x ou supérieur

# Python 3.10+ (pour Strands SDK)
python3 --version  # 3.10+

# AWS CLI configuré (optionnel, pour production)
aws configure
```

### 3.2 Installation Strands Agent SDK

```bash
# Installation Python
pip install strands-agents

# Ou avec conda
conda install -c conda-forge strands-agents

# Vérification
python3 -c "import strands; print(strands.__version__)"
```

### 3.3 Configuration Locale (Développement)

```python
# config/strands_config.py

from strands import Agent, Orchestrator
from strands.state import LocalStateStore
from strands.tools import ToolRegistry

# Configuration de base
config = {
    "orchestrator": {
        "name": "migration-orchestrator",
        "model": "anthropic.claude-sonnet-4-20250514",
        "region": "eu-west-1",  # ou local pour dev
    },
    "state": {
        "backend": "local",  # ou "dynamodb" pour production
        "path": ".kiro/state/strands-state.json",
        "ttl_hours": 168,  # 7 jours
    },
    "agents": {
        "max_concurrent": 2,
        "timeout_seconds": 300,
        "retry_attempts": 3,
    }
}
```

### 3.4 Configuration Kiro

Ajouter dans `.kiro/mcp/mcp.json` :

```json
{
  "mcpServers": {
    "strands-orchestrator": {
      "command": "python3",
      "args": ["-m", "strands.mcp_server"],
      "env": {
        "STRANDS_CONFIG": ".kiro/strands/config.json",
        "STRANDS_STATE_PATH": ".kiro/state/strands-state.json"
      },
      "alwaysLoad": false,
      "loadOn": {
        "keywords": ["orchestrate", "coordinate", "multi-agent", "strands"]
      },
      "tokenEstimate": 5000
    }
  }
}
```

---

## 4. Mode Stateful

### 4.1 Pourquoi le Mode Stateful ?

```
SANS STATEFUL                           AVEC STATEFUL
─────────────────────────────────────────────────────────────────────
Session 1:                              Session 1:
  - Migrer Angular 5→6 ✅                - Migrer Angular 5→6 ✅
  - Migrer Angular 6→7 ⏳                - Migrer Angular 6→7 ⏳
  [Interruption]                         [Interruption]
                                         État sauvé: {
Session 2:                                 currentStep: "6→7",
  - "Où en étais-je ?"                     completedSteps: ["5→6"],
  - Tout recommencer 😱                    context: {...}
                                         }
                                        
                                        Session 2:
                                          - Reprise automatique
                                          - Continue 6→7 ✅
```

### 4.2 Structure de l'État

```json
// .kiro/state/strands-state.json
{
  "version": "1.0",
  "orchestrator": {
    "id": "migration-orchestrator-001",
    "createdAt": "2026-01-29T10:00:00Z",
    "lastActivityAt": "2026-01-29T14:30:00Z"
  },
  
  "workflow": {
    "name": "angular-migration-5-to-20",
    "status": "in_progress",
    "currentPhase": "migration",
    "currentStep": "angular-7-to-8"
  },
  
  "agents": {
    "migration-lib": {
      "status": "idle",
      "lastTask": "migrate-6-to-7",
      "lastResult": "success",
      "context": {
        "repo": "pwc-ui-shared-v4-ia",
        "currentVersion": "7.0.0"
      }
    },
    "migration-client": {
      "status": "waiting",
      "waitingFor": "migration-lib >= 8.0.0",
      "context": {
        "repo": "pwc-ui-v4-ia",
        "currentVersion": "6.0.0"
      }
    }
  },
  
  "progress": {
    "completed": [
      {"step": "5-to-6-lib", "timestamp": "2026-01-29T10:30:00Z"},
      {"step": "5-to-6-client", "timestamp": "2026-01-29T11:00:00Z"},
      {"step": "6-to-7-lib", "timestamp": "2026-01-29T12:00:00Z"},
      {"step": "6-to-7-client", "timestamp": "2026-01-29T13:00:00Z"}
    ],
    "pending": [
      "7-to-8-lib",
      "7-to-8-client",
      "8-to-9-lib",
      "8-to-9-client"
    ],
    "percentComplete": 26.67
  },
  
  "errors": [],
  
  "checkpoints": [
    {
      "id": "checkpoint-6",
      "description": "Migration Angular 6 complète",
      "timestamp": "2026-01-29T11:00:00Z",
      "canRollbackTo": true
    }
  ]
}
```

### 4.3 API de Gestion d'État

```python
# scripts/strands_state_manager.py

from strands.state import StateManager

class MigrationStateManager:
    def __init__(self, state_path=".kiro/state/strands-state.json"):
        self.state = StateManager(state_path)
    
    def get_current_step(self) -> str:
        """Retourne l'étape en cours"""
        return self.state.get("workflow.currentStep")
    
    def complete_step(self, step_name: str, result: dict):
        """Marque une étape comme complétée"""
        self.state.append("progress.completed", {
            "step": step_name,
            "timestamp": datetime.now().isoformat(),
            "result": result
        })
        self.state.remove_first("progress.pending", step_name)
        self._update_progress_percent()
        self.state.save()
    
    def create_checkpoint(self, description: str):
        """Crée un point de sauvegarde pour rollback"""
        checkpoint = {
            "id": f"checkpoint-{uuid.uuid4().hex[:8]}",
            "description": description,
            "timestamp": datetime.now().isoformat(),
            "state_snapshot": self.state.to_dict(),
            "canRollbackTo": True
        }
        self.state.append("checkpoints", checkpoint)
        self.state.save()
        return checkpoint["id"]
    
    def rollback_to_checkpoint(self, checkpoint_id: str):
        """Restaure l'état à un checkpoint"""
        checkpoint = self.state.find("checkpoints", "id", checkpoint_id)
        if checkpoint and checkpoint["canRollbackTo"]:
            self.state.restore(checkpoint["state_snapshot"])
            return True
        return False
    
    def resume(self) -> dict:
        """Retourne les informations pour reprendre"""
        return {
            "currentStep": self.get_current_step(),
            "completedSteps": len(self.state.get("progress.completed")),
            "remainingSteps": len(self.state.get("progress.pending")),
            "lastActivity": self.state.get("orchestrator.lastActivityAt"),
            "canResume": self.state.get("workflow.status") == "in_progress"
        }
```

---

## 5. Orchestration des Agents Kiro

### 5.1 Définition de l'Orchestrateur

```python
# scripts/strands_orchestrator.py

from strands import Orchestrator, Agent
from strands.tools import tool
from strands.state import LocalStateStore

class MigrationOrchestrator:
    """Orchestrateur de migration Angular avec Strands Agent"""
    
    def __init__(self):
        self.state = LocalStateStore(".kiro/state/strands-state.json")
        
        # Définir les agents
        self.agents = {
            "lib": self._create_lib_agent(),
            "client": self._create_client_agent(),
            "audit": self._create_audit_agent()
        }
        
        # Créer l'orchestrateur
        self.orchestrator = Orchestrator(
            name="angular-migration",
            agents=list(self.agents.values()),
            state_store=self.state,
            model="anthropic.claude-sonnet-4"
        )
    
    def _create_lib_agent(self) -> Agent:
        return Agent(
            name="migration-lib",
            description="Agent spécialisé dans la migration de la bibliothèque",
            tools=[
                self.run_ng_update,
                self.run_codemods,
                self.run_build,
                self.run_tests
            ],
            system_prompt="""
            Tu es un expert en migration Angular.
            Tu travailles sur le repo pwc-ui-shared-v4-ia (bibliothèque).
            
            RÈGLE ABSOLUE : Tu dois toujours être migré AVANT le client.
            
            Pour chaque palier de migration :
            1. ng update @angular/cli@X @angular/core@X
            2. Appliquer les codemods de migration
            3. Résoudre les breaking changes
            4. Build et tests
            5. Signaler la fin au client
            """
        )
    
    def _create_client_agent(self) -> Agent:
        return Agent(
            name="migration-client",
            description="Agent spécialisé dans la migration de l'application cliente",
            tools=[
                self.run_ng_update,
                self.run_codemods,
                self.run_build,
                self.run_tests,
                self.reinstall_deps
            ],
            system_prompt="""
            Tu es un expert en migration Angular.
            Tu travailles sur le repo pwc-ui-v4-ia (application cliente).
            
            RÈGLE ABSOLUE : Tu dois ATTENDRE que la lib soit migrée au même palier.
            
            Pour chaque palier de migration :
            1. Vérifier que la lib est au bon palier
            2. rm -rf node_modules && npm install
            3. ng update @angular/cli@X @angular/core@X
            4. Appliquer les codemods
            5. Build et tests + tests d'intégration
            """
        )
    
    # Tools
    @tool
    def run_ng_update(self, repo: str, target_version: int) -> dict:
        """Exécute ng update vers la version cible"""
        # Implémentation
        pass
    
    @tool
    def run_codemods(self, repo: str, codemods: list) -> dict:
        """Exécute les codemods de migration"""
        pass
    
    @tool
    def run_build(self, repo: str) -> dict:
        """Lance le build du projet"""
        pass
    
    @tool
    def run_tests(self, repo: str) -> dict:
        """Lance les tests"""
        pass
    
    @tool
    def reinstall_deps(self, repo: str) -> dict:
        """Réinstalle les dépendances (rm -rf node_modules && npm install)"""
        pass
```

### 5.2 Workflow de Migration

```python
# scripts/migration_workflow.py

from strands import Workflow, Step, Condition

def create_migration_workflow(start_version: int, end_version: int):
    """Crée le workflow de migration complet"""
    
    workflow = Workflow(
        name=f"angular-migration-{start_version}-to-{end_version}",
        description=f"Migration Angular {start_version} → {end_version}"
    )
    
    for version in range(start_version, end_version):
        next_version = version + 1
        
        # Étape 1: Migration de la lib
        workflow.add_step(Step(
            id=f"migrate-lib-{version}-to-{next_version}",
            agent="migration-lib",
            action="migrate",
            params={
                "repo": "pwc-ui-shared-v4-ia",
                "from_version": version,
                "to_version": next_version
            },
            on_success=f"migrate-client-{version}-to-{next_version}",
            on_failure="rollback",
            checkpoint=True  # Créer un checkpoint avant cette étape
        ))
        
        # Étape 2: Migration du client (attend la lib)
        workflow.add_step(Step(
            id=f"migrate-client-{version}-to-{next_version}",
            agent="migration-client",
            action="migrate",
            params={
                "repo": "pwc-ui-v4-ia",
                "from_version": version,
                "to_version": next_version
            },
            precondition=Condition(
                check="agent_status",
                agent="migration-lib",
                expected_status="completed",
                expected_version=f">= {next_version}"
            ),
            on_success=f"validate-{next_version}" if next_version < end_version else "complete",
            on_failure="rollback"
        ))
        
        # Étape 3: Validation
        if next_version < end_version:
            workflow.add_step(Step(
                id=f"validate-{next_version}",
                agent="audit",
                action="validate_migration",
                params={"version": next_version},
                on_success=f"migrate-lib-{next_version}-to-{next_version + 1}",
                on_failure="manual_review"
            ))
    
    # Étape finale
    workflow.add_step(Step(
        id="complete",
        action="mark_complete",
        params={"final_version": end_version}
    ))
    
    return workflow
```

### 5.3 Exécution avec Reprise

```python
# scripts/run_migration.py

from strands_orchestrator import MigrationOrchestrator
from migration_workflow import create_migration_workflow
from strands.state import StateManager

def main():
    orchestrator = MigrationOrchestrator()
    state = StateManager(".kiro/state/strands-state.json")
    
    # Vérifier si une migration est en cours
    resume_info = state.resume()
    
    if resume_info["canResume"]:
        print(f"🔄 Migration en cours détectée")
        print(f"   Étape actuelle: {resume_info['currentStep']}")
        print(f"   Progression: {resume_info['completedSteps']}/{resume_info['remainingSteps'] + resume_info['completedSteps']}")
        
        choice = input("Reprendre ? (o/n/rollback): ")
        
        if choice == "o":
            # Reprendre
            orchestrator.resume()
        elif choice == "rollback":
            # Afficher les checkpoints
            checkpoints = state.get("checkpoints")
            for i, cp in enumerate(checkpoints):
                print(f"  {i+1}. {cp['id']}: {cp['description']} ({cp['timestamp']})")
            
            cp_choice = int(input("Checkpoint à restaurer: ")) - 1
            state.rollback_to_checkpoint(checkpoints[cp_choice]["id"])
            orchestrator.resume()
        else:
            # Nouvelle migration
            start_fresh()
    else:
        start_fresh()

def start_fresh():
    print("🚀 Démarrage nouvelle migration")
    
    start = int(input("Version de départ (ex: 5): "))
    end = int(input("Version cible (ex: 20): "))
    
    workflow = create_migration_workflow(start, end)
    orchestrator.run(workflow)

if __name__ == "__main__":
    main()
```

---

## 6. Exemples de Workflows

### 6.1 Migration Simple (1 palier)

```bash
# Commande chat Kiro
> #strands migrate --from 5 --to 6

# L'orchestrateur :
# 1. Charge l'état précédent (si existe)
# 2. Vérifie les prérequis
# 3. Délègue à migration-lib
# 4. Attend la complétion
# 5. Délègue à migration-client
# 6. Valide avec audit
# 7. Sauvegarde l'état
```

### 6.2 Migration Complète (Interruption/Reprise)

```
Session 1 :
───────────────────────────────────────────────────────────
> #strands migrate --from 5 --to 20

[ORCHESTRATOR] Démarrage migration Angular 5 → 20
[ORCHESTRATOR] 15 paliers à migrer

[migration-lib] Palier 5→6 : ng update en cours...
[migration-lib] Palier 5→6 : ✅ Complété (12 min)
[migration-client] Palier 5→6 : En attente de la lib...
[migration-client] Palier 5→6 : ✅ Complété (8 min)

[ORCHESTRATOR] Checkpoint créé: "angular-6-complete"

[migration-lib] Palier 6→7 : ng update en cours...
[migration-lib] Palier 6→7 : ✅ Complété
[migration-client] Palier 6→7 : En cours...

[INTERRUPTION - Connexion perdue]

───────────────────────────────────────────────────────────
Session 2 (plus tard) :
───────────────────────────────────────────────────────────
> #strands resume

[ORCHESTRATOR] Migration en cours détectée
[ORCHESTRATOR] Dernier état: Palier 6→7 client (60% complété)
[ORCHESTRATOR] Reprise automatique...

[migration-client] Palier 6→7 : Reprise en cours...
[migration-client] Palier 6→7 : ✅ Complété

[migration-lib] Palier 7→8 : ng update en cours...
...
```

### 6.3 Rollback après Erreur

```
> #strands migrate --from 8 --to 9

[migration-lib] Palier 8→9 : ng update en cours...
[migration-lib] Palier 8→9 : ❌ ERREUR
  - ModuleWithProviders requires generic type
  - 47 fichiers affectés

[ORCHESTRATOR] Erreur détectée. Options :
  1. Corriger manuellement et reprendre
  2. Rollback au checkpoint "angular-8-complete"
  3. Abandonner

> #strands rollback --checkpoint angular-8-complete

[ORCHESTRATOR] Rollback en cours...
[ORCHESTRATOR] État restauré à Angular 8
[migration-lib] git checkout v8.0.0-ai
[migration-client] git checkout v8.0.0-ai
[ORCHESTRATOR] ✅ Rollback complété
```

---

## 7. Bonnes Pratiques

### 7.1 Checkpoints

```python
# Créer un checkpoint après chaque palier réussi
CHECKPOINT_TRIGGERS = [
    "after_major_version",  # Après 5→6, 6→7, etc.
    "before_breaking_change",  # Avant Angular 8→9 (Ivy)
    "after_dependency_update",  # Après mise à jour dépendances
]
```

### 7.2 Gestion des Erreurs

```python
ERROR_STRATEGIES = {
    "build_failure": {
        "retry": 2,
        "then": "pause_for_manual_fix"
    },
    "test_failure": {
        "retry": 1,
        "then": "continue_with_warning"
    },
    "dependency_conflict": {
        "retry": 0,
        "then": "rollback_and_notify"
    }
}
```

### 7.3 Monitoring

```python
# Métriques à suivre
METRICS = {
    "migration_duration_per_step": "histogram",
    "errors_per_step": "counter",
    "rollbacks_total": "counter",
    "state_size_bytes": "gauge"
}
```

---

## 8. Troubleshooting

### 8.1 État Corrompu

```bash
# Réinitialiser l'état
rm .kiro/state/strands-state.json

# Ou restaurer depuis backup
cp .kiro/state/strands-state.backup.json .kiro/state/strands-state.json
```

### 8.2 Agent Bloqué

```bash
# Forcer le statut d'un agent
> #strands agent-status migration-lib --set idle

# Ou via script Python
python3 -c "
from strands.state import StateManager
state = StateManager('.kiro/state/strands-state.json')
state.set('agents.migration-lib.status', 'idle')
state.save()
"
```

### 8.3 Logs de Debug

```bash
# Activer les logs détaillés
export STRANDS_LOG_LEVEL=DEBUG

# Voir les logs
tail -f .kiro/state/strands.log
```

---

## 📋 Checklist d'Installation

- [ ] Python 3.10+ installé
- [ ] `pip install strands-agents`
- [ ] Configuration `.kiro/strands/config.json`
- [ ] MCP server configuré dans `mcp.json`
- [ ] Dossier state créé : `.kiro/state/`
- [ ] Test de connexion : `python3 -c "import strands; print('OK')"`
- [ ] Premier workflow test réussi

---

*Document généré le 2026-01-29 - MODOP Strands Agent v1.0*
