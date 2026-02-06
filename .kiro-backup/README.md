# 📁 Dossier .kiro-backup - Système de Snapshots

> **Version** : 2.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **snapshots** et **diffs** des fichiers modifiés pendant la migration Angular.

Le système de snapshots permet :
- ✅ Rollback précis et fiable
- ✅ Fichiers sources propres (pas de commentaires)
- ✅ Traçabilité complète des modifications
- ✅ Documentation des changements via diffs

---

## 📂 Structure

```
.kiro-backup/
├── snapshots/                    # Snapshots complets des fichiers
│   ├── 2026-02-04/              # Organisés par date
│   │   ├── mod-001-package.json # Snapshot AVANT modification
│   │   ├── mod-002-npmrc
│   │   └── mod-003-tsconfig.json
│   └── 2026-02-05/
│       └── ...
├── diffs/                        # Diffs générés (documentation)
│   ├── mod-001.diff             # Diff de la modification mod-001
│   ├── mod-002.diff
│   └── mod-003.diff
└── README.md                     # Ce fichier
```

---

## 🔄 Workflow

### Création d'un Snapshot

```powershell
# 1. Générer un ID unique
$modId = "mod-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$date = Get-Date -Format "yyyy-MM-dd"

# 2. Créer le snapshot
$snapshotDir = ".kiro-backup/snapshots/$date"
New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null
Copy-Item "chemin/vers/fichier.json" "$snapshotDir/$modId-fichier.json"
```

### Rollback depuis un Snapshot

```powershell
# Restaurer un fichier depuis son snapshot
Copy-Item ".kiro-backup/snapshots/2026-02-04/mod-001-package.json" `
  "pwc-ui/pwc-ui-v4-ia/package.json" -Force
```

### Génération d'un Diff

```powershell
# Générer le diff après modification
git diff --no-index `
  ".kiro-backup/snapshots/2026-02-04/mod-001-package.json" `
  "pwc-ui/pwc-ui-v4-ia/package.json" > ".kiro-backup/diffs/mod-001.diff"
```

---

## 📋 Convention de Nommage

### Snapshots
```
mod-YYYYMMDD-HHMMSS-<nom_fichier_original>
```

Exemples :
- `mod-20260204-143000-package.json`
- `mod-20260204-150000-tsconfig.json`
- `mod-20260205-091500-angular.json`

### Diffs
```
mod-YYYYMMDD-HHMMSS.diff
```

Exemples :
- `mod-20260204-143000.diff`
- `mod-20260204-150000.diff`

---

## 🧹 Nettoyage

### Politique de Rétention
- Les snapshots sont conservés **30 jours** par défaut
- Configurable dans `.kiro/state/modifications-index.json`

### Nettoyage Manuel

```powershell
# Supprimer les snapshots de plus de 30 jours
$cutoffDate = (Get-Date).AddDays(-30)
Get-ChildItem ".kiro-backup/snapshots" -Directory | Where-Object {
    $_.CreationTime -lt $cutoffDate
} | Remove-Item -Recurse -Force

# Supprimer les diffs correspondants
Get-ChildItem ".kiro-backup/diffs" -File | Where-Object {
    $_.CreationTime -lt $cutoffDate
} | Remove-Item -Force
```

---

## ⚠️ Important

- **NE PAS supprimer** les snapshots manuellement sans mettre à jour l'index
- **NE PAS modifier** les snapshots (ils doivent rester identiques à l'original)
- **Toujours** vérifier l'intégrité avant un rollback

---

## 🔗 Ressources

- Index des modifications : `.kiro/state/modifications-index.json`
- Règles de modification : `.kiro/steering/12-modification-rules.md`
- Journal de bord : `Documentation/JOURNAL-DE-BORD.md`
