# Design - Palier 11 : Angular 15.2 → 16.2 (Signals)

## Architecture

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────┐
│              PALIER 11 : SIGNALS                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Phase 1: pwc-ui-shared                                 │
│  ├─ Migration Angular 15 → 16                           │
│  ├─ Vérification libs compatibles Ivy                   │
│  ├─ Découverte Signals (optionnel)                      │
│  ├─ Required Inputs (optionnel)                         │
│  └─ Décision adoption Signals                           │
│                                                          │
│  Phase 2: pwc-ui                                        │
│  ├─ Mise à jour @pwc/shared                             │
│  ├─ Migration Angular 15 → 16                           │
│  ├─ Même décision Signals que Shared                    │
│  └─ Tests complets                                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Nouveau Paradigme : Signals

#### Comparaison RxJS vs Signals

```typescript
// ═══════════════════════════════════════════════════════
// AVANT : RxJS (Angular 15)
// ═══════════════════════════════════════════════════════
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

// ═══════════════════════════════════════════════════════
// APRÈS : Signals (Angular 16)
// ═══════════════════════════════════════════════════════
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

**Avantages Signals** :
- ✅ Plus simple (pas de `async` pipe)
- ✅ Plus performant (change detection optimisée)
- ✅ Moins de code
- ✅ Meilleure intégration avec les templates

**Quand Garder RxJS** :
- ⚠️ Opérations asynchrones (HTTP)
- ⚠️ Opérateurs complexes (debounce, switchMap)
- ⚠️ Gestion d'erreurs avancée
- ⚠️ Code existant stable

## Stratégie de Migration

### Phase 1 : pwc-ui-shared

#### Étape 1 : Migration Angular
```bash
ng update @angular/cli@16 @angular/core@16 --allow-dirty
```

**Résultat** :
- Angular 16.2 installé
- TypeScript 4.9+ installé
- Signals disponibles

#### Étape 2 : Vérification Bibliothèques Tierces

**Problème** : ngcc est supprimé, toutes les libs doivent être Ivy.

**Vérifier** :
```bash
npm list
```

**Bibliothèques à risque** :
- PrimeNG (doit être v15+)
- NgRx (doit être v15+)
- Autres libs Angular

**Actions** :
1. Mettre à jour vers version compatible
2. OU remplacer par alternative
3. OU contacter mainteneur

#### Étape 3 : Découverte Signals (Optionnel)

**Note** : Signals est optionnel en Angular 16.

**Décision à prendre** :
- **Option A** : Adopter Signals progressivement
- **Option B** : Rester avec RxJS (stable)

**Critères de décision** :
- Complexité du code existant
- Temps disponible
- Bénéfices attendus
- Courbe d'apprentissage équipe

#### Étape 4 : Build et Tests
```bash
npm run build
npm test
```

### Phase 2 : pwc-ui

Même processus que pwc-ui-shared.

## Patterns Signals

### Pattern 1 : État Local Simple

```typescript
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-toggle',
  template: `
    <button (click)="toggle()">
      {{ isOpen() ? 'Close' : 'Open' }}
    </button>
    <div *ngIf="isOpen()">Content</div>
  `
})
export class ToggleComponent {
  isOpen = signal(false);
  
  toggle() {
    this.isOpen.update(value => !value);
  }
}
```

### Pattern 2 : Computed Values

```typescript
import { Component, signal, computed } from '@angular/core';

interface Item {
  name: string;
  price: number;
}

@Component({
  selector: 'app-cart',
  template: `
    <div>Items: {{ items().length }}</div>
    <div>Total: {{ total() }}€</div>
    <button (click)="addItem()">Add Item</button>
  `
})
export class CartComponent {
  items = signal<Item[]>([]);
  
  // Computed signal (dérivé automatiquement)
  total = computed(() => 
    this.items().reduce((sum, item) => sum + item.price, 0)
  );
  
  addItem() {
    this.items.update(items => [
      ...items, 
      { name: 'Item', price: 10 }
    ]);
  }
}
```

### Pattern 3 : Effects (Side Effects)

```typescript
import { Component, signal, effect } from '@angular/core';

