# 📁 Dossier .kiro - Guide d'Utilisation

> **Important** : Kiro ne charge PAS automatiquement les fichiers de ce dossier. Vous devez les référencer explicitement.

> **Nouveau** : Système de routage intelligent via keywords - voir `CUSTOM-RESOURCES-GUIDE.md`

---

## 🚀 Démarrage Rapide

### Au Début de Chaque Session

**Option 1 : Chargement Manuel (Ancien)**
```
Charge le fichier .kiro/START-HERE.md
```

**Option 2 : Routage Automatique (Nouveau)**
Utilisez simplement des keywords dans votre prompt :
```
Migrer Angular 5 vers 6
Auditer le code de pwc-ui-shared
Coordonner les deux repos
```

Le fichier `.kiro/steering/00-agent-router.md` route automatiquement vers les bonnes ressources.

---

## 📂 Structure du Dossier

```
.kiro/
├── START-HERE.md              ⭐ FICHIER PRINCIPAL - Commencez ici
├── README.md                  📖 Ce fichier
├── config.json                ⚙️ Configuration (non utilisé par Kiro)
│
├── specs/                     📋 Plans de migration
│   ├── _index.json           🔄 Index (pour synchronisation)
│   ├── 00-resume-executif.md ⭐ Résumé exécutif
│   ├── 02-plan-migration.md  ⭐ Plan global
│   ├── 04-palier-01-...md    📝 Spec Palier 1
│   └── ...                   📝 Autres paliers
│
├── steering/                  📚 Règles et guides
│   ├── _index.json           🔄 Index (pour synchronisation)
│   ├── 01-project-overview.md ⭐ Vue d'ensemble
│   ├── 02-migration-angular-rules.md ⭐ Règles de migration
│   ├── 12-modification-rules.md ⭐ Règles de modification
│   ├── 13-versioning-rules.md ⭐ Règles de versioning
│   └── ...                   📝 Autres guides
│
├── hooks/                     🪝 Automatisations
│   ├── cleanup-and-journal.json
│   ├── rules-reminder.json
│   └── sync-kiro-indexes.json
│
├── scripts/                   🔧 Scripts de synchronisation
│   ├── sync-all.bat          ⭐ Synchroniser tous les index
│   ├── sync-specs-index.js
│   ├── sync-steering-index.js
│   └── sync-all-indexes.js
│
├── state/                     💾 État et données
│   ├── modifications-index.json  📝 Index des modifications
│   └── strands-state.json
│
├── temp/                      🗑️ Fichiers temporaires
│   └── *.md                  📄 Rapports temporaires
│
└── templates/                 📄 Templates
    └── journal-entry-template.md
```

---

## 🎯 Comment Charger les Fichiers

### Méthode 1 : Référence Explicite (Recommandé)

Dans le chat Kiro, tapez :
```
Charge le fichier .kiro/specs/04-palier-01-angular-5-to-6.md
```

### Méthode 2 : Liste de Fichiers

Pour charger plusieurs fichiers :
```
Charge les fichiers suivants :
- .kiro/START-HERE.md
- .kiro/specs/02-plan-migration.md
- .kiro/steering/02-migration-angular-rules.md
```

### Méthode 3 : Syntaxe #file

Utilisez la syntaxe `#file:` :
```
#file:.kiro/START-HERE.md
```

---

## ⭐ Fichiers Essentiels

### À Charger au Démarrage
1. **START-HERE.md** - Point d'entrée principal
2. **specs/00-resume-executif.md** - Résumé du projet
3. **specs/02-plan-migration.md** - Plan des 15 paliers
4. **steering/02-migration-angular-rules.md** - Règles de migration

### Pour Commencer un Palier
1. **specs/04-palier-01-angular-5-to-6.md** - Spec du Palier 1
2. **steering/09-version-management.md** - Gestion des versions Node
3. **specs/10-workflow-tests-playwright.md** - Workflow de tests

### Pour les Modifications
1. **steering/12-modification-rules.md** - Règles de modification
2. **steering/13-versioning-rules.md** - Règles de versioning

---

## 🔄 Synchronisation des Index

Les fichiers `_index.json` sont utilisés pour la synchronisation automatique des index.

