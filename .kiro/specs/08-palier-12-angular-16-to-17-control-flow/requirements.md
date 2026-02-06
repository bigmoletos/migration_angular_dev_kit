# Requirements - Palier 12 : Angular 16.2 → 17.3 (Control Flow Syntax)

## Objectifs

### Objectif Principal
Migrer Angular 16.2 vers 17.3 en découvrant la nouvelle syntaxe Control Flow qui remplace les directives structurelles classiques.

### Objectifs Spécifiques
1. Découvrir la nouvelle syntaxe Control Flow (`@if`, `@for`, `@switch`)
2. Migrer les templates (optionnel mais recommandé)
3. Découvrir Deferrable Views (`@defer`)
4. Mettre à jour TypeScript 5.2+
5. Valider build et tests

## Contexte

### Situation Actuelle
- Angular 16.2 avec syntaxe classique (`*ngIf`, `*ngFor`, `*ngSwitch`)
- TypeScript 4.9
- Pas de lazy loading de templates

### Situation Cible
- Angular 17.3 avec nouvelle syntaxe disponible
- Templates migrés vers `@if`, `@for`, `@switch` (optionnel)
- Deferrable Views (`@defer`) disponibles
- TypeScript 5.2+
- Meilleure performance des templates

## Contraintes

### Techniques
- **Durée estimée** : 1-2 semaines
- **Complexité** : 🟡 Moyenne
- **Criticité** : Nouvelle syntaxe de templates
- **Tests** : >95% doivent passer
- **Ordre** : pwc-ui-shared AVANT pwc-ui

### Breaking Changes
1. **Nouvelle syntaxe Control Flow** : `@if`, `@for`, `@switch` disponibles
2. **Deferrable Views** : `@defer` pour lazy loading de templates
3. **TypeScript 5.2+** : Nouvelles fonctionnalités
4. **Ancienne syntaxe** : Toujours supportée (rétrocompatible)

## Critères d'Acceptation

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

## Nouvelle Syntaxe Control Flow

### @if (remplace *ngIf)

```html
<!-- AVANT -->
<div *ngIf="user">Welcome {{ user.name }}</div>

<!-- APRÈS -->
@if (user) {
  <div>Welcome {{ user.name }}</div>
}
```

### @for (remplace *ngFor)

```html
<!-- AVANT -->
<li *ngFor="let item of items; trackBy: trackByFn">{{ item.name }}</li>

<!-- APRÈS -->
@for (item of items; track item.id) {
  <li>{{ item.name }}</li>
}
```

### @switch (remplace *ngSwitch)

```html
<!-- AVANT -->
<div [ngSwitch]="status">
  <p *ngSwitchCase="'loading'">Loading...</p>
  <p *ngSwitchDefault>Unknown</p>
</div>

<!-- APRÈS -->
@switch (status) {
  @case ('loading') { <p>Loading...</p> }
  @default { <p>Unknown</p> }
}
```

### @defer (Nouveau - Lazy Loading)

```html
@defer (on viewport) {
  <heavy-component />
} @placeholder {
  <p>Loading...</p>
}
```

## Risques Identifiés

### Risque 1 : Migration Automatique Échoue
- **Probabilité** : Faible
- **Impact** : Moyen
- **Mitigation** : Migration manuelle des templates problématiques

### Risque 2 : Templates Cassés Après Migration
- **Probabilité** : Faible
- **Impact** : Élevé
- **Mitigation** : Tests approfondis, vérification syntaxe

### Risque 3 : Courbe d'Apprentissage
- **Probabilité** : Moyenne
- **Impact** : Faible
- **Mitigation** : Documentation, exemples

## Dépendances

### Prérequis
- Palier 11 (Angular 16) complété et validé
- Node.js v18 installé
- Tests passent sur Angular 16

### Dépendances Externes
- Angular CLI 17.3
- TypeScript 5.2+

## Ressources

### Documentation
- [Angular 17 Release Notes](https://blog.angular.io/introducing-angular-v17-4d7033312e4b)
- [Control Flow Guide](https://angular.io/guide/control-flow)
- [Deferrable Views Guide](https://angular.io/guide/defer)

### Outils
- Angular CLI migration schematic : `ng generate @angular/core:control-flow`
