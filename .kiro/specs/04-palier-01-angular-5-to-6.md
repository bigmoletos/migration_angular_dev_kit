# Spec Palier 1 : Angular 5.2 → 6.1

**Durée estimée** : 1-2 semaines  
**Complexité** : 🔴 Élevée  
**Criticité** : Bloquant pour tous les paliers suivants

---

## 🎯 Objectifs

1. Migrer Angular 5.2 → 6.1
2. Migrer RxJS 5.5 → 6.0
3. Migrer @angular/http → @angular/common/http
4. Valider build et tests

---

## 📋 Breaking Changes

### 1. RxJS 5 → 6
- Tous les opérateurs deviennent pipeable
- Imports changent complètement
- `rxjs-compat` requis temporairement

### 2. @angular/http déprécié
- Remplacé par `@angular/common/http`
- `HttpModule` → `HttpClientModule`
- API légèrement différente

### 3. Angular CLI 1.x → 6.x
- `.angular-cli.json` → `angular.json`
- Nouvelles commandes
- Nouveaux builders

---

## 🔄 Ordre d'Exécution

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Créer une branche
git checkout -b palier-1-angular-6

# Créer un tag de sauvegarde
git tag palier-0-angular-5-shared

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi
- [ ] Tests passent

---

#### Étape 1.2 : Installer rxjs-compat
```bash
npm install rxjs-compat@6.0.0 --save
```

**Pourquoi** : Permet de faire coexister RxJS 5 et 6 temporairement.

**Validation** :
- [ ] `rxjs-compat` dans package.json
- [ ] Build réussi

---

#### Étape 1.3 : Mettre à jour Angular
```bash
# Dry-run (voir les changements)
ng update @angular/cli@6 @angular/core@6 --dry-run

# Appliquer la mise à jour
ng update @angular/cli@6 @angular/core@6 --allow-dirty
```

**Ce qui change** :
- `.angular-cli.json` → `angular.json`
- `package.json` mis à jour
- Migrations automatiques appliquées

**Validation** :
- [ ] `angular.json` créé
- [ ] `.angular-cli.json` supprimé (ou renommé)
- [ ] `package.json` mis à jour
- [ ] Compilation réussie

---

#### Étape 1.4 : Migrer RxJS avec Codemod
```bash
# Installer le codemod
npm install -g rxjs-tslint

# Dry-run (voir les changements)
rxjs-5-to-6-migrate -p src/tsconfig.app.json

# Appliquer les changements
rxjs-5-to-6-migrate -p src/tsconfig.app.json --apply
```

**Ce qui change** :
- Imports RxJS mis à jour
- Opérateurs deviennent pipeable
- `Observable.of()` → `of()`
- `.do()` → `tap()`
- `.catch()` → `catchError()`

**Validation** :
- [ ] Aucun import `rxjs/add/...` restant
- [ ] Tous les opérateurs utilisent `pipe()`
- [ ] Compilation réussie

**Vérification manuelle** :
```bash
# Chercher les anciens imports
grep -r "rxjs/add/" src/

# Chercher les anciens opérateurs
grep -r "\.do(" src/
grep -r "\.catch(" src/
grep -r "Observable\.of(" src/
```

---

#### Étape 1.5 : Migrer @angular/http → @angular/common/http

**Fichiers à modifier** :

1. **Modules** :
```typescript
// AVANT
import { HttpModule } from '@angular/http';

@NgModule({
  imports: [HttpModule]
})

// APRÈS
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  imports: [HttpClientModule]
})
```

2. **Services** :
```typescript
// AVANT
import { Http, Response } from '@angular/http';
import 'rxjs/add/operator/map';

constructor(private http: Http) {}

getData() {
  return this.http.get('/api/data')
    .map(res => res.json());
}

// APRÈS
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';

constructor(private http: HttpClient) {}

getData() {
  return this.http.get<Data[]>('/api/data');
  // Pas besoin de .json(), c'est automatique
}
```

**Validation** :
- [ ] Aucun import `@angular/http` restant
- [ ] Tous les services utilisent `HttpClient`
- [ ] Compilation réussie

**Vérification** :
```bash
grep -r "@angular/http" src/
```

---

#### Étape 1.6 : Fixer les Erreurs de Compilation

