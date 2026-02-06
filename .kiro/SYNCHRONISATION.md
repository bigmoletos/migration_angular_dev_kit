# Système de Synchronisation Automatique Kiro

**Date de mise en place** : 2026-02-03
**Version** : 1.0

---

## 🎯 Problème Résolu

### Symptôme
Kiro affichait toujours **"+create new spec"** sans afficher les specs existantes dans le dossier `.kiro/specs/`.

### Cause Racine
Le fichier `.kiro/specs/_index.json` contenait des références à des specs qui **n'existaient plus** :
- ❌ `00-coordination-migration.md` (obsolète)
- ❌ `01-audit-global.md` (obsolète)
- ❌ `02-sequence-migration.md` (obsolète)

Alors que les **vraies specs** étaient :
- ✅ `00-resume-executif.md`
- ✅ `01-etat-actuel.md`
- ✅ `02-plan-migration.md`
- ✅ ... (et 8 autres specs)

Kiro utilise ce fichier `_index.json` pour lister les ressources disponibles. Si l'index ne correspond pas aux fichiers réels, Kiro ne peut pas les "voir".

---

## ✅ Solution Mise en Place

### 1. Scripts de Synchronisation Automatique

Trois scripts Node.js ont été créés dans `.kiro/scripts/` :

#### `sync-specs-index.js`
- Scanne tous les fichiers `.md` dans `.kiro/specs/`
- Génère automatiquement le fichier `_index.json`
- Extrait les métadonnées de chaque spec (titre, description, mots-clés)
- Estime le nombre de tokens

#### `sync-steering-index.js`
- Scanne tous les fichiers `.md` dans `.kiro/steering/`
- Génère le fichier `.kiro/steering/_index.json`
- Détecte les triggers contextuels
- Identifie les steerings "toujours chargés"

#### `sync-all-indexes.js` ⭐ **PRINCIPAL**
- Exécute tous les scripts de synchronisation
- Affiche un rapport complet
- Vérifie la cohérence globale

### 2. Hook Automatique

Le hook `.kiro/hooks/sync-kiro-indexes.json` :
- Se déclenche automatiquement à la fin de chaque session (`agentStop`)
- Vérifie si des fichiers ont été ajoutés/modifiés/supprimés
- Synchronise les index si nécessaire
- Fonctionne de manière silencieuse (sauf anomalie)

---

## 📊 État Actuel

### Specs (`.kiro/specs/`)

**Fichier d'index** : `.kiro/specs/_index.json`

| Spec | Tokens | Description |
|------|--------|-------------|
| 00-resume-executif.md | 1776 | Résumé exécutif de la migration |
| 01-etat-actuel.md | 806 | État actuel du workspace |
| 02-plan-migration.md | 2598 | Plan complet de migration |
| 03-risques-identifies.md | 2532 | Risques et mitigations |
| 04-palier-01-angular-5-to-6.md | 3037 | Migration Angular 5→6 (RxJS) |
| 05-palier-04-angular-8-to-9-ivy.md | 3036 | Migration Angular 8→9 (Ivy) |
| 06-palier-07-angular-11-to-12-webpack5.md | 2118 | Migration Angular 11→12 (Webpack 5) |
| 07-palier-11-angular-15-to-16-signals.md | 2725 | Migration Angular 15→16 (Signals) |
| 08-palier-12-angular-16-to-17-control-flow.md | 2700 | Migration Angular 16→17 (Control Flow) |
| 09-palier-15-angular-19-to-20-final.md | 2549 | Migration finale Angular 19→20 |
| 10-workflow-tests-playwright.md | 3358 | Workflow tests E2E avec Playwright |

**Total** : 11 specs, 27 235 tokens estimés

---

### Steering (`.kiro/steering/`)

**Fichier d'index** : `.kiro/steering/_index.json`

