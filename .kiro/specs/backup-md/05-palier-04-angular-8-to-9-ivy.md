# Spec Palier 4 : Angular 8.2 → 9.1 (Ivy)

**Durée estimée** : 2 semaines  
**Complexité** : 🔴 Très Élevée  
**Criticité** : Changement architectural majeur

---

## 🎯 Objectifs

1. Migrer Angular 8.2 → 9.1
2. Activer Ivy (nouveau moteur de rendu)
3. Typer tous les `ModuleWithProviders<T>`
4. Supprimer tous les `entryComponents`
5. Valider que le rendu fonctionne correctement

---

## 📋 Breaking Changes Majeurs

### 1. Ivy devient le moteur par défaut
- View Engine déprécié
- Comportements de rendu peuvent changer
- Bundles plus petits attendus

### 2. ModuleWithProviders doit être typé
```typescript
// AVANT
static forRoot(): ModuleWithProviders { }

// APRÈS
static forRoot(): ModuleWithProviders<MyModule> { }
```

### 3. entryComponents obsolète
```typescript
// AVANT
@NgModule({
  entryComponents: [MyDialogComponent]
})

// APRÈS
@NgModule({
  // entryComponents supprimé
})
```

### 4. @ViewChild / @ContentChild plus stricts
Le flag `static` devient obligatoire (ajouté en Angular 8).

---

## 🔄 Ordre d'Exécution

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Créer une branche
git checkout -b palier-4-angular-9-ivy

# Créer un tag de sauvegarde
git tag palier-3-angular-8-shared

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 8)
- [ ] Tests passent

---

#### Étape 1.2 : Mettre à jour Angular
```bash
# Dry-run
ng update @angular/cli@9 @angular/core@9 --dry-run

# Appliquer
ng update @angular/cli@9 @angular/core@9 --allow-dirty
```

**Ce qui change** :
- Angular 9.1 installé
- Migrations automatiques appliquées
- `tsconfig.json` mis à jour

**Validation** :
- [ ] Angular 9.1 installé
- [ ] Compilation réussie

---

#### Étape 1.3 : Activer Ivy

**Vérifier** `tsconfig.json` :
```json
{
  "angularCompilerOptions": {
    "enableIvy": true
  }
}
```

Si pas présent, ajouter.

**Validation** :
- [ ] `enableIvy: true` dans tsconfig.json
- [ ] Compilation réussie

---

#### Étape 1.4 : Appliquer les Migrations Automatiques
```bash
ng update @angular/core --migrate-only --from=8 --to=9
```

**Ce qui est migré automatiquement** :
- `ModuleWithProviders` typés
- `entryComponents` supprimés
- Queries mises à jour

**Validation** :
- [ ] Migrations appliquées
- [ ] Compilation réussie

---

#### Étape 1.5 : Typer ModuleWithProviders Manuellement

**Chercher** tous les `ModuleWithProviders` non typés :
```bash
grep -r "ModuleWithProviders" src/ --include="*.ts"
```

**Fixer** chaque occurrence :
```typescript
// AVANT
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

// APRÈS
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

**Ou utiliser le codemod** :
```bash
node scripts_outils_ia/codemods/migrate-module-with-providers.js src/**/*.ts
```

**Validation** :
- [ ] Tous les `ModuleWithProviders` typés
- [ ] Compilation réussie

**Vérification** :
```bash
# Chercher les non-typés (ne doit rien retourner)
grep -r "ModuleWithProviders[^<]" src/ --include="*.ts"
```

---

#### Étape 1.6 : Supprimer entryComponents

**Chercher** tous les `entryComponents` :
```bash
grep -r "entryComponents" src/ --include="*.ts"
```

**Supprimer** chaque occurrence :
```typescript
// AVANT
@NgModule({
  declarations: [MyDialogComponent],
  entryComponents: [MyDialogComponent]
})

