---
inclusion: always
priority: 100
---

# Règles de Migration Angular

> **Version** : 1.1.0  
> **Dernière mise à jour** : 2026-02-04  
> **Changelog** :
> - v1.1.0 (2026-02-04) : Ajout référence système de snapshots, Palier 0
> - v1.0.0 (2026-02-03) : Création initiale

> **Contexte** : Migration Angular 5 → 20 pour pwc-ui-shared et pwc-ui

---

## 🔴 RÈGLE D'OR : Ordre de Migration

```
pwc-ui-shared (lib)  →  pwc-ui (client)
   MIGRER AVANT            MIGRER APRÈS
```

**TOUJOURS** :
1. Migrer `pwc-ui-shared` en premier
2. Valider (build + tests)
3. Publier sur Nexus
4. Mettre à jour `@pwc/shared` dans `pwc-ui`
5. Migrer `pwc-ui`

**JAMAIS** :
- Migrer `pwc-ui` avant `pwc-ui-shared`
- Passer au palier suivant sans validation complète
- Sauter un palier (migration incrémentale obligatoire)

---

## 📋 Checklist par Palier

### Avant de Commencer un Palier

- [ ] Checkpoint Git créé
- [ ] Build réussi sur palier actuel
- [ ] Tests passent sur palier actuel
- [ ] Documentation du palier lue
- [ ] **🚦 Gate Playwright validé (si applicable)**
- [ ] **📸 Snapshots créés pour les fichiers à modifier** (voir `.kiro/steering/12-modification-rules.md`)

### Pour pwc-ui-shared
1. [ ] `ng update @angular/cli@X @angular/core@X`
2. [ ] Appliquer les codemods si nécessaire
3. [ ] Fixer les erreurs de compilation
4. [ ] `npm run build` réussi
5. [ ] `npm test` réussi (>95% passent)
6. [ ] `npm publish` sur Nexus
7. [ ] Tag Git : `git tag palier-X-shared-angular-Y`

### Pour pwc-ui
1. [ ] `npm update @pwc/shared`
2. [ ] `npm install`
3. [ ] `ng update @angular/cli@X @angular/core@X`
4. [ ] Appliquer les codemods si nécessaire
5. [ ] Adapter webpack.config si nécessaire
6. [ ] Fixer les erreurs de compilation
7. [ ] `npm run build` réussi
8. [ ] `npm test` réussi (>95% passent)
9. [ ] Application démarre sans erreurs
10. [ ] Tests manuels des fonctionnalités critiques
11. [ ] Tag Git : `git tag palier-X-ui-angular-Y`

### Après Chaque Palier
- [ ] Mettre à jour `.kiro/state/strands-state.json`
- [ ] Documenter les problèmes rencontrés
- [ ] Commit final avec message descriptif

---

## 🛠️ Commandes Standard

### Vérification Versions
```powershell
# Basculer vers la bonne version Node.js
Use-Node10  # Pour Angular 5-8 (Paliers 1-4)
Use-Node12  # Pour Angular 9-11 (Paliers 5-7)
Use-Node14  # Pour Angular 12 (Palier 8)
Use-Node16  # Pour Angular 13-14 (Paliers 9-10)
Use-Node18  # Pour Angular 15-17 (Paliers 11-13)
Use-Node20  # Pour Angular 18-19 (Palier 14)
Use-Node22  # Pour Angular 20 (Palier 15)

# Vérifier les versions
node --version
npm --version
ng version
```

### Migration Angular
```powershell
# Basculer vers la bonne version Node.js AVANT toute migration
Use-Node10  # Exemple pour Angular 5-8

# Vérifier
node --version
npm --version

# Voir les mises à jour disponibles
ng update

# Mettre à jour Angular (dry-run)
ng update @angular/cli@X @angular/core@X --dry-run

# Mettre à jour Angular (réel)
ng update @angular/cli@X @angular/core@X --allow-dirty
```

### Tests
```powershell
# Vérifier la version Node.js active
node --version

# Tests unitaires
npm test

# Tests avec couverture
npm test -- --code-coverage

# Build
npm run build
```

### Publication (pwc-ui-shared uniquement)
```powershell
# Vérifier la version Node.js
node --version

# Vérifier la version du package
npm version

# Publier sur Nexus
npm publish
```

---

## ⚠️ Gestion des Erreurs

### Erreurs de Compilation TypeScript
1. Lire l'erreur complètement
2. Vérifier la documentation Angular pour ce palier
3. Appliquer le codemod approprié si disponible
4. Fixer manuellement si nécessaire
5. Ne jamais utiliser `@ts-ignore` sans justification

### Tests qui Échouent
1. Identifier le composant/service concerné
2. Vérifier les breaking changes du palier
3. Adapter le test si nécessaire
4. Si >5% des tests échouent, STOP et analyser

### Build qui Échoue
1. Vérifier les erreurs de compilation
2. Vérifier les dépendances manquantes
3. Vérifier webpack.config (pwc-ui uniquement)
4. Consulter les logs complets

---

## 🔄 Rollback

Si un palier échoue après plusieurs tentatives :

```powershell
# Revenir au tag précédent
git reset --hard palier-X-angular-Y

# Nettoyer node_modules
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# Basculer vers la bonne version Node.js
Use-Node10  # Adapter selon le palier

# Réinstaller
npm install

# Vérifier que tout fonctionne
npm run build
npm test
```

---

## 📊 Métriques de Validation

| Métrique | Seuil Minimum | Idéal |
|----------|---------------|-------|
| Build réussi | 100% | 100% |
| Tests passent | 95% | 100% |
| Couverture code | 75% | 80% |
| Temps build | <15 min | <10 min |
| Temps tests | <10 min | <5 min |
| Erreurs TypeScript | 0 | 0 |
| Warnings critiques | 0 | 0 |

