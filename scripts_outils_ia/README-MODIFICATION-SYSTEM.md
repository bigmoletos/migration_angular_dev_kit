# Système de Gestion des Modifications

> **Objectif** : Traçabilité et rollback de toutes les modifications sans dépendre uniquement de Git

---

## 📋 Vue d'Ensemble

Ce système permet de :
- ✅ Tracer toutes les modifications de fichiers
- ✅ Créer des backups automatiques
- ✅ Rollback facilement sans Git
- ✅ Vérifier l'intégrité des modifications
- ✅ Nettoyer les anciens backups

---

## 🚀 Quick Start

### 1. Modifier un Fichier

```powershell
# 1. Créer un backup
.\scripts_outils_ia\backup-file.ps1 -File "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json"

# 2. Enregistrer la modification
.\scripts_outils_ia\register-modification.ps1 `
    -File "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json" `
    -Type "addition" `
    -Description "Ajout de json-ignore" `
    -Reason "json-ignore utilisé par @pwc/shared" `
    -RelatedJournalEntry "v0.4.0"

# 3. Modifier le fichier avec commentaires
# (Ajouter les commentaires MODIFIED/NEW/DEPRECATED)

# 4. Vérifier
.\scripts_outils_ia\list-modifications.ps1
```

### 2. Rollback

```powershell
# Rollback d'une modification
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"

# Rollback d'un fichier (dernière modification)
.\scripts_outils_ia\rollback.ps1 -File "package.json"

# Rollback d'une date
.\scripts_outils_ia\rollback.ps1 -Date "2026-02-03"
```

---

## 📂 Structure

```
.kiro/
├── state/
│   └── modifications-index.json    # Index de toutes les modifications
├── steering/
│   └── 12-modification-rules.md    # Règles de modification
└── ...

.kiro-backup/
└── backup/
    ├── 2026-02-03/
    │   ├── mod-001-package.json.bak
    │   └── ...
    └── README.md

scripts_outils_ia/
├── backup-file.ps1                 # Créer un backup
├── register-modification.ps1       # Enregistrer une modification
├── rollback.ps1                    # Rollback
├── list-modifications.ps1          # Lister les modifications
├── verify-backups.ps1              # Vérifier les backups
├── verify-comments.ps1             # Vérifier les commentaires
├── cleanup-backups.ps1             # Nettoyer les anciens backups
└── README-MODIFICATION-SYSTEM.md   # Ce fichier
```

---

## 🔧 Scripts Disponibles

### backup-file.ps1
Crée un backup d'un fichier avant modification

```powershell
.\scripts_outils_ia\backup-file.ps1 -File "path/to/file"
```

### register-modification.ps1
Enregistre une modification dans l'index

```powershell
.\scripts_outils_ia\register-modification.ps1 `
    -File "path/to/file" `
    -Type "modification" `
    -Description "Description" `
    -Reason "Raison" `
    -RelatedJournalEntry "v0.4.0"
```

**Types** : `modification`, `addition`, `deprecation`, `creation`

### rollback.ps1
Effectue un rollback

```powershell
# Par ID
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"

# Par fichier
.\scripts_outils_ia\rollback.ps1 -File "package.json"

# Par date
.\scripts_outils_ia\rollback.ps1 -Date "2026-02-03"

# Par version du journal
.\scripts_outils_ia\rollback.ps1 -JournalVersion "v0.4.0"
```

### list-modifications.ps1
Liste les modifications

```powershell
# Toutes
.\scripts_outils_ia\list-modifications.ps1

# Par ID
.\scripts_outils_ia\list-modifications.ps1 -ModificationId "mod-001"

# Par fichier
.\scripts_outils_ia\list-modifications.ps1 -File "package.json"

# Par date
.\scripts_outils_ia\list-modifications.ps1 -Date "2026-02-03"

# Par statut
.\scripts_outils_ia\list-modifications.ps1 -Status "applied"

# Détaillé
.\scripts_outils_ia\list-modifications.ps1 -Detailed
```

### verify-backups.ps1
Vérifie que tous les backups existent

```powershell
.\scripts_outils_ia\verify-backups.ps1
```

### verify-comments.ps1
Vérifie que les fichiers ont des commentaires

```powershell
# Tous les fichiers
.\scripts_outils_ia\verify-comments.ps1

# Un fichier spécifique
.\scripts_outils_ia\verify-comments.ps1 -File "package.json"
```

