# Palier 0 : Validation Infrastructure

> **Statut** : ✅ Configuré - ⏳ En attente de validation  
> **Date** : 2026-02-05  
> **Durée estimée** : 30-45 minutes

---

## 🎯 Objectif

Valider que les applications **pwc-ui-shared** et **pwc-ui** fonctionnent correctement sur Angular 5 actuel AVANT de commencer la migration.

---

## 📊 Vue d'Ensemble

### Ce qui a été fait

✅ **Configuration Playwright** :
- pwc-ui-shared : Playwright déjà installé, tests améliorés/créés
- pwc-ui : Configuration et tests créés

✅ **Tests E2E créés** :
- pwc-ui-shared : 18 tests (3 fichiers)
- pwc-ui : 13 tests (3 fichiers)

✅ **Documentation** :
- Steering file Playwright (11-playwright-e2e-testing.md)
- Instructions utilisateur
- Résumé du Gate

### Ce qu'il reste à faire

⏳ **Installation** :
- Installer Playwright dans pwc-ui

⏳ **Validation** :
- Exécuter les tests sur Angular 5 actuel
- Documenter les résultats

---

## 🚀 Démarrage Rapide

### 1. Lire les Instructions

📖 **[INSTRUCTIONS-UTILISATEUR.md](./INSTRUCTIONS-UTILISATEUR.md)**

Ce document contient toutes les étapes détaillées pour exécuter les tests.

### 2. Exécuter les Tests

```powershell
# Installer Playwright dans pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm install --save-dev @playwright/test@^1.40.0 --legacy-peer-deps

# Tester pwc-ui-shared
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start  # Terminal 1
npm run test:e2e  # Terminal 2

# Tester pwc-ui (après gate validé)
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start  # Terminal 1
npm run test:e2e  # Terminal 2
```

### 3. Documenter les Résultats

Mettre à jour `Documentation/JOURNAL-DE-BORD.md` avec les résultats.

---

## 📁 Structure du Palier 0

```
00-palier-00-validation-infrastructure/
├── README.md                          # Ce fichier
├── INSTRUCTIONS-UTILISATEUR.md        # Instructions détaillées
├── GATE-PLAYWRIGHT-RESUME.md          # Résumé complet du Gate
├── design.md                          # Design technique
└── implementation.md                  # (À créer après validation)
```

---

## 🚦 Gate Playwright

### Principe

```
pwc-ui-shared (Port 4201)
    ↓
🚦 Tests Playwright (18 tests)
    ↓
✅ 100% passent → Tester pwc-ui
❌ Échec → Corriger avant de continuer
    ↓
pwc-ui (Port 4200)
    ↓
🚦 Tests Playwright (13 tests)
    ↓
✅ 100% passent → Palier 0 validé
❌ Échec → Corriger
```

### Règle Bloquante

**Les tests Playwright de pwc-ui-shared DOIVENT passer à 100% avant de tester pwc-ui.**

---

## 📊 Tests Créés

### pwc-ui-shared (18 tests)

| Fichier | Tests | Description |
|---------|-------|-------------|
| `demo-home.spec.ts` | 6 | Page d'accueil, titre, navigation, erreurs |
| `demo-forms.spec.ts` | 5 | Composants form, inputs, boutons |
| `demo-navigation.spec.ts` | 7 | Navigation, routes, lazy-loading |

### pwc-ui (13 tests)

| Fichier | Tests | Description |
|---------|-------|-------------|
| `app-home.spec.ts` | 6 | Page d'accueil, titre, navigation, erreurs |
| `app-forms.spec.ts` | 3 | Éléments de formulaire, inputs, boutons |
| `app-navigation.spec.ts` | 4 | Navigation, routes, lazy-loading |

---

## 📚 Documentation

### Documents Principaux

1. **[INSTRUCTIONS-UTILISATEUR.md](./INSTRUCTIONS-UTILISATEUR.md)**
   - Instructions pas à pas
   - Commandes à exécuter
   - Résolution de problèmes

2. **[GATE-PLAYWRIGHT-RESUME.md](./GATE-PLAYWRIGHT-RESUME.md)**
   - Résumé complet du Gate
   - Configuration détaillée
   - Workflow complet

3. **[design.md](./design.md)**
   - Design technique
   - Architecture des tests
   - Configuration Playwright

### Steering Files

- **`.kiro/steering/11-playwright-e2e-testing.md`**
  - Documentation complète du Gate Playwright
  - Règles et bonnes pratiques
  - Debugging et résolution de problèmes

- **`.kiro/steering/06-testing-strategy.md`**
  - Stratégie de tests globale
  - Tests unitaires et E2E
  - Validation par palier

---

## ✅ Checklist

### Configuration
- [x] Playwright installé dans pwc-ui-shared
- [x] Tests E2E créés pour pwc-ui-shared (18 tests)
- [x] Configuration Playwright créée pour pwc-ui
- [x] Tests E2E créés pour pwc-ui (13 tests)
- [x] Scripts npm ajoutés
- [x] Documentation créée

### Installation
- [ ] Playwright installé dans pwc-ui

### Validation
- [ ] pwc-ui-shared : 18 tests passent à 100%
- [ ] pwc-ui : 13 tests passent à 100%
- [ ] Résultats documentés dans le journal de bord
- [ ] Baseline de référence créé

---

## 🎯 Prochaines Étapes

1. **Maintenant** : Exécuter les tests (voir INSTRUCTIONS-UTILISATEUR.md)
2. **Après validation** : Documenter les résultats
3. **Ensuite** : Passer au Palier 1 (Angular 5 → 6)

---

## 📞 Support

### Problèmes Courants

- **Port déjà utilisé** : Voir INSTRUCTIONS-UTILISATEUR.md
- **Tests timeout** : Voir GATE-PLAYWRIGHT-RESUME.md
- **Application ne démarre pas** : Vérifier node_modules et package-lock.json

### Outils de Debug

```powershell
npm run test:e2e:ui       # Mode UI interactif
npm run test:e2e:debug    # Mode debug
npm run test:e2e:report   # Rapport HTML
```

---

## 📝 Notes

- **Gate Bloquant** : Les tests Playwright de pwc-ui-shared sont un gate BLOQUANT
- **100% Requis** : Tous les tests doivent passer, pas de tolérance
- **Ports Fixes** : pwc-ui-shared sur 4201, pwc-ui sur 4200
- **Ordre Strict** : Toujours tester pwc-ui-shared AVANT pwc-ui

---

## 🎉 Succès

Si tous les tests passent, le **Palier 0 est validé** ! Vous êtes prêt pour le Palier 1.

---

**Dernière mise à jour** : 2026-02-05  
**Version** : 1.0.0
