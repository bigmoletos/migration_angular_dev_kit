# Spec Palier 12 : Angular 16.2 → 17.3 (Control Flow Syntax)

**Durée estimée** : 1-2 semaines  
**Complexité** : 🟡 Moyenne  
**Criticité** : Nouvelle syntaxe de templates

---

## 🎯 Objectifs

1. Migrer Angular 16.2 → 17.3
2. Découvrir la nouvelle syntaxe Control Flow (`@if`, `@for`, `@switch`)
3. Migrer les templates (optionnel mais recommandé)
4. Mettre à jour TypeScript 5.2+
5. Valider build et tests

---

## 📋 Breaking Changes

### 1. Nouvelle Syntaxe Control Flow
- `@if` remplace `*ngIf`
- `@for` remplace `*ngFor`
- `@switch` remplace `*ngSwitch`
- Plus performant et plus lisible

### 2. Deferrable Views (`@defer`)
- Lazy loading de parties de templates
- Améliore les performances

### 3. TypeScript 5.2+ Requis
- Nouvelles fonctionnalités TypeScript

---

## 🎯 Nouvelle Syntaxe Control Flow

### @if (remplace *ngIf)

#### AVANT (*ngIf)
```html
<div *ngIf="user">
  <p>Welcome {{ user.name }}</p>
</div>

<div *ngIf="user; else loading">
  <p>Welcome {{ user.name }}</p>
</div>
<ng-template #loading>
  <p>Loading...</p>
</ng-template>
```

#### APRÈS (@if)
```html
@if (user) {
  <div>
    <p>Welcome {{ user.name }}</p>
  </div>
}

@if (user) {
  <div>
    <p>Welcome {{ user.name }}</p>
  </div>
} @else {
  <p>Loading...</p>
}
```

**Avantages** :
- Plus lisible
- Pas besoin de `<ng-template>`
- Plus performant

---

### @for (remplace *ngFor)

#### AVANT (*ngFor)
```html
<ul>
  <li *ngFor="let item of items; let i = index; trackBy: trackByFn">
    {{ i }}: {{ item.name }}
  </li>
</ul>

<div *ngIf="items.length === 0">
  No items
</div>
```

#### APRÈS (@for)
```html
<ul>
  @for (item of items; track item.id) {
    <li>{{ $index }}: {{ item.name }}</li>
  } @empty {
    <li>No items</li>
  }
</ul>
```

**Avantages** :
- `track` obligatoire (meilleure performance)
- `@empty` intégré
- Variables implicites : `$index`, `$first`, `$last`, `$even`, `$odd`, `$count`

---

### @switch (remplace *ngSwitch)

#### AVANT (*ngSwitch)
```html
<div [ngSwitch]="status">
  <p *ngSwitchCase="'loading'">Loading...</p>
  <p *ngSwitchCase="'success'">Success!</p>
  <p *ngSwitchCase="'error'">Error!</p>
  <p *ngSwitchDefault>Unknown</p>
</div>
```

#### APRÈS (@switch)
```html
@switch (status) {
  @case ('loading') {
    <p>Loading...</p>
  }
  @case ('success') {
    <p>Success!</p>
  }
  @case ('error') {
    <p>Error!</p>
  }
  @default {
    <p>Unknown</p>
  }
}
```

---

### @defer (Nouveau - Lazy Loading)

```html
@defer (on viewport) {
  <heavy-component />
} @placeholder {
  <p>Loading component...</p>
} @loading (minimum 1s) {
  <spinner />
} @error {
  <p>Failed to load</p>
}
```

**Triggers** :
- `on idle` : Quand le navigateur est idle
- `on viewport` : Quand visible dans le viewport
- `on interaction` : Au clic/hover
- `on hover` : Au survol
- `on immediate` : Immédiatement
- `on timer(2s)` : Après un délai

---

## 🔄 Ordre d'Exécution

### Phase 1 : pwc-ui-shared (PRIORITÉ 1)

#### Étape 1.1 : Préparation
```bash
cd c:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia

# Créer une branche
git checkout -b palier-12-angular-17-control-flow

# Créer un tag de sauvegarde
git tag palier-11-angular-16-shared

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 16)
- [ ] Tests passent

---

#### Étape 1.2 : Mettre à jour Angular
```bash
# Dry-run
ng update @angular/cli@17 @angular/core@17 --dry-run

