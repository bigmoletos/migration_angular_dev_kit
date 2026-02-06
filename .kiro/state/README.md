# 📁 Dossier .kiro/state - État et Données Persistantes

> **Statut** : 💾 Données Persistantes  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **données d'état** persistantes pour la migration Angular et l'orchestration Strands.

⚠️ **Important** : Ces fichiers sont **modifiés automatiquement** par les agents et hooks. Ne pas éditer manuellement sauf si nécessaire.

---

## 📂 Contenu

### Fichiers d'État

| Fichier | Rôle | Modifié Par |
|---------|------|-------------|
| **strands-state.json** | État orchestration Strands | Strands MCP Server |
| **modifications-index.json** | Index des modifications | Hooks, Scripts |
| **session-state.template.json** | Template état session | Template uniquement |

---

## 📋 Détail des Fichiers

### 1. strands-state.json

**Rôle** : État de l'orchestration multi-agents avec AWS Strands SDK

**Structure** :
```json
{
  "version": "1.0.0",
  "lastUpdate": "2026-02-04T10:30:00Z",
  "currentPalier": 0,
  "migration": {
    "pwc-ui-shared": {
      "currentVersion": "5.2.0",
      "targetVersion": "20.x",
      "palierCompleted": 0,
      "status": "ready"
    },
    "pwc-ui": {
      "currentVersion": "5.2.0",
      "targetVersion": "20.x",
      "palierCompleted": 0,
      "status": "waiting"
    }
  },
  "checkpoints": [],
  "workflows": []
}
```

**Utilisé Par** :
- Strands MCP Server (`.kiro/settings/mcp.json`)
- Agents de migration
- Scripts de validation

**Modification** :
- Automatique via Strands
- Manuelle possible mais déconseillée

### 2. modifications-index.json

**Rôle** : Index de toutes les modifications de fichiers avec système de rollback

**Structure** :
```json
{
  "version": "1.0.0",
  "lastUpdate": "2026-02-04T10:30:00Z",
  "modifications": [
    {
      "id": "mod-001",
      "date": "2026-02-04T10:00:00Z",
      "author": "Kiro",
      "file": "c:/repo_hps/pwc-ui/package.json",
      "type": "modification",
      "description": "Ajout de json-ignore",
      "reason": "Dépendance manquante",
      "backup": ".kiro-backup/backup/2026-02-04/mod-001-package.json.bak",
      "rollbackCommand": "Copy-Item ...",
      "changes": [
        {
          "lineNumber": 41,
          "before": "...",
          "after": "..."
        }
      ],
      "relatedJournalEntry": "v0.4.0",
      "status": "applied"
    }
  ]
}
```

**Utilisé Par** :
- Hook `cleanup-and-journal.json`
- Scripts de rollback
- Scripts de backup

**Modification** :
- Automatique via hooks
- Scripts `scripts_outils_ia/register-modification.ps1`

### 3. session-state.template.json

**Rôle** : Template pour créer un état de session

**Structure** :
```json
{
  "sessionId": "session-YYYY-MM-DD-HH-MM",
  "startTime": "2026-02-04T10:00:00Z",
  "endTime": null,
  "palier": 0,
  "tasks": [],
  "modifications": [],
  "issues": [],
  "notes": ""
}
```

**Utilisé Par** :
- Scripts de création de session
- Agents de migration

**Modification** :
- Template uniquement, ne pas modifier

---

## 🔄 Workflow d'État

### Début de Palier

1. Strands crée un checkpoint dans `strands-state.json`
2. Session créée à partir de `session-state.template.json`
3. État initial enregistré

### Pendant le Palier

1. Chaque modification enregistrée dans `modifications-index.json`
2. État Strands mis à jour régulièrement
3. Checkpoints intermédiaires créés

### Fin de Palier

1. État final enregistré dans `strands-state.json`
2. Modifications validées dans `modifications-index.json`
3. Session fermée
4. Journal de bord mis à jour

---

## 🚀 Utilisation

### Consulter l'État Actuel

```powershell
# État Strands
Get-Content .kiro/state/strands-state.json | ConvertFrom-Json

# Index des modifications
Get-Content .kiro/state/modifications-index.json | ConvertFrom-Json
```

### Créer un Checkpoint

Via Strands MCP :
```
Crée un checkpoint avant la migration
```

### Rollback

Via l'index des modifications :
```powershell
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"
```

---

## ⚠️ Règles Importantes

### ✅ Bonnes Pratiques

- Laisser Strands gérer `strands-state.json`
- Enregistrer toutes les modifications dans `modifications-index.json`
- Créer des checkpoints avant chaque palier
- Sauvegarder régulièrement ces fichiers

### ❌ À Éviter

- Ne PAS éditer `strands-state.json` manuellement (sauf debug)
- Ne PAS supprimer des entrées de `modifications-index.json`
- Ne PAS modifier les IDs de modification
- Ne PAS oublier de créer des backups

---

## 🔍 Debugging

### État Strands Corrompu

1. Vérifier la syntaxe JSON
2. Restaurer depuis backup (`.kiro-backup/`)
3. Recréer depuis le dernier checkpoint

### Modifications Perdues

1. Consulter `.kiro-backup/backup/`
2. Vérifier les logs Git
3. Reconstruire l'index si nécessaire

---

## 📊 Métriques

### État de Migration

Consulter `strands-state.json` pour :
- Palier actuel
- Paliers complétés
- Statut des repos
- Checkpoints disponibles

### Historique des Modifications

Consulter `modifications-index.json` pour :
- Nombre de modifications
- Fichiers modifiés
- Modifications par date
- Statut des modifications

---

## 🔗 Relation avec les Autres Ressources

```
state/                  → État persistant
  ↓ utilisé par
strands/                → Configuration Strands
  ↓ orchestré par
settings/mcp.json       → Configuration MCP active
  ↓ exécute
hooks/                  → Automatisations
  ↓ met à jour
state/                  → Boucle fermée
```

---

## 📝 Notes

- Les fichiers d'état sont **critiques** pour la traçabilité
- Toujours créer un backup avant modification manuelle
- Les checkpoints Strands permettent le rollback complet
- L'index des modifications permet le rollback granulaire

---

## 🔗 Ressources

- Configuration Strands : `.kiro/strands/config.json`
- Configuration MCP : `.kiro/settings/mcp.json`
- Scripts de rollback : `scripts_outils_ia/rollback.ps1`
- Backups : `.kiro-backup/backup/`
- Journal de bord : `Documentation/JOURNAL-DE-BORD.md`
