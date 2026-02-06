---
inclusion: always
priority: 95
---

# Hygiène du Workspace

> **Version** : 1.1.0  
> **Dernière mise à jour** : 2026-02-04  
> **Changelog** :
> - v1.1.0 (2026-02-04) : Ajout référence au système de snapshots
> - v1.0.0 (2026-02-03) : Création initiale

> **Contexte** : Maintenir les repos propres pendant la migration

---

## 🎯 Objectif

Éviter la pollution des repositories avec des fichiers temporaires, scripts de test, ou documentation de debug.

---

## 📂 Dossiers Spéciaux

### Dossier Temporaire : `.kiro/temp/`
Tous les fichiers temporaires doivent être créés dans :
```
.kiro/temp/
```

**Ce dossier est** :
- Ignoré par Git (`.gitignore`)
- Nettoyé automatiquement
- Réservé aux tests et debug

### Dossier Backups : `.kiro-backup/`
Les snapshots et diffs des modifications sont stockés dans :
```
.kiro-backup/
├── snapshots/    # Snapshots complets des fichiers AVANT modification
└── diffs/        # Diffs générés pour documentation
```

**Ce dossier est** :
- Partiellement ignoré par Git (snapshots et diffs ignorés, structure conservée)
- Utilisé pour le rollback des modifications
- Nettoyé automatiquement après 30 jours

**Voir** : `.kiro/steering/12-modification-rules.md` pour le système de snapshots

---

## 🚫 Interdictions

### Ne JAMAIS créer dans les repos principaux :
- ❌ Scripts de test temporaires
- ❌ Fichiers de debug
- ❌ Documentation de test
- ❌ Logs de debug
- ❌ Fichiers `.tmp`, `.test`, `.debug`

### Exemples de ce qu'il NE FAUT PAS faire :
```bash
# ❌ MAUVAIS
echo "test" > pwc-ui/test-script.js
echo "debug" > pwc-ui-shared/debug.log
cat > pwc-ui/test-doc.md << EOF
Test documentation
EOF
```

### Exemples de ce qu'il FAUT faire :
```bash
# ✅ BON
echo "test" > .kiro/temp/test-script.js
echo "debug" > .kiro/temp/debug.log
cat > .kiro/temp/test-doc.md << EOF
Test documentation
EOF
```

---

## 🧹 Nettoyage Automatique

### Hook de Dépollution
Un hook automatique nettoie `.kiro/temp/` :
- Quotidiennement
- Après chaque palier
- Sur demande

### Commande Manuelle
```bash
# Nettoyer le dossier temporaire
rm -rf .kiro/temp/*

# Ou sur Windows
Remove-Item -Path ".kiro/temp/*" -Recurse -Force
```

---

## 📝 Journal de Bord

### Mise à Jour Automatique
Le fichier `Documentation/JOURNAL-DE-BORD.md` est mis à jour automatiquement après chaque changement majeur :
- Fin d'un palier
- Problème critique résolu
- Décision technique importante

### Format d'Entrée
```markdown
## [DATE] - [PALIER] - [TITRE]

**Contexte** : [Description du contexte]

**Actions** :
- Action 1
- Action 2

**Résultat** : [Résultat obtenu]

**Problèmes** : [Problèmes rencontrés]

**Solutions** : [Solutions appliquées]

**Temps** : [Temps réel vs estimé]

---
```

### Exemple
```markdown
## 2026-02-10 - Palier 1 - Migration RxJS 5 → 6

**Contexte** : Migration de tous les opérateurs RxJS vers la syntaxe pipeable

**Actions** :
- Installation de rxjs-compat
- Exécution du codemod rxjs-5-to-6-migrate
- Migration manuelle de 15 fichiers complexes
- Tests et validation

**Résultat** : Migration réussie, 100% des tests passent

**Problèmes** :
- Imports circulaires dans 3 services
- Tests HttpClient à adapter

**Solutions** :
- Refactoring des imports
- Migration vers HttpClientTestingModule

**Temps** : 1.5 semaines (estimé: 1-2 semaines)

---
```