# Appliquer
ng update @angular/cli@17 @angular/core@17 --allow-dirty
```

**Ce qui change** :
- Angular 17.3 installé
- TypeScript 5.2+ installé
- Nouvelle syntaxe disponible

**Validation** :
- [ ] Angular 17.3 installé
- [ ] TypeScript 5.2+ installé
- [ ] Compilation réussie

---

#### Étape 1.3 : Migration Automatique des Templates (RECOMMANDÉ)

Angular CLI fournit un schematic pour migrer automatiquement :

```bash
ng generate @angular/core:control-flow
```

**Ce qui est migré** :
- `*ngIf` → `@if`
- `*ngFor` → `@for`
- `*ngSwitch` → `@switch`

**Options** :
```bash
# Dry-run (voir les changements)
ng generate @angular/core:control-flow --dry-run

# Migrer un chemin spécifique
ng generate @angular/core:control-flow --path=src/app/components

# Migrer tout le projet
ng generate @angular/core:control-flow
```

**Validation** :
- [ ] Migration automatique exécutée
- [ ] Templates mis à jour
- [ ] Compilation réussie

---

#### Étape 1.4 : Vérification Manuelle des Templates

**Vérifier** que la migration automatique a bien fonctionné :

```bash
# Chercher les anciens patterns
grep -r "\*ngIf" src/ --include="*.html"
grep -r "\*ngFor" src/ --include="*.html"
grep -r "\*ngSwitch" src/ --include="*.html"
```

**Si des templates n'ont pas été migrés** :
- Les migrer manuellement
- Ou les laisser (l'ancienne syntaxe fonctionne toujours)

**Validation** :
- [ ] Templates vérifiés
- [ ] Décision prise (migrer tout ou partiellement)

---

#### Étape 1.5 : Utiliser @defer (Optionnel)

**Identifier** les composants lourds qui pourraient bénéficier de `@defer` :
- Composants avec beaucoup de données
- Composants rarement visibles
- Composants en bas de page

**Exemple** :
```html
<!-- AVANT -->
<app-heavy-chart [data]="chartData"></app-heavy-chart>

<!-- APRÈS -->
@defer (on viewport) {
  <app-heavy-chart [data]="chartData" />
} @placeholder {
  <div class="chart-placeholder">Chart will load when visible</div>
}
```

**Validation** :
- [ ] Composants lourds identifiés
- [ ] `@defer` utilisé si pertinent

---

#### Étape 1.6 : Build
```bash
npm run build
```

**Validation** :
- [ ] Build réussi
- [ ] Bundles générés correctement

---

#### Étape 1.7 : Tests
```bash
npm test
```

**Note** : Les tests ne devraient pas être impactés (la logique ne change pas).

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 1.8 : Publication sur Nexus
```bash
# Incrémenter la version (patch)
npm version patch

# Publier
npm publish
```

**Validation** :
- [ ] Version incrémentée
- [ ] Publication réussie

---

#### Étape 1.9 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 17 with Control Flow syntax"
git tag palier-12-shared-angular-17-control-flow
git push origin palier-12-angular-17-control-flow
git push origin palier-12-shared-angular-17-control-flow
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
git checkout -b palier-12-angular-17-control-flow

# Créer un tag de sauvegarde
git tag palier-11-angular-16-ui

# Vérifier l'état actuel
ng version
npm test
npm run build
```

**Validation** :
- [ ] Branche créée
- [ ] Tag créé
- [ ] Build réussi (Angular 16)

---

#### Étape 2.2 : Mettre à jour @pwc/shared
```bash
npm install @pwc/shared@latest
```

**Validation** :
- [ ] `@pwc/shared` mis à jour

---

#### Étape 2.3 : Mettre à jour Angular
```bash
ng update @angular/cli@17 @angular/core@17 --allow-dirty
```

**Validation** :
- [ ] Angular 17.3 installé
- [ ] TypeScript 5.2+ installé

---

#### Étape 2.4 : Migration Automatique des Templates
```bash
ng generate @angular/core:control-flow
```

