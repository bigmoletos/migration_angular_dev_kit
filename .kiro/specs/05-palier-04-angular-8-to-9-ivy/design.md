# Design - Palier 4 : Angular 8.2 → 9.1 (Ivy)

## Architecture

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────┐
│                    PALIER 4 : IVY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Phase 1: pwc-ui-shared                                 │
│  ├─ Migration Angular 8 → 9                             │
│  ├─ Activation Ivy                                      │
│  ├─ Typage ModuleWithProviders                          │
│  ├─ Suppression entryComponents                         │
│  └─ Validation composants dynamiques                    │
│                                                          │
│  Phase 2: pwc-ui                                        │
│  ├─ Mise à jour @pwc/shared                             │
│  ├─ Migration Angular 8 → 9                             │
│  ├─ Activation Ivy                                      │
│  ├─ Adaptation Webpack si nécessaire                    │
│  └─ Tests complets                                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Changements Majeurs

#### 1. Ivy vs View Engine

**View Engine (Angular 8)** :
- Ancien moteur de rendu
- Bundles plus gros
- entryComponents requis
- Compilation plus lente

**Ivy (Angular 9)** :
- Nouveau moteur de rendu
- Bundles plus petits (-10 à -30%)
- Détection automatique des composants dynamiques
- Compilation plus rapide
- Tree-shaking amélioré

#### 2. ModuleWithProviders Typé

```typescript
// AVANT (Angular 8)
import { ModuleWithProviders } from '@angular/core';

@NgModule({...})
export class MyModule {
  static forRoot(config: Config): ModuleWithProviders {
    return {
      ngModule: MyModule,
      providers: [...]
    };
  }
}

// APRÈS (Angular 9)
import { ModuleWithProviders } from '@angular/core';

@NgModule({...})
export class MyModule {
  static forRoot(config: Config): ModuleWithProviders<MyModule> {
    return {
      ngModule: MyModule,
      providers: [...]
    };
  }
}
```

**Raison** : Améliore le type-checking et permet à Ivy de mieux optimiser.

#### 3. entryComponents Obsolète

```typescript
// AVANT (Angular 8)
@NgModule({
  declarations: [MyDialogComponent],
  entryComponents: [MyDialogComponent]  // Requis pour composants dynamiques
})
export class MyModule {}

// APRÈS (Angular 9)
@NgModule({
  declarations: [MyDialogComponent]
  // entryComponents supprimé - Ivy détecte automatiquement
})
export class MyModule {}
```

**Raison** : Ivy détecte automatiquement les composants chargés dynamiquement.

## Stratégie de Migration

### Phase 1 : pwc-ui-shared

#### Étape 1 : Préparation
1. Créer branche `palier-4-angular-9-ivy`
2. Créer tag `palier-3-angular-8-shared`
3. Vérifier build et tests sur Angular 8

#### Étape 2 : Migration Angular
```bash
ng update @angular/cli@9 @angular/core@9 --allow-dirty
```

**Migrations automatiques** :
- Mise à jour des dépendances
- Ajout de `enableIvy: true` dans tsconfig.json
- Migrations de base

#### Étape 3 : Activation Ivy
Vérifier `tsconfig.json` :
```json
{
  "angularCompilerOptions": {
    "enableIvy": true
  }
}
```

#### Étape 4 : Typage ModuleWithProviders

**Recherche** :
```bash
grep -r "ModuleWithProviders[^<]" src/ --include="*.ts"
```

**Migration automatique** :
```bash
ng update @angular/core --migrate-only --from=8 --to=9
```

**OU codemod manuel** :
```bash
node scripts_outils_ia/codemods/migrate-module-with-providers.js src/**/*.ts
```

**Pattern de remplacement** :
- Chercher : `ModuleWithProviders {`
- Remplacer : `ModuleWithProviders<NomDuModule> {`

#### Étape 5 : Suppression entryComponents

**Recherche** :
```bash
grep -r "entryComponents" src/ --include="*.ts"
```

**Action** : Supprimer toutes les occurrences de `entryComponents` dans les `@NgModule`.

#### Étape 6 : Validation Composants Dynamiques

**Identifier** :
```bash
grep -r "ComponentFactoryResolver" src/ --include="*.ts"
grep -r "createComponent" src/ --include="*.ts"
```

**Tester** :
- Tous les dialogs
- Tous les modals
- Tous les composants chargés via ViewContainerRef

#### Étape 7 : Build et Tests
```bash
npm run build
npm test
```