---

## 🎯 Paliers Critiques - Attention Spéciale

### Palier 0 (Validation + Playwright) : Gate Bloquant
- Installer et configurer Playwright
- Créer 3 fichiers de tests E2E (demo-home, demo-forms, demo-navigation)
- Valider que 100% des tests passent sur Angular 5 actuel
- Tester les codemods disponibles
- Analyser webpack.config de pwc-ui
- Dry-run du Palier 1
- **BLOQUANT** : Ne pas passer au Palier 1 sans gate validé

### Palier 1 (5→6) : RxJS
- Installer `rxjs-compat` AVANT la migration
- Utiliser le codemod officiel `rxjs-5-to-6-migrate`
- Vérifier TOUS les imports RxJS
- Retirer `rxjs-compat` au Palier 2

### Palier 4 (8→9) : Ivy
- Activer Ivy : `"enableIvy": true` dans tsconfig
- Utiliser `ng update @angular/core --migrate-only`
- Tests approfondis (Ivy change le rendu)
- Vérifier les composants dynamiques

### Palier 7 (11→12) : Webpack 5
- Adapter `webpack.dev.config.js` et `webpack.prod.config.js` (pwc-ui)
- Ou migrer vers Angular CLI natif (recommandé)
- Vérifier les loaders et plugins

### Palier 11 (15→16) : Signals
- Nouveau paradigme de réactivité
- Optionnel mais recommandé pour nouveaux composants
- Coexiste avec RxJS

### Palier 12 (16→17) : Control Flow
- Nouvelle syntaxe : `@if`, `@for`, `@switch`
- Utiliser `ng generate @angular/core:control-flow`
- Migration automatique disponible

---

## 📝 Documentation Obligatoire

Après chaque palier, documenter dans `.kiro/state/strands-state.json` :
- Timestamp de début et fin
- Problèmes rencontrés
- Solutions appliquées
- Temps réel vs estimé
- Notes pour les prochains paliers

---

## 🚫 Interdictions

- ❌ Ne JAMAIS forcer une migration avec `--force`
- ❌ Ne JAMAIS ignorer les tests qui échouent
- ❌ Ne JAMAIS commiter du code qui ne compile pas
- ❌ Ne JAMAIS sauter un palier
- ❌ Ne JAMAIS migrer pwc-ui avant pwc-ui-shared
- ❌ Ne JAMAIS utiliser `any` pour contourner les erreurs TypeScript
- ❌ Ne JAMAIS désactiver les tests pour faire passer le build
- ❌ Ne JAMAIS créer ou supprimer des branches Git
- ❌ Ne JAMAIS faire de Pull Request
- ❌ Ne JAMAIS changer de branche (rester sur `dev_vibecoding`)
- ❌ Ne JAMAIS supprimer des fichiers sans accord explicite
- ❌ Ne JAMAIS polluer les repos avec des scripts de test temporaires

---

## ✅ Bonnes Pratiques

### Développement
- ✅ Lire la documentation AVANT de commencer
- ✅ Utiliser `Use-NodeXX` pour basculer vers la bonne version Node.js
- ✅ Vérifier `node --version` avant chaque palier
- ✅ Faire un dry-run avec `--dry-run` avant toute migration
- ✅ Commiter fréquemment avec des messages descriptifs
- ✅ Tester manuellement les fonctionnalités critiques
- ✅ Documenter les décisions techniques
- ✅ Demander de l'aide si bloqué >2h sur un problème
- ✅ Utiliser les codemods disponibles
- ✅ Garder les dépendances tierces à jour

### Gestion Git
- ✅ Rester TOUJOURS sur la branche `dev_vibecoding`
- ✅ Commiter régulièrement avec des messages clairs
- ✅ Ne PAS créer de nouvelles branches
- ✅ Ne PAS faire de Pull Request
- ✅ Utiliser des tags Git pour marquer les paliers

### Propreté du Workspace
- ✅ Utiliser un dossier temporaire pour les tests/debug : `.kiro/temp/`
- ✅ Nettoyer automatiquement les fichiers temporaires après usage
- ✅ Ne PAS créer de fichiers de test dans les repos principaux
- ✅ Supprimer la documentation de test après validation
- ✅ Utiliser le hook de dépollution automatique

### Documentation
- ✅ Mettre à jour `Documentation/JOURNAL-DE-BORD.md` après chaque changement majeur
- ✅ Documenter les problèmes rencontrés
- ✅ Documenter les solutions appliquées
- ✅ Garder un historique des décisions

### Questions et Amélioration
- ✅ Poser des questions en cas de doute
- ✅ Challenger le processus pour l'améliorer
- ✅ Proposer des optimisations
- ✅ Signaler les incohérences

---

## ✅ Bonnes Pratiques

- ✅ Lire la documentation officielle du palier AVANT de commencer
- ✅ Faire un dry-run avec `--dry-run` avant toute migration
- ✅ Commiter fréquemment avec des messages descriptifs
- ✅ Tester manuellement les fonctionnalités critiques
- ✅ Documenter les décisions techniques
- ✅ Demander de l'aide si bloqué >2h sur un problème
- ✅ Utiliser les codemods disponibles
- ✅ Garder les dépendances tierces à jour

---

## 🔗 Ressources

- [Angular Update Guide](https://update.angular.io/)
- [RxJS Migration Guide](https://rxjs.dev/guide/v6/migration)
- [Ivy Migration Guide](https://angular.io/guide/ivy)
- Specs : `.kiro/specs/02-plan-migration.md`
- Risques : `.kiro/specs/03-risques-identifies.md`
- État : `.kiro/state/strands-state.json`
