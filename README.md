# Workspace Migration Angular 5 → 20

> Workspace de coordination pour la migration progressive d'Angular 5.2.0 vers Angular 20

## 📋 Vue d'Ensemble

Ce workspace coordonne la migration de deux repositories Angular :
- **pwc-ui-shared-v4-ia** : Bibliothèque de composants partagés (à migrer EN PREMIER)
- **pwc-ui-v4-ia** : Application principale (à migrer EN SECOND)

## 🏗️ Structure du Workspace

```
C:\repo_hps\
│
├── 📁 pwc-ui-shared-v4-ia/          # Bibliothèque (NE PAS polluer)
├── 📁 pwc-ui-v4-ia/                 # Application (NE PAS polluer)
│
├── 📁 scripts_outils_ia/            # Scripts temporaires et tests
│   └── (nettoyer après usage)       # ⚠️ Supprimer les fichiers temporaires
│
├── 📁 docs_outils_ia/               # Documentation du projet
│   ├── JOURNAL-COORDINATION.md      # 📝 Journal de bord (MAJ quotidienne)
│   ├── ETAT-MIGRATION.md            # 📊 Suivi de progression
│   ├── GUIDE-*.md                   # 📚 Guides de référence
│   └── ANALYSE-*.md                 # 🔍 Analyses techniques
│
├── 🤖 .claude                       # Config Claude (orchestrateur)
├── 🤖 .cursorrules                  # Config Cursor IDE
├── 🤖 .vibe                         # Config Vibe AI
├── 🤖 .gemini                       # Config Google Gemini
├── 🤖 .opencode                     # Config OpenCode
├── 🤖 .codex                        # Config OpenAI Codex
│
├── 📄 README.md                     # Ce fichier
└── 📄 GUIDE-DEMARRAGE-RAPIDE.md     # Guide de démarrage existant
```

## 🎯 Stratégie de Migration (5 Phases)

```
Phase 1: Angular 5 → 8  (Foundation)     [5→6→7→8]
Phase 2: Angular 8 → 12 (Ivy Engine)     [8→9→10→11→12]
Phase 3: Angular 12 → 15 (Standalone)    [12→13→14→15]
Phase 4: Angular 15 → 17 (Signals)       [15→16→17]
Phase 5: Angular 17 → 20 (Zoneless)      [17→18→19→20]
```

**⚠️ Ordre de migration CRITIQUE** :
1. **D'ABORD** : pwc-ui-shared-v4-ia (bibliothèque)
2. **ENSUITE** : pwc-ui-v4-ia (application)

Ne JAMAIS inverser cet ordre !

## 🤖 Assistants IA Configurés

Plusieurs assistants IA sont configurés pour ce projet. Chacun partage les mêmes contraintes et objectifs :

### Configuration Commune à Tous les Assistants

#### ✅ Règles d'Or
1. **Pas de droits admin** : Pas de `sudo`, pas de `npm install -g`
2. **Repos propres** : Aucun fichier de test/debug dans pwc-ui-shared-v4-ia/ ou pwc-ui-v4-ia/
3. **Documentation obligatoire** : Mise à jour quotidienne de JOURNAL-COORDINATION.md
4. **TDD systématique** : Red → Green → Refactor → Commit
5. **Économie de tokens** : Mode stateful, orchestration, réutilisation

#### 📝 Documentation Requise

**Après chaque action significative**, mettre à jour `docs_outils_ia/JOURNAL-COORDINATION.md` :

```markdown
## [YYYY-MM-DD] - [Titre de l'Action]

**Repos concernés** : pwc-ui-shared-v4-ia / pwc-ui-v4-ia / les deux

**Action effectuée** :
- [Description détaillée]

**Résultat** :
- Succès ✅ / Échec ❌ / Partiel ⏳
- [Détails]

**Problèmes rencontrés** :
- [Problème] → [Solution]

**Prochaine étape** :
- [Action suivante]

**Temps passé** : X heures
```

### Fichiers de Configuration

| Fichier | Assistant | Usage Principal |
|---------|-----------|----------------|
| `.claude` | Claude | Orchestration, décisions complexes, documentation |
| `.cursorrules` | Cursor | Édition de code, refactoring, IDE |
| `.vibe` | Vibe AI | Assistance développement |
| `.gemini` | Google Gemini | Analyse, suggestions |
| `.opencode` | OpenCode | Génération de code |
| `.codex` | OpenAI Codex | Complétion de code |