// APRÈS
@NgModule({
  declarations: [MyDialogComponent]
  // entryComponents supprimé
})
```

**Validation** :
- [ ] Tous les `entryComponents` supprimés
- [ ] Compilation réussie

**Vérification** :
```bash
# Ne doit rien retourner
grep -r "entryComponents" src/ --include="*.ts"
```

---

#### Étape 1.7 : Vérifier les Composants Dynamiques

**Identifier** tous les composants chargés dynamiquement :
```bash
grep -r "ComponentFactoryResolver" src/ --include="*.ts"
grep -r "createComponent" src/ --include="*.ts"
```

**Tester** chaque composant dynamique :
1. Dialogs
2. Modals
3. Composants chargés via ViewContainerRef

**Exemple de test** :
```typescript
// Service qui charge un composant dynamique
@Injectable()
export class DialogService {
  constructor(
    private componentFactoryResolver: ComponentFactoryResolver,
    private viewContainerRef: ViewContainerRef
  ) {}
  
  openDialog(component: Type<any>) {
    const factory = this.componentFactoryResolver
      .resolveComponentFactory(component);
    this.viewContainerRef.createComponent(factory);
  }
}
```

**Validation** :
- [ ] Tous les composants dynamiques identifiés
- [ ] Tests manuels OK

---

#### Étape 1.8 : Build avec Ivy
```bash
npm run build
```

**Vérifier** :
- Taille des bundles (devrait être plus petit)
- Aucune erreur
- Warnings acceptables

**Validation** :
- [ ] Build réussi
- [ ] Bundles plus petits (vérifier)

**Comparaison** :
```bash
# Avant (Angular 8)
# main.js: 2.5 MB

# Après (Angular 9 + Ivy)
# main.js: 2.0 MB (attendu: -10 à -30%)
```

---

#### Étape 1.9 : Tests Unitaires
```bash
npm test
```

**Si des tests échouent** :

1. **Erreur : "Cannot find module"**
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

2. **Erreur : "Component not found"**
   - Vérifier que le composant est déclaré dans le module
   - Ivy détecte automatiquement les composants dynamiques

3. **Erreur : "TestBed configuration"**
   ```typescript
   // Ajouter compileComponents() si nécessaire
   await TestBed.configureTestingModule({
     declarations: [MyComponent]
   }).compileComponents();
   ```

**Validation** :
- [ ] >95% des tests passent
- [ ] Aucun test critique échoue

---

#### Étape 1.10 : Tests Approfondis

**Tester manuellement** (si possible) :
- [ ] Composants dynamiques (dialogs, modals)
- [ ] Lazy loading
- [ ] Directives structurelles custom
- [ ] Pipes custom
- [ ] Providers avec useFactory

**Créer des tests E2E** (optionnel) :
```bash
npm run e2e
```

---

#### Étape 1.11 : Publication sur Nexus
```bash
# Incrémenter la version (minor car breaking change)
npm version minor

