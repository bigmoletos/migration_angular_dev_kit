---
inclusion: always
priority: 95
---

# Règles de Modification des Fichiers - Système de Snapshots

> **Version** : 2.0.0  
> **Dernière mise à jour** : 2026-02-04  
> **Auteur** : Kiro  
> **Changelog** :
> - v2.0.0 (2026-02-04) : Migration vers système de snapshots (abandon des commentaires)
> - v1.0.0 (2026-02-03) : Création initiale avec système de commentaires

---

## 🎯 Objectif

Toute modification de fichier doit être traçable et réversible via un **système de snapshots** qui préserve la lisibilité des fichiers.

---

## 🔴 RÈGLES ABSOLUES

### 1. Toujours Créer un Snapshot AVANT Modification

❌ **INTERDIT** : Modifier un fichier sans snapshot préalable

✅ **OBLIGATOIRE** : Créer un snapshot complet du fichier avant toute modification

### 2. NE PAS Ajouter de Commentaires de Traçabilité dans les Fichiers

❌ **INTERDIT** (ancienne méthode) :
```json
{
  "dependencies": {
    // ORIGINAL: "@pwc/shared": "2.6.23"
    // MODIFIED: 2026-02-03 - Kiro - Lien local
    "@pwc/shared": "file:../pwc-ui-shared"
  }
}
```

✅ **OBLIGATOIRE** (nouvelle méthode) :
```json
{
  "dependencies": {
    "@pwc/shared": "file:../pwc-ui-shared"
  }
}
```
→ Le fichier reste **propre et lisible**
→ La traçabilité est dans les **métadonnées externes**

### 3. Enregistrer Chaque Modification dans l'Index

Toute modification doit être enregistrée dans `.kiro/state/modifications-index.json`

---

## 📁 Architecture du Système de Snapshots

### Structure des Dossiers

```
.kiro-backup/
├── snapshots/                        # Snapshots complets des fichiers
│   ├── 2026-02-04/
│   │   ├── mod-001-package.json     # Snapshot AVANT modification
│   │   ├── mod-002-npmrc
│   │   └── mod-003-tsconfig.json
│   └── 2026-02-05/
│       └── ...
├── diffs/                            # Diffs générés (documentation)
│   ├── mod-001.diff
│   ├── mod-002.diff
│   └── mod-003.diff
└── README.md

.kiro/state/
├── modifications-index.json          # Index de toutes les modifications
└── snapshots-metadata.json           # Métadonnées des snapshots
```

---

## 📋 Format de l'Index des Modifications

### Structure de `.kiro/state/modifications-index.json`

```json
{
  "metadata": {
    "version": "2.0.0",
    "lastUpdate": "2026-02-04",
    "system": "snapshots"
  },
  "modifications": [
    {
      "id": "mod-001",
      "date": "2026-02-04T14:30:00Z",
      "author": "Kiro",
      "file": "pwc-ui/pwc-ui-v4-ia/package.json",
      "type": "modification",
      "description": "Ajout de json-ignore dans les dépendances",
      "reason": "json-ignore utilisé par @pwc/shared mais non déclaré",
      "snapshot": ".kiro-backup/snapshots/2026-02-04/mod-001-package.json",
      "diff": ".kiro-backup/diffs/mod-001.diff",
      "palier": 0,
      "relatedJournalEntry": "2026-02-04",
      "status": "applied",
      "rollbackTested": false
    }
  ]
}
```

---

## 🔄 Processus de Modification (Workflow)

### Étape 1 : Créer le Snapshot

**AVANT** toute modification :

```powershell
# Générer un ID unique
$modId = "mod-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$date = Get-Date -Format "yyyy-MM-dd"

# Créer le dossier du jour si nécessaire
$snapshotDir = ".kiro-backup/snapshots/$date"
New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null

# Créer le snapshot
$fileName = Split-Path "pwc-ui/pwc-ui-v4-ia/package.json" -Leaf
Copy-Item "pwc-ui/pwc-ui-v4-ia/package.json" "$snapshotDir/$modId-$fileName"

Write-Host "✅ Snapshot créé : $snapshotDir/$modId-$fileName"
```

