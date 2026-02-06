# Design - Palier 1 : Angular 5.2 → 6.1

## Approche Technique

### Stratégie de Migration

**Migration en 2 phases séquentielles** :
1. **Phase 1** : pwc-ui-shared (bibliothèque) - PRIORITÉ 1
2. **Phase 2** : pwc-ui (application) - APRÈS validation Gate Playwright

### Architecture de Migration

```
Phase 1 : pwc-ui-shared
    ↓
Préparation (branche + tag)
    ↓
Installation rxjs-compat
    ↓
ng update @angular/cli@6 @angular/core@6
    ↓
Migration RxJS (codemod)
    ↓
Migration @angular/http → HttpClient
    ↓
Fix erreurs compilation
    ↓
Tests unitaires (>95%)
    ↓
🚦 Gate Playwright (100% - BLOQUANT)
    ↓
Publication Nexus
    ↓
Tag Git
    ↓
Phase 2 : pwc-ui (SI GATE VALIDÉ)
```

## Décisions Techniques

### DT-1 : Utilisation de rxjs-compat
**Décision** : Installer rxjs-compat@6.0.0 temporairement  
**Justification** : Permet la coexistence de RxJS 5 et 6 pendant la migration  
**Retrait** : Palier 2 (Angular 6→7)  
**Alternative rejetée** : Migration directe sans compat (trop risqué)

### DT-2 : Codemod Officiel RxJS
**Décision** : Utiliser `rxjs-5-to-6-migrate` (officiel)  
**Justification** : Outil maintenu par l'équipe RxJS, couvre la majorité des cas  
**Complément** : Codemod custom `scripts_outils_ia/codemods/migrate-rxjs.js` pour cas spécifiques

### DT-3 : Migration HttpClient
**Décision** : Migrer tous les services vers HttpClient en une fois  
**Justification** : @angular/http sera supprimé au Palier 2, migration obligatoire  
**Impact** : Tous les services HTTP et leurs tests doivent être adaptés

### DT-4 : Gate Playwright Bloquant
**Décision** : Tests E2E Playwright obligatoires à 100% avant de passer à pwc-ui  
**Justification** : Garantit que la bibliothèque fonctionne correctement  
**Implémentation** :
- Lancer Shared sur port 4201 : `start-pwc-ui-shared-4201.bat`
- Exécuter tests : `npm run test:e2e`
- Validation : 100% des tests passent

### DT-5 : Publication Nexus Obligatoire
**Décision** : Publier pwc-ui-shared sur Nexus après validation Gate  
**Justification** : pwc-ui dépend de @pwc/shared via Nexus  
**Commande** : `npm publish`

### DT-6 : Node.js v10
**Décision** : Utiliser Node.js v10.24.1 pour ce palier  
**Justification** : Compatible avec Angular 5-8  
**Commande** : `Use-Node10`

## Détails d'Implémentation

### Phase 1 : pwc-ui-shared

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia
git checkout -b palier-1-angular-6
git tag palier-0-angular-5-shared
ng version
npm test
npm run build
```

#### Étape 1.2 : Installation rxjs-compat
```bash
npm install rxjs-compat@6.0.0 --save
```

#### Étape 1.3 : Mise à jour Angular
```bash
ng update @angular/cli@6 @angular/core@6 --dry-run
ng update @angular/cli@6 @angular/core@6 --allow-dirty
```

**Changements automatiques** :
- `.angular-cli.json` → `angular.json`
- `package.json` mis à jour
- Migrations Angular appliquées

#### Étape 1.4 : Migration RxJS
```bash
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json --apply
```

**Transformations** :
- `import 'rxjs/add/operator/map'` → `import { map } from 'rxjs/operators'`
- `Observable.of()` → `of()`
- `.do()` → `tap()`
- `.catch()` → `catchError()`
- `.map()` → `pipe(map())`

**Vérification** :
```bash
grep -r "rxjs/add/" src/
grep -r "\.do(" src/
grep -r "Observable\.of(" src/
```

#### Étape 1.5 : Migration HttpClient

**Modules** :
```typescript
// AVANT
import { HttpModule } from '@angular/http';
@NgModule({ imports: [HttpModule] })

// APRÈS
import { HttpClientModule } from '@angular/common/http';
@NgModule({ imports: [HttpClientModule] })
```

**Services** :
```typescript
// AVANT
import { Http, Response } from '@angular/http';
constructor(private http: Http) {}
getData() {
  return this.http.get('/api/data').map(res => res.json());
}

// APRÈS
import { HttpClient } from '@angular/common/http';
constructor(private http: HttpClient) {}
getData() {
  return this.http.get<Data[]>('/api/data');
}
```

**Tests** :
```typescript
// AVANT
import { HttpModule } from '@angular/http';
TestBed.configureTestingModule({ imports: [HttpModule] });

