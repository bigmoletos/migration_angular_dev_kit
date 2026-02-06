# Spec Palier 11 : Angular 15.2 → 16.2 (Signals)

**Durée estimée** : 1-2 semaines  
**Complexité** : 🟠 Élevée  
**Criticité** : Nouveau paradigme de réactivité

---

## 🎯 Objectifs

1. Migrer Angular 15.2 → 16.2
2. Découvrir Signals (nouvelle réactivité)
3. Supprimer ngcc (toutes les libs doivent être Ivy)
4. Mettre à jour TypeScript 4.9+
5. Valider build et tests

---

## 📋 Breaking Changes

### 1. Signals Introduits
- Nouveau système de réactivité
- Alternative à RxJS pour certains cas
- Coexiste avec RxJS

### 2. ngcc Supprimé
- Toutes les bibliothèques doivent être compilées avec Ivy
- Les anciennes libs View Engine ne fonctionnent plus

### 3. TypeScript 4.9+ Requis
- Nouvelles fonctionnalités TypeScript
- `satisfies` operator disponible

### 4. Required Inputs
```typescript
@Component({...})
export class MyComponent {
  @Input({ required: true }) name!: string;
}
```

---

## 🎯 Qu'est-ce que Signals ?

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
  // Signal
  count = signal(0);
  
  // Computed signal (dérivé)
  double = computed(() => this.count() * 2);
  
  // Effect (side effect)
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

---

## 🔄 Ordre d'Exécution

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Créer une branche
git checkout -b palier-11-angular-16-signals

# Créer un tag de sauvegarde
git tag palier-10-angular-15-shared

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 15)
- [ ] Tests passent

---

#### Étape 1.2 : Mettre à jour Angular
```bash
# Dry-run
ng update @angular/cli@16 @angular/core@16 --dry-run

# Appliquer
ng update @angular/cli@16 @angular/core@16 --allow-dirty
```

**Ce qui change** :
- Angular 16.2 installé
- TypeScript 4.9+ installé
- Signals disponibles
- ngcc supprimé

**Validation** :
- [ ] Angular 16.2 installé
- [ ] TypeScript 4.9+ installé
- [ ] Compilation réussie

---

#### Étape 1.3 : Vérifier les Bibliothèques Tierces

**Problème** : ngcc est supprimé, toutes les libs doivent être Ivy.

**Vérifier** :
```bash
npm list
```

**Bibliothèques à risque** :
- PrimeNG (doit être v15+)
- NgRx (doit être v15+)
- Autres libs Angular

**Si une lib n'est pas compatible** :
1. Mettre à jour vers une version compatible
2. OU remplacer par une alternative
3. OU contacter le mainteneur

**Validation** :
- [ ] Toutes les libs compatibles Ivy
- [ ] Aucune erreur ngcc

---

#### Étape 1.4 : Découvrir Signals (Optionnel)

**Note** : Signals est optionnel en Angular 16. Vous pouvez continuer à utiliser RxJS.

**Exemple de migration** (optionnel) :

##### AVANT (RxJS)
```typescript
import { Component } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'app-counter',
  template: `
    <div>Count: {{ count$ | async }}</div>
    <button (click)="increment()">+1</button>
  `
})
export class CounterComponent {
  count$ = new BehaviorSubject(0);
  
  increment() {
    this.count$.next(this.count$.value + 1);
  }
}
```

##### APRÈS (Signals)
```typescript
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-counter',
  template: `
    <div>Count: {{ count() }}</div>
    <button (click)="increment()">+1</button>
  `
})
export class CounterComponent {
  count = signal(0);
  
  increment() {
    this.count.update(value => value + 1);
  }
}
```

**Avantages** :
- Plus simple (pas de `async` pipe)
- Plus performant (change detection optimisée)
- Moins de code

**Validation** :
- [ ] Signals compris (lecture documentation)
- [ ] Décision prise : migrer ou pas

---

#### Étape 1.5 : Utiliser Required Inputs (Optionnel)

```typescript
// AVANT
@Component({...})
export class MyComponent {
  @Input() name!: string; // Peut être undefined
}

// APRÈS
@Component({...})
export class MyComponent {
  @Input({ required: true }) name!: string; // Obligatoire
}
```

**Validation** :
- [ ] Required inputs utilisés si pertinent

---

#### Étape 1.6 : Build
```bash
npm run build
```

**Validation** :
- [ ] Build réussi
- [ ] Aucune erreur ngcc

---

#### Étape 1.7 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 1.8 : Publication sur Nexus
```bash
# Incrémenter la version (minor car Signals)
npm version minor

# Publier
npm publish
```

**Validation** :
- [ ] Version incrémentée
- [ ] Publication réussie

---

#### Étape 1.9 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 16 with Signals support"
git tag palier-11-shared-angular-16-signals
git push origin palier-11-angular-16-signals
git push origin palier-11-shared-angular-16-signals
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé
- [ ] Push réussi