@Component({
  selector: 'app-logger',
  template: `
    <input [value]="name()" (input)="name.set($event.target.value)">
  `
})
export class LoggerComponent {
  name = signal('');
  
  constructor() {
    // Effect s'exécute quand name change
    effect(() => {
      console.log('Name changed:', this.name());
      localStorage.setItem('name', this.name());
    });
  }
}
```

### Pattern 4 : Interop avec RxJS

```typescript
import { Component, signal } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { interval } from 'rxjs';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-interop',
  template: `
    <div>Count: {{ count() }}</div>
    <div>Timer: {{ timer() }}</div>
  `
})
export class InteropComponent {
  // Signal → Observable
  count = signal(0);
  count$ = toObservable(this.count);
  
  // Observable → Signal
  timer$ = interval(1000).pipe(map(n => n));
  timer = toSignal(this.timer$, { initialValue: 0 });
  
  increment() {
    this.count.update(v => v + 1);
  }
}
```

### Pattern 5 : Required Inputs

```typescript
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-user-card',
  template: `
    <div>{{ name }}</div>
    <div>{{ email }}</div>
  `
})
export class UserCardComponent {
  // AVANT (Angular 15)
  @Input() name!: string;  // Peut être undefined
  
  // APRÈS (Angular 16)
  @Input({ required: true }) name!: string;  // Obligatoire
  @Input({ required: true }) email!: string;
}
```

## Décision : Adopter Signals ou Pas ?

### Scénario A : Adopter Signals Progressivement

**Avantages** :
- ✅ Code plus moderne
- ✅ Meilleures performances
- ✅ Moins de boilerplate

**Inconvénients** :
- ⚠️ Temps de migration
- ⚠️ Courbe d'apprentissage
- ⚠️ Coexistence RxJS/Signals

**Stratégie** :
1. Nouveaux composants : Signals
2. Composants existants simples : Migrer progressivement
3. Composants complexes avec RxJS : Garder RxJS

### Scénario B : Rester avec RxJS

**Avantages** :
- ✅ Pas de migration
- ✅ Code stable
- ✅ Équipe familière

**Inconvénients** :
- ⚠️ Pas de bénéfices Signals
- ⚠️ Code plus verbeux

**Stratégie** :
1. Garder RxJS partout
2. Réévaluer dans 6-12 mois

## Gestion des Erreurs

### Erreur 1 : Bibliothèque incompatible (ngcc requis)
**Solution** : Mettre à jour vers version Ivy ou remplacer

### Erreur 2 : Signals ne fonctionnent pas
**Cause** : Angular 16+ requis
**Solution** : Vérifier version Angular

### Erreur 3 : "Cannot read property of undefined"
**Cause** : Signal non initialisé
**Solution** : Toujours initialiser les signals

```typescript
// ❌ MAUVAIS
count = signal();  // Erreur

// ✅ BON
count = signal(0);  // Initialisé
```

## Métriques de Validation

### Métriques Techniques

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Angular 16.2 | ✅ | ✅ | |
| TypeScript 4.9+ | ✅ | ✅ | |
| Libs compatibles | ✅ | ✅ | |
| ngcc supprimé | ✅ | ✅ | |
| Application démarre | N/A | ✅ | |

### Métriques de Décision Signals

| Critère | Poids | Score RxJS | Score Signals |
|---------|-------|------------|---------------|
| Simplicité code | 30% | 6/10 | 9/10 |
| Performance | 20% | 7/10 | 9/10 |
| Courbe apprentissage | 20% | 9/10 | 6/10 |
| Stabilité | 30% | 10/10 | 7/10 |

## Rollback

Si le palier échoue :

```bash
git reset --hard palier-10-angular-15-shared
rm -rf node_modules package-lock.json
npm install
npm run build
npm test
```

## Documentation

### Fichiers à Mettre à Jour
- `.kiro/state/strands-state.json` : État du palier
- `Documentation/JOURNAL-DE-BORD.md` : Décision Signals
- `README.md` : Version Angular

### Informations à Documenter
- Décision Signals (adopter ou pas)
- Justification de la décision
- Bibliothèques mises à jour
- Problèmes rencontrés
- Temps réel vs estimé
