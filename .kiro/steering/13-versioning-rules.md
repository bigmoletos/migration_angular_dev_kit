---
inclusion: always
priority: 96
---

# Règles de Versioning des Fichiers .kiro

> **Contexte** : Garantir la traçabilité des modifications des fichiers de configuration et documentation

---

## 🎯 Objectif

Chaque fichier dans `.kiro/` doit avoir un numéro de version et une date de dernière modification pour faciliter le suivi des changements.

---

## 🔴 RÈGLES ABSOLUES

### 1. Toujours Mettre à Jour la Version et la Date

À chaque modification d'un fichier dans `.kiro/`, vous DEVEZ :
1. Incrémenter le numéro de version
2. Mettre à jour la date de dernière modification
3. Ajouter un commentaire décrivant le changement

---

## 📋 Format de Versioning

### Pour les Fichiers Markdown (.md)

Ajouter un bloc de métadonnées en haut du fichier (après le front-matter YAML si présent) :

```markdown
---
inclusion: always
priority: 95
---

# Titre du Document

> **Version** : 1.2.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.2.0 (2026-02-03) : Ajout de la section X
> - v1.1.0 (2026-02-02) : Modification de la règle Y
> - v1.0.0 (2026-01-31) : Création initiale

---

## Contenu du document...
```

### Pour les Fichiers JSON (.json)

Ajouter un champ `metadata` en haut du fichier :

```json
{
  "metadata": {
    "version": "1.2.0",
    "lastUpdate": "2026-02-03",
    "author": "Kiro",
    "changelog": [
      {
        "version": "1.2.0",
        "date": "2026-02-03",
        "changes": "Ajout de la règle X"
      },
      {
        "version": "1.1.0",
        "date": "2026-02-02",
        "changes": "Modification du hook Y"
      },
      {
        "version": "1.0.0",
        "date": "2026-01-31",
        "changes": "Création initiale"
      }
    ]
  },
  "name": "Mon Hook",
  "version": "1.0.0",
  ...
}
```

### Pour les Fichiers PowerShell (.ps1)

Ajouter un bloc de commentaires en haut du fichier :

```powershell
<#
.SYNOPSIS
    Description courte du script

.DESCRIPTION
    Description détaillée du script

.VERSION
    1.2.0

.LAST UPDATE
    2026-02-03

.AUTHOR
    Kiro

.CHANGELOG
    v1.2.0 (2026-02-03) : Ajout de la fonctionnalité X
    v1.1.0 (2026-02-02) : Correction du bug Y
    v1.0.0 (2026-01-31) : Création initiale

.EXAMPLE
    .\mon-script.ps1 -Param1 "value"
#>

# Code du script...
```

---

## 🔢 Règles de Numérotation Sémantique

Utiliser le format **MAJOR.MINOR.PATCH** :

- **MAJOR** (X.0.0) : Changements incompatibles, refonte majeure
- **MINOR** (0.X.0) : Ajout de fonctionnalités, modifications importantes
- **PATCH** (0.0.X) : Corrections de bugs, petites modifications

### Exemples

| Changement | Avant | Après | Raison |
|------------|-------|-------|--------|
| Ajout d'une nouvelle section | 1.0.0 | 1.1.0 | MINOR |
| Correction d'une typo | 1.1.0 | 1.1.1 | PATCH |
| Refonte complète du document | 1.1.1 | 2.0.0 | MAJOR |
| Modification d'une règle existante | 2.0.0 | 2.1.0 | MINOR |

---

## 📁 Fichiers Concernés

### Obligatoire

Tous les fichiers dans ces dossiers DOIVENT avoir un versioning :
- `.kiro/steering/*.md`
- `.kiro/specs/*.md`
- `.kiro/hooks/*.json`
- `.kiro/templates/*.md`
- `scripts_outils_ia/*.ps1`

### Optionnel

Ces fichiers PEUVENT avoir un versioning (recommandé) :
- `.kiro/state/*.json` (si modifications manuelles)
- `.kiro/agents/*.md`
- `.kiro/skills/*.md`

### Exclus

Ces fichiers n'ont PAS besoin de versioning :
- `.kiro/temp/*` (fichiers temporaires)
- `.kiro/.gitignore`
- Fichiers générés automatiquement

---

## 🔄 Workflow de Modification

### Étape 1 : Avant Modification

```powershell
# 1. Lire la version actuelle
Get-Content .kiro/steering/mon-fichier.md | Select-String -Pattern "Version.*:"

# 2. Noter la version actuelle (ex: 1.1.0)
```

### Étape 2 : Modifier le Fichier

Effectuer les modifications nécessaires dans le contenu du fichier.

### Étape 3 : Mettre à Jour les Métadonnées

```markdown
# AVANT
> **Version** : 1.1.0  
> **Dernière mise à jour** : 2026-02-02  
> **Changelog** :
> - v1.1.0 (2026-02-02) : Modification de la règle Y
> - v1.0.0 (2026-01-31) : Création initiale

# APRÈS
> **Version** : 1.2.0  
> **Dernière mise à jour** : 2026-02-03  
> **Changelog** :
> - v1.2.0 (2026-02-03) : Ajout de la section X
> - v1.1.0 (2026-02-02) : Modification de la règle Y
> - v1.0.0 (2026-01-31) : Création initiale
```

### Étape 4 : Commit

```powershell
git add .kiro/steering/mon-fichier.md
git commit -m "docs: [v1.2.0] Ajout de la section X dans mon-fichier.md"
```

