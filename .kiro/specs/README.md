# 📁 Dossier .kiro/specs - Spécifications de Migration

> **Statut** : 📋 Spécifications (chargées sur demande)  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **spécifications détaillées** pour la migration Angular 5 → 20.

⚠️ **Important** : Les specs sont chargées **sur demande explicite** uniquement (pas automatiquement).

---

## 📂 Structure

### Specs Globales (Markdown)

| Spec | Description | Fichier |
|------|-------------|---------|
| **00-resume-executif** | Vue d'ensemble du projet | `00-resume-executif.md` |
| **01-etat-actuel** | État actuel des repos | `01-etat-actuel.md` |
| **02-plan-migration** | Plan complet 15 paliers | `02-plan-migration.md` |
| **03-risques-identifies** | Risques et mitigations | `03-risques-identifies.md` |
| **04-palier-01** | Palier 1 : Angular 5→6 | `04-palier-01-angular-5-to-6.md` |

### Specs Détaillées (Dossiers)

Chaque palier critique a un dossier avec 3 fichiers :
```
XX-palier-YY-description/
├── requirements.md    # Exigences et prérequis
├── design.md          # Design et approche technique
└── tasks.md           # Tâches détaillées
```

**Paliers avec specs détaillées** :
- `00-palier-00-validation-infrastructure/` - Validation initiale
- `04-palier-01-angular-5-to-6/` - Premier palier (RxJS)
- `05-palier-04-angular-8-to-9-ivy/` - Migration Ivy
- `06-palier-07-angular-11-to-12-webpack5/` - Webpack 5
- `07-palier-11-angular-15-to-16-signals/` - Signals
- `08-palier-12-angular-16-to-17-control-flow/` - Control Flow
- `09-palier-15-angular-19-to-20-final/` - Finalisation
- `10-workflow-tests-playwright/` - Tests E2E

### `_index.json`
Index des specs disponibles pour synchronisation automatique.

---

## 🚀 Utilisation

### Charger une Spec Globale

```
Charge la spec 02-plan-migration
```

Ou avec le chemin complet :
```
Charge le fichier .kiro/specs/02-plan-migration.md
```

### Charger une Spec Détaillée

Pour un palier spécifique :
```
Charge les specs du palier 1
```

Ou fichier par fichier :
```
Charge .kiro/specs/04-palier-01-angular-5-to-6/requirements.md
Charge .kiro/specs/04-palier-01-angular-5-to-6/design.md
Charge .kiro/specs/04-palier-01-angular-5-to-6/tasks.md
```

---

## 📋 Format des Specs

### Format Kiro (Dossiers)

Chaque spec détaillée suit le format Kiro :

**`requirements.md`** :
- Objectifs
- Prérequis
- Contraintes
- Critères de succès

**`design.md`** :
- Approche technique
- Architecture
- Décisions de design
- Alternatives considérées

**`tasks.md`** :
- Liste des tâches
- Ordre d'exécution
- Estimation temps
- Dépendances

### Format Markdown (Fichiers)

Les specs globales sont en Markdown simple avec :
- Vue d'ensemble
- Détails techniques
- Exemples de code
- Références

---

## 🔄 Workflow Recommandé

### Avant de Commencer un Palier

1. **Charger le plan global** :
```
Charge .kiro/specs/02-plan-migration.md
```

2. **Charger la spec du palier** :
```
Charge les specs du palier 1
```

3. **Lire les steering files** (chargés automatiquement) :
   - `.kiro/steering/02-migration-angular-rules.md`
   - `.kiro/steering/09-version-management.md`

### Pendant le Palier

- Suivre les tâches dans `tasks.md`
- Référencer `design.md` pour les décisions techniques
- Vérifier `requirements.md` pour les critères de succès

### Après le Palier

- Mettre à jour `.kiro/state/strands-state.json`
- Documenter dans le journal de bord
- Passer au palier suivant

---

## 📊 Paliers de Migration

| Palier | Angular | Node | Spec Détaillée | Criticité |
|--------|---------|------|----------------|-----------|
| 0 | Validation | - | ✅ | ⭐⭐⭐ |
| 1 | 5→6 | v10 | ✅ | ⭐⭐⭐ |
| 2 | 6→7 | v10 | ❌ | ⭐ |
| 3 | 7→8 | v10 | ❌ | ⭐ |
| 4 | 8→9 (Ivy) | v10 | ✅ | ⭐⭐⭐ |
| 5 | 9→10 | v12 | ❌ | ⭐ |
| 6 | 10→11 | v12 | ❌ | ⭐ |
| 7 | 11→12 (Webpack5) | v12 | ✅ | ⭐⭐⭐ |
| 8 | 12→13 | v14 | ❌ | ⭐ |
| 9 | 13→14 | v16 | ❌ | ⭐ |
| 10 | 14→15 | v16 | ❌ | ⭐ |
| 11 | 15→16 (Signals) | v18 | ✅ | ⭐⭐ |
| 12 | 16→17 (Control Flow) | v18 | ✅ | ⭐⭐ |
| 13 | 17→18 | v18 | ❌ | ⭐ |
| 14 | 18→19 | v20 | ❌ | ⭐ |
| 15 | 19→20 | v22 | ✅ | ⭐⭐ |

---

## 📝 Notes

- Les specs sont **complémentaires** aux steering files
- Steering files = règles générales (chargées automatiquement)
- Specs = plans détaillés (chargées sur demande)
- Toujours charger la spec AVANT de commencer un palier
- Budget contexte : **1 spec à la fois maximum**

---

## 🔗 Ressources

- Steering files : `.kiro/steering/`
- État de migration : `.kiro/state/strands-state.json`
- Routage automatique : `.kiro/steering/00-agent-router.md`
- Guide principal : `.kiro/START-HERE.md`
