---
inclusion: fileMatch
fileMatchPattern: "**/*.spec.ts"
priority: 75
---

# Stratégie de Tests - Migration Angular

> **Contexte** : Tests unitaires et E2E pendant la migration

---

## 🎯 Objectifs

1. Maintenir >95% de tests passants à chaque palier
2. Adapter les tests aux breaking changes
3. Éviter les régressions
4. Valider les fonctionnalités critiques

---

## 📋 Types de Tests

### 1. Tests Unitaires (Karma/Jasmine)
- Composants
- Services
- Pipes
- Directives

### 2. Tests E2E (Playwright) 🚦 GATE
- **Écran de démo Shared (port 4201)** - BLOQUANT
- Validation avant migration UI
- Parcours utilisateur
- Fonctionnalités critiques

### 3. Tests E2E Legacy (Protractor)
- À migrer vers Playwright progressivement

### 4. Tests Manuels
- Composants dynamiques
- Dialogs/Modals
- Lazy loading

---

## 🔄 Stratégie par Palier

### Avant Chaque Palier
```bash
# Exécuter les tests
npm test

# Vérifier la couverture
npm test -- --code-coverage

# Sauvegarder les résultats
# Nombre de tests : X
# Tests passants : Y
# Couverture : Z%
```

**Validation** :
- [ ] Tous les tests passent
- [ ] Couverture >80%

---

### Pendant la Migration

#### Étape 1 : Identifier les Tests Cassés
```bash
npm test
```

**Analyser** :
- Quels tests échouent ?
- Pourquoi ?
- Lié au breaking change ?

#### Étape 2 : Fixer les Tests

**Priorité** :
1. Tests critiques (login, navigation, API)
2. Tests de composants principaux
3. Tests de services
4. Tests de pipes/directives

**Seuil acceptable** :
- >95% des tests passent
- 0 test critique échoue

---

### Après Chaque Palier

#### 🚦 GATE PLAYWRIGHT (pwc-ui-shared SEULEMENT)
```bash
# 1. Tests unitaires
npm test

# 2. 🚦 GATE : Tests Playwright sur écran demo (port 4201)
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start  # Port 4201
npm run test:e2e

# 3. ✅ SI GATE PASSÉ : Passer à pwc-ui
# 4. ❌ SI GATE ÉCHOUÉ : NE PAS passer à pwc-ui, corriger d'abord
```

#### Tests pwc-ui (après validation gate)
```bash
# Tests unitaires
npm test

# Tests E2E (si disponibles)
npm run e2e

# Tests manuels sur port 4200
npm start
```

**Validation** :
- [ ] >95% des tests unitaires passent
- [ ] 🚦 **100% des tests Playwright passent (Shared uniquement, BLOQUANT)**
- [ ] Aucune régression détectée
- [ ] Fonctionnalités critiques OK

---

## 🛠️ Patterns de Migration des Tests

### Pattern 1 : HttpClient (Palier 1)

#### AVANT (Angular 5 + Http)
```typescript
import { HttpModule } from '@angular/http';
import { MockBackend } from '@angular/http/testing';

describe('MyService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpModule],
      providers: [
        MyService,
        MockBackend
      ]
    });
  });
  
  it('should fetch data', () => {
    // ...
  });
});
```

#### APRÈS (Angular 6+ + HttpClient)
```typescript
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

describe('MyService', () => {
  let service: MyService;
  let httpMock: HttpTestingController;
  
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [MyService]
    });
    
    service = TestBed.inject(MyService);
    httpMock = TestBed.inject(HttpTestingController);
  });
  
  afterEach(() => {
    httpMock.verify();
  });
  
  it('should fetch data', () => {
    const mockData = [{ id: 1, name: 'Test' }];
    
    service.getData().subscribe(data => {
      expect(data).toEqual(mockData);
    });
    
    const req = httpMock.expectOne('/api/data');
    expect(req.request.method).toBe('GET');
    req.flush(mockData);
  });
});
```

---

### Pattern 2 : Ivy (Palier 4)

#### Composants Dynamiques
```typescript
describe('DialogService', () => {
  it('should create component dynamically', async () => {
    await TestBed.configureTestingModule({
      declarations: [MyDialogComponent]
    }).compileComponents(); // Important avec Ivy
    
    const service = TestBed.inject(DialogService);
    const componentRef = service.openDialog(MyDialogComponent);
    
    expect(componentRef).toBeDefined();
  });
});
```

#### ViewChild avec static
```typescript
describe('MyComponent', () => {
  it('should access ViewChild', () => {
    const fixture = TestBed.createComponent(MyComponent);
    const component = fixture.componentInstance;
    
    // Si static: true
    expect(component.myElement).toBeDefined();
    
    // Si static: false
    fixture.detectChanges();
    expect(component.myElement).toBeDefined();
  });
});
```

---

### Pattern 3 : RxJS (Palier 1-2)

#### AVANT (RxJS 5)
```typescript
it('should transform data', () => {
  const obs = Observable.of([1, 2, 3])
    .map(x => x * 2);
  
  obs.subscribe(result => {
    expect(result).toEqual([2, 4, 6]);
  });
});
```

#### APRÈS (RxJS 6+)
```typescript
import { of } from 'rxjs';
import { map } from 'rxjs/operators';

it('should transform data', () => {
  const obs = of([1, 2, 3]).pipe(
    map(x => x * 2)
  );
  
  obs.subscribe(result => {
    expect(result).toEqual([2, 4, 6]);
  });
});
```