| Steering | Tokens | Type | Triggers |
|----------|--------|------|----------|
| 01-project-overview.md | 1369 | Contextuel | `*.module.ts` |
| 02-migration-angular-rules.md | 2143 | Contextuel | `*.spec.ts`, `webpack*.js` |
| 03-rxjs-migration-patterns.md | 2533 | Contextuel | - |
| 04-ivy-migration-guide.md | 2447 | Contextuel | `*.spec.ts` |
| 05-webpack-custom-migration.md | 2543 | Contextuel | `webpack*.js` |
| 06-testing-strategy.md | 2371 | Contextuel | `*.spec.ts`, `**/e2e/**/*.ts`, `**/playwright/**/*.ts` |
| 07-typescript-migration.md | 1688 | Contextuel | - |
| 08-nodejs-version-management.md | 0 | Contextuel | ⚠️ **Fichier vide** |
| 08-workspace-hygiene.md | 1335 | Contextuel | `*.spec.ts` |
| 09-version-management.md | 1707 | Contextuel | - |
| 10-local-dev-config.md | 1583 | Contextuel | `*.spec.ts`, `*.module.ts` |
| 11-playwright-e2e-testing.md | 4052 | Contextuel | `*.spec.ts`, `**/e2e/**/*.ts`, `**/playwright/**/*.ts` |
| 12-modification-rules.md | 2015 | Contextuel | - |

**Total** : 13 steerings, 25 786 tokens estimés

⚠️ **Note** : Le fichier `08-nodejs-version-management.md` est vide et devrait probablement être supprimé ou complété.

---

## 🚀 Utilisation

### Synchronisation Manuelle

#### Synchroniser tous les index (recommandé)
```bash
node C:\repo_hps\.kiro\scripts\sync-all-indexes.js
```

#### Synchroniser uniquement les specs
```bash
node C:\repo_hps\.kiro\scripts\sync-specs-index.js
```

#### Synchroniser uniquement les steering
```bash
node C:\repo_hps\.kiro\scripts\sync-steering-index.js
```

### Quand Synchroniser Manuellement ?

Exécutez la synchronisation après :
- ✅ Ajout d'une nouvelle spec dans `.kiro/specs/`
- ✅ Modification ou suppression d'une spec existante
- ✅ Ajout d'un nouveau steering dans `.kiro/steering/`
- ✅ Clonage ou mise à jour du dépôt
- ✅ Si Kiro affiche "+create new spec" alors que des specs existent

### Synchronisation Automatique

Le hook `.kiro/hooks/sync-kiro-indexes.json` s'exécute automatiquement :
- ✅ À la fin de chaque session Kiro (`agentStop`)
- ✅ Vérifie les modifications dans `.kiro/specs/` et `.kiro/steering/`
- ✅ Synchronise silencieusement les index
- ✅ Affiche un message uniquement en cas d'anomalie

---

## 📂 Architecture

```
.kiro/
├── specs/
│   ├── _index.json              # ← Généré automatiquement
│   ├── 00-resume-executif.md
│   ├── 01-etat-actuel.md
│   └── ...
│
├── steering/
│   ├── _index.json              # ← Généré automatiquement
│   ├── 01-project-overview.md
│   ├── 02-migration-angular-rules.md
│   └── ...
│
├── hooks/
│   ├── sync-kiro-indexes.json   # ← Hook automatique
│   ├── cleanup-and-journal.json
│   └── rules-reminder.json
│
├── scripts/
│   ├── sync-specs-index.js      # ← Script de synchronisation specs
│   ├── sync-steering-index.js   # ← Script de synchronisation steering
│   ├── sync-all-indexes.js      # ← Script principal ⭐
│   └── README.md                # ← Documentation des scripts
│
├── SYNCHRONISATION.md           # ← Ce fichier
└── ...
```

---

## 🔧 Maintenance

### Ajouter une Nouvelle Spec

1. Créer le fichier `.md` dans `.kiro/specs/`
2. Écrire le contenu (avec un titre `# Titre`)
3. Exécuter la synchronisation :
   ```bash
   node C:\repo_hps\.kiro\scripts\sync-all-indexes.js
   ```
4. Vérifier que la spec apparaît dans Kiro

### Supprimer une Spec Obsolète

1. Supprimer le fichier `.md` dans `.kiro/specs/`
2. Exécuter la synchronisation :
   ```bash
   node C:\repo_hps\.kiro\scripts\sync-all-indexes.js
   ```
