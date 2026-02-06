# 📁 Dossier .kiro/strands - Configuration Strands

> **Statut** : ⚙️ Configuration Active  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient la **configuration** pour l'orchestration multi-agents avec AWS Strands Agent SDK.

✅ **Important** : Cette configuration est utilisée par le serveur MCP Strands pour orchestrer les workflows de migration.

---

## 📂 Contenu

### Fichiers de Configuration

| Fichier | Rôle | Modifié Par |
|---------|------|-------------|
| **config.json** | Configuration Strands principale | Manuelle |

---

## 📋 Détail de la Configuration

### config.json

**Rôle** : Configuration de l'orchestration Strands

**Structure** :
```json
{
  "version": "1.0.0",
  "orchestration": {
    "enabled": true,
    "statePath": "c:/repo_hps/.kiro/state/strands-state.json",
    "checkpointPath": "c:/repo_hps/.kiro-backup/checkpoints/",
    "maxConcurrentAgents": 3
  },
  "agents": {
    "migration-agent": {
      "enabled": true,
      "priority": 100,
      "skills": ["angular-migration", "rxjs-patterns", "codemods-refactoring"]
    },
    "coordinator-agent": {
      "enabled": true,
      "priority": 90,
      "skills": ["strands-orchestration"]
    },
    "audit-agent": {
      "enabled": true,
      "priority": 80,
      "skills": ["code-audit", "validation-formelle"]
    }
  },
  "workflows": {
    "palier-migration": {
      "steps": [
        "validate-prerequisites",
        "create-checkpoint",
        "migrate-shared",
        "validate-shared",
        "migrate-ui",
        "validate-ui",
        "finalize"
      ],
      "rollbackOnError": true
    }
  },
  "checkpoints": {
    "autoCreate": true,
    "retentionDays": 30,
    "maxCheckpoints": 50
  }
}
```

---

## 🔄 Intégration avec MCP

### Configuration MCP

Le serveur MCP Strands est configuré dans `.kiro/settings/mcp.json` :

```json
{
  "mcpServers": {
    "strands-orchestrator": {
      "command": "C:\\Users\\...\\uv.exe",
      "args": ["tool", "run", "strands-agents-mcp-server"],
      "env": {
        "STRANDS_CONFIG": "c:/repo_hps/.kiro/strands/config.json",
        "STRANDS_STATE_PATH": "c:/repo_hps/.kiro/state/strands-state.json",
        "STRANDS_LOG_LEVEL": "INFO"
      }
    }
  }
}
```

### Variables d'Environnement

| Variable | Valeur | Rôle |
|----------|--------|------|
| **STRANDS_CONFIG** | `.kiro/strands/config.json` | Configuration Strands |
| **STRANDS_STATE_PATH** | `.kiro/state/strands-state.json` | État persistant |
| **STRANDS_LOG_LEVEL** | INFO | Niveau de log |

---

## 🚀 Utilisation

### Démarrer un Workflow

Via le serveur MCP Strands :
```
Démarre le workflow de migration du palier 1
```

Ou directement :
```
start_workflow(workflow="palier-migration", palier=1)
```

### Créer un Checkpoint

```
Crée un checkpoint avant la migration
```

Ou :
```
create_checkpoint(name="avant-palier-1")
```

### Rollback

```
Rollback au checkpoint avant-palier-1
```

Ou :
```
rollback(checkpoint="avant-palier-1")
```

---

## ⚙️ Configuration des Agents

### Agents Disponibles

**migration-agent** :
- Priorité : 100 (la plus haute)
- Skills : angular-migration, rxjs-patterns, codemods-refactoring
- Rôle : Exécuter les migrations Angular

**coordinator-agent** :
- Priorité : 90
- Skills : strands-orchestration
- Rôle : Coordonner les agents et workflows

**audit-agent** :
- Priorité : 80
- Skills : code-audit, validation-formelle
- Rôle : Valider la qualité du code

### Modifier la Configuration

Éditer `.kiro/strands/config.json` :

```json
{
  "agents": {
    "mon-agent": {
      "enabled": true,
      "priority": 85,
      "skills": ["mon-skill"]
    }
  }
}
```

Puis redémarrer le serveur MCP Strands.

---

## 🔄 Workflows

### Workflow de Migration

**Étapes** :
1. `validate-prerequisites` : Vérifier Node.js, npm, etc.
2. `create-checkpoint` : Créer un point de sauvegarde
3. `migrate-shared` : Migrer pwc-ui-shared
4. `validate-shared` : Valider (build + tests)
5. `migrate-ui` : Migrer pwc-ui
6. `validate-ui` : Valider (build + tests)
7. `finalize` : Finaliser et documenter

**Rollback** : Automatique en cas d'erreur

### Créer un Workflow Personnalisé

Éditer `.kiro/strands/config.json` :

```json
{
  "workflows": {
    "mon-workflow": {
      "steps": [
        "step1",
        "step2",
        "step3"
      ],
      "rollbackOnError": true
    }
  }
}
```

---

## 📊 Checkpoints

### Configuration

```json
{
  "checkpoints": {
    "autoCreate": true,           // Créer automatiquement
    "retentionDays": 30,          // Conserver 30 jours
    "maxCheckpoints": 50          // Maximum 50 checkpoints
  }
}
```

### Emplacement

Les checkpoints sont stockés dans :
```
.kiro-backup/checkpoints/
├── checkpoint-2026-02-04-avant-palier-1/
├── checkpoint-2026-02-05-apres-palier-1/
└── ...
```

### Gestion

```powershell
# Lister les checkpoints
Get-ChildItem .kiro-backup/checkpoints/

# Supprimer les checkpoints anciens (>30 jours)
Get-ChildItem .kiro-backup/checkpoints/ | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Recurse
```

---

## ⚠️ Règles Importantes

### ✅ Bonnes Pratiques

- Créer un checkpoint avant chaque palier
- Tester les workflows avant utilisation en production
- Conserver les checkpoints importants
- Documenter les modifications de configuration

### ❌ À Éviter

- Ne PAS supprimer les checkpoints récents
- Ne PAS modifier la configuration pendant un workflow actif
- Ne PAS désactiver le rollback automatique
- Ne PAS oublier de redémarrer le serveur MCP après modification

---

## 🔍 Debugging

### Serveur MCP Ne Démarre Pas

1. Vérifier que `uv` est installé : `uv --version`
2. Vérifier que `strands-agents-mcp-server` est installé
3. Vérifier les chemins dans `.kiro/settings/mcp.json`
4. Consulter les logs Kiro

### Workflow Échoue

1. Consulter `.kiro/state/strands-state.json`
2. Vérifier les logs du serveur MCP
3. Vérifier que les agents sont activés
4. Tester chaque étape manuellement

### Checkpoint Non Créé

1. Vérifier que `autoCreate: true`
2. Vérifier les permissions sur `.kiro-backup/checkpoints/`
3. Vérifier l'espace disque disponible
4. Consulter les logs

---

## 📝 Notes

- Strands permet l'orchestration **stateful** des workflows
- Les checkpoints permettent le **rollback complet** d'un palier
- Les agents peuvent être **activés/désactivés** dynamiquement
- La configuration est **rechargée** au démarrage du serveur MCP

---

## 🔗 Ressources

- Configuration MCP : `.kiro/settings/mcp.json`
- État Strands : `.kiro/state/strands-state.json`
- Checkpoints : `.kiro-backup/checkpoints/`
- Wrapper MCP : `.kiro/scripts/strands-mcp-wrapper.py`
- Documentation Strands : https://github.com/awslabs/strands-agents
