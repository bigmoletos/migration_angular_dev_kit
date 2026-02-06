# Requirements - Palier 4 : Angular 8.2 → 9.1 (Ivy)

## Objectifs

### Objectif Principal
Migrer Angular 8.2 vers 9.1 en activant Ivy, le nouveau moteur de rendu qui remplace View Engine.

### Objectifs Spécifiques
1. Activer Ivy comme moteur de rendu par défaut
2. Typer tous les `ModuleWithProviders<T>`
3. Supprimer tous les `entryComponents` (obsolètes avec Ivy)
4. Valider que le rendu fonctionne correctement
5. Vérifier que les composants dynamiques fonctionnent
6. Obtenir des bundles plus petits (-10 à -30%)

## Contexte

### Situation Actuelle
- Angular 8.2 avec View Engine
- `ModuleWithProviders` non typés
- `entryComponents` utilisés pour les composants dynamiques
- Bundles de taille ~2.5 MB

### Situation Cible
- Angular 9.1 avec Ivy activé
- Tous les `ModuleWithProviders` typés avec `<T>`
- `entryComponents` supprimés (Ivy les détecte automatiquement)
- Bundles réduits de 10-30%
- Meilleure performance de rendu

## Contraintes

### Techniques
- **Durée estimée** : 2 semaines
- **Complexité** : 🔴 Très Élevée
- **Criticité** : Changement architectural majeur
- **Tests** : >95% doivent passer
- **Ordre** : pwc-ui-shared AVANT pwc-ui

### Breaking Changes
1. **Ivy obligatoire** : View Engine déprécié
2. **ModuleWithProviders typé** : `ModuleWithProviders<MyModule>` requis
3. **entryComponents obsolète** : Doit être supprimé
4. **@ViewChild/@ContentChild** : Flag `static` obligatoire (ajouté en Angular 8)
5. **Comportements de rendu** : Peuvent changer avec Ivy

## Critères d'Acceptation

### pwc-ui-shared
- [ ] Angular 9.1 installé
- [ ] Ivy activé (`enableIvy: true` dans tsconfig.json)
- [ ] 100% des `ModuleWithProviders` typés
- [ ] 100% des `entryComponents` supprimés
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Bundles plus petits (-10 à -30%)
- [ ] Composants dynamiques testés et fonctionnels
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 9.1 installé
- [ ] Ivy activé
- [ ] 100% des `ModuleWithProviders` typés
- [ ] 100% des `entryComponents` supprimés
- [ ] Webpack adapté si nécessaire
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre sans erreurs
- [ ] Composants dynamiques testés (dialogs, modals)
- [ ] Lazy loading testé
- [ ] Tests manuels OK
- [ ] Tag Git créé

## Risques Identifiés

### Risque 1 : Composants Dynamiques Cassés
- **Probabilité** : Moyenne
- **Impact** : Élevé
- **Mitigation** : Tests approfondis de tous les dialogs/modals

### Risque 2 : Comportements de Rendu Différents
- **Probabilité** : Moyenne
- **Impact** : Moyen
- **Mitigation** : Tests visuels et fonctionnels complets

### Risque 3 : Bundles Plus Gros
- **Probabilité** : Faible
- **Impact** : Moyen
- **Mitigation** : Vérifier configuration AOT et buildOptimizer

## Dépendances

### Prérequis
- Palier 3 (Angular 8) complété et validé
- Node.js v10 installé
- Tests passent sur Angular 8

### Dépendances Externes
- Angular CLI 9.1
- TypeScript 3.7+
- RxJS 6.6+

## Ressources

### Documentation
- [Ivy Compatibility Guide](https://angular.io/guide/ivy-compatibility)
- [Ivy Migration Guide](https://angular.io/guide/ivy)
- [Angular 9 Release Notes](https://blog.angular.io/version-9-of-angular-now-available-project-ivy-has-arrived-23c97b63cfa3)
- Steering : `.kiro/steering/04-ivy-migration-guide.md`

### Outils
- Angular CLI migration schematics
- Codemod pour `ModuleWithProviders`
- grep pour rechercher les patterns