---

## 🔄 Workflow de Propreté

### Avant de Commencer un Palier
1. Vérifier que `.kiro/temp/` est vide
2. Vérifier qu'aucun fichier temporaire n'existe dans les repos

### Pendant le Palier
1. Créer tous les fichiers temporaires dans `.kiro/temp/`
2. Documenter les tests dans `.kiro/temp/`
3. Ne PAS commiter `.kiro/temp/`

### Après le Palier
1. Nettoyer `.kiro/temp/`
2. Mettre à jour `Documentation/JOURNAL-DE-BORD.md`
3. Commiter uniquement les changements pertinents

---

## 🛠️ Commandes Utiles

### Vérifier la Propreté
```bash
# Chercher les fichiers temporaires dans pwc-ui
find pwc-ui -name "*.tmp" -o -name "*.test" -o -name "*.debug"

# Chercher les fichiers temporaires dans pwc-ui-shared
find pwc-ui-shared -name "*.tmp" -o -name "*.test" -o -name "*.debug"

# Sur Windows
Get-ChildItem -Path "pwc-ui" -Recurse -Include "*.tmp","*.test","*.debug"
Get-ChildItem -Path "pwc-ui-shared" -Recurse -Include "*.tmp","*.test","*.debug"
```

### Nettoyer
```bash
# Nettoyer .kiro/temp/
rm -rf .kiro/temp/*

# Sur Windows
Remove-Item -Path ".kiro/temp/*" -Recurse -Force
```

---

## 📋 Checklist de Propreté

### Avant Chaque Commit
- [ ] Aucun fichier temporaire dans pwc-ui
- [ ] Aucun fichier temporaire dans pwc-ui-shared
- [ ] `.kiro/temp/` nettoyé (ou ignoré par Git)
- [ ] `Documentation/JOURNAL-DE-BORD.md` mis à jour si nécessaire
- [ ] Seulement les fichiers pertinents dans le commit

### Après Chaque Palier
- [ ] `.kiro/temp/` nettoyé
- [ ] `Documentation/JOURNAL-DE-BORD.md` mis à jour
- [ ] Aucun fichier de debug dans les repos
- [ ] Git status propre

---

## 🤖 Hook de Dépollution

### Configuration
Le hook `.kiro/hooks/cleanup.json` est configuré pour :
- Nettoyer `.kiro/temp/` quotidiennement
- Vérifier la propreté avant chaque commit
- Alerter si des fichiers temporaires sont détectés

### Activation
Le hook est activé automatiquement. Pour le désactiver temporairement :
```bash
# Désactiver
export KIRO_CLEANUP_DISABLED=1

# Réactiver
unset KIRO_CLEANUP_DISABLED
```

---

## 📊 Métriques de Propreté

### Indicateurs
- Nombre de fichiers temporaires : 0
- Taille de `.kiro/temp/` : <10 MB
- Dernière mise à jour du journal : <7 jours

### Alertes
- ⚠️ Si >5 fichiers temporaires détectés
- ⚠️ Si `.kiro/temp/` >50 MB
- ⚠️ Si journal non mis à jour depuis >14 jours

---

## ✅ Bonnes Pratiques

### DO
- ✅ Utiliser `.kiro/temp/` pour tous les tests
- ✅ Nettoyer régulièrement
- ✅ Documenter dans le journal de bord
- ✅ Vérifier avant chaque commit

### DON'T
- ❌ Créer des fichiers temporaires dans les repos
- ❌ Commiter des fichiers de debug
- ❌ Oublier de nettoyer `.kiro/temp/`
- ❌ Ignorer les alertes de propreté

---

## 🎯 Objectif

Maintenir les repositories **propres**, **organisés** et **professionnels** tout au long de la migration.