**Vérifications** :
- Build réussi
- Bundles plus petits
- Tests passent (>95%)

#### Étape 8 : Publication
```bash
npm version minor  # Breaking change
npm publish
```

### Phase 2 : pwc-ui

#### Étape 1 : Mise à Jour Dépendance
```bash
npm install @pwc/shared@latest
```

#### Étape 2 : Migration Angular
```bash
ng update @angular/cli@9 @angular/core@9 --allow-dirty
```

#### Étape 3 : Même Process que Shared
- Activer Ivy
- Typer ModuleWithProviders
- Supprimer entryComponents
- Adapter Webpack si nécessaire

#### Étape 4 : Tests Complets
- Build
- Tests unitaires
- Tests manuels
- Tests composants dynamiques
- Tests lazy loading

## Patterns de Code

### Pattern 1 : ModuleWithProviders Typé

```typescript
import { NgModule, ModuleWithProviders } from '@angular/core';

@NgModule({
  declarations: [MyComponent],
  exports: [MyComponent]
})
export class MyModule {
  static forRoot(config: MyConfig): ModuleWithProviders<MyModule> {
    return {
      ngModule: MyModule,
      providers: [
        { provide: MY_CONFIG, useValue: config }
      ]
    };
  }
}
```

### Pattern 2 : Composant Dynamique

```typescript
// Service qui charge un composant dynamique
@Injectable()
export class DialogService {
  constructor(
    private componentFactoryResolver: ComponentFactoryResolver,
    private viewContainerRef: ViewContainerRef
  ) {}
  
  openDialog(component: Type<any>) {
    // Ivy détecte automatiquement le composant
    // Pas besoin de entryComponents
    const factory = this.componentFactoryResolver
      .resolveComponentFactory(component);
    this.viewContainerRef.createComponent(factory);
  }
}
```

### Pattern 3 : Configuration AOT pour Bundles Optimisés

```json
// angular.json
{
  "projects": {
    "my-app": {
      "architect": {
        "build": {
          "options": {
            "aot": true,
            "buildOptimizer": true,
            "optimization": true
          }
        }
      }
    }
  }
}
```

## Gestion des Erreurs

### Erreur 1 : "Cannot find module" après migration
**Cause** : Cache npm corrompu

**Solution** :
```bash
rm -rf node_modules package-lock.json
npm install
```

### Erreur 2 : Composants dynamiques ne s'affichent pas
**Cause** : Composant non déclaré dans le module

**Solution** : Vérifier que le composant est dans `declarations` du module.

### Erreur 3 : Tests échouent avec "Component not found"
**Cause** : TestBed non compilé

**Solution** :
```typescript
await TestBed.configureTestingModule({
  declarations: [MyComponent]
}).compileComponents();
```

### Erreur 4 : Bundles plus gros qu'avant
**Cause** : AOT ou buildOptimizer désactivé

**Solution** : Vérifier `angular.json` et activer les optimisations.

## Métriques de Validation

### Métriques Techniques

| Métrique | Seuil | Mesure |
|----------|-------|--------|
| Build réussi | 100% | Obligatoire |
| Tests passent | >95% | Obligatoire |
| Ivy activé | 100% | Obligatoire |
| ModuleWithProviders typés | 100% | Obligatoire |
| entryComponents supprimés | 100% | Obligatoire |
| Bundles plus petits | -10 à -30% | Attendu |
| Composants dynamiques OK | 100% | Obligatoire |

### Métriques de Performance

| Métrique | Avant (Angular 8) | Après (Angular 9) | Amélioration |
|----------|-------------------|-------------------|--------------|
| Taille main.js | ~2.5 MB | ~1.8-2.0 MB | -10 à -30% |
| Temps build | ~5 min | ~4 min | -20% |
| Temps compilation | Baseline | -40% | Attendu |

## Rollback

Si le palier échoue :

```bash
# Revenir au tag précédent
git reset --hard palier-3-angular-8-shared

# Nettoyer
rm -rf node_modules package-lock.json
npm install

# Vérifier
npm run build
npm test
```

## Documentation

### Fichiers à Mettre à Jour
- `.kiro/state/strands-state.json` : État du palier
- `Documentation/JOURNAL-DE-BORD.md` : Problèmes et solutions
- `README.md` : Version Angular

### Informations à Documenter
- Problèmes rencontrés avec Ivy
- Solutions appliquées
- Temps réel vs estimé
- Composants dynamiques testés
- Taille des bundles avant/après
