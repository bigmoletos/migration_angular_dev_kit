---
inclusion: manual
---

# Guide d'Utilisation des Ressources Personnalisées

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04  
> **Auteur** : Kiro  

---

## 🎯 Objectif

Ce guide explique comment utiliser les agents, skills et specs personnalisés dans Kiro.

---

## 📂 Structure des Ressources

```
.kiro/
├── agents/
│   ├── _index.json              # Index des agents (v2.0, format MD)
│   ├── README.md                # Documentation agents
│   ├── coordinator-agent.md     # Agent coordinateur (Strands ✅)
│   ├── migration-agent.md       # Agent migration (Strands ✅)
│   ├── audit-agent.md           # Agent audit (Strands ✅)
│   └── backup-json/             # Backup JSON originaux
│
├── skills/
│   ├── _index.json              # Index des skills (référence)
│   ├── angular-migration/       # Skill migration Angular
│   ├── codemods-refactoring/    # Skill codemods
│   ├── rxjs-patterns/           # Skill RxJS
│   └── code-audit/              # Skill audit
│
├── specs/
│   ├── _index.json              # Index des specs
│   ├── 00-resume-executif.md   # Résumé exécutif
│   ├── 02-plan-migration.md    # Plan de migration
│   └── ...                      # Autres specs
│
└── steering/
    ├── 00-agent-router.md       # Routeur intelligent (NOUVEAU)
    ├── 01-project-overview.md   # Vue d'ensemble
    ├── 02-migration-angular-rules.md
    └── ...                      # Autres règles
```

---

## 🔄 Comment Kiro Charge les Ressources

### 1. Steering Files (Automatique)

Les fichiers dans `.kiro/steering/` avec `inclusion: always` sont chargés automatiquement.

**Exemple** :
```markdown
---
inclusion: always
priority: 95
---

# Règles de Migration Angular
...
```

### 2. Specs (Sur Demande)

Les specs dans `.kiro/specs/` sont chargées uniquement quand vous les demandez explicitement.

**Commandes** :
```
Charge la spec 02-plan-migration
Montre-moi le plan de migration
Exécute la spec 04-palier-01-angular-5-to-6
```

### 3. Agents et Skills (Référence)

Les agents et skills JSON sont des **références** uniquement. Kiro ne les charge pas directement.

**Pour les utiliser** :
1. Créer un steering file correspondant
2. Référencer les informations de l'agent/skill
3. Kiro utilisera le steering file

---

## 🔀 Routage Intelligent

Le fichier `.kiro/steering/00-agent-router.md` route automatiquement vers les bonnes ressources selon vos keywords.

### Exemples

| Prompt | Keywords Détectés | Ressources Chargées |
|--------|-------------------|---------------------|
| "Migrer Angular 5 vers 6" | `migration`, `angular` | `02-migration-angular-rules.md` + `02-plan-migration.md` |
| "Audit du code TypeScript" | `audit`, `code` | `06-testing-strategy.md` |
| "Coordonner les deux repos" | `coordinate`, `repos` | `01-project-overview.md` |

---

## 📝 Comment Créer un Nouveau Steering File

### Étape 1 : Créer le Fichier

```markdown
---
inclusion: always
priority: 80
---

# Mon Nouveau Guide

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04  
> **Auteur** : Kiro  

---

## Contenu du guide...
```

### Étape 2 : Ajouter au Router

Modifier `.kiro/steering/00-agent-router.md` pour ajouter les keywords de routage.

### Étape 3 : Tester

```
Applique les règles de [nom du guide]
```

---

## 🔗 Conversion Agent JSON → Steering File

Si vous avez un agent JSON comme `coordinator-agent.json`, voici comment le convertir :

### Agent JSON (Ancien Format)
```json
{
  "name": "coordinator-agent",
  "systemPrompt": "Tu es l'agent coordinateur...",
  "delegationRules": [...]
}
```

### Steering File (Nouveau Format)
```markdown
---
inclusion: always
priority: 100
---

# Agent Coordinateur

Tu es l'agent coordinateur du workspace repo_hps.

## Règles de Délégation

- Migration → Charger `02-migration-angular-rules.md`
- Audit → Charger `06-testing-strategy.md`
```

---

## 🎯 Workflow Recommandé

### Pour une Migration Angular

1. **Demander** : "Migrer Angular 5 vers 6"
2. **Kiro charge automatiquement** :
   - `00-agent-router.md` (routage)
   - `02-migration-angular-rules.md` (règles)
   - `02-plan-migration.md` (plan)
3. **Kiro exécute** la migration selon les règles

### Pour un Audit

1. **Demander** : "Auditer le code de pwc-ui-shared"
2. **Kiro charge automatiquement** :
   - `00-agent-router.md` (routage)
   - `06-testing-strategy.md` (stratégie)
3. **Kiro exécute** l'audit

---

## ⚠️ Limitations

### Ce qui NE fonctionne PAS

- ❌ Charger directement un agent JSON : `Utilise coordinator-agent.json`
- ❌ Charger directement un skill JSON : `Utilise angular-migration skill`

### Ce qui FONCTIONNE

- ✅ Utiliser des keywords : `Migrer Angular`
- ✅ Charger une spec : `Charge la spec 02-plan-migration`
- ✅ Référencer un steering file : `Applique les règles de migration`

---

## 📊 Métriques de Contexte

Kiro surveille l'utilisation du contexte :

| Ressource | Budget Max | Actuel |
|-----------|------------|--------|
| Steering files | 15% | Variable |
| Specs | 10% | Variable |
| Conversation | 75% | Variable |

Si le contexte dépasse 70%, Kiro décharge automatiquement les ressources inutilisées.

---

## 🔗 Ressources

- Router : `.kiro/steering/00-agent-router.md`
- Index agents : `.kiro/agents/_index.json`
- Index skills : `.kiro/skills/_index.json`
- Index specs : `.kiro/specs/_index.json`

---

## 📝 Notes

- Les agents et skills JSON restent utiles comme **documentation**
- Kiro utilise les **steering files** pour les instructions réelles
- Le routage est **automatique** via keywords
- Les specs sont chargées **sur demande explicite**