Compiler et fixer les erreurs une par une :
```bash
npm run build
```

**Erreurs courantes** :

1. **Import manquant** :
```typescript
// Erreur : Cannot find name 'of'
// Solution : import { of } from 'rxjs';
```

2. **Opérateur incorrect** :
```typescript
// Erreur : Property 'do' does not exist
// Solution : Utiliser tap() dans pipe()
```

3. **Type incorrect** :
```typescript
// Erreur : Type 'Observable<Object>' is not assignable
// Solution : Typer le HttpClient : http.get<MyType>()
```

**Validation** :
- [ ] Aucune erreur de compilation
- [ ] Aucun warning critique

---

#### Étape 1.7 : Exécuter les Tests
```bash
npm test
```

**Si des tests échouent** :
1. Identifier le composant/service
2. Vérifier les imports RxJS
3. Vérifier les mocks HttpClient
4. Adapter le test

**Exemple de fix** :
```typescript
// AVANT
import { HttpModule } from '@angular/http';

TestBed.configureTestingModule({
  imports: [HttpModule]
});

// APRÈS
import { HttpClientTestingModule } from '@angular/common/http/testing';

TestBed.configureTestingModule({
  imports: [HttpClientTestingModule]
});
```

**Validation** :
- [ ] >95% des tests passent
- [ ] Aucun test critique échoue

---

#### Étape 1.8 : Build Final
```bash
npm run build
```

**Validation** :
- [ ] Build réussi
- [ ] Aucune erreur
- [ ] Warnings acceptables (<10)

---

#### Étape 1.9 : 🚦 GATE PLAYWRIGHT - Tests E2E Demo (BLOQUANT)

Cette étape est **OBLIGATOIRE** et **BLOQUANTE**. Ne pas passer à pwc-ui tant que ce gate n'est pas validé à 100%.

##### 1.9.1 : Installation Playwright (première fois seulement)
```bash
# Installer Playwright
npm install -D @playwright/test

# Installer les navigateurs
npx playwright install

# Copier la configuration et les tests depuis .kiro/steering/11-playwright-e2e-testing.md
```

##### 1.9.2 : Lancer l'Application Demo (Terminal 1)
```bash
# Option 1 : Script batch (RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Option 2 : Manuel
npm start -- --port 4201
```

**Vérification** :
- [ ] Application démarre sur http://localhost:4201
- [ ] Page d'accueil "PowerCARD Sandbox" s'affiche
- [ ] Aucune erreur console critique

##### 1.9.3 : Lancer les Tests Playwright (Terminal 2)
```bash
# Dans un autre terminal
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia

# Lancer les tests
npm run test:e2e

# OU avec interface UI pour debug
npm run test:e2e:ui
```

**Validation du Gate** :
- [ ] 🚦 **100% des tests Playwright passent (OBLIGATOIRE)**
- [ ] Test demo-home.spec.ts : ✅ PASSÉ
- [ ] Test demo-forms.spec.ts : ✅ PASSÉ
- [ ] Test demo-navigation.spec.ts : ✅ PASSÉ
- [ ] Page d'accueil charge en <5s
- [ ] Aucune erreur console critique
- [ ] Tous les composants form visibles
- [ ] Navigation fonctionne

**🚫 SI UN TEST ÉCHOUE** :
- NE PAS passer à l'étape suivante
- NE PAS passer à pwc-ui
- Analyser et corriger le problème
- Relancer les tests jusqu'à 100% de succès

**✅ SI TOUS LES TESTS PASSENT** :
- Gate validé ✅
- Passer à l'étape 1.10 (Publication)

**Documentation complète** : `.kiro/steering/11-playwright-e2e-testing.md`

---

#### Étape 1.10 : Publication sur Nexus
```bash
# Vérifier la version
npm version

# Incrémenter la version (patch)
npm version patch

# Publier
npm publish
```

**Validation** :
- [ ] Version incrémentée (ex: 2.6.25 → 2.6.26)
- [ ] Publication réussie sur Nexus
- [ ] Package disponible

---

#### Étape 1.11 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 6 and RxJS 6"
git tag palier-1-shared-angular-6
git push origin palier-1-angular-6
git push origin palier-1-shared-angular-6
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
git checkout -b palier-1-angular-6

