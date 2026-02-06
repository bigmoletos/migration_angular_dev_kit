---
name: validation-formelle
displayName: Validation Formelle Légère
description: Validation de types et invariants avec TypeScript strict, io-ts, zod (alternative à Coq)
version: 1.0.0

# LAZY LOADING CONFIG
loadOn:
  keywords:
    - validation
    - formal
    - proof
    - preuve
    - invariant
    - type-safe
    - io-ts
    - zod
    - strict
    - runtime
  manual: "#validation-formelle"

# TOKEN ESTIMATION
tokenEstimate: 5000
priority: medium

# DEPENDENCIES
requires: []
mcpNeeds:
  - filesystem
---

# 🔒 Validation Formelle Légère Skill

## Activation

Ce skill se charge automatiquement quand :
- Le prompt contient : "validation", "formal", "proof", "preuve", "invariant"
- On parle de types stricts : "type-safe", "io-ts", "zod", "strict"
- L'utilisateur tape : `#validation-formelle`

---

## 🎯 Objectif

Fournir des **garanties formelles légères** sans la complexité de Coq :
- Validation de types à runtime
- Invariants métier vérifiés
- Contracts pour fonctions critiques
- Tests property-based

---

## ⚠️ Pourquoi pas Coq ?

| Aspect | Coq | Approche Légère |
|--------|-----|-----------------|
| Courbe d'apprentissage | 6-12 mois | 1-2 jours |
| Applicabilité Angular | ❌ Très limitée | ✅ Complète |
| ROI pour migration | ❌ Faible | ✅ Élevé |
| Maintenance | ❌ Complexe | ✅ Simple |

**Recommandation** : Coq n'est pas adapté à une migration Angular. Utiliser des approches de validation TypeScript.

---

## 📐 Architecture de Validation

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PYRAMIDE DE VALIDATION                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                        ┌─────────────┐                                  │
│                        │    COQ      │  ← Preuves mathématiques         │
│                        │ (Non utilisé)│   (Trop complexe)               │
│                        └─────────────┘                                  │
│                                                                         │
│                   ┌─────────────────────┐                               │
│                   │  PROPERTY-BASED     │  ← Tests exhaustifs           │
│                   │   (fast-check)      │    automatiques               │
│                   └─────────────────────┘                               │
│                                                                         │
│              ┌─────────────────────────────┐                            │
│              │    RUNTIME VALIDATION       │  ← Validation à            │
│              │     (io-ts / zod)           │    l'exécution             │
│              └─────────────────────────────┘                            │
│                                                                         │
│         ┌───────────────────────────────────────┐                       │
│         │      TYPESCRIPT STRICT                │  ← Validation à       │
│         │   (strict: true, no any)              │    la compilation     │
│         └───────────────────────────────────────┘                       │
│                                                                         │
│    ┌───────────────────────────────────────────────────┐                │
│    │           TESTS UNITAIRES (Jest)                  │  ← Cas         │
│    │        + TESTS E2E (Cypress/Playwright)           │    concrets    │
│    └───────────────────────────────────────────────────┘                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 1. TypeScript Strict Mode

### Configuration Recommandée

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    
    // Extras recommandés
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true
  }
}
```

### Migration Progressive vers Strict

```bash
# 1. Activer progressivement
# tsconfig.json
{
  "strict": false,  // Pas encore
  "noImplicitAny": true,  // Étape 1
  "strictNullChecks": true  // Étape 2
}

# 2. Corriger les erreurs par batch
npx tsc --noEmit | grep "error TS" | wc -l

# 3. Passer à strict: true quand prêt
```

---

## 2. Validation Runtime avec io-ts

### Installation

```bash
npm install io-ts fp-ts
```

### Exemples de Validation

```typescript
// src/core/validators/amount.validator.ts

import * as t from 'io-ts';
import { either } from 'fp-ts/Either';
import { pipe } from 'fp-ts/function';

// Type de base
const Amount = t.type({
  value: t.number,
  currency: t.string,
});

// Refinement : montant positif
const PositiveAmount = t.brand(
  Amount,
  (a): a is t.Branded<t.TypeOf<typeof Amount>, { readonly Positive: unique symbol }> =>
    a.value >= 0,
  'Positive'
);

// Refinement : devise valide
const validCurrencies = ['EUR', 'USD', 'GBP', 'CHF'] as const;
const ValidCurrency = t.keyof(
  Object.fromEntries(validCurrencies.map(c => [c, null])) as Record<string, null>
);

