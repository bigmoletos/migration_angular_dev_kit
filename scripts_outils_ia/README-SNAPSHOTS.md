# 📸 Scripts de Gestion des Snapshots

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ces scripts permettent de gérer le système de snapshots pour le rollback des modifications de fichiers pendant la migration Angular.

Le système de snapshots remplace l'ancienne méthode des commentaires dans les fichiers, gardant ainsi les fichiers **propres et lisibles** (notamment les fichiers JSON).

---

## 📂 Scripts Disponibles

| Script | Rôle |
|--------|------|
| `snapshot-file.ps1` | Crée un snapshot avant modification |
| `rollback-snapshot.ps1` | Restaure un fichier depuis son snapshot |
| `generate-diff.ps1` | Génère un diff après modification |
| `list-modifications.ps1` | Liste les modifications enregistrées |

---

## 🔄 Workflow Complet

### 1. Avant Modification : Créer un Snapshot

```powershell
.\scripts_outils_ia\snapshot-file.ps1 -File "pwc-ui/pwc-ui-v4-ia/package.json" -Description "Ajout de json-ignore" -Palier 1
```

**Résultat** :
- Snapshot créé dans `.kiro-backup/snapshots/2026-02-04/mod-XXXXXX-package.json`
- Entrée ajoutée dans `.kiro/state/modifications-index.json`
- ID de modification retourné (ex: `mod-20260204-143000`)

### 2. Modifier le Fichier

Modifier le fichier **SANS ajouter de commentaires** :
```powershell
# Exemple : modifier package.json
# Le fichier reste propre et lisible
```

### 3. Après Modification : Générer le Diff

```powershell
.\scripts_outils_ia\generate-diff.ps1 -ModificationId "mod-20260204-143000"
```

**Résultat** :
- Diff généré dans `.kiro-backup/diffs/mod-20260204-143000.diff`
- Statut mis à jour : `pending` → `applied`

### 4. Si Besoin : Rollback

```powershell
# Par ID de modification
.\scripts_outils_ia\rollback-snapshot.ps1 -ModificationId "mod-20260204-143000"

# Ou par fichier (dernière modification)
.\scripts_outils_ia\rollback-snapshot.ps1 -File "package.json"
```

**Résultat** :
- Fichier restauré depuis le snapshot
- Statut mis à jour : `applied` → `rolled-back`

---

## 📋 Commandes Utiles

### Lister Toutes les Modifications

```powershell
.\scripts_outils_ia\list-modifications.ps1
```

### Filtrer par Fichier

```powershell
.\scripts_outils_ia\list-modifications.ps1 -File "package.json"
```

### Filtrer par Palier

```powershell
.\scripts_outils_ia\list-modifications.ps1 -Palier 1
```

### Filtrer par Statut

```powershell
.\scripts_outils_ia\list-modifications.ps1 -Status "applied"
```

---

## 📁 Structure des Fichiers

```
.kiro-backup/
├── snapshots/                    # Snapshots complets
│   └── 2026-02-04/
│       ├── mod-20260204-143000-package.json
│       └── mod-20260204-150000-tsconfig.json
├── diffs/                        # Diffs générés
│   ├── mod-20260204-143000.diff
│   └── mod-20260204-150000.diff
└── README.md

.kiro/state/
└── modifications-index.json      # Index des modifications
```

---

## ⚠️ Règles Importantes

### ✅ À Faire

- Toujours créer un snapshot AVANT de modifier un fichier
- Générer le diff APRÈS la modification
- Utiliser des descriptions claires
- Spécifier le numéro de palier

### ❌ À Éviter

- Ne PAS modifier les fichiers sans snapshot
- Ne PAS supprimer les snapshots manuellement
- Ne PAS éditer l'index manuellement
- Ne PAS ajouter de commentaires de traçabilité dans les fichiers

---

## 🔗 Ressources

- Règles de modification : `.kiro/steering/12-modification-rules.md`
- Index des modifications : `.kiro/state/modifications-index.json`
- Dossier backups : `.kiro-backup/`
