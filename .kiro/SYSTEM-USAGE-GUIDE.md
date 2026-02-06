# Guide d'Utilisation du Système Kiro

> **Version** : 1.0.0  
> **Date** : 2026-02-04  
> **Statut** : ✅ Système opérationnel

---

## 🎯 Pourquoi les Steering Apparaissent et Pas les Autres ?

### Steering Rules ✅ (Automatiques)

Les **steering rules** apparaissent automatiquement dans vos prompts car elles utilisent le **mécanisme natif de Kiro** :

```
<steering-reminder>
AGENTS.md:
# AGENTS.md - Routeur Intelligent
...

01-project-overview.md:
# 01 - Vue d'Ensemble du Projet de Migration
...
</steering-reminder>
```

**Pourquoi ?**
- Kiro charge automatiquement les fichiers du dossier `.kiro/steering/`
- Ils sont injectés dans le contexte de chaque conversation
- Vous n'avez rien à faire, ils sont toujours présents

### Agents, Skills, Specs, Hooks ⚠️ (Explicites)

Les **agents, skills, specs et hooks** n'apparaissent PAS automatiquement car ce sont des **conventions personnalisées** du projet, pas des fonctionnalités natives de Kiro.

**Pourquoi ?**
- Kiro ne les charge pas automatiquement pour économiser le contexte
- Vous devez les référencer explicitement quand vous en avez besoin
- C'est **par design** pour optimiser l'utilisation du contexte

---

## 📋 Comment Utiliser Chaque Composant

### 1. Steering Rules (Automatique) ✅

**Rien à faire !** Elles sont toujours chargées.

Vous pouvez les voir dans les `<steering-reminder>` de vos prompts.

**Fichiers actifs** :
- `01-project-overview.md` : Vue d'ensemble du projet
- `02-migration-angular-rules.md` : Règles de migration
- `12-modification-rules.md` : Règles de modification
- `13-versioning-rules.md` : Règles de versioning
- Et 9 autres...

---

### 2. Specs (Chargement Manuel) 📋

Les **specs** sont des plans de migration détaillés. Vous devez les charger explicitement.

#### Comment Charger une Spec

**Méthode 1 : Commande naturelle**
```
Charge la spec 04-palier-01-angular-5-to-6
```

**Méthode 2 : Syntaxe #file**
```
#file:.kiro/specs/04-palier-01-angular-5-to-6.md
```

**Méthode 3 : Commande explicite**
```
Charge le fichier .kiro/specs/04-palier-01-angular-5-to-6.md
```

#### Specs Disponibles

| Spec | Description |
|------|-------------|
| `00-resume-executif.md` | Résumé exécutif de la migration |
| `02-plan-migration.md` | Plan global des 15 paliers |
| `04-palier-01-angular-5-to-6.md` | Palier 1 : Angular 5 → 6 |
| `05-palier-04-angular-8-to-9-ivy.md` | Palier 4 : Angular 8 → 9 (Ivy) |
| `06-palier-07-angular-11-to-12-webpack5.md` | Palier 7 : Angular 11 → 12 (Webpack 5) |
| `07-palier-11-angular-15-to-16-signals.md` | Palier 11 : Angular 15 → 16 (Signals) |
| `08-palier-12-angular-16-to-17-control-flow.md` | Palier 12 : Angular 16 → 17 (Control Flow) |
| `09-palier-15-angular-19-to-20-final.md` | Palier 15 : Angular 19 → 20 (Final) |
| `10-workflow-tests-playwright.md` | Workflow de tests Playwright |

---

### 3. Skills (Activation par Keywords) 🎓

Les **skills** sont des compétences spécialisées qui se chargent automatiquement quand vous mentionnez certains mots-clés.

#### Comment Activer un Skill

**Méthode 1 : Keywords dans le prompt (Automatique)**

Mentionnez simplement les mots-clés dans votre prompt :

```
Je veux migrer angular de la version 5 à 6
```
→ Active automatiquement le skill `angular-migration`

```
Je veux auditer la qualité du code
```
→ Active automatiquement le skill `code-audit`

```
Comment utiliser les observables rxjs ?
```
→ Active automatiquement le skill `rxjs-patterns`

**Méthode 2 : Activation explicite**

```
#angular-migration
```

#### Skills Disponibles

| Skill | Keywords | Description |
|-------|----------|-------------|
| `angular-migration` | migration, angular, ng update, upgrade, palier | Migration Angular 5→20 |
| `codemods-refactoring` | codemod, refactor, jscodeshift, transform | Refactoring automatique |
| `strands-orchestration` | strands, orchestrate, multi-agent, workflow | Orchestration multi-agents |
| `validation-formelle` | validation, formal, proof, invariant, type-safe | Validation de types |
| `code-audit` | audit, quality, security, lint, analyze | Audit qualité/sécurité |
| `rxjs-patterns` | rxjs, observable, subscribe, pipe, operator | Patterns RxJS modernes |