// Type complet avec invariants
const ValidAmount = t.intersection([
  t.type({
    value: t.number,
    currency: ValidCurrency,
  }),
  t.partial({
    description: t.string,
  }),
]);

// Utilisation
export function validateAmount(input: unknown): ValidAmount | null {
  const result = ValidAmount.decode(input);
  
  return pipe(
    result,
    either.fold(
      () => null,  // Échec de validation
      (valid) => valid  // Succès
    )
  );
}

// Dans un service Angular
@Injectable()
export class AmountService {
  processPayment(input: unknown): Observable<PaymentResult> {
    const amount = validateAmount(input);
    
    if (!amount) {
      return throwError(() => new Error('Montant invalide'));
    }
    
    // ICI, TypeScript SAIT que:
    // - amount.value est un number >= 0
    // - amount.currency est 'EUR' | 'USD' | 'GBP' | 'CHF'
    return this.paymentApi.process(amount);
  }
}
```

### Validation de DTOs API

```typescript
// src/core/validators/api-response.validator.ts

import * as t from 'io-ts';
import { PathReporter } from 'io-ts/PathReporter';

// Définir le schéma de réponse API
const UserResponse = t.type({
  id: t.string,
  email: t.string,
  createdAt: t.string,
  profile: t.type({
    firstName: t.string,
    lastName: t.string,
  }),
});

type UserResponse = t.TypeOf<typeof UserResponse>;

// Interceptor HTTP avec validation
@Injectable()
export class ValidationInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    return next.handle(req).pipe(
      map(event => {
        if (event instanceof HttpResponse && req.url.includes('/api/users/')) {
          const validation = UserResponse.decode(event.body);
          
          if (validation._tag === 'Left') {
            const errors = PathReporter.report(validation);
            console.error('Validation API échouée:', errors);
            throw new Error(`Réponse API invalide: ${errors.join(', ')}`);
          }
        }
        return event;
      })
    );
  }
}
```

---

## 3. Validation avec Zod (Alternative Plus Simple)

### Installation

```bash
npm install zod
```

### Exemples

```typescript
// src/core/validators/user.validator.ts

import { z } from 'zod';

// Schéma de validation
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  age: z.number().int().min(0).max(150),
  role: z.enum(['admin', 'user', 'guest']),
  createdAt: z.string().datetime(),
  profile: z.object({
    firstName: z.string().min(1).max(100),
    lastName: z.string().min(1).max(100),
  }).optional(),
});

// Type inféré automatiquement
type User = z.infer<typeof UserSchema>;

// Validation
export function parseUser(input: unknown): User {
  return UserSchema.parse(input);  // Throw si invalide
}

export function safeParseUser(input: unknown): User | null {
  const result = UserSchema.safeParse(input);
  return result.success ? result.data : null;
}

// Transformation
const UserCreateSchema = UserSchema.omit({ id: true, createdAt: true });
type UserCreate = z.infer<typeof UserCreateSchema>;
```

---

## 4. Design by Contract

### Pattern Contract pour Fonctions Critiques

```typescript
// src/core/contracts/contract.decorator.ts

function contract<T extends (...args: any[]) => any>(
  precondition: (...args: Parameters<T>) => boolean,
  postcondition: (result: ReturnType<T>, ...args: Parameters<T>) => boolean,
  invariant?: () => boolean
) {
  return function (
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor
  ) {
    const originalMethod = descriptor.value;
    
    descriptor.value = function (...args: Parameters<T>): ReturnType<T> {
      // Vérifier l'invariant avant
      if (invariant && !invariant.call(this)) {
        throw new Error(`Invariant violated before ${propertyKey}`);
      }
      
      // Vérifier la précondition
      if (!precondition.apply(this, args)) {
        throw new Error(`Precondition failed for ${propertyKey}`);
      }
      
      // Exécuter la méthode
      const result = originalMethod.apply(this, args);
      
      // Vérifier la postcondition
      if (!postcondition.call(this, result, ...args)) {
        throw new Error(`Postcondition failed for ${propertyKey}`);
      }
      
      // Vérifier l'invariant après
      if (invariant && !invariant.call(this)) {
        throw new Error(`Invariant violated after ${propertyKey}`);
      }
      
      return result;
    };
    
    return descriptor;
  };
}

