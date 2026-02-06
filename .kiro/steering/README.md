# 📁 Dossier .kiro/steering - Règles et Guides

> **Statut** : ✅ Chargés Automatiquement  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **règles et guides** qui sont **chargés automatiquement** par Kiro selon le contexte.

✅ **Important** : Ces fichiers sont inclus automatiquement dans le contexte Kiro via le système de steering.

---

## 📂 Contenu

### Steering Files Disponibles

| Fichier | Sujet | Priorité | Chargement |
|---------|-------|----------|------------|
| **00-agent-router.md** | Routage intelligent | 100 | Toujours |
| **01-project-overview.md** | Vue d'ensemble projet | 95 | Toujours |
| **02-migration-angular-rules.md** | Règles migration Angular | 95 | Auto (keywords) |
| **03-rxjs-migration-patterns.md** | Patterns RxJS | 90 | Auto (keywords) |
| **04-ivy-migration-guide.md** | Guide migration Ivy | 85 | Auto (keywords) |
| **05-webpack-custom-migration.md** | Migration Webpack custom | 85 | Auto (keywords) |
| **06-testing-strategy.md** | Stratégie de tests | 80 | Auto (keywords) |
| **07-typescript-migration.md** | Migration TypeScript | 80 | Auto (keywords) |
| **08-workspace-hygiene.md** | Hygiène du workspace | 90 | Toujours |
| **09-version-management.md** | Gestion versions Node | 90 | Auto (keywords) |
| **10-local-dev-config.md** | Config développement local | 75 | Sur demande |
| **11-playwright-e2e-testing.md** | Tests E2E Playwright | 75 | Auto (keywords) |
| **12-modification-rules.md** | Règles de modification | 95 | Toujours |
| **13-versioning-rules.md** | Règles de versioning | 95 | Toujours |

### `_index.json`
Index des steering files pour synchronisation automatique.

---

## 🔄 Système de Chargement

### Chargement Automatique

Les steering files sont chargés selon 3 modes :

**1. Toujours (inclusion: always)** :
- Chargés dans chaque session Kiro
- Exemples : `00-agent-router.md`, `01-project-overview.md`, `08-workspace-hygiene.md`

**2. Par Keywords (inclusion: auto)** :
- Chargés automatiquement quand des keywords sont détectés
- Exemples : `migration`, `angular`, `rxjs`, `test`, `audit`

**3. Sur Demande (inclusion: manual)** :
- Chargés uniquement si référencés explicitement
- Exemples : `10-local-dev-config.md`

### Front Matter

Chaque steering file a un front matter YAML :
```yaml
---
inclusion: always|auto|manual
priority: 95
keywords: ["migration", "angular", "upgrade"]
---
```

---

## 🚀 Utilisation

### Chargement Automatique (Recommandé)

Utilisez simplement des **keywords** dans votre prompt :

```
Migrer Angular 5 vers 6
→ Charge automatiquement 02-migration-angular-rules.md

Problème avec RxJS
→ Charge automatiquement 03-rxjs-migration-patterns.md

Auditer le code
→ Charge automatiquement 06-testing-strategy.md
```

### Chargement Manuel

Pour forcer le chargement :
```
Charge le steering file 10-local-dev-config
```

Ou avec le chemin complet :
```
Charge .kiro/steering/10-local-dev-config.md
```

---

## 📋 Règles Critiques

### 🔴 RÈGLE D'OR : Ordre de Migration

```
pwc-ui-shared-v4-ia (lib)  →  pwc-ui-v4-ia (client)
       MIGRER AVANT               MIGRER APRÈS
```

**Source** : `01-project-overview.md`, `02-migration-angular-rules.md`

### ⚠️ Règles de Modification

- ❌ Ne JAMAIS supprimer de lignes sans commentaire
- ✅ Toujours commenter les modifications
- ✅ Enregistrer dans `.kiro/state/modifications-index.json`
- ✅ Créer un backup avant modification

**Source** : `12-modification-rules.md`

### 📝 Règles de Versioning

- ✅ Incrémenter la version à chaque modification
- ✅ Mettre à jour la date
- ✅ Ajouter une entrée dans le changelog
- ✅ Format : MAJOR.MINOR.PATCH

**Source** : `13-versioning-rules.md`

### 🧹 Hygiène du Workspace

- ✅ Utiliser `.kiro/temp/` pour les fichiers temporaires
- ❌ Ne JAMAIS créer de fichiers de test dans les repos
- ✅ Nettoyer automatiquement après usage
- ✅ Mettre à jour le journal de bord

**Source** : `08-workspace-hygiene.md`

---

## 🔗 Relation avec les Autres Ressources

```
steering/            → Règles générales (chargées automatiquement)
  ↓ complétées par
specs/               → Plans détaillés (chargés sur demande)
  ↓ référencent
agents/              → Agents orchestrateurs (référence)
  ↓ utilisent
skills/              → Compétences techniques (référence)
```

---

## 📊 Matrice Steering vs Paliers

| Steering File | Paliers | Toujours Chargé |
|---------------|---------|-----------------|
| 00-agent-router | Tous | ✅ |
| 01-project-overview | Tous | ✅ |
| 02-migration-angular-rules | Tous | ❌ (auto) |
| 03-rxjs-migration-patterns | 1-2 | ❌ (auto) |
| 04-ivy-migration-guide | 4 | ❌ (auto) |
| 05-webpack-custom-migration | 7 | ❌ (auto) |
| 06-testing-strategy | Tous | ❌ (auto) |
| 08-workspace-hygiene | Tous | ✅ |
| 09-version-management | Tous | ❌ (auto) |
| 12-modification-rules | Tous | ✅ |
| 13-versioning-rules | Tous | ✅ |

---

## 📝 Notes

- Les steering files sont la **source de vérité** pour les règles
- Ils sont **toujours à jour** et versionnés
- Préférer les steering files aux specs pour les règles générales
- Budget contexte : **15% maximum** pour les steering files

---

## 🔗 Ressources

- Specs détaillées : `.kiro/specs/`
- État de migration : `.kiro/state/strands-state.json`
- Hooks automatiques : `.kiro/hooks/`
- Guide principal : `.kiro/START-HERE.md`