### cleanup-backups.ps1
Nettoie les anciens backups

```powershell
# Dry run (simulation)
.\scripts_outils_ia\cleanup-backups.ps1 -DaysOld 30 -DryRun

# Suppression réelle
.\scripts_outils_ia\cleanup-backups.ps1 -DaysOld 30
```

---

## 📝 Format des Commentaires

### Fichiers JSON/Properties

```json
{
  // ORIGINAL: "value": "old"
  // MODIFIED: 2026-02-03 - Kiro - Description (mod-001)
  "value": "new"
}
```

### Fichiers TypeScript/JavaScript

```typescript
// DEPRECATED: 2026-02-03 - Kiro - Description (mod-001)
// const oldFunction = () => { };

// NEW: 2026-02-03 - Kiro - Description (mod-001)
const newFunction = () => { };
```

### Fichiers Gradle

```gradle
# ORIGINAL: url System.getenv('VAR')
# MODIFIED: 2026-02-03 - Kiro - Description (mod-001)
url System.getenv('VAR') ?: System.getProperty('VAR')
```

---

## 🔍 Workflow Complet

### Avant de Modifier un Fichier

1. **Backup** : `.\scripts_outils_ia\backup-file.ps1 -File "path/to/file"`
2. **Enregistrer** : `.\scripts_outils_ia\register-modification.ps1 ...`
3. **Modifier** : Ajouter les commentaires appropriés
4. **Vérifier** : `.\scripts_outils_ia\verify-comments.ps1 -File "file"`

### En Cas de Problème

1. **Lister** : `.\scripts_outils_ia\list-modifications.ps1 -File "file"`
2. **Rollback** : `.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-XXX"`
3. **Vérifier** : `git diff path/to/file`

---

## ⚠️ Règles Importantes

1. **Ne JAMAIS supprimer de lignes** : Toujours commenter
2. **Toujours créer un backup** : Avant toute modification
3. **Toujours enregistrer** : Dans l'index des modifications
4. **Toujours commenter** : Format MODIFIED/NEW/DEPRECATED
5. **Toujours vérifier** : Que le backup existe

---

## 📊 Maintenance

### Vérification Quotidienne

```powershell
# Vérifier les backups
.\scripts_outils_ia\verify-backups.ps1

# Vérifier les commentaires
.\scripts_outils_ia\verify-comments.ps1
```

### Nettoyage Mensuel

```powershell
# Nettoyer les backups de plus de 30 jours
.\scripts_outils_ia\cleanup-backups.ps1 -DaysOld 30
```

---

## 🔗 Ressources

- **Steering** : `.kiro/steering/12-modification-rules.md`
- **Index** : `.kiro/state/modifications-index.json`
- **Backups** : `.kiro-backup/backup/`
- **Journal** : `Documentation/JOURNAL-DE-BORD.md`

---

## 💡 Exemples

### Exemple 1 : Modifier package.json

```powershell
# 1. Backup
$backup = .\scripts_outils_ia\backup-file.ps1 -File "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json"

# 2. Enregistrer
$modId = .\scripts_outils_ia\register-modification.ps1 `
    -File "c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json" `
    -Type "addition" `
    -Description "Ajout de json-ignore" `
    -Reason "Dépendance manquante" `
    -Backup $backup `
    -RelatedJournalEntry "v0.4.0"

# 3. Modifier le fichier
# Ajouter dans package.json :
# // ORIGINAL: "fullpage.js": "^2.9.7",
# // NEW: 2026-02-03 - Kiro - Ajout json-ignore (mod-001)
# "fullpage.js": "^2.9.7",
# "json-ignore": "^0.4.0",

# 4. Vérifier
.\scripts_outils_ia\list-modifications.ps1 -ModificationId $modId
.\scripts_outils_ia\verify-comments.ps1 -File "package.json"
```

### Exemple 2 : Rollback

```powershell
# Rollback de la modification
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"

# Vérifier
git diff c:/repo_hps/pwc-ui/pwc-ui-v4-ia/package.json
```

---

## ✅ Checklist

Avant chaque modification :
- [ ] Backup créé
- [ ] Modification enregistrée dans l'index
- [ ] Commentaires ajoutés dans le fichier
- [ ] Backup vérifié
- [ ] Modification testée
- [ ] Journal de bord mis à jour