// APRÈS
import { HttpClientTestingModule } from '@angular/common/http/testing';
TestBed.configureTestingModule({ imports: [HttpClientTestingModule] });
```

#### Étape 1.6 : Fix Erreurs Compilation
```bash
npm run build
```

**Erreurs courantes** :
1. Import manquant : `import { of } from 'rxjs';`
2. Opérateur incorrect : Utiliser `pipe(tap())` au lieu de `.do()`
3. Type incorrect : Typer HttpClient : `http.get<MyType>()`

#### Étape 1.7 : Tests Unitaires
```bash
npm test
```

**Seuil** : >95% des tests passent

#### Étape 1.8 : 🚦 Gate Playwright (BLOQUANT)

**Terminal 1** : Lancer l'application
```bash
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat
```

**Terminal 2** : Exécuter les tests
```bash
npm run test:e2e
```

**Validation** :
- [ ] 100% des tests passent (OBLIGATOIRE)
- [ ] demo-home.spec.ts : ✅
- [ ] demo-forms.spec.ts : ✅
- [ ] demo-navigation.spec.ts : ✅
- [ ] Page charge en <5s
- [ ] Aucune erreur console critique

**🚫 SI ÉCHEC** : NE PAS passer à Phase 2, corriger Shared d'abord

#### Étape 1.9 : Publication Nexus
```bash
npm version patch
npm publish
```

#### Étape 1.10 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 6 and RxJS 6"
git tag palier-1-shared-angular-6
git push origin palier-1-angular-6
git push origin palier-1-shared-angular-6
```

### Phase 2 : pwc-ui (Après Gate Validé)

#### Étape 2.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia
git checkout -b palier-1-angular-6
git tag palier-0-angular-5-ui
ng version
npm test
npm run build
```

#### Étape 2.2 : Mise à jour @pwc/shared
```bash
npm update @pwc/shared
npm install
npm list @pwc/shared
```

#### Étape 2.3 : Installation rxjs-compat
```bash
npm install rxjs-compat@6.0.0 --save
```

#### Étape 2.4 : Mise à jour Angular
```bash
ng update @angular/cli@6 @angular/core@6 --allow-dirty
```

#### Étape 2.5 : Adaptation Webpack (si nécessaire)
Vérifier `webpack.dev.config.js` et `webpack.prod.config.js`.

Si erreurs, ajouter des alias :
```javascript
module.exports = {
  resolve: {
    alias: {
      'rxjs/operators': 'rxjs/operators'
    }
  }
};
```

#### Étape 2.6 : Migration RxJS
```bash
rxjs-5-to-6-migrate -p src/tsconfig.app.json --apply
```

#### Étape 2.7 : Migration HttpClient
Même processus que Phase 1 Étape 1.5

#### Étape 2.8 : Fix Erreurs
```bash
npm run build
```

#### Étape 2.9 : Tests Unitaires
```bash
npm test
```

#### Étape 2.10 : Build Final
```bash
npm run build
```

#### Étape 2.11 : Test Manuel
```bash
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat
```

Vérifier :
- [ ] Application démarre sur http://localhost:4200
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Appels API fonctionnent
- [ ] Aucune erreur console

#### Étape 2.12 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 6 and RxJS 6"
git tag palier-1-ui-angular-6
git push origin palier-1-angular-6
git push origin palier-1-ui-angular-6
```

## Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Seuil |
|----------|---------------|--------|-------|
| Build réussi | ✅ | ✅ | 100% |
| Tests passent | >95% | >95% | 95% |
| Erreurs compilation | 0 | 0 | 0 |
| Warnings | <10 | <20 | - |
| Gate Playwright | 100% | N/A | 100% |
| Publication Nexus | ✅ | N/A | - |
| Application démarre | N/A | ✅ | - |

## Problèmes Connus et Solutions

### Problème 1 : "Cannot find module 'rxjs/operators'"
**Solution** :
```bash
rm -rf node_modules package-lock.json
npm install
```

### Problème 2 : Tests HttpClient échouent
**Solution** :
```typescript
import { HttpClientTestingModule } from '@angular/common/http/testing';
TestBed.configureTestingModule({ imports: [HttpClientTestingModule] });
```

### Problème 3 : Webpack build échoue
**Solution** : Vérifier les loaders dans webpack.config.js

### Problème 4 : Gate Playwright échoue
**Solution** :
1. Analyser les logs des tests
2. Vérifier la console du navigateur
3. Corriger les erreurs dans Shared
4. Relancer les tests jusqu'à 100%

## Rollback

Si échec après plusieurs tentatives :
```bash
git reset --hard palier-0-angular-5-shared
rm -rf node_modules package-lock.json
Use-Node10
npm install
npm run build
npm test
```

## Ressources

- [Angular 6 Release Notes](https://blog.angular.io/version-6-of-angular-now-available-cc56b0efa7a4)
- [RxJS 6 Migration Guide](https://rxjs.dev/guide/v6/migration)
- [HttpClient Guide](https://angular.io/guide/http)
- `.kiro/steering/03-rxjs-migration-patterns.md`
- `.kiro/specs/10-workflow-tests-playwright.md`