# Créer un tag de sauvegarde
git tag palier-0-angular-5-ui

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi
- [ ] Tests passent

---

#### Étape 2.2 : Mettre à jour @pwc/shared
```bash
# Mettre à jour vers la nouvelle version publiée
npm update @pwc/shared

# Ou spécifier la version
npm install @pwc/shared@2.6.26

# Vérifier
npm list @pwc/shared
```

**Validation** :
- [ ] `@pwc/shared` mis à jour dans package.json
- [ ] `npm install` réussi

---

#### Étape 2.3 : Installer rxjs-compat
```bash
npm install rxjs-compat@6.0.0 --save
```

**Validation** :
- [ ] `rxjs-compat` dans package.json

---

#### Étape 2.4 : Mettre à jour Angular
```bash
ng update @angular/cli@6 @angular/core@6 --allow-dirty
```

**Validation** :
- [ ] `angular.json` créé
- [ ] `package.json` mis à jour
- [ ] Compilation réussie

---

#### Étape 2.5 : Adapter webpack.config (si nécessaire)

**Vérifier** `webpack.dev.config.js` et `webpack.prod.config.js` :

Si erreurs de build, adapter :
```javascript
// Exemple : Ajouter des alias si nécessaire
module.exports = {
  resolve: {
    alias: {
      'rxjs/operators': 'rxjs/operators'
    }
  }
};
```

**Validation** :
- [ ] Build réussi avec webpack custom

---

#### Étape 2.6 : Migrer RxJS
```bash
rxjs-5-to-6-migrate -p src/tsconfig.app.json --apply
```

**Validation** :
- [ ] Imports RxJS mis à jour
- [ ] Compilation réussie

---

#### Étape 2.7 : Migrer @angular/http
Même processus que pwc-ui-shared (Étape 1.5).

**Validation** :
- [ ] Aucun import `@angular/http`
- [ ] Compilation réussie

---

#### Étape 2.8 : Fixer les Erreurs
```bash
npm run build
```

**Validation** :
- [ ] Aucune erreur de compilation

---

#### Étape 2.9 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 2.10 : Build Final
```bash
npm run build
```

**Validation** :
- [ ] Build réussi

---

#### Étape 2.11 : Test Manuel

##### Lancer l'Application UI
```bash
# Option 1 : Script batch (RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui.bat

# Option 2 : Manuel
npm start
```

Ouvrir http://localhost:4200 et tester :
- [ ] Application démarre
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Appels API fonctionnent
- [ ] Aucune erreur console

---

#### Étape 2.12 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 6 and RxJS 6"
git tag palier-1-ui-angular-6
git push origin palier-1-angular-6
git push origin palier-1-ui-angular-6
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé
- [ ] Push réussi

---

## 📊 Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Compilation | 0 erreurs | 0 erreurs | |
| Warnings | <10 | <20 | |
| Publication Nexus | ✅ | N/A | |
| Application démarre | N/A | ✅ | |

---

## ⚠️ Problèmes Connus et Solutions

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

TestBed.configureTestingModule({
  imports: [HttpClientTestingModule]
});
```

### Problème 3 : Webpack build échoue
**Solution** : Vérifier les loaders dans webpack.config.js

---

## 📚 Ressources

- [Angular 6 Release Notes](https://blog.angular.io/version-6-of-angular-now-available-cc56b0efa7a4)
- [RxJS 6 Migration Guide](https://rxjs.dev/guide/v6/migration)
- [HttpClient Guide](https://angular.io/guide/http)
- Steering : `.kiro/steering/03-rxjs-migration-patterns.md`

---

## ✅ Checklist Finale

### pwc-ui-shared
- [ ] Angular 6.1 installé
- [ ] RxJS 6.0 installé
- [ ] rxjs-compat installé
- [ ] @angular/http supprimé
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 6.1 installé
- [ ] RxJS 6.0 installé
- [ ] rxjs-compat installé
- [ ] @angular/http supprimé
- [ ] Webpack adapté (si nécessaire)
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre
- [ ] Tests manuels OK
- [ ] Tag Git créé

### Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Problèmes rencontrés documentés
- [ ] Solutions documentées

---

## 🎯 Prochaine Étape

Une fois le Palier 1 validé, passer au **Palier 2 : Angular 6 → 7** (retirer rxjs-compat).