---

## 📊 Script de Vérification

Créer un script pour vérifier que tous les fichiers ont un versioning :

```powershell
# scripts_outils_ia/verify-versioning.ps1

<#
.SYNOPSIS
    Vérifie que tous les fichiers .kiro ont un versioning

.VERSION
    1.0.0

.LAST UPDATE
    2026-02-03
#>

param(
    [switch]$Fix
)

$errors = @()

# Vérifier les fichiers Markdown
Get-ChildItem -Path ".kiro/steering", ".kiro/specs", ".kiro/templates" -Filter "*.md" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    if ($content -notmatch "Version\s*:\s*\d+\.\d+\.\d+") {
        $errors += "❌ $($_.FullName) : Pas de version trouvée"
    }
    
    if ($content -notmatch "Dernière mise à jour\s*:\s*\d{4}-\d{2}-\d{2}") {
        $errors += "❌ $($_.FullName) : Pas de date de mise à jour trouvée"
    }
}

# Vérifier les fichiers JSON
Get-ChildItem -Path ".kiro/hooks" -Filter "*.json" -Recurse | ForEach-Object {
    $json = Get-Content $_.FullName | ConvertFrom-Json
    
    if (-not $json.metadata) {
        $errors += "❌ $($_.FullName) : Pas de metadata trouvée"
    } elseif (-not $json.metadata.version) {
        $errors += "❌ $($_.FullName) : Pas de version dans metadata"
    }
}

# Vérifier les scripts PowerShell
Get-ChildItem -Path "scripts_outils_ia" -Filter "*.ps1" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    if ($content -notmatch "\.VERSION\s+\d+\.\d+\.\d+") {
        $errors += "❌ $($_.FullName) : Pas de version trouvée"
    }
}

# Afficher les résultats
if ($errors.Count -eq 0) {
    Write-Host "✅ Tous les fichiers ont un versioning correct" -ForegroundColor Green
} else {
    Write-Host "❌ $($errors.Count) fichier(s) sans versioning correct :" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
    
    if ($Fix) {
        Write-Host "`n🔧 Mode Fix activé : ajout des versions manquantes..." -ForegroundColor Cyan
        # TODO: Implémenter la correction automatique
    }
}
```

---

## 🎯 Exemples Complets

### Exemple 1 : Steering Markdown

```markdown
---
inclusion: always
priority: 95
---

# Règles de Migration Angular

> **Version** : 2.1.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v2.1.0 (2026-02-03) : Ajout des règles pour Angular 20
> - v2.0.0 (2026-02-02) : Refonte complète du document
> - v1.5.0 (2026-02-01) : Ajout des règles pour Ivy
> - v1.0.0 (2026-01-31) : Création initiale

---

## Contenu du document...
```

### Exemple 2 : Hook JSON

```json
{
  "metadata": {
    "version": "1.1.0",
    "lastUpdate": "2026-02-03",
    "author": "Kiro",
    "changelog": [
      {
        "version": "1.1.0",
        "date": "2026-02-03",
        "changes": "Ajout de la vérification des fichiers temporaires"
      },
      {
        "version": "1.0.0",
        "date": "2026-01-31",
        "changes": "Création initiale"
      }
    ]
  },
  "name": "Cleanup & Journal Update",
  "version": "1.0.0",
  "description": "Nettoie les fichiers temporaires et met à jour le journal de bord",
  "when": {
    "type": "agentStop"
  },
  "then": {
    "type": "askAgent",
    "prompt": "..."
  }
}
```

### Exemple 3 : Script PowerShell

```powershell
<#
.SYNOPSIS
    Crée un backup d'un fichier avant modification

.DESCRIPTION
    Ce script crée une copie de sauvegarde d'un fichier dans le dossier .kiro-backup
    avant toute modification, permettant un rollback facile.

.VERSION
    1.2.0

.LAST UPDATE
    2026-02-03

.AUTHOR
    Kiro

.CHANGELOG
    v1.2.0 (2026-02-03) : Ajout du support des chemins relatifs
    v1.1.0 (2026-02-02) : Amélioration de la gestion des erreurs
    v1.0.0 (2026-01-31) : Création initiale

.PARAMETER File
    Chemin du fichier à sauvegarder

.EXAMPLE
    .\backup-file.ps1 -File "package.json"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$File
)

# Code du script...
```

---

## ✅ Checklist de Modification

Avant de commiter un fichier `.kiro/`, vérifier :

- [ ] Version incrémentée selon les règles sémantiques
- [ ] Date de mise à jour actualisée (format YYYY-MM-DD)
- [ ] Changelog mis à jour avec la nouvelle version
- [ ] Description claire du changement dans le changelog
- [ ] Commit message contient la version : `docs: [v1.2.0] Description`

---

## 🔗 Ressources

- Versioning sémantique : https://semver.org/
- Format de date ISO 8601 : YYYY-MM-DD
- Changelog : `.kiro/state/modifications-index.json`
- Journal de bord : `Documentation/JOURNAL-DE-BORD.md`

---

## 📝 Notes Importantes

1. **Cohérence** : Utiliser toujours le même format pour tous les fichiers du même type
2. **Traçabilité** : Le changelog doit permettre de comprendre l'évolution du fichier
3. **Automatisation** : Utiliser le script `verify-versioning.ps1` avant chaque commit
4. **Documentation** : Mettre à jour le journal de bord pour les changements majeurs
5. **Commit** : Inclure la version dans le message de commit

