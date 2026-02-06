# 📁 Dossier .kiro/scripts - Scripts Utilitaires

> **Statut** : 🔧 Scripts Actifs  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **scripts utilitaires** pour la synchronisation des index et l'orchestration Strands.

✅ **Important** : Ces scripts sont exécutés automatiquement par les hooks ou manuellement selon les besoins.

---

## 📂 Contenu

### Scripts Disponibles

| Script | Langage | Rôle | Exécution |
|--------|---------|------|-----------|
| **sync-all.bat** | Batch | Synchronise tous les index | Manuelle/Hook |
| **sync-all-indexes.js** | Node.js | Synchronise tous les index | Appelé par sync-all.bat |
| **sync-specs-index.js** | Node.js | Synchronise l'index des specs | Appelé par sync-all-indexes.js |
| **sync-steering-index.js** | Node.js | Synchronise l'index des steering | Appelé par sync-all-indexes.js |
| **strands-mcp-wrapper.py** | Python | Wrapper MCP pour Strands | Appelé par MCP |

---

## 📋 Détail des Scripts

### 1. sync-all.bat

**Rôle** : Point d'entrée pour synchroniser tous les index

**Usage** :
```powershell
C:\repo_hps\.kiro\scripts\sync-all.bat
```

**Comportement** :
1. Vérifie que Node.js est installé
2. Exécute `sync-all-indexes.js`
3. Affiche le résultat

**Appelé Par** :
- Hook `sync-kiro-indexes.json` (fin de session)
- Manuellement par l'utilisateur

### 2. sync-all-indexes.js

**Rôle** : Orchestrateur de synchronisation

**Usage** :
```powershell
node .kiro/scripts/sync-all-indexes.js
```

**Comportement** :
1. Exécute `sync-specs-index.js`
2. Exécute `sync-steering-index.js`
3. Exécute `sync-agents-index.js` (si existe)
4. Exécute `sync-skills-index.js` (si existe)
5. Affiche un résumé

**Sortie** :
```
✅ Synchronisation des index Kiro
  ✓ Specs : 15 fichiers indexés
  ✓ Steering : 14 fichiers indexés
  ✓ Agents : 3 fichiers indexés
  ✓ Skills : 6 fichiers indexés
✅ Synchronisation terminée
```

### 3. sync-specs-index.js

**Rôle** : Synchronise l'index des spécifications

**Usage** :
```powershell
node .kiro/scripts/sync-specs-index.js
```

**Comportement** :
1. Scanne le dossier `.kiro/specs/`
2. Détecte tous les fichiers `.md` et dossiers
3. Extrait les métadonnées (titre, description, version)
4. Met à jour `.kiro/specs/_index.json`

**Format de l'index** :
```json
{
  "version": "1.0.0",
  "lastUpdate": "2026-02-04T10:30:00Z",
  "specs": [
    {
      "id": "02-plan-migration",
      "title": "Plan de Migration Angular 5→20",
      "path": "02-plan-migration.md",
      "type": "global",
      "priority": 100
    },
    {
      "id": "04-palier-01-angular-5-to-6",
      "title": "Palier 1 : Angular 5→6",
      "path": "04-palier-01-angular-5-to-6/",
      "type": "detailed",
      "priority": 90
    }
  ]
}
```

### 4. sync-steering-index.js

**Rôle** : Synchronise l'index des steering files

**Usage** :
```powershell
node .kiro/scripts/sync-steering-index.js
```

**Comportement** :
1. Scanne le dossier `.kiro/steering/`
2. Détecte tous les fichiers `.md`
3. Extrait le front matter YAML (inclusion, priority, keywords)
4. Met à jour `.kiro/steering/_index.json`

