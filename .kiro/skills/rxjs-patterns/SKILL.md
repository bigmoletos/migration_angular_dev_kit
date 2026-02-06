---
name: rxjs-patterns
displayName: RxJS Patterns & Migration
description: Patterns RxJS modernes et migration 5→6→7
version: 1.0.0

loadOn:
  keywords:
    - rxjs
    - observable
    - subscribe
    - pipe
    - operator
    - subscription
  filePatterns:
    - "*.service.ts"
    - "*.component.ts"
  manual: "#rxjs"

tokenEstimate: 4000
priority: medium

requires: []
mcpNeeds:
  - filesystem
---

# 🔄 RxJS Patterns Skill

## Activation

Se charge quand : "rxjs", "observable", "subscribe", "pipe"

---

## 📊 Migration RxJS 5 → 6

### Imports

```typescript
// ❌ RxJS 5 (ANCIEN)
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';

// ✅ RxJS 6+ (NOUVEAU)
import { Observable, Subject, of, from } from 'rxjs';
import { map, filter, catchError, switchMap } from 'rxjs/operators';
```

### Chaînage

```typescript
// ❌ ANCIEN (méthodes chaînées)
this.http.get('/api/data')
  .map(res => res.json())
  .filter(data => data.active)
  .catch(err => Observable.of(null));

// ✅ NOUVEAU (pipe)
this.http.get('/api/data').pipe(
  map(res => res.json()),
  filter(data => data.active),
  catchError(err => of(null))
);
```

### Création d'Observables

```typescript
// ❌ ANCIEN
Observable.of(1, 2, 3);
Observable.from([1, 2, 3]);
Observable.throw(new Error('oops'));

// ✅ NOUVEAU
of(1, 2, 3);
from([1, 2, 3]);
throwError(() => new Error('oops'));
```

---

## 🎯 Patterns Recommandés

### Gestion des Subscriptions

```typescript
// ✅ Pattern avec takeUntil
export class MyComponent implements OnDestroy {
  private destroy$ = new Subject<void>();

  ngOnInit() {
    this.myService.getData().pipe(
      takeUntil(this.destroy$)
    ).subscribe(data => {
      // ...
    });
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

### Async Pipe (Préféré)

```typescript
// ✅ Pattern avec async pipe - PAS de subscribe manuel
@Component({
  template: `
    @if (data$ | async; as data) {
      <div>{{ data.name }}</div>
    }
  `
})
export class MyComponent {
  data$ = this.service.getData();
}
```

### Error Handling

```typescript
// ✅ Pattern avec catchError
this.http.get('/api/data').pipe(
  catchError(error => {
    console.error('Error:', error);
    return of({ data: [], error: true }); // Fallback
  })
);
```

### Retry Logic

```typescript
// ✅ Pattern avec retry
this.http.get('/api/data').pipe(
  retry(3),
  catchError(err => {
    // Après 3 tentatives
    return throwError(() => err);
  })
);
```

---

## ⚠️ Anti-Patterns à Éviter

### Subscribe dans Subscribe

```typescript
// ❌ MAUVAIS
this.service.getUser().subscribe(user => {
  this.service.getOrders(user.id).subscribe(orders => {
    // Nested subscribe = callback hell
  });
});

// ✅ BON
this.service.getUser().pipe(
  switchMap(user => this.service.getOrders(user.id))
).subscribe(orders => {
  // Flat and clean
});
```

### Oublier de Unsubscribe

```typescript
// ❌ MAUVAIS - Memory leak
ngOnInit() {
  this.service.getData().subscribe(data => {
    this.data = data;
  });
}

// ✅ BON - Avec cleanup
private subscription: Subscription;

ngOnInit() {
  this.subscription = this.service.getData().subscribe(data => {
    this.data = data;
  });
}

ngOnDestroy() {
  this.subscription?.unsubscribe();
}
```

### Any Type sur Observables

```typescript
// ❌ MAUVAIS
getData(): Observable<any> { ... }

// ✅ BON
getData(): Observable<User[]> { ... }
```

---

## 🔧 Commandes de Migration

```bash
# Installation du helper de migration
npm install -g rxjs-tslint

# Migration automatique
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Installation temporaire pour transition
npm install rxjs-compat

# Après migration complète, supprimer
npm uninstall rxjs-compat
```

---

## 📋 Checklist RxJS

- [ ] Tous les imports convertis vers `rxjs` et `rxjs/operators`
- [ ] Toutes les chaînes converties en `.pipe()`
- [ ] Pas de `rxjs/add/operator/*`
- [ ] Tous les `Observable.of()` → `of()`
- [ ] Tous les `Observable.throw()` → `throwError()`
- [ ] Subscriptions gérées (takeUntil ou unsubscribe)
- [ ] Pas de subscribe dans subscribe
- [ ] Types explicites sur les Observables
