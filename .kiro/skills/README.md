# 📁 Dossier .kiro/skills - Compétences Techniques

> **Statut** : 📝 Référence (non chargés automatiquement)  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **skills (compétences techniques)** spécialisées pour la migration Angular.

⚠️ **Important** : Ces fichiers sont des **références** uniquement. Kiro ne les charge pas automatiquement.

---

## 📂 Contenu

### Skills Disponibles

| Skill | Domaine | Dossier |
|-------|---------|---------|
| **angular-migration** | Migration Angular incrémentale | `angular-migration/` |
| **rxjs-patterns** | Patterns RxJS et migration | `rxjs-patterns/` |
| **codemods-refactoring** | Codemods et refactoring automatique | `codemods-refactoring/` |
| **code-audit** | Audit de code et qualité | `code-audit/` |
| **strands-orchestration** | Orchestration multi-agents | `strands-orchestration/` |
| **validation-formelle** | Validation et tests | `validation-formelle/` |

### `_index.json`
Index des skills disponibles pour synchronisation automatique.

---

## 🔄 Format des Skills

Chaque skill contient un fichier `SKILL.md` avec :
- Description et objectif
- Prérequis
- Commandes et outils
- Patterns et exemples
- Bonnes pratiques

**Exemple** :
```markdown
# Skill: Angular Migration

## Objectif
Gérer la migration incrémentale d'Angular version par version.

## Prérequis
- Node.js version appropriée
- Angular CLI installé
- Tests passants

## Commandes
- `ng update @angular/cli@X @angular/core@X`
- `npm run build`
- `npm test`

## Patterns
- Toujours migrer pwc-ui-shared AVANT pwc-ui
- Utiliser --dry-run avant migration
- Valider avec tests après chaque palier
```

---

## 🚀 Utilisation

### Référencer un Skill

Les skills ne sont **pas chargés automatiquement**. Pour les utiliser :

1. **Lire la définition** :
```
Charge le fichier .kiro/skills/angular-migration/SKILL.md
```

2. **Appliquer les patterns** décrits

3. **Ou utiliser le routage automatique** via keywords (voir `.kiro/steering/00-agent-router.md`)

---

## 🔗 Relation avec les Autres Ressources

```
skills/              → Compétences techniques (référence)
  ↓ appliquées par
agents/              → Agents orchestrateurs
  ↓ suivent
steering/            → Règles et guides (chargés automatiquement)
  ↓ exécutent
specs/               → Plans détaillés (chargés sur demande)
```

---

## 📊 Matrice Skills vs Paliers

| Skill | Paliers | Criticité |
|-------|---------|-----------|
| **angular-migration** | Tous | ⭐⭐⭐ |
| **rxjs-patterns** | 1-2 | ⭐⭐⭐ |
| **codemods-refactoring** | 1-15 | ⭐⭐ |
| **code-audit** | Tous | ⭐⭐ |
| **strands-orchestration** | Tous | ⭐ |
| **validation-formelle** | Tous | ⭐⭐ |

---

## 📝 Notes

- Les skills sont des **compétences atomiques** réutilisables
- Chaque skill est indépendant et peut être combiné
- Les steering files (`.kiro/steering/`) contiennent souvent les mêmes informations mais sont chargés automatiquement
- Préférer les steering files pour les règles critiques

---

## 🔗 Ressources

- Agents disponibles : `.kiro/agents/`
- Steering files : `.kiro/steering/`
- Specs : `.kiro/specs/`
- Routage automatique : `.kiro/steering/00-agent-router.md`