3. La spec disparaîtra automatiquement de l'index

### Renommer une Spec

1. Renommer le fichier `.md`
2. Exécuter la synchronisation
3. L'index sera mis à jour automatiquement

---

## 🎯 Avantages du Système

### Avant (Manuel)
- ❌ Fichiers `_index.json` manuellement maintenus
- ❌ Risque de désynchronisation
- ❌ Kiro affiche "+create new spec" pour des specs existantes
- ❌ Métadonnées incohérentes ou obsolètes
- ❌ Estimation manuelle des tokens

### Après (Automatique)
- ✅ Fichiers `_index.json` générés automatiquement
- ✅ Toujours synchronisés avec les fichiers réels
- ✅ Kiro affiche correctement toutes les specs disponibles
- ✅ Métadonnées extraites automatiquement du contenu
- ✅ Estimation automatique des tokens
- ✅ Hook automatique en fin de session
- ✅ Détection des triggers contextuels pour les steering

---

## ⚠️ Points d'Attention

### Fichiers Ignorés

Les scripts ignorent automatiquement :
- `README.md` (documentation)
- `_index.json` (fichier généré)

### Estimation des Tokens

L'estimation est approximative :
- **Formule** : `nombre_de_caractères / 4`
- **Précision** : ±20%
- **Objectif** : Donner un ordre de grandeur

### Format Markdown Attendu

Pour une extraction optimale des métadonnées :
```markdown
# Titre de la Spec

Description de la spec sur une ou plusieurs lignes.

## Section 1
...
```

---

## 🐛 Dépannage

### Problème : Kiro n'affiche toujours pas les specs

**Solutions** :
1. Vérifier que les fichiers `.md` existent dans `.kiro/specs/`
2. Exécuter manuellement la synchronisation
3. Vérifier que le fichier `_index.json` est généré et valide
4. Redémarrer la session Kiro

### Problème : Script de synchronisation échoue

**Solutions** :
1. Vérifier que Node.js est installé : `node --version`
2. Vérifier les permissions de fichiers
3. Vérifier que les dossiers `.kiro/specs/` et `.kiro/steering/` existent
4. Consulter les logs d'erreur

### Problème : Hook ne se déclenche pas automatiquement

**Solutions** :
1. Vérifier que le fichier `sync-kiro-indexes.json` existe dans `.kiro/hooks/`
2. Vérifier le format JSON du hook
3. Tester manuellement les scripts
4. Vérifier la configuration des hooks dans Kiro

---

## 📈 Évolutions Futures

Améliorations possibles :

- [ ] **Validation automatique** : Vérifier le format des specs (frontmatter, structure)
- [ ] **Détection des dépendances** : Identifier les liens entre specs
- [ ] **Génération de tags** : Extraire automatiquement des tags du contenu
- [ ] **Rapport de couverture** : Vérifier que chaque palier a sa spec
- [ ] **Synchronisation des skills** : Générer `.kiro/skills/_index.json`
- [ ] **Synchronisation des agents** : Générer `.kiro/agents/_index.json`
- [ ] **Détection des specs obsolètes** : Identifier les specs non utilisées
- [ ] **Intégration CI/CD** : Exécuter automatiquement lors des commits

---

## 📞 Support

Pour toute question ou problème :

1. Consulter la documentation : `.kiro/scripts/README.md`
2. Vérifier les logs d'exécution des scripts
3. Tester manuellement les scripts de synchronisation
4. Vérifier l'état des fichiers d'index générés

---

**Dernière mise à jour** : 2026-02-03
**Auteur** : Système de maintenance Kiro
**Version** : 1.0

---

## 🎉 Résultat Final

Grâce à ce système de synchronisation automatique, **Kiro reconnaît maintenant correctement** :

✅ **11 specs** dans `.kiro/specs/`
✅ **13 steering** dans `.kiro/steering/`
✅ **3 hooks** dans `.kiro/hooks/`

Plus de "+create new spec" pour des ressources qui existent déjà ! 🎯