---

### 4. Agents (Référencement Explicite) 🤖

Les **agents** sont des profils spécialisés pour différentes tâches.

#### Comment Utiliser un Agent

**Méthode 1 : Mention dans le prompt**

```
Utilise l'agent migration pour commencer le palier 1
```

**Méthode 2 : Keywords**

Mentionnez les mots-clés associés à l'agent :

```
Je veux coordonner la migration entre les deux repos
```
→ Active l'agent `coordinator-agent`

```
Je veux migrer angular
```
→ Active l'agent `migration-agent`

```
Je veux auditer le code
```
→ Active l'agent `audit-agent`

#### Agents Disponibles

| Agent | Keywords | Description |
|-------|----------|-------------|
| `coordinator-agent` | coordinate, sync, multi-repo, both | Coordonne les actions entre repos |
| `migration-agent` | migrate, migration, upgrade, angular | Spécialisé migration Angular |
| `audit-agent` | audit, analyze, quality, security | Analyse qualité et sécurité |
| `devops-agent` | build, deploy, ci, cd, pipeline | CI/CD et infrastructure |

---

### 5. Hooks (Automatiques) 🪝

Les **hooks** sont des automatisations qui se déclenchent sur certains événements.

#### Hooks Configurés

| Hook | Déclencheur | Action |
|------|-------------|--------|
| `cleanup-and-journal` | Fin de session (`agentStop`) | Nettoie les fichiers temporaires et propose de mettre à jour le journal |
| `rules-reminder` | Tous les 10 messages (`promptSubmit`) | Rappelle les règles critiques (silencieux) |
| `sync-kiro-indexes` | Fin de session (`agentStop`) | Synchronise les index avec les fichiers réels |

**Vous n'avez rien à faire**, les hooks se déclenchent automatiquement.

---

## 🚀 Workflow Recommandé

### Au Démarrage de Chaque Session

1. **Charger START-HERE.md**
   ```
   Charge le fichier .kiro/START-HERE.md
   ```

2. **Vérifier l'état actuel**
   Les steering rules sont déjà chargées, vous voyez les règles critiques.

3. **Charger la spec nécessaire**
   ```
   Charge la spec 04-palier-01-angular-5-to-6
   ```

### Pendant le Travail

1. **Utiliser les keywords** pour activer les skills automatiquement
   - "migration angular" → Active `angular-migration`
   - "audit code" → Active `code-audit`

2. **Référencer les agents** si besoin
   ```
   Utilise l'agent migration
   ```

3. **Charger les specs** au fur et à mesure
   ```
   Charge la spec du palier suivant
   ```

### En Fin de Session

Les hooks se déclenchent automatiquement :
- Nettoyage des fichiers temporaires
- Synchronisation des index
- Proposition de mise à jour du journal

---

## 📊 Résumé

| Composant | Chargement | Comment l'utiliser |
|-----------|------------|-------------------|
| **Steering Rules** | ✅ Automatique | Rien à faire, toujours présentes |
| **Specs** | ⚠️ Manuel | `Charge la spec XXX` ou `#file:...` |
| **Skills** | ⚠️ Keywords | Mentionner les mots-clés dans le prompt |
| **Agents** | ⚠️ Explicite | `Utilise l'agent XXX` ou keywords |
| **Hooks** | ✅ Automatique | Se déclenchent automatiquement |

---

## ✅ Checklist de Démarrage

- [ ] Charger `.kiro/START-HERE.md`
- [ ] Lire les steering rules (déjà chargées)
- [ ] Charger la spec du palier actuel
- [ ] Mentionner les keywords pour activer les skills
- [ ] Commencer le travail

---

## 💡 Astuces

### Pour Voir les Steering Rules Actives

Elles apparaissent dans les `<steering-reminder>` de vos prompts.

### Pour Lister les Specs Disponibles

```
Liste-moi les specs disponibles
```

### Pour Activer Plusieurs Skills

Mentionnez plusieurs keywords :
```
Je veux migrer angular avec des codemods et auditer le code
```
→ Active `angular-migration`, `codemods-refactoring` et `code-audit`

### Pour Charger Plusieurs Fichiers

```
Charge les fichiers suivants :
- .kiro/specs/00-resume-executif.md
- .kiro/specs/02-plan-migration.md
- .kiro/steering/02-migration-angular-rules.md
```

---

## 🎯 Conclusion

Le système Kiro est **optimisé pour économiser le contexte** :

- **Steering rules** : Toujours chargées (essentielles)
- **Specs, Skills, Agents** : Chargés à la demande (optimisation)
- **Hooks** : Automatiques (transparents)

C'est **par design** et c'est **optimal** pour votre workflow.

**Vous êtes prêt à commencer !** 🚀

---

**Version** : 1.0.0  
**Date** : 2026-02-04  
**Auteur** : Kiro  
**Statut** : ✅ Guide complet
