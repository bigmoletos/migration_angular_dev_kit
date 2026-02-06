---
inclusion: fileMatch
fileMatchPattern: "**/*.{ts,module.ts}"
priority: 85
---

# Guide de Migration Ivy (Angular 8 → 9)

> **Contexte** : Palier 4 - Migration critique vers le nouveau moteur de rendu

---

## 🎯 Qu'est-ce qu'Ivy ?

Ivy est le nouveau moteur de compilation et de rendu d'Angular, remplaçant View Engine.

**Avantages** :
- Bundles plus petits (tree-shaking amélioré)
- Compilation plus rapide
- Meilleur debugging
- Chargement lazy plus efficace
- Composants dynamiques simplifiés

---

## 🔴 Breaking Changes Majeurs

### 1. ModuleWithProviders doit être typé

#### AVANT (Angular 8)
```typescript
@NgModule({...})
export class MyModule {
  static forRoot(config: Config): ModuleWithProviders {
    return {
      ngModule: MyModule,
      providers: [
        { provide: CONFIG, useValue: config }
      ]
    };
  }
}
```

#### APRÈS (Angular 9+)
```typescript
@NgModule({...})
export class MyModule {
  static forRoot(config: Config): ModuleWithProviders<MyModule> {
    return {
      ngModule: MyModule,
      providers: [
        { provide: CONFIG, useValue: config }
      ]
    };
  }
}
```

**Codemod disponible** :
```bash
node scripts_outils_ia/codemods/migrate-module-with-providers.js src/**/*.ts
```

---

### 2. entryComponents devient obsolète

#### AVANT (Angular 8)
```typescript
@NgModule({
  declarations: [MyDialogComponent],
  entryComponents: [MyDialogComponent] // Nécessaire pour composants dynamiques
})
export class MyModule {}
```

#### APRÈS (Angular 9+)
```typescript
@NgModule({
  declarations: [MyDialogComponent]
  // entryComponents supprimé - Ivy le détecte automatiquement
})
export class MyModule {}
```

**Action** : Supprimer tous les `entryComponents` des modules.

---

### 3. Changements dans les Queries (@ViewChild, @ContentChild)

Les queries sont maintenant plus strictes avec Ivy.

#### AVANT (Angular 8)
```typescript
@ViewChild('myElement') myElement: ElementRef;
@ViewChild(MyComponent) myComponent: MyComponent;
```

#### APRÈS (Angular 9+)
```typescript
// Si l'élément est toujours présent (pas dans *ngIf)
@ViewChild('myElement', { static: true }) myElement: ElementRef;

// Si l'élément peut être absent (dans *ngIf, *ngFor, etc.)
@ViewChild('myElement', { static: false }) myElement: ElementRef;

// Ou simplement (static: false par défaut)
@ViewChild('myElement') myElement: ElementRef;
```

**Note** : Le flag `static` a été ajouté en Angular 8, mais devient obligatoire avec Ivy.

---

### 4. Injection de Dépendances plus stricte

#### AVANT (Angular 8)
```typescript
constructor(private service: MyService) {}
// Fonctionne même si MyService n'est pas fourni
```

#### APRÈS (Angular 9+)
```typescript
constructor(private service: MyService) {}
// Erreur si MyService n'est pas fourni dans le module ou le composant
```

**Solution** : S'assurer que tous les services sont correctement fournis.

---

### 5. Changements dans les Templates

#### Expressions plus strictes
```html
<!-- ❌ ERREUR avec Ivy -->
<div *ngIf="user && user.name">{{ user.name }}</div>

<!-- ✅ CORRECT -->
<div *ngIf="user?.name">{{ user.name }}</div>
```

#### Binding de propriétés
```html
<!-- ❌ ERREUR avec Ivy -->
<input [value]="undefined">

<!-- ✅ CORRECT -->
<input [value]="value || ''">
```

---

## 🛠️ Migration Automatique

### Commande Officielle
```bash
ng update @angular/core@9 --migrate-only
```

Cette commande applique automatiquement :
- Typage de `ModuleWithProviders`
- Suppression de `entryComponents`
- Ajustements des queries
- Corrections de templates

---

## 📋 Checklist de Migration

### Avant la Migration
- [ ] Lire la documentation Ivy
- [ ] Backup du code (tag Git)
- [ ] Build et tests passent sur Angular 8

### Pendant la Migration
- [ ] `ng update @angular/core@9 @angular/cli@9`
- [ ] Activer Ivy dans `tsconfig.json` :
  ```json
  {
    "angularCompilerOptions": {
      "enableIvy": true
    }
  }
  ```
- [ ] Appliquer les migrations automatiques
- [ ] Fixer les erreurs de compilation

### Après la Migration
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre sans erreurs
- [ ] Tests manuels des composants dynamiques
- [ ] Tests manuels des dialogs/modals
- [ ] Vérifier les performances (bundles plus petits ?)

---

## 🔍 Zones à Vérifier Manuellement

### 1. Composants Dynamiques

#### Avec ComponentFactoryResolver (Angular 8)
```typescript
constructor(
  private componentFactoryResolver: ComponentFactoryResolver,
  private viewContainerRef: ViewContainerRef
) {}

loadComponent() {
  const factory = this.componentFactoryResolver
    .resolveComponentFactory(MyComponent);
  this.viewContainerRef.createComponent(factory);
}
```

#### Avec Ivy (Angular 9+)
```typescript
constructor(private viewContainerRef: ViewContainerRef) {}

loadComponent() {
  // Plus simple avec Ivy
  this.viewContainerRef.createComponent(MyComponent);
}
```

