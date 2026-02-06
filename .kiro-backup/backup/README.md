# Backups - Système de Rollback

Ce dossier contient les backups automatiques de tous les fichiers modifiés.

## Structure

```
backup/
├── 2026-02-03/
│   ├── mod-001-package.json.bak
│   ├── mod-002-npmrc.bak
│   └── modifications-log.json
├── 2026-02-04/
│   └── ...
└── README.md
```

## Utilisation

### Créer un Backup

```powershell
.\scripts_outils_ia\backup-file.ps1 -File "path/to/file"
```

### Rollback

```powershell
.\scripts_outils_ia\rollback.ps1 -ModificationId "mod-001"
```

### Nettoyer les Anciens Backups

```powershell
# Supprimer les backups de plus de 30 jours
.\scripts_outils_ia\cleanup-backups.ps1 -DaysOld 30
```

## Rétention

- **Défaut** : 30 jours
- **Configurable** : Modifier le paramètre `-DaysOld` dans cleanup-backups.ps1

## Notes

- Les backups sont organisés par date (YYYY-MM-DD)
- Chaque backup est nommé avec l'ID de modification (mod-XXX)
- Les backups sont automatiquement créés avant chaque modification
