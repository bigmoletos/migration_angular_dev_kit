# Design - Résumé Exécutif Migration Angular 5 → 20

## Approche Technique

### Structure du Document

Le résumé exécutif suit une structure en entonnoir :
1. **État actuel** : Où sommes-nous ?
2. **Objectif** : Où voulons-nous aller ?
3. **Plan** : Comment y arriver ?
4. **Risques** : Quels obstacles ?
5. **Outils** : Quels moyens ?
6. **Prochaines étapes** : Par où commencer ?

### Principes de Rédaction

- **Synthèse** : Informations essentielles uniquement
- **Visuel** : Tableaux et listes pour faciliter la lecture
- **Actionnable** : Commandes concrètes pour démarrer
- **Références** : Liens vers documents détaillés

## Décisions Techniques

### DT-1 : Format Tableau pour État Actuel
**Décision** : Utiliser un tableau pour présenter les versions détectées  
**Justification** : Facilite la comparaison entre pwc-ui-shared et pwc-ui  
**Contenu** : Angular, RxJS, TypeScript, Node.js, Nombre de composants

### DT-2 : Identification des Paliers Critiques
**Décision** : Mettre en avant 5 paliers critiques (1, 4, 7, 11, 12)  
**Justification** : Permet de prioriser l'attention et les ressources  
**Présentation** : Tableau avec complexité, durée, raison

### DT-3 : Catégorisation des Risques
**Décision** : Séparer risques critiques (🔴) et élevés (🟠)  
**Justification** : Hiérarchise les préoccupations  
**Contenu** : Description + mitigation pour chaque risque

### DT-4 : Liste des Outils Disponibles
**Décision** : Lister tous les outils (skills, codemods, scripts)  
**Justification** : Montre que l'équipe est bien équipée  
**Organisation** : Par catégorie (Skills Kiro, Codemods, Scripts)

### DT-5 : Instructions Palier 1 Détaillées
**Décision** : Fournir les commandes exactes pour démarrer le Palier 1  
**Justification** : Facilite le démarrage immédiat  
**Contenu** : Commandes PowerShell avec Use-Node10, ng update, tests

### DT-6 : Métriques de Succès
**Décision** : Définir des indicateurs mesurables  
**Justification** : Permet de suivre l'avancement  
**Indicateurs** : Paliers complétés, build, tests, couverture, temps

## Structure Détaillée

### Section 1 : État Actuel

**Tableau des versions** :
| Repo | Angular | RxJS | TypeScript | Node.js | Composants |
|------|---------|------|------------|---------|------------|
| pwc-ui-shared | 5.2.0 | 5.5.6 | 2.6.2 | v10 | 447 |
| pwc-ui | 5.2.10 | 5.5.6 | 2.5.3 | v10 | 2369 |
| TOTAL | - | - | - | - | 2816 |

**Complexité** : Services, Modules, Évaluation globale

### Section 2 : Objectif

**Versions cibles** :
- Angular 20.0
- RxJS 7.8+
- TypeScript 5.6+
- Node.js v20+

**Technologies optionnelles** :
- Standalone Components
- Signals

### Section 3 : Plan de Migration

**Stratégie** : Migration incrémentale par 15 paliers

**Durée** : 8-12 semaines

**Ordre** : pwc-ui-shared → pwc-ui (règle d'or)

### Section 4 : Paliers Critiques

**Tableau** :
| Palier | Versions | Complexité | Durée | Raison |
|--------|----------|------------|-------|--------|
| 1 | 5→6 | 🔴 Élevée | 1-2 sem | Migration RxJS |
| 4 | 8→9 | 🔴 Très Élevée | 2 sem | Migration Ivy |
| 7 | 11→12 | 🟠 Moyenne | 1 sem | Webpack 5 |
| 11 | 15→16 | 🟠 Élevée | 1-2 sem | Signals |
| 12 | 16→17 | 🟡 Moyenne | 1-2 sem | Control flow |

### Section 5 : Risques Majeurs

**Risques critiques (🔴)** :
1. Dépendance circulaire (pwc-ui → @pwc/shared)
2. Migration RxJS 5→6 (2816 composants)
3. Migration Ivy (changement moteur)
4. Webpack custom (configs incompatibles)

**Risques élevés (🟠)** :
- Bibliothèques tierces obsolètes
- Tests unitaires (2816 composants)
- TypeScript 2.5 → 5.6

**Mitigations** : Pour chaque risque

### Section 6 : Outils Disponibles

**Skills Kiro** :
- angular-migration
- codemods-refactoring
- strands-orchestration
- validation-formelle
- code-audit
- rxjs-patterns

**Codemods** :
- rxjs-5-to-6-migrate (officiel)
- migrate-rxjs.js (custom)
- add-static-flag.js (custom)
- migrate-module-with-providers.js (custom)

**Scripts PowerShell** :
- Use-Node10, Use-Node12, etc.
- check-stack.ps1
- start-pwc-ui-shared-4201.bat
- start-pwc-ui.bat

**État Strands** :
- .kiro/state/strands-state.json

### Section 7 : Prochaines Étapes

**1. Préparation** :
```powershell
Use-Node10
node --version
git checkout -b migration-angular-20
```

**2. Palier 1 - pwc-ui-shared** :
```powershell
Use-Node10
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia
npm install rxjs-compat --save
ng update @angular/cli@6 @angular/core@6
rxjs-5-to-6-migrate -p src/tsconfig.app.json
npm test
npm run build
# Gate Playwright (Terminal 1)
start-pwc-ui-shared-4201.bat
# Terminal 2
npm run test:e2e
# Si 100% passent
npm publish
```

**3. Palier 1 - pwc-ui** (Après Gate Validé) :
```powershell
Use-Node10
cd c:/repo_hps/pwc-ui/pwc-ui-v4-ia
npm update @pwc/shared
npm install rxjs-compat --save
ng update @angular/cli@6 @angular/core@6
rxjs-5-to-6-migrate -p src/tsconfig.app.json
npm test
npm run build
start-pwc-ui.bat
```

**4. Validation Palier 1** :
- [ ] pwc-ui-shared : Build ✅, Tests >95% ✅, Gate Playwright 100% ✅, Nexus ✅
- [ ] pwc-ui : Build ✅, Tests >95% ✅, App démarre ✅
- [ ] Tags Git créés

### Section 8 : Métriques de Succès

**Tableau de suivi** :
| Indicateur | Cible | Actuel |
|------------|-------|--------|
| Paliers complétés | 15/15 | 0/15 |
| Build réussi | 100% | - |
| Tests passent | >95% | - |
| Couverture code | >80% | - |
| Temps build | <10 min | - |
| Temps tests | <5 min | - |

### Section 9 : Ressources

**Documentation officielle** :
- Angular Update Guide
- RxJS Migration Guide
- Ivy Migration Guide

**Documentation interne** :
- .kiro/specs/02-plan-migration.md
- .kiro/specs/04-palier-01-angular-5-to-6.md
- .kiro/steering/02-migration-angular-rules.md

## Mise à Jour du Document

Le résumé exécutif doit être mis à jour :
- **Après chaque palier** : Mettre à jour les métriques
- **En cas de problème majeur** : Ajouter dans les risques
- **Nouvelles décisions** : Documenter dans les notes

## Format de Présentation

- **Markdown** : Format source
- **PDF** : Pour distribution management
- **HTML** : Pour consultation web
- **Slides** : Pour présentations (optionnel)
