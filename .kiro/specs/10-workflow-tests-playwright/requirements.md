# Requirements - Workflow de Tests avec Gate Playwright

## Objectifs

### Objectif Principal
Établir un processus de validation rigoureux avec un **gate Playwright** qui bloque la migration de `pwc-ui` tant que `pwc-ui-shared` ne passe pas 100% des tests E2E automatisés.

### Objectifs Spécifiques
1. Configurer Playwright pour pwc-ui-shared
2. Créer des tests E2E pour l'écran demo
3. Établir un gate bloquant à 100% de tests passants
4. Configurer les ports (4201 pour shared, 4200 pour ui)
5. Automatiser le workflow avec scripts batch

## Contexte

### Situation Actuelle
- Tests unitaires uniquement (npm test)
- Pas de gate automatique entre shared et ui
- Validation manuelle requise

### Situation Cible
- Tests E2E Playwright automatisés
- Gate bloquant à 100% pour pwc-ui-shared
- Scripts batch pour lancer les apps
- Workflow rigoureux et reproductible

## Contraintes

### Techniques
- **Statut** : ✅ Actif pour tous les paliers
- **Criticité** : Gate BLOQUANT
- **Seuil** : 100% des tests Playwright doivent passer
- **Ordre** : pwc-ui-shared AVANT pwc-ui (toujours)

### Architecture des Ports

```
pwc-ui-shared-v4-ia → Port 4201 (avec tests Playwright)
pwc-ui-v4-ia        → Port 4200 (après gate validé)
```

## Critères d'Acceptation

### Gate Playwright (pwc-ui-shared)

| Critère | Seuil | Blocant ? |
|---------|-------|-----------|
| Tests Playwright passants | **100%** | ✅ **OUI** |
| Page d'accueil charge | < 5s | ✅ OUI |
| Aucune erreur console critique | 0 | ✅ OUI |
| Composants form visibles | 100% | ✅ OUI |
| Navigation fonctionne | 100% | ✅ OUI |

### Résultat du Gate

**✅ SI TOUS LES TESTS PASSENT** :
- Commiter les changements
- Passer à la phase 2 (pwc-ui)

**❌ SI AU MOINS UN TEST ÉCHOUE** :
- Analyser les erreurs
- Corriger les problèmes dans pwc-ui-shared
- Relancer depuis le build
- **NE PAS passer à pwc-ui**

## Tests Couverts

### 1. Page d'Accueil Demo (demo-home.spec.ts)
- [ ] Titre "PWC 3.5 Shared Documentation" visible
- [ ] Texte "Welcome to PowerCARD Sandbox" visible
- [ ] Logo HPS visible
- [ ] Carte du monde PowerCARD visible
- [ ] Menu de navigation présent
- [ ] Aucune erreur console critique

### 2. Composants Form (demo-forms.spec.ts)
- [ ] Documentation "Form Input Component" visible
- [ ] Champs Simple et SimpleRW affichés
- [ ] Champ Password avec toggle visible
- [ ] Champ TextArea visible
- [ ] Champ Number visible
- [ ] periodPicker (1200 H Min) visible
- [ ] Possibilité d'interagir avec les inputs
- [ ] Exemples de code (pwc-input) visibles

### 3. Navigation (demo-navigation.spec.ts)
- [ ] Navigation entre sections fonctionne
- [ ] Responsive mobile (375x667)
- [ ] Responsive tablet (768x1024)

## Workflow Complet

### Phase 1 : pwc-ui-shared

1. **Migration Angular**
2. **Build** : `npm run build`
3. **Tests Unitaires** : `npm test` (>95%)
4. **🚦 GATE PLAYWRIGHT** :
   - Lancer app demo sur port 4201
   - Lancer tests Playwright : `npm run test:e2e`
   - Validation : 100% des tests doivent passer
5. **Commit** si gate passé

### Phase 2 : pwc-ui (Seulement Après Gate Validé)

1. **Mise à jour @pwc/shared**
2. **Migration Angular**
3. **Build** : `npm run build`
4. **Tests** : `npm test`
5. **Lancer app** : Port 4200
6. **Tests manuels**
7. **Commit**

## Scripts Batch Disponibles

**Localisation** : `C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\`

| Script | Description | Port |
|--------|-------------|------|
| `start-pwc-ui-shared-4201.bat` | Lance Shared avec Node v10 | 4201 |
| `start-pwc-ui.bat` | Lance UI avec Node v10 | 4200 |
| `Use-Node10.bat` | Active Node v10 | - |

## Dépendances

### Prérequis
- Playwright installé : `npm install -D @playwright/test`
- Navigateurs installés : `npx playwright install`
- Configuration `playwright.config.ts` créée
- Tests E2E créés dans `e2e/tests/`

### Configuration package.json

```json
{
  "scripts": {
    "start": "ng serve --port 4201",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:report": "playwright show-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.40.0"
  }
}
```

## Risques Identifiés

### Risque 1 : Tests Flaky
- **Probabilité** : Moyenne
- **Impact** : Élevé
- **Mitigation** : Augmenter timeouts, ajouter waitFor explicites

### Risque 2 : Port Déjà Utilisé
- **Probabilité** : Faible
- **Impact** : Moyen
- **Mitigation** : Vérifier et tuer le processus

### Risque 3 : Images de Référence v3.5 vs v4
- **Probabilité** : Élevée
- **Impact** : Faible
- **Mitigation** : Tester présence/fonctionnalité, pas apparence pixel-perfect

## Ressources

### Documentation
- Steering Playwright : `.kiro/steering/11-playwright-e2e-testing.md`
- Stratégie Tests : `.kiro/steering/06-testing-strategy.md`
- README : `.kiro/specs/README.md`

### Outils
- Playwright : https://playwright.dev/
- Scripts batch : `kiro_migration_angular/outils_communs/`