# Publier
npm publish
```

**Validation** :
- [ ] Version incrémentée (ex: 2.6.26 → 2.7.0)
- [ ] Publication réussie

---

#### Étape 1.12 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 9 with Ivy"
git tag palier-4-shared-angular-9-ivy
git push origin palier-4-angular-9-ivy
git push origin palier-4-shared-angular-9-ivy
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
git checkout -b palier-4-angular-9-ivy

# Créer un tag de sauvegarde
git tag palier-3-angular-8-ui

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 8)

---

#### Étape 2.2 : Mettre à jour @pwc/shared
```bash
npm install @pwc/shared@2.7.0
```

**Validation** :
- [ ] `@pwc/shared` mis à jour
- [ ] `npm install` réussi

---

#### Étape 2.3 : Mettre à jour Angular
```bash
ng update @angular/cli@9 @angular/core@9 --allow-dirty
```

**Validation** :
- [ ] Angular 9.1 installé
- [ ] Compilation réussie

---

#### Étape 2.4 : Activer Ivy
Vérifier `tsconfig.json` (même que pwc-ui-shared).

**Validation** :
- [ ] `enableIvy: true`

---

#### Étape 2.5 : Appliquer les Migrations
```bash
ng update @angular/core --migrate-only --from=8 --to=9
```

**Validation** :
- [ ] Migrations appliquées

---

#### Étape 2.6 : Typer ModuleWithProviders
Même processus que pwc-ui-shared (Étape 1.5).

**Validation** :
- [ ] Tous typés

---

#### Étape 2.7 : Supprimer entryComponents
Même processus que pwc-ui-shared (Étape 1.6).

**Validation** :
- [ ] Tous supprimés

---

#### Étape 2.8 : Adapter Webpack (si nécessaire)

**Vérifier** `webpack.dev.config.js` et `webpack.prod.config.js` :

Si erreurs, adapter :
```javascript
// Exemple : Ivy peut nécessiter des ajustements
module.exports = {
  resolve: {
    mainFields: ['es2015', 'browser', 'module', 'main']
  }
};
```

**Validation** :
- [ ] Build réussi avec webpack custom

---

#### Étape 2.9 : Build
```bash
npm run build
```

**Validation** :
- [ ] Build réussi
- [ ] Bundles plus petits

---

#### Étape 2.10 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 2.11 : Test Manuel Approfondi
```bash
npm start
```

**Tester** :
- [ ] Application démarre
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Dialogs/Modals fonctionnent
- [ ] Lazy loading fonctionne
- [ ] Aucune erreur console
- [ ] Aucune régression visuelle

**Tester spécifiquement** :
- Tous les composants dynamiques
- Toutes les routes lazy-loaded
- Tous les dialogs/modals
- Toutes les fonctionnalités critiques

---

#### Étape 2.12 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 9 with Ivy"
git tag palier-4-ui-angular-9-ivy
git push origin palier-4-angular-9-ivy
git push origin palier-4-ui-angular-9-ivy
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé

---

## 📊 Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Ivy activé | ✅ | ✅ | |
| ModuleWithProviders typés | 100% | 100% | |
| entryComponents supprimés | 100% | 100% | |
| Bundles plus petits | -10 à -30% | -10 à -30% | |
| Composants dynamiques OK | ✅ | ✅ | |
| Application démarre | N/A | ✅ | |

---

## ⚠️ Problèmes Connus et Solutions

### Problème 1 : "Cannot find module" après migration
**Solution** :
```bash
rm -rf node_modules package-lock.json
npm install
```

### Problème 2 : Composants dynamiques ne s'affichent pas
**Solution** : Vérifier que le composant est déclaré dans le module (Ivy le détecte automatiquement).

### Problème 3 : Tests échouent avec "Component not found"
**Solution** :
```typescript
await TestBed.configureTestingModule({
  declarations: [MyComponent]
}).compileComponents();
```

### Problème 4 : Bundles plus gros qu'avant
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

### Problème 5 : Webpack build échoue
**Solution** : Adapter webpack.config.js pour Ivy.

---

## 📚 Ressources

- [Ivy Compatibility Guide](https://angular.io/guide/ivy-compatibility)
- [Ivy Migration Guide](https://angular.io/guide/ivy)
- [Angular 9 Release Notes](https://blog.angular.io/version-9-of-angular-now-available-project-ivy-has-arrived-23c97b63cfa3)
- Steering : `.kiro/steering/04-ivy-migration-guide.md`

---

## ✅ Checklist Finale

### pwc-ui-shared
- [ ] Angular 9.1 installé
- [ ] Ivy activé
- [ ] ModuleWithProviders typés (100%)
- [ ] entryComponents supprimés (100%)
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Bundles plus petits
- [ ] Composants dynamiques testés
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 9.1 installé
- [ ] Ivy activé
- [ ] ModuleWithProviders typés (100%)
- [ ] entryComponents supprimés (100%)
- [ ] Webpack adapté (si nécessaire)
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Bundles plus petits
- [ ] Application démarre
- [ ] Composants dynamiques testés
- [ ] Dialogs/Modals testés
- [ ] Lazy loading testé
- [ ] Tests manuels OK
- [ ] Tag Git créé

### Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Problèmes rencontrés documentés
- [ ] Temps réel vs estimé documenté

---

## 🎯 Prochaine Étape

Une fois le Palier 4 validé, passer au **Palier 5 : Angular 9 → 10** (TypeScript 3.9+).

**Note** : Les paliers suivants seront plus simples car Ivy est maintenant activé.
