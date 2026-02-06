# 📁 Dossier backup-json - Backup Agents JSON

> **Statut** : 📦 Archive  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **backups des anciennes définitions JSON** des agents avant leur conversion en Markdown.

⚠️ **Important** : Ces fichiers sont des **archives** uniquement. Ne pas utiliser.

---

## 📂 Contenu

### Fichiers Archivés

| Fichier | Agent | Date Conversion |
|---------|-------|-----------------|
| `migration-agent.json` | Agent de migration | 2026-02-04 |
| `coordinator-agent.json` | Agent coordinateur | 2026-02-04 |
| `audit-agent.json` | Agent d'audit | 2026-02-04 |
| `_index.json` | Index des agents | 2026-02-04 |

---

## 🔄 Historique

### Conversion JSON → Markdown

Les agents ont été convertis de JSON vers Markdown pour :
- Meilleure lisibilité
- Facilité d'édition
- Compatibilité avec le système de steering Kiro
- Documentation plus riche

**Avant (JSON)** :
```json
{
  "name": "migration-agent",
  "skills": ["angular-migration", "rxjs-patterns"],
  "description": "..."
}
```

**Après (Markdown)** :
```markdown
# Migration Agent

## Objectif
Gérer la migration incrémentale Angular.

## Skills
- angular-migration
- rxjs-patterns
```

---

## 📝 Notes

- Ces fichiers sont conservés pour référence historique
- Les agents actifs sont maintenant en Markdown dans `.kiro/agents/`
- Ne pas modifier ces fichiers
- Peuvent être supprimés après validation complète du système

---

## 🔗 Ressources

- Agents actifs : `.kiro/agents/*.md`
- Index des agents : `.kiro/agents/_index.json`
