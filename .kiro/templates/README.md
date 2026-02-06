# 📁 Dossier .kiro/templates - Templates

> **Statut** : 📄 Templates  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **templates** pour créer rapidement des documents standardisés.

✅ **Important** : Ces templates garantissent la cohérence de la documentation.

---

## 📂 Contenu

### Templates Disponibles

| Template | Usage | Fichier |
|----------|-------|---------|
| **journal-entry-template.md** | Entrée de journal de bord | `journal-entry-template.md` |

---

## 📋 Détail des Templates

### journal-entry-template.md

**Rôle** : Template pour créer une entrée dans le journal de bord

**Structure** :
```markdown
## [DATE] - [PALIER] - [TITRE]

**Contexte** : [Description du contexte]

**Actions** :
- Action 1
- Action 2
- Action 3

**Résultat** : [Résultat obtenu]

**Problèmes** : [Problèmes rencontrés]

**Solutions** : [Solutions appliquées]

**Temps** : [Temps réel vs estimé]

**Notes** : [Notes additionnelles]

---
```

**Utilisation** :
```powershell
# Copier le template
Copy-Item .kiro/templates/journal-entry-template.md .kiro/temp/journal-entry-2026-02-04.md

# Éditer
notepad .kiro/temp/journal-entry-2026-02-04.md

# Ajouter au journal de bord
Get-Content .kiro/temp/journal-entry-2026-02-04.md | Add-Content Documentation/JOURNAL-DE-BORD.md
```

---

## 🚀 Utilisation

### Créer une Entrée de Journal

**Méthode 1 : Automatique (Recommandé)**

Le hook `cleanup-and-journal.json` propose automatiquement de créer une entrée en fin de session.

**Méthode 2 : Manuelle**

```powershell
# 1. Copier le template
Copy-Item .kiro/templates/journal-entry-template.md .kiro/temp/journal-entry.md

# 2. Remplir les informations
# Éditer .kiro/temp/journal-entry.md

# 3. Ajouter au journal
Get-Content .kiro/temp/journal-entry.md | Add-Content Documentation/JOURNAL-DE-BORD.md

# 4. Nettoyer
Remove-Item .kiro/temp/journal-entry.md
```

**Méthode 3 : Via Kiro**

```
Crée une entrée de journal pour le palier 1
```

---

## 📝 Exemple d'Entrée

```markdown
## 2026-02-04 - Palier 1 - Migration Angular 5→6

**Contexte** : Premier palier de migration, focus sur RxJS 5→6

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

**Notes** : rxjs-compat sera retiré au palier 2

---
```

---

## 🔄 Créer de Nouveaux Templates

### Template de Spec

Créer `.kiro/templates/spec-template.md` :

```markdown
# [TITRE DE LA SPEC]

> **Version** : 1.0.0  
> **Dernière mise à jour** : [DATE]  
> **Auteur** : Kiro

---

## 🎯 Objectif

[Description de l'objectif]

---

## 📋 Prérequis

- Prérequis 1
- Prérequis 2

---

## 🔄 Étapes

1. Étape 1
2. Étape 2
3. Étape 3

---

## ✅ Validation

- [ ] Critère 1
- [ ] Critère 2

---

## 📝 Notes

[Notes additionnelles]
```

### Template de Steering File

Créer `.kiro/templates/steering-template.md` :

```markdown
---
inclusion: auto
priority: 80
keywords: ["keyword1", "keyword2"]
---

# [TITRE DU STEERING FILE]

> **Version** : 1.0.0  
> **Dernière mise à jour** : [DATE]  
> **Auteur** : Kiro

---

## 🎯 Objectif

[Description de l'objectif]

---

## 🔴 RÈGLES ABSOLUES

- ❌ Interdiction 1
- ✅ Obligation 1

---

## 📋 Bonnes Pratiques

- ✅ Bonne pratique 1
- ✅ Bonne pratique 2

---

## 📝 Notes

[Notes additionnelles]
```

---

## ⚠️ Règles Importantes

### ✅ Bonnes Pratiques

- Utiliser les templates pour garantir la cohérence
- Mettre à jour les templates si nécessaire
- Versionner les templates
- Documenter les nouveaux templates

### ❌ À Éviter

- Ne PAS modifier les templates sans raison
- Ne PAS créer de documents sans template
- Ne PAS oublier de remplir tous les champs
- Ne PAS commiter les fichiers temporaires créés depuis les templates

---

## 📊 Templates Disponibles

| Template | Fichier | Usage |
|----------|---------|-------|
| Journal de bord | `journal-entry-template.md` | Entrées de journal |
| Spec (futur) | `spec-template.md` | Nouvelles specs |
| Steering (futur) | `steering-template.md` | Nouveaux steering files |
| Hook (futur) | `hook-template.json` | Nouveaux hooks |

---

## 📝 Notes

- Les templates garantissent la **cohérence** de la documentation
- Ils facilitent la **création rapide** de documents
- Ils servent de **référence** pour le format attendu
- Ils sont **versionnés** comme le reste du projet

---

## 🔗 Ressources

- Journal de bord : `Documentation/JOURNAL-DE-BORD.md`
- Hook de journal : `.kiro/hooks/cleanup-and-journal.json`
- Specs : `.kiro/specs/`
- Steering files : `.kiro/steering/`
