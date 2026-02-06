# Design - Palier 12 : Angular 16.2 → 17.3 (Control Flow Syntax)

## Architecture

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────┐
│          PALIER 12 : CONTROL FLOW SYNTAX                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Phase 1: pwc-ui-shared                                 │
│  ├─ Migration Angular 16 → 17                           │
│  ├─ Migration automatique templates                     │
│  ├─ Vérification manuelle                               │
│  ├─ Utilisation @defer (optionnel)                      │
│  └─ Build et tests                                      │
│                                                          │
│  Phase 2: pwc-ui                                        │
│  ├─ Mise à jour @pwc/shared                             │
│  ├─ Migration Angular 16 → 17                           │
│  ├─ Migration templates                                 │
│  └─ Tests complets                                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Comparaison Syntaxe

### @if vs *ngIf

| Fonctionnalité | *ngIf | @if |
|----------------|-------|-----|
| Condition simple | `*ngIf="condition"` | `@if (condition) {}` |
| Else | `*ngIf="...; else tpl"` | `@if (...) {} @else {}` |
| Lisibilité | Moyenne | Élevée |
| Performance | Bonne | Meilleure |

### @for vs *ngFor

| Fonctionnalité | *ngFor | @for |
|----------------|--------|------|
| Boucle | `*ngFor="let x of items"` | `@for (x of items; track x.id) {}` |
| Track | `trackBy: fn` | `track expression` (obligatoire) |
| Empty | Séparé avec `*ngIf` | `@empty {}` intégré |
| Variables | `let i = index` | `$index` implicite |

### @switch vs *ngSwitch

| Fonctionnalité | *ngSwitch | @switch |
|----------------|-----------|---------|
| Switch | `[ngSwitch]` + `*ngSwitchCase` | `@switch () { @case () {} }` |
| Lisibilité | Moyenne | Élevée |
| Syntaxe | Verbeux | Concis |

## Stratégie de Migration

### Migration Automatique

```bash
# Migrer tous les templates automatiquement
ng generate @angular/core:control-flow

# Dry-run (voir les changements)
ng generate @angular/core:control-flow --dry-run

# Migrer un chemin spécifique
ng generate @angular/core:control-flow --path=src/app/components
```

### Vérification Manuelle

```bash
# Chercher les anciens patterns
grep -r "\*ngIf" src/ --include="*.html"
grep -r "\*ngFor" src/ --include="*.html"
grep -r "\*ngSwitch" src/ --include="*.html"
```

## Patterns de Code

### Pattern 1 : @if avec @else

```html
@if (user) {
  <div>Welcome {{ user.name }}</div>
} @else {
  <div>Please login</div>
}
```

### Pattern 2 : @for avec @empty

```html
<ul>
  @for (item of items; track item.id) {
    <li>{{ $index }}: {{ item.name }}</li>
  } @empty {
    <li>No items</li>
  }
</ul>
```

### Pattern 3 : @switch

```html
@switch (status) {
  @case ('loading') {
    <spinner />
  }
  @case ('success') {
    <data-table [data]="data" />
  }
  @case ('error') {
    <error-message />
  }
  @default {
    <p>Unknown status</p>
  }
}
```

### Pattern 4 : @defer (Lazy Loading)

```html
@defer (on viewport) {
  <heavy-chart [data]="chartData" />
} @placeholder {
  <div class="chart-placeholder">Chart will load when visible</div>
} @loading (minimum 1s) {
  <spinner />
} @error {
  <p>Failed to load chart</p>
}
```

**Triggers disponibles** :
- `on idle` : Quand le navigateur est idle
- `on viewport` : Quand visible dans le viewport
- `on interaction` : Au clic/hover
- `on hover` : Au survol
- `on immediate` : Immédiatement
- `on timer(2s)` : Après un délai

## Gestion des Erreurs

### Erreur 1 : "track is required"
**Cause** : `@for` nécessite un `track`

**Solution** :
```html
<!-- Ajouter track -->
@for (item of items; track item.id) {
  <div>{{ item.name }}</div>
}

<!-- Ou utiliser $index si pas d'id -->
@for (item of items; track $index) {
  <div>{{ item.name }}</div>
}
```

### Erreur 2 : Templates cassés après migration
**Cause** : Syntaxe incorrecte

**Solution** : Vérifier les accolades, la syntaxe doit être correcte

## Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Angular 17.3 | ✅ | ✅ | |
| TypeScript 5.2+ | ✅ | ✅ | |
| Templates migrés | ✅ | ✅ | |
| Application démarre | N/A | ✅ | |

## Documentation

### Fichiers à Mettre à Jour
- `.kiro/state/strands-state.json`
- `Documentation/JOURNAL-DE-BORD.md`
- `README.md`

### Informations à Documenter
- Décision migration templates (tout ou partiel)
- Problèmes rencontrés
- Temps réel vs estimé
