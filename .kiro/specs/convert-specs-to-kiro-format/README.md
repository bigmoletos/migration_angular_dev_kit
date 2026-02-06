# 📁 Dossier convert-specs-to-kiro-format - Spec de Conversion

> **Statut** : 📋 Spec Utilitaire  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Spec pour convertir les anciennes specs Markdown vers le format Kiro structuré.

---

## 📂 Contenu

| Fichier | Rôle |
|---------|------|
| `requirements.md` | Exigences de conversion |
| `design.md` | Méthodologie de conversion |

---

## 📋 Processus de Conversion

**Format Source** (Markdown simple) :
```
05-palier-04-angular-8-to-9-ivy.md
```

**Format Cible** (Kiro structuré) :
```
05-palier-04-angular-8-to-9-ivy/
├── requirements.md
├── design.md
└── tasks.md
```

---

## ✅ Statut

Conversion terminée pour :
- ✅ Palier 4 (Angular 8→9 Ivy)
- ✅ Palier 7 (Angular 11→12 Webpack5)
- ✅ Palier 11 (Angular 15→16 Signals)
- ✅ Palier 12 (Angular 16→17 Control Flow)
- ✅ Palier 15 (Angular 19→20 Final)
- ✅ Workflow Tests Playwright

---

## 🔗 Ressources

- Backups : `.kiro/specs/backup-md/`
- Specs converties : `.kiro/specs/05-palier-04-*/`, etc.