Tous les assistants suivent les mêmes règles et contraintes définies dans leurs fichiers de configuration respectifs.

## 🧪 Méthodologie : Test-Driven Development (TDD)

**Obligatoire pour tous les changements de code** :

1. 🔴 **Red** : Écrire un test qui échoue
2. 🟢 **Green** : Implémenter le minimum pour passer le test
3. 🔵 **Refactor** : Améliorer le code (tests restent verts)
4. 💾 **Commit** : Sauvegarder avec un message descriptif

## ✅ Checklist par Palier de Migration

- [ ] Audit des dépendances actuelles
- [ ] Écriture des tests (TDD)
- [ ] Mise à jour de package.json
- [ ] Installation des dépendances (`npm install`)
- [ ] Correction des breaking changes
- [ ] Tests unitaires (tous passent ✅)
- [ ] Build sans erreur (`npm run build`)
- [ ] Audit de sécurité (`npm audit`)
- [ ] Tests manuels des fonctionnalités critiques
- [ ] Mise à jour JOURNAL-COORDINATION.md
- [ ] Mise à jour ETAT-MIGRATION.md
- [ ] Commit avec message descriptif
- [ ] Planification de l'étape suivante

## 🚫 Contraintes Critiques

### Pas de Droits Administrateur

**Commandes INTERDITES** :
```bash
❌ npm install -g <package>
❌ sudo <command>
❌ chown / chmod <files>
```

**Solutions de contournement** :
```bash
✅ npm install --save <package>        # Installation locale
✅ npx <command>                       # Exécution sans installation globale
✅ npm install --save-dev <dev-tool>   # Outils de dev locaux
```

### Gestion des Fichiers Temporaires

**Emplacement des scripts de test/debug** :

```bash
# ❌ INTERDIT
pwc-ui-shared-v4-ia/test-script.js
pwc-ui-v4-ia/debug.log

# ✅ CORRECT
scripts_outils_ia/test-migration.js
scripts_outils_ia/analyze-deps.sh
scripts_outils_ia/temp-output.log
```

**Cycle de vie** :
1. Créer dans `scripts_outils_ia/`
2. Utiliser pour tester/débugger
3. **Supprimer immédiatement après usage**
4. Si utile pour plus tard → documenter dans `docs_outils_ia/`

## 📊 Suivi de Progression

### Fichiers de Suivi

1. **JOURNAL-COORDINATION.md** : Journal de bord quotidien
   - Entrées chronologiques (plus récent en haut)
   - Actions, résultats, problèmes, solutions

2. **ETAT-MIGRATION.md** : Dashboard de progression
   - Tableaux de progression par phase
   - Statuts : ✅ Complété | ⏳ En cours | ❌ Non commencé | 🔴 Bloqué
   - Versions actuelles, blocages, prochaines étapes

### Exemple d'État Actuel

```
Phase 1: Angular 5 → 8
├── 5.2.0 (initial) ✅ [pwc-ui-shared-v4-ia] ✅ [pwc-ui-v4-ia]
├── 5 → 6           ⏳ [en préparation]
├── 6 → 7           ❌ [non commencé]
└── 7 → 8           ❌ [non commencé]
```

## 🛠️ Commandes Courantes

### Audit et Analyse
```bash
# Vérifier les dépendances obsolètes
npm outdated

# Audit de sécurité
npm audit

# Analyser la structure du projet
npm ls <package-name>
```

### Développement
```bash
# Installer les dépendances
npm install

# Lancer les tests (TDD)
npm test

# Compiler le projet
npm run build

# Lancer l'application en mode dev
npm start
```

### Git
```bash
# Voir les modifications
git status
git diff

# Committer les changements
git add <files>
git commit -m "feat(migration): descriptif"

# Pousser vers le remote
git push
```

## 🎓 Bonnes Pratiques

### Code Quality
- **SOLID** : Principes de conception orientée objet
- **DRY** : Don't Repeat Yourself
- **KISS** : Keep It Simple, Stupid
- **Clean Code** : Noms significatifs, fonctions courtes
- **TypeScript strict mode** : Typage fort