---

### 2. Directives Structurelles Custom

Vérifier que les directives structurelles fonctionnent correctement avec Ivy.

```typescript
@Directive({
  selector: '[appCustomIf]'
})
export class CustomIfDirective {
  constructor(
    private templateRef: TemplateRef<any>,
    private viewContainer: ViewContainerRef
  ) {}
  
  @Input() set appCustomIf(condition: boolean) {
    if (condition) {
      this.viewContainer.createEmbeddedView(this.templateRef);
    } else {
      this.viewContainer.clear();
    }
  }
}
```

**Action** : Tester toutes les directives structurelles custom.

---

### 3. Pipes Custom

Vérifier que les pipes fonctionnent correctement.

```typescript
@Pipe({ name: 'customPipe' })
export class CustomPipe implements PipeTransform {
  transform(value: any, ...args: any[]): any {
    // ...
  }
}
```

**Action** : Tester tous les pipes custom.

---

### 4. Providers avec useFactory

```typescript
@NgModule({
  providers: [
    {
      provide: MY_TOKEN,
      useFactory: (service: MyService) => service.getValue(),
      deps: [MyService]
    }
  ]
})
```

**Action** : Vérifier que tous les providers avec `useFactory` fonctionnent.

---

## ⚠️ Problèmes Courants et Solutions

### Problème 1 : "Cannot find module" après migration

**Cause** : Ivy change la résolution des modules.

**Solution** :
```bash
rm -rf node_modules package-lock.json
npm install
```

---

### Problème 2 : Tests qui échouent

**Cause** : `TestBed` change avec Ivy.

**Solution** : Mettre à jour les tests :
```typescript
// AVANT
TestBed.configureTestingModule({
  declarations: [MyComponent],
  imports: [MyModule]
});

// APRÈS (même syntaxe, mais comportement différent)
TestBed.configureTestingModule({
  declarations: [MyComponent],
  imports: [MyModule]
}).compileComponents(); // Peut être nécessaire
```

---

### Problème 3 : Composants dynamiques ne s'affichent pas

**Cause** : `entryComponents` supprimé.

**Solution** : Ivy détecte automatiquement les composants dynamiques. Vérifier que le composant est bien déclaré dans le module.

---

### Problème 4 : Erreurs de template

**Cause** : Ivy est plus strict sur les types dans les templates.

**Solution** : Utiliser le safe navigation operator (`?.`) et vérifier les types.

```html
<!-- ❌ ERREUR -->
<div>{{ user.name }}</div>

<!-- ✅ CORRECT -->
<div>{{ user?.name }}</div>
```

---

### Problème 5 : Bundles plus gros qu'avant

**Cause** : Configuration de build incorrecte.

**Solution** : Vérifier `angular.json` :
```json
{
  "projects": {
    "my-app": {
      "architect": {
        "build": {
          "options": {
            "aot": true,
            "buildOptimizer": true
          }
        }
      }
    }
  }
}
```

---

## 🎯 Optimisations Ivy

### 1. Lazy Loading Amélioré

#### AVANT (Angular 8)
```typescript
const routes: Routes = [
  {
    path: 'admin',
    loadChildren: './admin/admin.module#AdminModule'
  }
];
```

#### APRÈS (Angular 9+)
```typescript
const routes: Routes = [
  {
    path: 'admin',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule)
  }
];
```

---

### 2. Composants Standalone (Preview en Angular 9)

Ivy prépare le terrain pour les composants standalone (disponibles en Angular 14+).

---

## 📊 Vérification des Performances

### Avant Migration (Angular 8)
```bash
npm run build -- --prod
# Noter la taille des bundles
```

### Après Migration (Angular 9)
```bash
npm run build -- --prod
# Comparer la taille des bundles
```

**Attendu** : Réduction de 10-30% de la taille des bundles.

---

## 🔄 Rollback si Nécessaire

Si la migration Ivy pose trop de problèmes :

### Désactiver Ivy temporairement
```json
// tsconfig.json
{
  "angularCompilerOptions": {
    "enableIvy": false
  }
}
```

**Note** : View Engine est déprécié et sera supprimé en Angular 12. Le rollback n'est qu'une solution temporaire.

---

## 📚 Ressources

- [Ivy Compatibility Guide](https://angular.io/guide/ivy-compatibility)
- [Ivy Migration Guide](https://angular.io/guide/ivy)
- [Angular 9 Release Notes](https://blog.angular.io/version-9-of-angular-now-available-project-ivy-has-arrived-23c97b63cfa3)

---

## ✅ Validation Finale

### Checklist
- [ ] Build réussi avec Ivy activé
- [ ] Tests unitaires passent (>95%)
- [ ] Application démarre sans erreurs
- [ ] Composants dynamiques fonctionnent
- [ ] Dialogs/Modals fonctionnent
- [ ] Lazy loading fonctionne
- [ ] Bundles plus petits (vérifier)
- [ ] Pas de régression de performance
- [ ] Tous les `ModuleWithProviders` typés
- [ ] Tous les `entryComponents` supprimés

### Commandes de Vérification
```bash
# Vérifier que Ivy est activé
cat tsconfig.json | grep enableIvy

# Build
npm run build -- --prod

# Tests
npm test

# Démarrer l'application
npm start
```

---

## 🚀 Prêt pour Ivy !

Cette migration est critique mais ouvre la voie à toutes les fonctionnalités modernes d'Angular (Standalone Components, Signals, etc.).