**Validation** :
- [ ] Migration automatique exécutée
- [ ] Templates mis à jour

---

#### Étape 2.5 : Vérification Manuelle
Même processus que pwc-ui-shared (Étape 1.4).

**Validation** :
- [ ] Templates vérifiés

---

#### Étape 2.6 : Utiliser @defer (Optionnel)
Même processus que pwc-ui-shared (Étape 1.5).

**Validation** :
- [ ] `@defer` utilisé si pertinent

---

#### Étape 2.7 : Build
```bash
npm run build
```

**Validation** :
- [ ] Build réussi

---

#### Étape 2.8 : Tests
```bash
npm test
```

**Validation** :
- [ ] >95% des tests passent

---

#### Étape 2.9 : Test Manuel
```bash
npm start
```

**Tester** :
- [ ] Application démarre
- [ ] Login fonctionne
- [ ] Navigation fonctionne
- [ ] Templates affichent correctement
- [ ] Aucune erreur console
- [ ] Aucune régression visuelle

---

#### Étape 2.10 : Tag Git
```bash
git add .
git commit -m "feat: migrate to Angular 17 with Control Flow syntax"
git tag palier-12-ui-angular-17-control-flow
git push origin palier-12-angular-17-control-flow
git push origin palier-12-ui-angular-17-control-flow
```

**Validation** :
- [ ] Commit créé
- [ ] Tag créé

---

## 📊 Comparaison Syntaxe

| Fonctionnalité | Ancienne Syntaxe | Nouvelle Syntaxe |
|----------------|------------------|------------------|
| Condition | `*ngIf="condition"` | `@if (condition) {}` |
| Else | `*ngIf="...; else tpl"` | `@if (...) {} @else {}` |
| Boucle | `*ngFor="let x of items"` | `@for (x of items; track x.id) {}` |
| Empty | Séparé avec `*ngIf` | `@empty {}` intégré |
| Switch | `[ngSwitch]` + `*ngSwitchCase` | `@switch () { @case () {} }` |
| Track | `trackBy: fn` | `track expression` |

---

## 📊 Métriques de Validation

| Métrique | pwc-ui-shared | pwc-ui | Statut |
|----------|---------------|--------|--------|
| Build réussi | ✅ | ✅ | |
| Tests passent | >95% | >95% | |
| Angular 17.3 | ✅ | ✅ | |
| TypeScript 5.2+ | ✅ | ✅ | |
| Templates migrés | ✅ | ✅ | |
| Application démarre | N/A | ✅ | |

---

## ⚠️ Problèmes Connus et Solutions

### Problème 1 : Migration automatique échoue
**Solution** : Migrer manuellement les templates problématiques

### Problème 2 : "track is required"
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

### Problème 3 : Templates cassés après migration
**Solution** : Vérifier la syntaxe, les accolades doivent être correctes

---

## 📚 Ressources

- [Angular 17 Release Notes](https://blog.angular.io/introducing-angular-v17-4d7033312e4b)
- [Control Flow Guide](https://angular.io/guide/control-flow)
- [Deferrable Views Guide](https://angular.io/guide/defer)

---

## ✅ Checklist Finale

### pwc-ui-shared
- [ ] Angular 17.3 installé
- [ ] TypeScript 5.2+ installé
- [ ] Templates migrés (automatique ou manuel)
- [ ] `@defer` utilisé si pertinent
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Publié sur Nexus
- [ ] Tag Git créé

### pwc-ui
- [ ] @pwc/shared mis à jour
- [ ] Angular 17.3 installé
- [ ] TypeScript 5.2+ installé
- [ ] Templates migrés
- [ ] `@defer` utilisé si pertinent
- [ ] Build réussi
- [ ] Tests passent (>95%)
- [ ] Application démarre
- [ ] Templates affichent correctement
- [ ] Tests manuels OK
- [ ] Tag Git créé

### Documentation
- [ ] `.kiro/state/strands-state.json` mis à jour
- [ ] Décision migration templates documentée
- [ ] Problèmes rencontrés documentés

---

## 🎯 Prochaine Étape

Une fois le Palier 12 validé, passer au **Palier 13 : Angular 17 → 18** (TypeScript 5.4+).
