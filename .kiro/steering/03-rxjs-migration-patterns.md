---
inclusion: fileMatch
fileMatchPattern: "**/*.ts"
priority: 90
---

# Patterns de Migration RxJS 5 → 6/7

> **Contexte** : Palier 1 (Angular 5→6) - Migration RxJS critique

---

## 🎯 Objectif

Migrer tous les opérateurs RxJS 5 vers la syntaxe pipeable RxJS 6/7.

---

## 📋 Changements Principaux

### 1. Imports

#### AVANT (RxJS 5)
```typescript
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/switchMap';
import 'rxjs/add/observable/of';
import 'rxjs/add/observable/throw';
```

#### APRÈS (RxJS 6+)
```typescript
import { Observable, of, throwError } from 'rxjs';
import { map, filter, catchError, switchMap } from 'rxjs/operators';
```

---

### 2. Opérateurs Pipeable

#### AVANT (RxJS 5)
```typescript
observable
  .map(x => x * 2)
  .filter(x => x > 10)
  .catch(err => Observable.of(null))
  .do(x => console.log(x));
```

#### APRÈS (RxJS 6+)
```typescript
observable.pipe(
  map(x => x * 2),
  filter(x => x > 10),
  catchError(err => of(null)),
  tap(x => console.log(x))
);
```

---

## 🔄 Table de Conversion des Opérateurs

| RxJS 5 | RxJS 6+ | Notes |
|--------|---------|-------|
| `.do()` | `tap()` | Renommé |
| `.catch()` | `catchError()` | Renommé |
| `.switch()` | `switchAll()` | Renommé |
| `.finally()` | `finalize()` | Renommé |
| `.throw()` | `throwError()` | Fonction, pas opérateur |
| `Observable.of()` | `of()` | Fonction standalone |
| `Observable.throw()` | `throwError()` | Fonction standalone |
| `Observable.empty()` | `EMPTY` | Constante |
| `Observable.never()` | `NEVER` | Constante |
| `.merge()` | `merge()` | Fonction standalone |
| `.concat()` | `concat()` | Fonction standalone |
| `.combineLatest()` | `combineLatest()` | Fonction standalone |
| `.zip()` | `zip()` | Fonction standalone |
| `.forkJoin()` | `forkJoin()` | Fonction standalone |

---

## 📝 Patterns Courants

### Pattern 1 : HTTP Requests

#### AVANT
```typescript
this.http.get('/api/users')
  .map(res => res.json())
  .catch(err => Observable.throw(err))
  .subscribe(
    data => console.log(data),
    err => console.error(err)
  );
```

#### APRÈS
```typescript
this.http.get<User[]>('/api/users').pipe(
  catchError(err => throwError(() => err))
).subscribe({
  next: data => console.log(data),
  error: err => console.error(err)
});
```

---

### Pattern 2 : Transformation de Données

#### AVANT
```typescript
this.store.select('users')
  .map(users => users.filter(u => u.active))
  .map(users => users.length)
  .do(count => console.log('Active users:', count))
  .subscribe(count => this.activeCount = count);
```

#### APRÈS
```typescript
this.store.select('users').pipe(
  map(users => users.filter(u => u.active)),
  map(users => users.length),
  tap(count => console.log('Active users:', count))
).subscribe(count => this.activeCount = count);
```

---

### Pattern 3 : Gestion d'Erreurs

#### AVANT
```typescript
this.service.getData()
  .catch(err => {
    console.error(err);
    return Observable.of([]);
  })
  .subscribe(data => this.data = data);
```

#### APRÈS
```typescript
this.service.getData().pipe(
  catchError(err => {
    console.error(err);
    return of([]);
  })
).subscribe(data => this.data = data);
```

---

### Pattern 4 : Combinaison d'Observables

#### AVANT
```typescript
Observable.combineLatest(
  this.obs1,
  this.obs2,
  this.obs3
).map(([a, b, c]) => ({ a, b, c }))
 .subscribe(result => console.log(result));
```

#### APRÈS
```typescript
combineLatest([
  this.obs1,
  this.obs2,
  this.obs3
]).pipe(
  map(([a, b, c]) => ({ a, b, c }))
).subscribe(result => console.log(result));
```

---

### Pattern 5 : SwitchMap / MergeMap

#### AVANT
```typescript
this.searchTerm$
  .debounceTime(300)
  .distinctUntilChanged()
  .switchMap(term => this.service.search(term))
  .subscribe(results => this.results = results);
```

#### APRÈS
```typescript
this.searchTerm$.pipe(
  debounceTime(300),
  distinctUntilChanged(),
  switchMap(term => this.service.search(term))
).subscribe(results => this.results = results);
```

---

### Pattern 6 : Subjects

#### AVANT
```typescript
import { Subject } from 'rxjs/Subject';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { ReplaySubject } from 'rxjs/ReplaySubject';

const subject = new Subject();
const behavior = new BehaviorSubject(0);
const replay = new ReplaySubject(1);
```

#### APRÈS
```typescript
import { Subject, BehaviorSubject, ReplaySubject } from 'rxjs';

const subject = new Subject();
const behavior = new BehaviorSubject(0);
const replay = new ReplaySubject(1);
```

---

### Pattern 7 : Unsubscribe

#### AVANT
```typescript
export class MyComponent implements OnDestroy {
  subscription: Subscription;
  
  ngOnInit() {
    this.subscription = this.service.getData()
      .subscribe(data => this.data = data);
  }
  
  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
```