---

### Pattern 4 : Async Testing

#### Avec fakeAsync
```typescript
import { fakeAsync, tick } from '@angular/core/testing';

it('should handle async operation', fakeAsync(() => {
  let result: string;
  
  service.getDataAsync().subscribe(data => {
    result = data;
  });
  
  tick(1000); // Avancer le temps de 1s
  
  expect(result).toBe('data');
}));
```

#### Avec async/await
```typescript
it('should handle async operation', async () => {
  const result = await service.getDataAsync().toPromise();
  expect(result).toBe('data');
});
```

---

## ⚠️ Problèmes Courants

### Problème 1 : "Cannot find module" dans les tests
**Solution** :
```bash
rm -rf node_modules package-lock.json
npm install
```

### Problème 2 : Tests timeout
**Solution** :
```typescript
// Augmenter le timeout
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000;
```

### Problème 3 : "Component not found"
**Solution** :
```typescript
await TestBed.configureTestingModule({
  declarations: [MyComponent]
}).compileComponents();
```

### Problème 4 : Mocks ne fonctionnent plus
**Solution** : Adapter les mocks pour la nouvelle version.

---

## 🔍 Debugging des Tests

### Exécuter un seul test
```typescript
// Utiliser fdescribe ou fit
fdescribe('MyComponent', () => {
  fit('should work', () => {
    // ...
  });
});
```

### Voir les logs
```typescript
it('should work', () => {
  console.log('Debug:', component.data);
  expect(component.data).toBeDefined();
});
```

### Exécuter en mode debug
```bash
# Chrome DevTools
npm test -- --browsers=Chrome --watch
```

---

## 📊 Métriques de Tests

### Avant Migration
```bash
npm test -- --code-coverage
```

**Noter** :
- Nombre total de tests
- Tests passants
- Couverture de code
- Temps d'exécution

### Après Chaque Palier
**Comparer** :
- Nombre de tests (devrait rester stable)
- Tests passants (>95%)
- Couverture (devrait rester >80%)
- Temps d'exécution (peut varier)

---

## 🚦 Workflow Gate Playwright

### Architecture des Ports

```
pwc-ui-shared  →  Port 4201  →  Tests Playwright (GATE)
pwc-ui         →  Port 4200  →  Tests après gate validé
```

### Workflow avec Gate

```
1. Migrer pwc-ui-shared
   ↓
2. Build OK
   ↓
3. Tests unitaires OK (>95%)
   ↓
4. 🚦 GATE Playwright sur port 4201
   ├─ ✅ SI PASSÉ → Passer à pwc-ui
   └─ ❌ SI ÉCHOUÉ → Corriger Shared, ne pas passer à UI
```

**Documentation complète** : Voir `.kiro/steering/11-playwright-e2e-testing.md`

---

## ✅ Checklist Tests par Palier

### Palier 1 (Angular 5→6)
- [ ] Migrer HttpModule → HttpClientModule
- [ ] Adapter les mocks HttpClient
- [ ] Migrer les imports RxJS
- [ ] Tests passent (>95%)

### Palier 4 (Angular 8→9 Ivy)
- [ ] Ajouter compileComponents() si nécessaire
- [ ] Tester les composants dynamiques
- [ ] Vérifier les ViewChild
- [ ] Tests passent (>95%)

### Palier 7 (Angular 11→12 Webpack 5)
- [ ] Vérifier les imports
- [ ] Tester le build
- [ ] Tests passent (>95%)

### Tous les Paliers
- [ ] Build réussi
- [ ] Tests unitaires passent (>95%)
- [ ] 🚦 **Tests Playwright Shared passent (100%, BLOQUANT pour pwc-ui)**
- [ ] Tests E2E passent (si disponibles)
- [ ] Tests manuels OK
- [ ] Aucune régression détectée

---

## 🎯 Tests Manuels Critiques

### À Tester Manuellement à Chaque Palier

#### Fonctionnalités Critiques
- [ ] Login / Authentification
- [ ] Navigation principale
- [ ] Appels API
- [ ] Formulaires principaux
- [ ] Tableaux de données

#### Composants Dynamiques
- [ ] Dialogs
- [ ] Modals
- [ ] Popovers
- [ ] Tooltips

#### Lazy Loading
- [ ] Routes lazy-loaded
- [ ] Modules lazy-loaded

#### Autres
- [ ] Traductions (i18n)
- [ ] Thèmes
- [ ] Responsive design

---

## 📚 Ressources

- [Angular Testing Guide](https://angular.io/guide/testing)
- [Jasmine Documentation](https://jasmine.github.io/)
- [Karma Configuration](https://karma-runner.github.io/latest/config/configuration-file.html)

---

## 🚀 Commandes Utiles

```bash
# Tous les tests
npm test

# Tests avec couverture
npm test -- --code-coverage

# Tests en mode watch
npm test -- --watch

# Tests d'un seul fichier
npm test -- --include='**/my-component.spec.ts'

# Tests E2E
npm run e2e

# Tests avec Chrome visible
npm test -- --browsers=Chrome
```

---

## ✅ Validation Finale

Après chaque palier :
- [ ] >95% des tests passent
- [ ] Couverture >80%
- [ ] Aucune régression détectée
- [ ] Fonctionnalités critiques testées manuellement
- [ ] Documentation des problèmes rencontrés