### Étape 2 : Enregistrer dans l'Index

```powershell
# Ajouter l'entrée dans modifications-index.json
$modification = @{
    id = $modId
    date = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    author = "Kiro"
    file = "pwc-ui/pwc-ui-v4-ia/package.json"
    type = "modification"
    description = "Description de la modification"
    snapshot = "$snapshotDir/$modId-$fileName"
    status = "pending"
}
```

### Étape 3 : Appliquer la Modification

Modifier le fichier **SANS ajouter de commentaires** :
- Le fichier reste propre et lisible
- Pas de pollution du code
- Compatible avec tous les formats (JSON, YAML, etc.)

### Étape 4 : Générer le Diff (Documentation)

**APRÈS** la modification :

```powershell
# Créer le dossier diffs si nécessaire
$diffDir = ".kiro-backup/diffs"
New-Item -ItemType Directory -Path $diffDir -Force | Out-Null

# Générer le diff
$diffFile = "$diffDir/$modId.diff"
git diff --no-index "$snapshotDir/$modId-$fileName" "pwc-ui/pwc-ui-v4-ia/package.json" > $diffFile

Write-Host "✅ Diff généré : $diffFile"
```

### Étape 5 : Mettre à Jour le Statut

```powershell
# Mettre à jour le statut dans l'index
# status: "pending" → "applied"
```

---

## 🔙 Processus de Rollback

### Rollback Simple (Un Fichier)

```powershell
# 1. Identifier le snapshot
$modId = "mod-001"
$snapshot = ".kiro-backup/snapshots/2026-02-04/mod-001-package.json"
$targetFile = "pwc-ui/pwc-ui-v4-ia/package.json"

# 2. Restaurer le snapshot
Copy-Item $snapshot $targetFile -Force

# 3. Mettre à jour l'index
# status: "applied" → "rolled-back"

Write-Host "✅ Rollback effectué : $targetFile restauré depuis $snapshot"
```

### Rollback Multiple (Par Date)

```powershell
# Rollback de toutes les modifications d'une date
$date = "2026-02-04"
$snapshotDir = ".kiro-backup/snapshots/$date"

Get-ChildItem $snapshotDir | ForEach-Object {
    # Extraire le fichier cible depuis l'index
    # Restaurer chaque snapshot
}
```

### Rollback Par Palier

```powershell
# Rollback de toutes les modifications d'un palier
$palier = 1

# Lire l'index et filtrer par palier
# Restaurer tous les snapshots correspondants
```

---

## 📊 Commandes Utiles

### Lister les Modifications

```powershell
# Toutes les modifications
Get-Content ".kiro/state/modifications-index.json" | ConvertFrom-Json | 
    Select-Object -ExpandProperty modifications | Format-Table

# Modifications d'un fichier spécifique
Get-Content ".kiro/state/modifications-index.json" | ConvertFrom-Json | 
    Select-Object -ExpandProperty modifications | 
    Where-Object { $_.file -like "*package.json*" }

# Modifications d'un palier
Get-Content ".kiro/state/modifications-index.json" | ConvertFrom-Json | 
    Select-Object -ExpandProperty modifications | 
    Where-Object { $_.palier -eq 1 }
```

### Vérifier l'Intégrité des Snapshots

```powershell
# Vérifier que tous les snapshots existent
Get-Content ".kiro/state/modifications-index.json" | ConvertFrom-Json | 
    Select-Object -ExpandProperty modifications | ForEach-Object {
        if (-not (Test-Path $_.snapshot)) {
            Write-Warning "❌ Snapshot manquant : $($_.snapshot)"
        } else {
            Write-Host "✅ Snapshot OK : $($_.snapshot)"
        }
    }
```

### Voir un Diff

```powershell
# Afficher le diff d'une modification
$modId = "mod-001"
Get-Content ".kiro-backup/diffs/$modId.diff"
```

