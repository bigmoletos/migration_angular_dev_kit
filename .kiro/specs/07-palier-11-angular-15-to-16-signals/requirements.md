# Requirements - Palier 11 : Angular 15.2 → 16.2 (Signals)

## Objectifs

### Objectif Principal
Migrer Angular 15.2 vers 16.2 en découvrant Signals, le nouveau système de réactivité qui coexiste avec RxJS.

### Objectifs Spécifiques
1. Découvrir et comprendre Signals
2. Supprimer ngcc (toutes les libs doivent être Ivy)
3. Mettre à jour TypeScript 4.9+
4. Utiliser Required Inputs
5. Décider de l'adoption de Signals (optionnel)

## Contexte

### Situation Actuelle
- Angular 15.2 avec RxJS uniquement
- ngcc encore présent pour certaines libs
- TypeScript 4.8
- Inputs non requis par défaut

### Situation Cible
- Angular 16.2 avec Signals disponibles
- ngcc supprimé (toutes les libs Ivy)
- TypeScript 4.9+
- Required Inputs disponibles
- Décision prise sur l'adoption de Signals

## Contraintes

### Techniques
- **Durée estimée** : 1-2 semaines
- **Complexité** : 🟠 Élevée
- **Criticité** : Nouveau paradigme de réactivité
- **Tests** : >95% doivent passer
- **Ordre** : pwc-ui-shared AVANT pwc-ui

### Breaking Changes
1. **Signals introduits** : Nouveau système de réactivité
2. **ngcc supprimé** : Toutes les bibliothèques doivent être Ivy
3. **TypeScript 4.9+** : Nouvelles fonctionnalités (satisfies operator)
4. **Required Inputs** : `@Input({ required: true })` disponible

## Critères d'Acceptation

### pwc-ui-shared
- [ ] Angular 16.2 installé
- [ ] TypeScript 4.9+ installé
- [ ] Toutes les libs compatibles Ivy
- [ ] ngcc supprimé
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Décision Signals documentée (migrer ou pas)
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 16.2 installé
- [ ] TypeScript 4.9+ installé
- [ ] Toutes les libs compatibles Ivy
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre
- [ ] Tests manuels OK
- [ ] Tag Git créé

## Qu'est-ce que Signals ?

### Concept
Signals est un nouveau système de réactivité pour Angular, plus simple et plus performant que RxJS pour certains cas d'usage.

### Exemple de Base
```typescript
import { Component, signal, computed, effect } from '@angular/core';

@Component({
  selector: 'app-counter',
  template: `
    <div>Count: {{ count() }}</div>
    <div>Double: {{ double() }}</div>
    <button (click)="increment()">+1</button>
  `
})
export class CounterComponent {
  count = signal(0);
  double = computed(() => this.count() * 2);
  
  constructor() {
    effect(() => {
      console.log('Count changed:', this.count());
    });
  }
  
  increment() {
    this.count.update(value => value + 1);
  }
}
```

### Quand Utiliser Signals vs RxJS ?

**Signals** :
- État local du composant
- Valeurs synchrones
- Calculs dérivés simples
- Pas besoin d'opérateurs complexes

**RxJS** :
- Opérations asynchrones (HTTP, timers)
- Streams d'événements
- Opérateurs complexes (debounce, switchMap, etc.)
- Gestion d'erreurs avancée

## Risques Identifiés

### Risque 1 : Bibliothèque Incompatible (ngcc requis)
- **Probabilité** : Moyenne
- **Impact** : Élevé
- **Mitigation** : Mettre à jour vers version Ivy ou remplacer

### Risque 2 : Courbe d'Apprentissage Signals
- **Probabilité** : Élevée
- **Impact** : Faible
- **Mitigation** : Signals est optionnel, peut rester avec RxJS

### Risque 3 : Migration Prématurée vers Signals
- **Probabilité** : Moyenne
- **Impact** : Moyen
- **Mitigation** : Décision réfléchie, migration progressive si adoptée

## Dépendances

### Prérequis
- Palier 10 (Angular 15) complété et validé
- Node.js v18 installé
- Tests passent sur Angular 15

### Dépendances Externes
- Angular CLI 16.2
- TypeScript 4.9+
- Toutes les libs tierces compatibles Ivy

## Ressources

### Documentation
- [Angular 16 Release Notes](https://blog.angular.io/angular-v16-is-here-4d7a28ec680d)
- [Signals Guide](https://angular.io/guide/signals)
- [RxJS Interop](https://angular.io/guide/rxjs-interop)

### Outils
- Angular CLI migration schematics
- toObservable / toSignal pour interop RxJS
