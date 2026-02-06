# Requirements - Palier 1 : Angular 5.2 → 6.1

## Objectif

Migrer les repositories pwc-ui-shared et pwc-ui d'Angular 5.2 vers Angular 6.1, incluant la migration RxJS 5.5 → 6.0 et @angular/http → @angular/common/http.

## Contexte

- **Palier** : 1/15
- **Criticité** : 🔴 Bloquant pour tous les paliers suivants
- **Complexité** : Élevée (migration RxJS impacte 2816 composants)
- **Durée estimée** : 1-2 semaines
- **Node.js** : v10.24.1

## Exigences Fonctionnelles

### EF-1 : Migration Angular 5.2 → 6.1
Mettre à jour @angular/cli et @angular/core vers la version 6.1 (LTS).

### EF-2 : Migration RxJS 5.5 → 6.0
Migrer tous les imports et opérateurs RxJS vers la syntaxe pipeable de RxJS 6.

### EF-3 : Migration @angular/http → @angular/common/http
Remplacer tous les usages de @angular/http (déprécié) par @angular/common/http (HttpClient).

### EF-4 : Ordre de Migration
Migrer pwc-ui-shared EN PREMIER, puis pwc-ui APRÈS validation complète de Shared.

### EF-5 : Utilisation de rxjs-compat
Installer rxjs-compat temporairement pour faciliter la migration progressive.

## Exigences Non-Fonctionnelles

### ENF-1 : Compatibilité
Maintenir la compatibilité avec les 500+ repositories clients de pwc-ui-shared.

### ENF-2 : Performance
Aucune régression de performance après migration.

### ENF-3 : Qualité
Maintenir >95% de tests unitaires passants.

### ENF-4 : Traçabilité
Créer des tags Git et documenter toutes les modifications.

## Critères d'Acceptation

### CA-1 : pwc-ui-shared Migré
- [ ] Angular 6.1 installé
- [ ] RxJS 6.0 installé avec rxjs-compat
- [ ] Tous les imports RxJS migrés (aucun `rxjs/add/...` restant)
- [ ] @angular/http complètement supprimé
- [ ] `angular.json` créé (remplace `.angular-cli.json`)
- [ ] Build réussi : `npm run build`
- [ ] Tests passent : `npm test` (>95%)
- [ ] 🚦 **Gate Playwright validé à 100% (BLOQUANT)**
- [ ] Publié sur Nexus
- [ ] Tag Git créé : `palier-1-shared-angular-6`

### CA-2 : pwc-ui Migré (Après Gate Validé)
- [ ] @pwc/shared mis à jour vers nouvelle version
- [ ] Angular 6.1 installé
- [ ] RxJS 6.0 installé avec rxjs-compat
- [ ] Tous les imports RxJS migrés
- [ ] @angular/http complètement supprimé
- [ ] Webpack configs adaptés (si nécessaire)
- [ ] Build réussi : `npm run build`
- [ ] Tests passent : `npm test` (>95%)
- [ ] Application démarre : http://localhost:4200
- [ ] Tests manuels des fonctionnalités critiques OK
- [ ] Tag Git créé : `palier-1-ui-angular-6`

### CA-3 : Gate Playwright (BLOQUANT pour pwc-ui-shared)
- [ ] Application Shared démarre sur port 4201
- [ ] 100% des tests Playwright passent
- [ ] Test demo-home.spec.ts : ✅
- [ ] Test demo-forms.spec.ts : ✅
- [ ] Test demo-navigation.spec.ts : ✅
- [ ] Page d'accueil charge en <5s
- [ ] Aucune erreur console critique

### CA-4 : Vérifications Techniques
- [ ] Aucun import `rxjs/add/...` dans le code
- [ ] Aucun import `@angular/http` dans le code
- [ ] Tous les opérateurs RxJS utilisent `pipe()`
- [ ] `Observable.of()` remplacé par `of()`
- [ ] `.do()` remplacé par `tap()`
- [ ] `.catch()` remplacé par `catchError()`
- [ ] HttpModule remplacé par HttpClientModule
- [ ] Tests HttpClient utilisent HttpClientTestingModule

### CA-5 : Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Problèmes rencontrés documentés
- [ ] Solutions appliquées documentées
- [ ] Temps réel vs estimé documenté

## Contraintes

- **C-1** : Utiliser Node.js v10.24.1 (commande `Use-Node10`)
- **C-2** : Ne pas passer à pwc-ui tant que le gate Playwright n'est pas validé à 100%
- **C-3** : Publier pwc-ui-shared sur Nexus avant de migrer pwc-ui
- **C-4** : Utiliser le codemod officiel `rxjs-5-to-6-migrate`
- **C-5** : Conserver rxjs-compat jusqu'au Palier 2
- **C-6** : Créer des tags Git pour traçabilité

## Dépendances

- `.kiro/steering/02-migration-angular-rules.md` : Règles de migration
- `.kiro/steering/03-rxjs-migration-patterns.md` : Patterns RxJS
- `.kiro/steering/09-version-management.md` : Gestion versions Node.js
- `.kiro/specs/10-workflow-tests-playwright.md` : Workflow Playwright
- `scripts_outils_ia/codemods/migrate-rxjs.js` : Codemod custom RxJS
- `start-pwc-ui-shared-4201.bat` : Script lancement Shared
- `start-pwc-ui.bat` : Script lancement UI

## Risques

### R-1 : Migration RxJS Complexe
**Impact** : 🔴 Critique  
**Probabilité** : Élevée  
**Mitigation** : Utiliser rxjs-compat + codemod officiel

### R-2 : Tests HttpClient Échouent
**Impact** : 🟠 Élevé  
**Probabilité** : Moyenne  
**Mitigation** : Utiliser HttpClientTestingModule dans les tests

### R-3 : Webpack Build Échoue (pwc-ui)
**Impact** : 🟠 Élevé  
**Probabilité** : Moyenne  
**Mitigation** : Adapter webpack.config.js si nécessaire

### R-4 : Gate Playwright Échoue
**Impact** : 🔴 Bloquant  
**Probabilité** : Moyenne  
**Mitigation** : Tests approfondis, correction avant de passer à pwc-ui