### Synchroniser Manuellement
```powershell
C:\repo_hps\.kiro\scripts\sync-all.bat
```

### Synchronisation Automatique
Le hook `sync-kiro-indexes.json` se déclenche automatiquement en fin de session.

---

## 🪝 Hooks (Automatisations)

Les hooks sont des automatisations qui se déclenchent sur certains événements.

### Hooks Disponibles

1. **cleanup-and-journal.json**
   - Déclenché : Fin de session (`agentStop`)
   - Action : Nettoie les fichiers temporaires et propose de mettre à jour le journal

2. **rules-reminder.json**
   - Déclenché : Tous les 10 messages (`promptSubmit`)
   - Action : Rappelle les règles critiques (silencieux)

3. **sync-kiro-indexes.json**
   - Déclenché : Fin de session (`agentStop`)
   - Action : Synchronise les index specs et steering

### Comment Utiliser les Hooks

Les hooks se déclenchent automatiquement. Vous n'avez rien à faire.

---

## 📝 Specs vs Steering

### Specs (Plans de Migration)
- **Quoi** : Plans détaillés pour chaque palier de migration
- **Quand** : Charger avant de commencer un palier
- **Exemple** : `04-palier-01-angular-5-to-6.md`

### Steering (Règles et Guides)
- **Quoi** : Règles, guides techniques, bonnes pratiques
- **Quand** : Charger selon le besoin (RxJS, Ivy, Webpack, etc.)
- **Exemple** : `02-migration-angular-rules.md`

---

## 🔧 Scripts Utiles

### Vérifier le Versioning
```powershell
.\scripts_outils_ia\verify-versioning.ps1
```

### Lister les Modifications
```powershell
.\scripts_outils_ia\list-modifications.ps1
```

### Rollback
```powershell
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-XXX"
```

### Basculer Version Node
```powershell
Use-Node10  # Pour Angular 5-8
Use-Node12  # Pour Angular 9-11
Use-Node14  # Pour Angular 12
# etc.
```

---

## ❓ FAQ

### Q : Pourquoi Kiro ne charge pas automatiquement les fichiers ?
**R** : Kiro ne charge pas automatiquement les fichiers du dossier `.kiro`. Vous devez les référencer explicitement dans le chat.

### Q : Comment savoir quels fichiers charger ?
**R** : Commencez toujours par `START-HERE.md` qui contient les liens vers tous les fichiers importants.

### Q : Les hooks fonctionnent-ils ?
**R** : Oui, les hooks se déclenchent automatiquement selon les événements configurés.

### Q : À quoi servent les fichiers _index.json ?
**R** : Ils sont utilisés pour la synchronisation automatique des index, pas pour le chargement par Kiro.

### Q : Comment mettre à jour les index ?
**R** : Exécutez `C:\repo_hps\.kiro\scripts\sync-all.bat` ou attendez la fin de session (hook automatique).

---

## 💡 Bonnes Pratiques

### Au Démarrage de Chaque Session
1. Charger `START-HERE.md`
2. Lire les règles critiques
3. Vérifier l'état actuel
4. Charger les specs/steering nécessaires

### Pendant le Travail
1. Référencer les fichiers au besoin
2. Suivre les règles de modification
3. Mettre à jour le journal de bord

### En Fin de Session
1. Le hook cleanup se déclenche automatiquement
2. Vérifier les fichiers temporaires
3. Synchroniser les index (automatique)

---

## 📞 Aide

### Problème : Kiro ne voit pas mes fichiers
**Solution** : Chargez-les explicitement avec `Charge le fichier .kiro/...`

### Problème : Les hooks ne se déclenchent pas
**Solution** : Les hooks se déclenchent automatiquement, vous ne les verrez pas dans le chat.

### Problème : Les index sont désynchronisés
**Solution** : Exécutez `C:\repo_hps\.kiro\scripts\sync-all.bat`

---

## ✅ Checklist

- [ ] Fichier START-HERE.md lu
- [ ] Règles critiques comprises
- [ ] Fichiers essentiels identifiés
- [ ] Méthode de chargement comprise
- [ ] Scripts utiles repérés
- [ ] Prêt à travailler

**Commande pour démarrer** : `Charge .kiro/START-HERE.md`

