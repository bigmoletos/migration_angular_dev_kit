# État Actuel du Workspace - Migration Angular

**Date d'analyse** : 2026-02-03  
**Workspace** : `repo_hps`

---

## 📊 Versions Détectées

### pwc-ui-shared (Bibliothèque)
- **Angular** : `5.2.0`
- **RxJS** : `5.5.6`
- **TypeScript** : `2.6.2`
- **Zone.js** : `0.8.20`
- **Angular CLI** : `1.6.3`
- **Webpack** : Non utilisé (Angular CLI natif)

**Composants** :
- `@Component` : 447
- `@Injectable` : 51
- `@NgModule` : 143

### pwc-ui (Application Cliente)
- **Angular** : `5.2.10`
- **RxJS** : `5.5.6`
- **TypeScript** : `2.5.3`
- **Zone.js** : `0.8.26`
- **Angular CLI** : `1.7.4`
- **Webpack** : `4.16.5` (configuration custom)

**Composants** :
- `@Component` : 2369
- `@Injectable` : 109
- `@NgModule` : 547

---

## 🔗 Dépendances Critiques

### Bibliothèques Tierces (pwc-ui)
- **NgRx** : `4.1.1` (Store, Effects, Router-Store, DevTools)
- **PrimeNG** : `5.2.4`
- **ng-block-ui** : `2.0.0`
- **angular-tree-component** : `7.0.2`
- **@ngx-translate** : `9.0.2`
- **Chart.js** : `2.7.1`
- **fullpage.js** : `2.9.7`

### Bibliothèques Tierces (pwc-ui-shared)
- **NgRx** : `4.1.1`
- **PrimeNG** : `5.2.0`
- **ng-block-ui** : `2.0.0`
- **angular-tree-component** : `7.0.2`
- **@ngx-translate** : `9.0.2`
- **Chart.js** : `2.7.2`
- **codemirror** : `5.38.0`
- **ng2-codemirror** : `1.1.3`

---

## ⚠️ Points d'Attention

### Dépendances Internes
- `pwc-ui` dépend de `@pwc/shared@2.6.23`
- **RÈGLE D'OR** : Migrer `pwc-ui-shared` AVANT `pwc-ui`

### Configurations Custom
- **pwc-ui** utilise Webpack custom (`webpack.dev.config.js`, `webpack.prod.config.js`)
- **pwc-ui-shared** utilise Angular CLI natif
- Les deux utilisent Karma pour les tests

### Modules Dépréciés
- `@angular/http` (remplacé par `@angular/common/http` depuis Angular 4.3)
- `rxjs@5.5.6` (patterns obsolètes : `.do()`, `.catch()`, `.map()` sans pipe)

### Build Tools
- **Gradle** présent dans les deux repos (build Java/backend ?)
- **Node.js v10** actuellement utilisé (compatible Angular 5)

---

## 📈 Complexité Estimée

| Métrique | pwc-ui-shared | pwc-ui | Total |
|----------|---------------|--------|-------|
| Composants | 447 | 2369 | 2816 |
| Services | 51 | 109 | 160 |
| Modules | 143 | 547 | 690 |
| **Complexité** | Moyenne | Élevée | Très Élevée |

---

## 🎯 Objectif Final

**Migration vers Angular 20** avec :
- TypeScript 5.6+
- RxJS 7.8+
- Zone.js 0.14+
- Standalone Components (optionnel)
- Signals (optionnel)

---

## 📂 Structure Workspace

```
repo_hps/
├── .kiro/                          # Configuration Kiro (parent)
│   ├── skills/                     # 6 skills disponibles
│   ├── agents/                     # 4 agents spécialisés
│   ├── specs/                      # Spécifications migration
│   └── state/                      # État Strands
├── pwc-ui-shared-v4-ia/           # BIBLIOTHÈQUE (migrer EN PREMIER)
│   └── src/lib/shared/            # Code partagé
└── pwc-ui-v4-ia/                  # CLIENT (migrer APRÈS)
    └── src/app/                   # Application principale
```

---

## ✅ Prochaines Étapes

1. Générer le plan de migration par paliers (5→6→7→...→20)
2. Identifier les risques et breaking changes
3. Préparer les codemods pour chaque palier
4. Initialiser l'état Strands pour le suivi
