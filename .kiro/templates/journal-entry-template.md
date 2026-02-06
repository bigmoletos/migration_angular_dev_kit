# Template d'Entrée Journal de Bord

Copier ce template dans `Documentation/JOURNAL-DE-BORD.md` après chaque changement majeur.

---

## [DATE] - [PALIER/PHASE] - [TITRE]

**Contexte** : 
[Décrire le contexte : quel palier, quelle phase, quel objectif]

**Actions Effectuées** :
- [ ] Action 1
- [ ] Action 2
- [ ] Action 3

**Résultat** : 
[Décrire le résultat obtenu : succès, échec partiel, etc.]

**Problèmes Rencontrés** :
1. **Problème 1** : [Description]
   - Cause : [Cause identifiée]
   - Impact : [Impact sur le projet]

2. **Problème 2** : [Description]
   - Cause : [Cause identifiée]
   - Impact : [Impact sur le projet]

**Solutions Appliquées** :
1. **Pour Problème 1** : [Solution détaillée]
2. **Pour Problème 2** : [Solution détaillée]

**Décisions Techniques** :
- Décision 1 : [Raison]
- Décision 2 : [Raison]

**Métriques** :
- Temps estimé : [X] jours/semaines
- Temps réel : [Y] jours/semaines
- Tests passants : [Z]%
- Build : ✅ / ❌

**Leçons Apprises** :
- Leçon 1
- Leçon 2

**Prochaines Étapes** :
- [ ] Étape 1
- [ ] Étape 2

**Tags** : `#palier-X` `#angular-Y` `#problème` `#solution`

---

## Exemples d'Entrées

### Exemple 1 : Palier Complété
```markdown
## 2026-02-10 - Palier 1 - Migration RxJS 5 → 6 Complétée

**Contexte** : 
Migration de tous les opérateurs RxJS de la syntaxe chaînée vers la syntaxe pipeable pour pwc-ui-shared et pwc-ui.

**Actions Effectuées** :
- [x] Installation de rxjs-compat dans les deux repos
- [x] Exécution du codemod rxjs-5-to-6-migrate
- [x] Migration manuelle de 15 fichiers complexes
- [x] Adaptation des tests HttpClient
- [x] Validation build et tests
- [x] Publication pwc-ui-shared@2.6.26 sur Nexus

**Résultat** : 
✅ Migration réussie. 100% des tests passent dans les deux repos. Application fonctionne sans régression.

**Problèmes Rencontrés** :
1. **Imports circulaires** : 3 services avaient des imports circulaires révélés par la migration
   - Cause : Architecture de services mal organisée
   - Impact : Erreurs de compilation

2. **Tests HttpClient** : 45 tests échouaient après migration
   - Cause : Utilisation de MockBackend (Angular 5) au lieu de HttpClientTestingModule
   - Impact : Tests bloquants

**Solutions Appliquées** :
1. **Pour imports circulaires** : Refactoring de l'architecture des services, création d'un service intermédiaire
2. **Pour tests HttpClient** : Migration vers HttpClientTestingModule, adaptation de tous les mocks

**Décisions Techniques** :
- Garder rxjs-compat jusqu'au Palier 2 : Permet une migration progressive
- Migrer tous les tests en une fois : Évite les incohérences

**Métriques** :
- Temps estimé : 1-2 semaines
- Temps réel : 1.5 semaines
- Tests passants : 100%
- Build : ✅

**Leçons Apprises** :
- Le codemod automatique fonctionne bien mais nécessite une revue manuelle
- Les imports circulaires sont plus faciles à détecter après migration RxJS
- Prévoir du temps pour adapter les tests (20% du temps total)

**Prochaines Étapes** :
- [ ] Palier 2 : Retirer rxjs-compat
- [ ] Vérifier tous les imports RxJS
- [ ] Nettoyer le code obsolète

**Tags** : `#palier-1` `#angular-6` `#rxjs-6` `#succès`
```

### Exemple 2 : Problème Critique Résolu
```markdown
## 2026-02-15 - Palier 4 - Résolution Problème Ivy