### Nettoyer les Anciens Snapshots

```powershell
# Supprimer les snapshots de plus de 30 jours
$cutoffDate = (Get-Date).AddDays(-30)
Get-ChildItem ".kiro-backup/snapshots" | Where-Object {
    $_.CreationTime -lt $cutoffDate
} | Remove-Item -Recurse -Force
```

---

## 📋 Types de Modifications

| Type | Description | Snapshot Requis |
|------|-------------|-----------------|
| `modification` | Changement d'une ligne existante | ✅ Oui |
| `addition` | Ajout de nouvelles lignes | ✅ Oui |
| `deletion` | Suppression de lignes | ✅ Oui |
| `creation` | Création d'un nouveau fichier | ❌ Non (pas de fichier avant) |
| `rename` | Renommage d'un fichier | ✅ Oui |

---

## ⚠️ Cas Particuliers

### Fichiers Binaires

Les fichiers binaires sont gérés de la même manière :
```powershell
# Snapshot d'un fichier binaire
Copy-Item "assets/logo.png" ".kiro-backup/snapshots/2026-02-04/mod-010-logo.png"
```

### Fichiers Générés

Les fichiers générés (node_modules, dist, build) ne nécessitent pas de snapshot :
```json
{
  "id": "mod-020",
  "type": "generated",
  "snapshot": null,
  "rollbackCommand": "npm install"
}
```

### Création de Nouveaux Fichiers

Pour les nouveaux fichiers, pas de snapshot mais enregistrement dans l'index :
```json
{
  "id": "mod-030",
  "type": "creation",
  "file": "src/new-component.ts",
  "snapshot": null,
  "rollbackCommand": "Remove-Item src/new-component.ts"
}
```

---

## ✅ Checklist Avant Modification

- [ ] Snapshot créé dans `.kiro-backup/snapshots/`
- [ ] Modification enregistrée dans `.kiro/state/modifications-index.json`
- [ ] Fichier modifié **SANS commentaires de traçabilité**
- [ ] Diff généré dans `.kiro-backup/diffs/`
- [ ] Statut mis à jour : `"status": "applied"`
- [ ] Journal de bord mis à jour si modification majeure

---

## ✅ Checklist Rollback

- [ ] Snapshot identifié dans l'index
- [ ] Snapshot vérifié (existe et intègre)
- [ ] Fichier restauré depuis le snapshot
- [ ] Statut mis à jour : `"status": "rolled-back"`
- [ ] Tests effectués après rollback
- [ ] Journal de bord mis à jour

---

## 🎯 Avantages du Système de Snapshots

| Critère | Ancienne Méthode (Commentaires) | Nouvelle Méthode (Snapshots) |
|---------|--------------------------------|------------------------------|
| **Lisibilité fichiers** | ❌ Pollués | ✅ Propres |
| **Compatibilité JSON** | ❌ Problème | ✅ Parfaite |
| **Rollback** | ⚠️ Manuel | ✅ Automatique |
| **Traçabilité** | ⚠️ Dans fichiers | ✅ Centralisée |
| **Espace disque** | ✅ Minimal | ⚠️ Modéré |
| **Complexité** | ⚠️ Moyenne | ✅ Simple |

---

## 🔗 Ressources

- Index des modifications : `.kiro/state/modifications-index.json`
- Snapshots : `.kiro-backup/snapshots/`
- Diffs : `.kiro-backup/diffs/`
- Journal de bord : `Documentation/JOURNAL-DE-BORD.md`

---

## 📝 Notes Importantes

1. **Git reste la source de vérité** : Ce système complète Git, ne le remplace pas
2. **Snapshots temporaires** : Les snapshots sont conservés 30 jours par défaut
3. **Pas de commentaires** : Les fichiers restent propres et lisibles
4. **ID unique** : Chaque modification a un ID unique (mod-YYYYMMDD-HHMMSS)
5. **Traçabilité centralisée** : Tout est dans l'index, pas dans les fichiers
