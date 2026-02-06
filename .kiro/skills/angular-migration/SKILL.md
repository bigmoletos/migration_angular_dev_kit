---
name: angular-migration
displayName: Angular Migration Expert
description: Guide complet pour migration Angular 5→20 avec breaking changes
version: 1.0.0

# LAZY LOADING CONFIG
loadOn:
  keywords:
    - migration
    - angular
    - ng update
    - upgrade
    - migrate
    - palier
  filePatterns:
    - "*.module.ts"
    - "angular.json"
    - "package.json"
  manual: "#angular-migration"

# TOKEN ESTIMATION
tokenEstimate: 8000
priority: high

# DEPENDENCIES
requires:
  - rxjs-patterns
mcpNeeds:
  - filesystem
  - git
---

# 🔄 Angular Migration Skill

## Activation

Ce skill se charge automatiquement quand :
- Le prompt contient : "migration", "angular", "ng update", "upgrade"
- On travaille sur : `*.module.ts`, `angular.json`, `package.json`
- L'utilisateur tape : `#angular-migration`

---

## 🎯 Règle Fondamentale

```
╔══════════════════════════════════════════════════════════════════╗
║  LA BIBLIOTHÈQUE DOIT TOUJOURS ÊTRE MIGRÉE AVANT LE CLIENT      ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  SÉQUENCE OBLIGATOIRE :                                          ║
║                                                                  ║
║  1. Migrer pwc-ui-shared-v4-ia au palier N                       ║
║  2. npm run build && npm run test                                ║
║  3. Valider que la lib est stable                                ║
║  4. PUIS migrer pwc-ui-v4-ia au palier N                         ║
║  5. Tester l'intégration                                         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 📊 Matrice de Compatibilité

| Angular | Node.js | TypeScript | RxJS | CLI |
|---------|---------|------------|------|-----|
| 5.x | 8.x | 2.4-2.6 | 5.5.x | 1.6.x |
| 6.x | 8.x-10.x | 2.7-2.9 | 6.x | 6.x |
| 7.x | 10.x | 3.1-3.2 | 6.x | 7.x |
| 8.x | 10.x-12.x | 3.4-3.5 | 6.x | 8.x |
| 9.x | 10.x-12.x | 3.6-3.8 | 6.x | 9.x |
| 10.x | 10.x-12.x | 3.9 | 6.x | 10.x |
| 11.x | 10.x-12.x | 4.0-4.1 | 6.x | 11.x |
| 12.x | 12.x-14.x | 4.2-4.3 | 6.x-7.x | 12.x |
| 13.x | 12.x-16.x | 4.4-4.5 | 7.x | 13.x |
| 14.x | 14.x-16.x | 4.6-4.7 | 7.x | 14.x |
| 15.x | 14.x-18.x | 4.8-4.9 | 7.x | 15.x |
| 16.x | 16.x-18.x | 4.9-5.0 | 7.x | 16.x |
| 17.x | 18.x-20.x | 5.2-5.3 | 7.x | 17.x |
| 18.x | 18.x-20.x | 5.3-5.4 | 7.x | 18.x |
| 19.x | 18.x-22.x | 5.4-5.5 | 7.x | 19.x |
| 20.x | 20.x-24.x | 5.5+ | 7.x | 20.x |

---

## 🔥 Breaking Changes Critiques

### Angular 5 → 6 (RxJS Migration)

```typescript
// AVANT (RxJS 5)
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
observable.map(x => x * 2);

// APRÈS (RxJS 6)
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
observable.pipe(map(x => x * 2));
```

**Commandes :**
```bash
npm install rxjs-compat  # Transition temporaire
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json
```

### Angular 7 → 8 (Lazy Loading)

```typescript
// AVANT
loadChildren: './feature/feature.module#FeatureModule'

// APRÈS
loadChildren: () => import('./feature/feature.module').then(m => m.FeatureModule)
```

### Angular 7 → 8 (ViewChild)

```typescript
// AVANT
@ViewChild('myRef') myRef: ElementRef;

// APRÈS
@ViewChild('myRef', { static: true }) myRef: ElementRef;
// ou
@ViewChild('myRef', { static: false }) myRef: ElementRef;
```

### Angular 8 → 9 (Ivy)

- Ivy devient le renderer par défaut
- `ModuleWithProviders` doit avoir un type générique
- Suppression de `rxjs-compat`

```typescript
// AVANT
static forRoot(): ModuleWithProviders { ... }

// APRÈS  
static forRoot(): ModuleWithProviders<MyModule> { ... }
```

### Angular 12+ (Strict Mode)

- `strict: true` par défaut
- Vérifications de types plus strictes
- Erreurs sur `any` implicites

### Angular 14+ (Standalone Components)

```typescript
// Nouveau pattern
@Component({
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `...`
})
export class MyComponent { }
```

### Angular 16+ (Signals)

```typescript
// Nouveau pattern réactif
const count = signal(0);
const doubled = computed(() => count() * 2);

// Effect
effect(() => console.log(`Count: ${count()}`));
```

### Angular 17+ (New Control Flow)

```html
<!-- AVANT -->
<div *ngIf="condition">...</div>
<div *ngFor="let item of items">...</div>

<!-- APRÈS -->
@if (condition) {
  <div>...</div>
}
@for (item of items; track item.id) {
  <div>...</div>
}
```

---

## 📋 Checklist par Palier

### Template Checklist

```markdown
## Palier Angular X → Y

### Pré-migration
- [ ] Backup créé (branche ou tag)
- [ ] Tous les tests passent
- [ ] npm audit sans CRITICAL

### Migration Lib (pwc-ui-shared-v4-ia)
- [ ] ng update @angular/cli@Y @angular/core@Y
- [ ] Breaking changes résolus
- [ ] npm run build SUCCESS
- [ ] npm run test SUCCESS
- [ ] Commit créé

### Migration Client (pwc-ui-v4-ia)
- [ ] rm -rf node_modules && npm install
- [ ] ng update @angular/cli@Y @angular/core@Y
- [ ] Breaking changes résolus
- [ ] npm run build SUCCESS
- [ ] npm run test SUCCESS
- [ ] Intégration avec lib testée
- [ ] Commit créé

### Post-migration
- [ ] ETAT-MIGRATION.md mis à jour
- [ ] Tag créé (vY.0.0-ai)
```

---

## 🚨 Rollback

### Si la lib échoue

```bash
cd pwc-ui-shared-v4-ia
git checkout develop  # ou branche stable
rm -rf node_modules
npm install
npm run build
```

### Si le client échoue

```bash
cd pwc-ui-v4-ia
git checkout develop
rm -rf node_modules
npm install
npm run build
```

### Si intégration échoue

```bash
# Rollback des deux repos
cd pwc-ui-shared-v4-ia && git checkout v{PREVIOUS}-ai
cd ../pwc-ui-v4-ia && git checkout v{PREVIOUS}-ai
```

---

## 📞 Support

Pour questions sur la migration, consulter :
- [Angular Update Guide](https://update.angular.io)
- Docs internes : `docs_outils_ia/`