**Contexte** : 
Après migration vers Angular 9 avec Ivy, l'application ne démarrait plus avec une erreur "Cannot read property 'ɵcmp' of undefined".

**Actions Effectuées** :
- [x] Analyse des logs d'erreur
- [x] Vérification de la configuration Ivy
- [x] Test avec enableIvy: false
- [x] Identification du composant problématique
- [x] Refactoring du composant

**Résultat** : 
✅ Problème résolu. Application démarre correctement avec Ivy activé.

**Problèmes Rencontrés** :
1. **Composant dynamique incompatible** : MyDialogComponent utilisait une syntaxe View Engine
   - Cause : ComponentFactoryResolver avec entryComponents
   - Impact : Application ne démarre pas

**Solutions Appliquées** :
1. **Refactoring du composant** : 
   - Suppression de entryComponents
   - Simplification du chargement dynamique avec Ivy
   - Utilisation directe de ViewContainerRef.createComponent()

**Décisions Techniques** :
- Migrer tous les composants dynamiques vers la syntaxe Ivy : Évite les problèmes futurs

**Métriques** :
- Temps de résolution : 4 heures
- Impact : Bloquant
- Tests passants : 100% après résolution

**Leçons Apprises** :
- Ivy change fondamentalement le chargement des composants dynamiques
- Toujours tester les composants dynamiques après migration Ivy
- La documentation officielle Ivy est essentielle

**Prochaines Étapes** :
- [x] Vérifier tous les autres composants dynamiques
- [x] Documenter le pattern Ivy pour l'équipe

**Tags** : `#palier-4` `#angular-9` `#ivy` `#problème-critique` `#résolu`
```

### Exemple 3 : Décision Technique
```markdown
## 2026-02-20 - Palier 7 - Décision Webpack

**Contexte** : 
Choix entre migrer vers Angular CLI natif ou adapter les configs Webpack custom pour Webpack 5.

**Actions Effectuées** :
- [x] Analyse des configs Webpack actuelles
- [x] Évaluation des deux options
- [x] Tests de migration CLI natif
- [x] Estimation du temps pour chaque option

**Résultat** : 
✅ Décision prise : Migration vers Angular CLI natif avec @angular-builders/custom-webpack pour les customisations minimales.

**Décisions Techniques** :
- **Migration CLI natif** : 
  - Raison 1 : Maintenance simplifiée (mises à jour automatiques)
  - Raison 2 : Moins de dette technique
  - Raison 3 : Optimisations Angular intégrées
  - Raison 4 : Temps de migration similaire (3-5 jours vs 3-5 jours)

**Métriques** :
- Temps de décision : 1 jour
- Temps de migration estimé : 3-5 jours
- Customisations à garder : 3 (obfuscation, variables env, optimisations)

**Leçons Apprises** :
- Les configs Webpack custom sont difficiles à maintenir
- Angular CLI natif couvre 90% des besoins
- @angular-builders/custom-webpack est une bonne solution pour les 10% restants

**Prochaines Étapes** :
- [ ] Migrer webpack.dev.config.js vers angular.json
- [ ] Migrer webpack.prod.config.js vers angular.json
- [ ] Configurer @angular-builders/custom-webpack
- [ ] Tester le build

**Tags** : `#palier-7` `#angular-12` `#webpack-5` `#décision-technique`
```

---

## Quand Mettre à Jour le Journal ?

### Obligatoire
- ✅ Fin d'un palier (succès ou échec)
- ✅ Problème critique résolu
- ✅ Décision technique majeure
- ✅ Changement d'architecture

### Recommandé
- ✅ Problème intéressant résolu
- ✅ Leçon apprise importante
- ✅ Optimisation significative
- ✅ Découverte d'un pattern utile

### Optionnel
- ✅ Petits problèmes résolus
- ✅ Améliorations mineures
- ✅ Notes pour l'équipe

---

## Format Minimal

Si vous manquez de temps, utilisez ce format minimal :

```markdown
## [DATE] - [TITRE]

**Quoi** : [Ce qui a été fait]
**Résultat** : [Succès/Échec]
**Problèmes** : [Liste]
**Solutions** : [Liste]
**Temps** : [Réel vs estimé]

---
```