### Angular Specifics
- **OnPush Change Detection** : Optimisation des performances
- **Unsubscribe Observables** : Éviter les fuites mémoire (pattern takeUntil)
- **Reactive Forms** : Préférer aux template-driven
- **Lazy Loading** : Charger les modules à la demande
- **Standalone Components** : À partir d'Angular 14+

### RxJS Best Practices
- **Pipeable Operators** : Obligatoire à partir d'Angular 6+
- **Avoid Nested Subscriptions** : Utiliser les opérateurs (switchMap, mergeMap)
- **Declarative Approach** : Préférer au style impératif
- **shareReplay()** : Pour les opérations coûteuses

## 🚀 Démarrage Rapide

### 1. Premier Audit
```bash
cd C:\repo_hps\pwc-ui-shared-v4-ia
npm install
npm audit
npm outdated
```

### 2. Documenter l'État Initial
```bash
# Mettre à jour docs_outils_ia/ETAT-MIGRATION.md
# avec les versions actuelles et l'état des builds
```

### 3. Planifier la Première Migration (5→6)
- Lire le guide officiel : https://update.angular.io/?v=5.0-6.0
- Identifier les breaking changes
- Écrire les tests pour les fonctionnalités existantes (TDD)
- Créer un script de migration dans scripts_outils_ia/

### 4. Exécuter la Migration
- Suivre la checklist complète
- Tester à chaque étape
- Documenter les problèmes et solutions

## 📚 Documentation de Référence

### Guides Internes
- `docs_outils_ia/GUIDE-CONTEXT-OPTIMIZER.md` : Optimisation du contexte et tokens
- `docs_outils_ia/GUIDE-SKILLS-ACP-FINDTOOLS.md` : Utilisation des skills
- `docs_outils_ia/ANALYSE-ARCHITECTURE-REPO.md` : Architecture des repos

### Ressources Externes
- [Angular Update Guide](https://update.angular.io/) : Guide officiel de migration
- [RxJS Migration Guide](https://rxjs.dev/guide/v6/migration) : Migration RxJS 5→6
- [Angular Blog](https://blog.angular.io/) : Annonces et nouveautés

## 🆘 En Cas de Problème

### Blocages Courants

| Problème | Solution |
|----------|----------|
| "Permission denied" | Éviter sudo, installer localement |
| Conflits de dépendances | Utiliser `npm ls` pour débugger, résoudre incrémentalement |
| Tests qui échouent | Revenir en arrière, isoler le problème, TDD |
| Build errors | Vérifier les breaking changes du guide de migration |
| Token limits | Mode stateful, résumer le contexte, utiliser l'orchestrateur |

### Procédure de Déblocage

1. **Documenter** le problème dans JOURNAL-COORDINATION.md
2. **Analyser** les logs d'erreur
3. **Rechercher** des solutions (guides de migration, Stack Overflow)
4. **Tester** dans scripts_outils_ia/ avant d'appliquer
5. **Demander** validation si incertain (AskUserQuestion)
6. **Documenter** la solution pour référence future

## 🤝 Coordination Multi-Assistants

Si plusieurs assistants IA travaillent simultanément :
- Utiliser les mêmes fichiers de documentation (JOURNAL, ETAT)
- Éviter les duplications de travail
- Respecter les mêmes contraintes
- Communiquer via les fichiers partagés

## 📞 Contact

| Rôle | Responsabilité |
|------|---------------|
| Développeur | Questions techniques, validation des changements |
| Architecte | Décisions d'architecture, choix de migration |
| Assistants IA | Exécution, analyse, documentation |

---

## 🎯 État Actuel du Projet

**Dernière mise à jour** : 2026-02-03

**Phase actuelle** : Initialisation et configuration du workspace

**Prochaines étapes** :
1. Audit initial des deux repositories
2. Analyse des dépendances et vulnérabilités
3. Plan de tests pour la migration 5→6
4. Première migration : pwc-ui-shared-v4-ia (5.2.0 → 6.x)

---

**Version du README** : 1.0.0
**Maintenu par** : Migration Team
**Dernière révision** : 2026-02-03
