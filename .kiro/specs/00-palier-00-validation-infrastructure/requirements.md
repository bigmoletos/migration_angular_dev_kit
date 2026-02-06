# Requirements - Palier 0 : Validation Infrastructure

## Objectif

Valider que l'infrastructure de migration est opérationnelle et prête avant de commencer le Palier 1. Ce palier est **obligatoire** et **bloquant**.

## Contexte

- **Palier** : 0/15 (préparatoire)
- **Criticité** : 🔴 BLOQUANT pour tous les paliers suivants
- **Complexité** : Moyenne
- **Durée estimée** : 2 semaines
- **Principe** : "Fail Fast" - Découvrir les problèmes maintenant, quand ils sont faciles à corriger

## Exigences Fonctionnelles

### EF-1 : Gate Playwright Opérationnel
Implémenter et valider un système de tests E2E Playwright pour pwc-ui-shared.

### EF-2 : Codemods Testés
Tester tous les codemods disponibles (officiels et custom) sur des fichiers de test.

### EF-3 : Webpack Analysé
Analyser les configurations webpack custom de pwc-ui et définir une stratégie de migration.

### EF-4 : Dépendances Obsolètes Identifiées
Lister toutes les bibliothèques obsolètes et définir une stratégie de migration pour chacune.

### EF-5 : Matrice de Criticité Composants
Classifier les composants par criticité (critiques, importants, secondaires).

### EF-6 : Stratégie de Rollback Documentée
Documenter les procédures de rollback (Git, Nexus, communication).

### EF-7 : Dry-Run Palier 1
Effectuer un dry-run du Palier 1 pour identifier les problèmes potentiels.

## Exigences Non-Fonctionnelles

### ENF-1 : Documentation Complète
Tous les livrables doivent être documentés et versionnés.

### ENF-2 : Reproductibilité
Tous les tests doivent être reproductibles.

### ENF-3 : Traçabilité
Tous les résultats doivent être tracés et archivés.

## Critères d'Acceptation

### CA-1 : Gate Playwright (Tâche 1)
- [ ] Playwright installé dans pwc-ui-shared
- [ ] Configuration `playwright.config.ts` créée
- [ ] 3 fichiers de tests créés (demo-home, demo-forms, demo-navigation)
- [ ] Scripts npm ajoutés (test:e2e, test:e2e:ui, test:e2e:debug)
- [ ] Tests exécutés sur Angular 5 actuel
- [ ] Au moins 1 test passe
- [ ] Rapport HTML généré

### CA-2 : Codemods Testés (Tâche 2)
- [ ] Fichiers de test créés dans `.kiro/temp/`
- [ ] Codemod RxJS testé et documenté
- [ ] Codemod ModuleWithProviders testé et documenté
- [ ] Rapport de test créé : `.kiro/temp/rapport-test-codemods.md`
- [ ] Recommandations d'utilisation documentées

### CA-3 : Webpack Analysé (Tâche 3)
- [ ] Fichiers webpack lus (dev + prod)
- [ ] Loaders identifiés
- [ ] Plugins identifiés
- [ ] Compatibilité Webpack 5 évaluée
- [ ] Analyse documentée : `.kiro/temp/analyse-webpack.md`
- [ ] Recommandation formulée (migration Webpack 5 ou CLI natif)

### CA-4 : Dépendances Obsolètes (Tâche 4)
- [ ] `npm outdated` exécuté
- [ ] Toutes les libs obsolètes listées
- [ ] Stratégie définie pour chaque lib
- [ ] Document créé : `.kiro/specs/11-deprecated-libraries-strategy.md`
- [ ] Paliers de migration assignés

### CA-5 : Matrice Criticité (Tâche 5)
- [ ] Composants critiques identifiés (20%)
- [ ] Composants importants identifiés (30%)
- [ ] Composants secondaires identifiés (50%)
- [ ] Matrice documentée : `.kiro/temp/matrice-criticite-composants.md`

### CA-6 : Stratégie Rollback (Tâche 6)
- [ ] Critères Go/No-Go définis
- [ ] Procédure rollback Git documentée
- [ ] Procédure rollback Nexus documentée
- [ ] Template email communication documenté
- [ ] Document créé : `.kiro/specs/12-rollback-strategy.md`

### CA-7 : Dry-Run Palier 1 (Tâche 7)
- [ ] Branche de test créée
- [ ] `ng update --dry-run` exécuté
- [ ] Changements prévus notés
- [ ] Problèmes potentiels identifiés
- [ ] Temps estimé ajusté
- [ ] Rapport créé : `.kiro/temp/rapport-dry-run-palier-1.md`
- [ ] Rollback branche de test effectué

### CA-8 : Validation Globale
- [ ] Toutes les 7 tâches validées
- [ ] Tous les livrables créés
- [ ] Aucun bloquant identifié
- [ ] Prêt à démarrer Palier 1

## Contraintes

- **C-1** : Ne pas modifier le code source des applications (seulement tests)
- **C-2** : Utiliser `.kiro/temp/` pour tous les fichiers temporaires
- **C-3** : Documenter tous les résultats
- **C-4** : Rollback complet après dry-run
- **C-5** : Durée maximale : 2 semaines

## Dépendances

- `.kiro/steering/02-migration-angular-rules.md` : Règles de migration
- `.kiro/specs/02-plan-migration.md` : Plan global
- `.kiro/specs/04-palier-01-angular-5-to-6.md` : Spec Palier 1
- `scripts_outils_ia/codemods/` : Codemods custom
- `start-pwc-ui-shared-4201.bat` : Script lancement Shared

## Risques

### R-1 : Gate Playwright Complexe à Implémenter
**Impact** : 🟠 Élevé  
**Probabilité** : Moyenne  
**Mitigation** : Commencer par des tests simples, ajuster les sélecteurs

### R-2 : Codemods Ne Fonctionnent Pas
**Impact** : 🟠 Élevé  
**Probabilité** : Faible  
**Mitigation** : Utiliser codemods officiels en priorité, adapter les custom

### R-3 : Webpack Incompatible Webpack 5
**Impact** : 🔴 Critique (pour pwc-ui)  
**Probabilité** : Moyenne  
**Mitigation** : Prévoir migration vers Angular CLI natif

### R-4 : Dry-Run Révèle Problèmes Majeurs
**Impact** : 🟠 Élevé  
**Probabilité** : Moyenne  
**Mitigation** : Ajuster le plan de migration, augmenter les estimations
