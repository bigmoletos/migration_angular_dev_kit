# 📁 Dossier .kiro/agents - Agents Personnalisés

> **Statut** : 📝 Référence (non chargés automatiquement)  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **définitions d'agents personnalisés** pour la migration Angular.

⚠️ **Important** : Ces fichiers sont des **références** uniquement. Kiro ne les charge pas automatiquement.

---

## 📂 Contenu

### Agents Disponibles

| Agent | Rôle | Fichier |
|-------|------|---------|
| **migration-agent** | Migration incrémentale Angular | `migration-agent.md` |
| **coordinator-agent** | Coordination multi-repos | `coordinator-agent.md` |
| **audit-agent** | Audit de code et qualité | `audit-agent.md` |

### `_index.json`
Index des agents disponibles pour synchronisation automatique.

### `backup-json/`
Backup des anciennes définitions JSON (avant conversion en Markdown).

---

## 🔄 Format des Agents

Les agents sont définis en **Markdown** avec :
- Description et objectif
- Compétences (skills)
- Outils disponibles
- Workflow type
- Exemples d'utilisation

**Exemple** :
```markdown
# Migration Agent

## Objectif
Gérer la migration incrémentale Angular palier par palier.

## Skills
- angular-migration
- rxjs-patterns
- codemods-refactoring

## Workflow
1. Vérifier prérequis
2. Exécuter ng update
3. Appliquer codemods
4. Valider tests
```

---

## 🚀 Utilisation

### Référencer un Agent

Les agents ne sont **pas chargés automatiquement**. Pour les utiliser :

1. **Lire la définition** :
```
Charge le fichier .kiro/agents/migration-agent.md
```

2. **Appliquer les instructions** manuellement

3. **Ou utiliser le routage automatique** via keywords (voir `.kiro/steering/00-agent-router.md`)

---

## 🔗 Relation avec les Autres Ressources

```
agents/              → Définitions d'agents (référence)
  ↓ utilise
skills/              → Compétences techniques
  ↓ applique
steering/            → Règles et guides (chargés automatiquement)
  ↓ exécute
specs/               → Plans détaillés (chargés sur demande)
```

---

## 📝 Notes

- Les agents sont des **orchestrateurs** de skills
- Chaque agent a un domaine d'expertise spécifique
- Les agents peuvent être combinés pour des tâches complexes
- Le routage automatique (steering) remplace souvent le besoin d'agents explicites

---

## 🔗 Ressources

- Skills disponibles : `.kiro/skills/`
- Steering files : `.kiro/steering/`
- Specs : `.kiro/specs/`
- Routage automatique : `.kiro/steering/00-agent-router.md`