---

### Phase 2 : pwc-ui (PRIORITÉ 2)

#### Étape 2.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia

# Créer une branche
git checkout -b palier-11-angular-16-signals

# Créer un tag de sauvegarde
git tag palier-10-angular-15-ui

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 15)

---

#### Étape 2.2 : Mettre à jour @pwc/shared
```bash
npm install @pwc/shared@latest
```

**Validation** :
- [ ] `@pwc/shared` mis à jour

---

#### Étape 2.3 : Mettre à jour Angular
```bash
ng update @angular/cli@16 @angular/core@16 --allow-dirty
```

**Validation** :
- [ ] Angular 16.2 installé
- [ ] TypeScript 4.9+ installé

---

#### Étape 2.4 : Vérifier les Bibliothèques Tierces
Même processus que pwc-ui-shared (Étape 1.3).

**Validation** :
- [ ] Toutes les libs compatibles

---

#### Étape 2.5 : Découvrir Signals (Optionnel)
Même processus que pwc-ui-shared (Étape 1.4).

**Validation** :
- [ ] Décision prise

---

#### Étape 2.6 : Build
```bash
npm run build
```

**Validation** :
- [ ] Build réussi

---

#### Étape 2.7 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 2.8 : Test Manuel
```bash
npm start
```

**Tester** :
- [ ] Application démarre
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Aucune erreur console
- [ ] Aucune régression

---

#### Étape 2.9 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 16 with Signals support"
git tag palier-11-ui-angular-16-signals
git push origin palier-11-angular-16-signals
git push origin palier-11-ui-angular-16-signals
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé

---

## 📊 Patterns Signals

### Pattern 1 : État Local Simple
```typescript
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-toggle',
  template: `
    <button (click)="toggle()">
      {{ isOpen() ? 'Close' : 'Open' }}
    </button>
  `
})
export class ToggleComponent {
  isOpen = signal(false);
  
  toggle() {
    this.isOpen.update(value => !value);
  }
}
```

---

### Pattern 2 : Computed Values
```typescript
import { Component, signal, computed } from '@angular/core';

@Component({
  selector: 'app-cart',
  template: `
    <div>Items: {{ items().length }}</div>
    <div>Total: {{ total() }}€</div>
  `
})
export class CartComponent {
  items = signal<Item[]>([]);
  
  total = computed(() => 
    this.items().reduce((sum, item) => sum + item.price, 0)
  );
  
  addItem(item: Item) {
    this.items.update(items => [...items, item]);
  }
}
```

---

### Pattern 3 : Effects
```typescript
import { Component, signal, effect } from '@angular/core';

@Component({...})
export class LoggerComponent {
  count = signal(0);
  
  constructor() {
    // Effect s'exécute quand count change
    effect(() => {
      console.log('Count:', this.count());
      localStorage.setItem('count', this.count().toString());
    });
  }
}
```

---

### Pattern 4 : Interop avec RxJS
```typescript
import { Component, signal } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { interval } from 'rxjs';

@Component({...})
export class InteropComponent {
  // Signal → Observable
  count = signal(0);
  count$ = toObservable(this.count);
  
  // Observable → Signal
  timer$ = interval(1000);
  timer = toSignal(this.timer$, { initialValue: 0 });
}
```

---

## 📊 Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Angular 16.2 | ✅ | ✅ | |
| TypeScript 4.9+ | ✅ | ✅ | |
| Libs compatibles | ✅ | ✅ | |
| ngcc supprimé | ✅ | ✅ | |
| Application démarre | N/A | ✅ | |

---

## ⚠️ Problèmes Connus et Solutions

### Problème 1 : Bibliothèque incompatible (ngcc requis)
**Solution** : Mettre à jour vers une version Ivy ou remplacer

### Problème 2 : Signals ne fonctionnent pas
**Cause** : Angular 16+ requis

**Solution** : Vérifier la version Angular

### Problème 3 : Erreur "Cannot read property of undefined"
**Cause** : Signal non initialisé

**Solution** : Toujours initialiser les signals

---

## 📚 Ressources

- [Angular 16 Release Notes](https://blog.angular.io/angular-v16-is-here-4d7a28ec680d)
- [Signals Guide](https://angular.io/guide/signals)
- [RxJS Interop](https://angular.io/guide/rxjs-interop)

---

## ✅ Checklist Finale

### pwc-ui-shared
- [ ] Angular 16.2 installé
- [ ] TypeScript 4.9+ installé
- [ ] Toutes les libs compatibles Ivy
- [ ] ngcc supprimé
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Décision Signals documentée
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

### Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Décision Signals documentée (migrer ou pas)
- [ ] Problèmes rencontrés documentés

---

## 🎯 Prochaine Étape

Une fois le Palier 11 validé, passer au **Palier 12 : Angular 16 → 17** (Control Flow Syntax).