**Format de l'index** :
```json
{
  "version": "1.0.0",
  "lastUpdate": "2026-02-04T10:30:00Z",
  "steering": [
    {
      "id": "02-migration-angular-rules",
      "title": "Règles de Migration Angular",
      "path": "02-migration-angular-rules.md",
      "inclusion": "auto",
      "priority": 95,
      "keywords": ["migration", "angular", "upgrade"]
    }
  ]
}
```

### 5. strands-mcp-wrapper.py

**Rôle** : Wrapper Python pour le serveur MCP Strands

**Usage** : Appelé automatiquement par la configuration MCP

**Comportement** :
1. Charge la configuration Strands (`.kiro/strands/config.json`)
2. Initialise le serveur MCP
3. Expose les outils Strands (start_workflow, create_checkpoint, etc.)
4. Gère l'état dans `.kiro/state/strands-state.json`

**Configuration** :
Voir `.kiro/settings/mcp.json` :
```json
{
  "mcpServers": {
    "strands-orchestrator": {
      "command": "uv.exe",
      "args": ["tool", "run", "strands-agents-mcp-server"],
      "env": {
        "STRANDS_CONFIG": "c:/repo_hps/.kiro/strands/config.json",
        "STRANDS_STATE_PATH": "c:/repo_hps/.kiro/state/strands-state.json"
      }
    }
  }
}
```

---

## 🚀 Utilisation

### Synchronisation Manuelle

```powershell
# Synchroniser tous les index
C:\repo_hps\.kiro\scripts\sync-all.bat

# Ou directement avec Node.js
node .kiro/scripts/sync-all-indexes.js

# Synchroniser uniquement les specs
node .kiro/scripts/sync-specs-index.js

# Synchroniser uniquement les steering
node .kiro/scripts/sync-steering-index.js
```

### Synchronisation Automatique

La synchronisation est déclenchée automatiquement par le hook `sync-kiro-indexes.json` en fin de session.

---

## ⚠️ Règles Importantes

### ✅ Bonnes Pratiques

- Exécuter `sync-all.bat` après ajout/modification de specs ou steering
- Vérifier que Node.js est installé avant exécution
- Consulter les index générés pour vérifier la synchronisation
- Commiter les index après synchronisation

### ❌ À Éviter

- Ne PAS éditer les fichiers `_index.json` manuellement
- Ne PAS supprimer les scripts (utilisés par les hooks)
- Ne PAS modifier les scripts sans tester
- Ne PAS oublier de synchroniser après modifications

---

## 🔍 Debugging

### Script Échoue

1. Vérifier que Node.js est installé : `node --version`
2. Vérifier les permissions d'exécution
3. Exécuter manuellement pour voir les erreurs
4. Consulter les logs

### Index Non Mis à Jour

1. Exécuter manuellement `sync-all.bat`
2. Vérifier que les fichiers existent
3. Vérifier le format des fichiers (front matter YAML)
4. Consulter les erreurs dans la console

---

## 📊 Métriques

### Fichiers Indexés

Consulter les index pour voir le nombre de fichiers :
```powershell
# Specs
(Get-Content .kiro/specs/_index.json | ConvertFrom-Json).specs.Count

# Steering
(Get-Content .kiro/steering/_index.json | ConvertFrom-Json).steering.Count
```

### Dernière Synchronisation

Consulter le champ `lastUpdate` dans les index :
```powershell
(Get-Content .kiro/specs/_index.json | ConvertFrom-Json).lastUpdate
```

---

## 📝 Notes

- Les scripts sont **essentiels** pour le routage automatique
- La synchronisation garantit que Kiro voit tous les fichiers
- Les index sont utilisés par le système de steering
- Les scripts Python nécessitent `uv` et `strands-agents-mcp-server`

---

## 🔗 Ressources

- Hook de synchronisation : `.kiro/hooks/sync-kiro-indexes.json`
- Index des specs : `.kiro/specs/_index.json`
- Index des steering : `.kiro/steering/_index.json`
- Configuration Strands : `.kiro/strands/config.json`
- Configuration MCP : `.kiro/settings/mcp.json`