// Utilisation
class BankAccount {
  private balance: number = 0;
  
  @contract(
    // Précondition: montant positif
    (amount: number) => amount > 0,
    // Postcondition: nouveau solde = ancien + montant
    function(this: BankAccount, result: number, amount: number) {
      return this.balance === result;
    },
    // Invariant: solde jamais négatif
    function(this: BankAccount) {
      return this.balance >= 0;
    }
  )
  deposit(amount: number): number {
    this.balance += amount;
    return this.balance;
  }
  
  @contract(
    // Précondition: montant positif ET suffisant
    function(this: BankAccount, amount: number) {
      return amount > 0 && amount <= this.balance;
    },
    // Postcondition: montant bien retiré
    function(this: BankAccount, result: number, amount: number) {
      return result >= 0;
    },
    // Invariant
    function(this: BankAccount) {
      return this.balance >= 0;
    }
  )
  withdraw(amount: number): number {
    this.balance -= amount;
    return this.balance;
  }
}
```

---

## 5. Property-Based Testing avec fast-check

### Installation

```bash
npm install fast-check --save-dev
```

### Exemples

```typescript
// src/core/validators/__tests__/amount.property.spec.ts

import fc from 'fast-check';
import { validateAmount, addAmounts } from '../amount.validator';

describe('Amount Properties', () => {
  
  // Propriété: la validation accepte les montants valides
  it('should validate any positive amount with valid currency', () => {
    fc.assert(
      fc.property(
        fc.nat(),  // Entier positif
        fc.constantFrom('EUR', 'USD', 'GBP'),  // Devise valide
        (value, currency) => {
          const result = validateAmount({ value, currency });
          return result !== null;
        }
      )
    );
  });
  
  // Propriété: l'addition est commutative
  it('should have commutative addition', () => {
    fc.assert(
      fc.property(
        fc.record({ value: fc.nat(), currency: fc.constant('EUR') }),
        fc.record({ value: fc.nat(), currency: fc.constant('EUR') }),
        (a, b) => {
          const ab = addAmounts(a, b);
          const ba = addAmounts(b, a);
          return ab.value === ba.value;
        }
      )
    );
  });
  
  // Propriété: le retrait ne peut jamais rendre négatif
  it('should never result in negative balance', () => {
    fc.assert(
      fc.property(
        fc.nat({ max: 10000 }),  // Balance initiale
        fc.nat({ max: 20000 }),  // Montant à retirer
        (balance, withdrawal) => {
          const result = safeWithdraw(balance, withdrawal);
          // Soit le retrait réussit avec solde >= 0
          // Soit il échoue
          return result === null || result >= 0;
        }
      )
    );
  });
});
```

---

## 📊 Comparaison des Approches

| Approche | Effort | Garanties | Applicabilité Angular |
|----------|--------|-----------|----------------------|
| TypeScript strict | Faible | Compilation | ✅ 100% |
| io-ts / zod | Faible | Runtime | ✅ 100% |
| Design by Contract | Moyen | Runtime | ✅ 100% |
| Property-based | Moyen | Test exhaustif | ✅ 100% |
| **Coq** | **Très élevé** | **Mathématique** | **❌ 5%** |

---

## 📋 Checklist d'Implémentation

### Étape 1: TypeScript Strict (Priorité HAUTE)
- [ ] Activer `noImplicitAny`
- [ ] Activer `strictNullChecks`
- [ ] Corriger les erreurs
- [ ] Activer `strict: true`

### Étape 2: Validation Runtime (Priorité HAUTE)
- [ ] Installer io-ts ou zod
- [ ] Valider les DTOs API entrants
- [ ] Valider les inputs utilisateur
- [ ] Ajouter des interceptors

### Étape 3: Contracts (Priorité MOYENNE)
- [ ] Identifier les fonctions critiques
- [ ] Ajouter préconditions/postconditions
- [ ] Définir les invariants métier

### Étape 4: Property Testing (Priorité MOYENNE)
- [ ] Installer fast-check
- [ ] Écrire les propriétés pour la logique métier
- [ ] Intégrer dans CI/CD

---

## 📚 Ressources

- [io-ts Documentation](https://github.com/gcanti/io-ts)
- [Zod Documentation](https://zod.dev/)
- [fast-check Documentation](https://github.com/dubzzz/fast-check)
- [TypeScript Strict Mode Guide](https://www.typescriptlang.org/tsconfig#strict)