#### APRÈS (Même syntaxe, mais avec pipe)
```typescript
export class MyComponent implements OnDestroy {
  subscription: Subscription;
  
  ngOnInit() {
    this.subscription = this.service.getData().pipe(
      // opérateurs ici
    ).subscribe(data => this.data = data);
  }
  
  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
```

#### MIEUX (avec takeUntil)
```typescript
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

export class MyComponent implements OnDestroy {
  private destroy$ = new Subject<void>();
  
  ngOnInit() {
    this.service.getData().pipe(
      takeUntil(this.destroy$)
    ).subscribe(data => this.data = data);
  }
  
  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

---

## 🛠️ Codemod Automatique

### Installation
```bash
npm install -g rxjs-tslint
```

### Utilisation
```bash
# Dry-run (voir les changements sans appliquer)
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Appliquer les changements
rxjs-5-to-6-migrate -p src/tsconfig.app.json --apply
```

### Ou utiliser le codemod custom
```bash
node scripts_outils_ia/codemods/migrate-rxjs.js src/**/*.ts
```

---

## ⚠️ Pièges Courants

### 1. Observable.of() vs of()
```typescript
// ❌ ERREUR
import { Observable } from 'rxjs';
return Observable.of(data);

// ✅ CORRECT
import { of } from 'rxjs';
return of(data);
```

### 2. .catch() vs catchError()
```typescript
// ❌ ERREUR
.catch(err => of(null))

// ✅ CORRECT
.pipe(catchError(err => of(null)))
```

### 3. .do() vs tap()
```typescript
// ❌ ERREUR
.do(x => console.log(x))

// ✅ CORRECT
.pipe(tap(x => console.log(x)))
```

### 4. Oublier pipe()
```typescript
// ❌ ERREUR
observable
  .map(x => x * 2)
  .filter(x => x > 10);

// ✅ CORRECT
observable.pipe(
  map(x => x * 2),
  filter(x => x > 10)
);
```

### 5. Import incorrect
```typescript
// ❌ ERREUR
import { map } from 'rxjs';

// ✅ CORRECT
import { map } from 'rxjs/operators';
```

---

## 🔍 Vérification Post-Migration

### Checklist
- [ ] Tous les imports `rxjs/add/...` supprimés
- [ ] Tous les opérateurs utilisent `pipe()`
- [ ] `Observable.of()` remplacé par `of()`
- [ ] `Observable.throw()` remplacé par `throwError()`
- [ ] `.do()` remplacé par `tap()`
- [ ] `.catch()` remplacé par `catchError()`
- [ ] `.switch()` remplacé par `switchAll()`
- [ ] `.finally()` remplacé par `finalize()`
- [ ] Compilation réussie sans erreurs
- [ ] Tests passent

### Commandes de Vérification
```bash
# Chercher les anciens imports
grep -r "rxjs/add/" src/

# Chercher les anciens opérateurs
grep -r "\.do(" src/
grep -r "\.catch(" src/
grep -r "Observable\.of(" src/
grep -r "Observable\.throw(" src/

# Compiler
npm run build

# Tests
npm test
```

---

## 📚 Ressources

- [RxJS 6 Migration Guide](https://rxjs.dev/guide/v6/migration)
- [RxJS Operators](https://rxjs.dev/guide/operators)
- [Learn RxJS](https://www.learnrxjs.io/)

---

## 🎯 Stratégie de Migration

### Phase 1 : Installer rxjs-compat
```bash
npm install rxjs-compat --save
```
Permet de faire coexister RxJS 5 et 6 temporairement.

### Phase 2 : Migrer par modules
1. Commencer par les services (moins de dépendances)
2. Puis les composants simples
3. Enfin les composants complexes

### Phase 3 : Valider
- Build réussi
- Tests passent
- Application fonctionne

### Phase 4 : Retirer rxjs-compat (Palier 2)
```bash
npm uninstall rxjs-compat
```

---

## ✅ Exemple Complet de Migration

### AVANT (RxJS 5)
```typescript
import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import 'rxjs/add/operator/switchMap';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/of';

@Component({
  selector: 'app-user-search',
  template: `...`
})
export class UserSearchComponent implements OnInit {
  results$: Observable<User[]>;
  
  ngOnInit() {
    this.results$ = this.searchTerm$
      .debounceTime(300)
      .distinctUntilChanged()
      .filter(term => term.length > 2)
      .switchMap(term => this.userService.search(term))
      .map(users => users.slice(0, 10))
      .catch(err => {
        console.error(err);
        return Observable.of([]);
      });
  }
}
```

### APRÈS (RxJS 6+)
```typescript
import { Component, OnInit } from '@angular/core';
import { Observable, of } from 'rxjs';
import { 
  map, 
  filter, 
  debounceTime, 
  distinctUntilChanged, 
  switchMap, 
  catchError 
} from 'rxjs/operators';

@Component({
  selector: 'app-user-search',
  template: `...`
})
export class UserSearchComponent implements OnInit {
  results$: Observable<User[]>;
  
  ngOnInit() {
    this.results$ = this.searchTerm$.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      filter(term => term.length > 2),
      switchMap(term => this.userService.search(term)),
      map(users => users.slice(0, 10)),
      catchError(err => {
        console.error(err);
        return of([]);
      })
    );
  }
}
```

---

## 🚀 Prêt pour la Migration !

Utilisez ce guide comme référence pendant toute la migration RxJS.
