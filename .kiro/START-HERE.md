# 🚀 Guide de Démarrage - Migration Angular 5 → 20

> **Référencez ce fichier au démarrage** : `#file:.kiro/START-HERE.md`

---

## 📋 Résumé Exécutif

**Projet** : Migration Angular 5 → 20 pour pwc-ui-shared et pwc-ui  
**Stratégie** : Migration incrémentale par 15 paliers  
**Durée estimée** : 8-12 semaines  
**Statut** : ✅ Prêt à commencer le Palier 1

### 🔴 Règle d'Or

```
pwc-ui-shared (lib)  →  pwc-ui (client)
   MIGRER AVANT          MIGRER APRÈS
```

**Séquence obligatoire** : Lib build OK → Lib test OK → Gate Playwright 100% → Client migration

---

## 📁 Fichiers Importants

### Specs (Plans de Migration)
- **Résumé** : `.kiro/specs/00-resume-executif.md`
- **Plan Global** : `.kiro/specs/02-plan-migration.md`
- **Palier 1** : `.kiro/specs/04-palier-01-angular-5-to-6.md`
- **Workflow Playwright** : `.kiro/specs/10-workflow-tests-playwright.md`

### Steering (Règles et Guides)
- **Vue d'ensemble** : `.kiro/steering/01-project-overview.md`
- **Règles de migration** : `.kiro/steering/02-migration-angular-rules.md`
- **Règles de modification** : `.kiro/steering/12-modification-rules.md`
- **Règles de versioning** : `.kiro/steering/13-versioning-rules.md`
- **Gestion versions Node** : `.kiro/steering/09-version-management.md`

### Hooks (Automatisations)
- **Nettoyage** : `.kiro/hooks/cleanup-and-journal.json`
- **Rappel règles** : `.kiro/hooks/rules-reminder.json`
- **Sync index** : `.kiro/hooks/sync-kiro-indexes.json`

### Documentation
- **Journal de bord** : `Documentation/JOURNAL-DE-BORD.md`
- **Système de modification** : `scripts_outils_ia/README-MODIFICATION-SYSTEM.md`

---

## 🎯 Commandes Rapides

### Charger les Fichiers Essentiels
```
Charge les fichiers suivants :
- .kiro/specs/00-resume-executif.md
- .kiro/specs/02-plan-migration.md
- .kiro/steering/02-migration-angular-rules.md
- .kiro/steering/12-modification-rules.md
```

### Commencer le Palier 1
```
Charge la spec du Palier 1 : .kiro/specs/04-palier-01-angular-5-to-6.md
```

### Vérifier le Versioning
```powershell
.\scripts_outils_ia\verify-versioning.ps1
```

### Synchroniser les Index
```powershell
C:\repo_hps\.kiro\scripts\sync-all.bat
```

---

## 🔴 Règles Critiques (À Toujours Respecter)

### Git
- ✅ Rester TOUJOURS sur branche `dev_vibecoding`
- ❌ Ne JAMAIS créer/supprimer de branches
- ❌ Ne JAMAIS faire de Pull Request
- ❌ Ne JAMAIS supprimer de fichiers sans accord explicite

### Modifications
- ✅ Toujours créer un backup avant modification
- ✅ Toujours commenter les modifications (MODIFIED/NEW/DEPRECATED/TEMPORARY)
- ✅ Toujours enregistrer dans `.kiro/state/modifications-index.json`
- ❌ Ne JAMAIS supprimer de lignes (les commenter avec DEPRECATED)

### Migration
- ✅ Toujours migrer pwc-ui-shared EN PREMIER
- ✅ Toujours valider le gate Playwright à 100%
- ✅ Toujours utiliser la bonne version de Node.js (Use-NodeXX)
- ❌ Ne JAMAIS forcer une migration avec --force
- ❌ Ne JAMAIS ignorer les tests qui échouent

---

## 📊 État Actuel

### Commits Effectués
- **pwc-ui-shared** : commit `3a5191bf4` (3 commits en avance)
  - Configuration Nexus
  - Suppression TreeDemoModule
  
- **pwc-ui** : commit `fa503fe07e` (2 commits en avance)
  - Configuration Nexus
  - Lien local @pwc/shared
  - Mode mock désactivé
  - Fichiers temporaires supprimés

### Système de Traçabilité
- ✅ 12 modifications enregistrées (mod-001 à mod-012)
- ✅ Système de backup opérationnel
- ✅ Scripts de rollback disponibles
- ✅ Règles de versioning créées

### Workspace
- ✅ Propre (aucun fichier temporaire)
- ✅ Index synchronisés (11 specs, 14 steering, 3 hooks)
- ✅ Scripts PowerShell Use-NodeXX créés
- ⚠️ 48 fichiers .kiro à versionner

---

## 🚀 Prochaines Étapes

### Immédiat
1. Corriger le versioning des 48 fichiers .kiro
2. Corriger le fichier vide `08-nodejs-version-management.md`
3. Vérifier que Node v10.24.1 est installé

### Palier 1 (Angular 5 → 6)
1. **pwc-ui-shared** :
   - Basculer sur Node v10 : `Use-Node10`
   - Migrer Angular : `ng update @angular/cli@6 @angular/core@6`
   - Build : `npm run build`
   - Tests : `npm test` (>95%)
   - Gate Playwright : 100% ✅

2. **pwc-ui** (après gate validé) :
   - Installer nouvelle version : `npm install pwc-ui-shared@latest`
   - Migrer Angular : `ng update @angular/cli@6 @angular/core@6`
   - Build : `npm run build`
   - Tests : `npm test`
   - Lancer : `start-pwc-ui.bat`

---

## 📞 Aide Rapide

### Charger une Spec
```
Exécute la spec 04-palier-01-angular-5-to-6
```

### Charger un Steering
```
Charge le steering 02-migration-angular-rules
```

### Lister les Modifications
```powershell
.\scripts_outils_ia\list-modifications.ps1
```

### Rollback
```powershell
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-XXX"
```

---

## 💡 Astuces

### Pour Charger Plusieurs Fichiers
Utilisez une liste dans votre prompt :
```
Charge les fichiers suivants :
- .kiro/specs/00-resume-executif.md
- .kiro/steering/02-migration-angular-rules.md
- Documentation/JOURNAL-DE-BORD.md
```

### Pour Référencer un Fichier
Utilisez la syntaxe `#file:` :
```
#file:.kiro/specs/04-palier-01-angular-5-to-6.md
```

### Pour Voir le Journal de Bord
```
Montre-moi les dernières entrées du journal de bord
```

---

## 📝 Versions

- **Journal de bord** : v0.11.0
- **Système de modification** : v0.7.0
- **Règles de versioning** : v1.0.0
- **Scripts Use-NodeXX** : v0.5.0

---

## ✅ Checklist de Démarrage

- [ ] Fichier START-HERE.md chargé
- [ ] Règles critiques lues
- [ ] État actuel compris
- [ ] Prochaines étapes identifiées
- [ ] Node v10.24.1 installé
- [ ] Prêt à commencer le Palier 1

**Commande pour démarrer** : `Charge .kiro/START-HERE.md et commence le Palier 1`

