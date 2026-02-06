---
name: code-audit
displayName: Code Audit Expert
description: Audit qualité, sécurité et patterns du code TypeScript/Angular
version: 1.0.0

loadOn:
  keywords:
    - audit
    - quality
    - security
    - lint
    - analyze
    - review
    - console.log
    - TODO
  filePatterns:
    - "*.ts"
    - "*.spec.ts"
  manual: "#audit"

tokenEstimate: 5000
priority: medium

requires: []
mcpNeeds:
  - filesystem
---

# 🔍 Code Audit Skill

## Activation

Se charge quand : "audit", "quality", "security", "analyze", "review"

---

## 📋 Checklist d'Audit Standard

### 1. Code Hygiene

```bash
# Console.log en production
grep -r "console.log" src --include="*.ts" | wc -l

# TODO/FIXME non résolus
grep -rE "TODO|FIXME" src --include="*.ts" | wc -l

# Debugger statements
grep -r "debugger" src --include="*.ts" | wc -l

# Commented code blocks
grep -rE "^\s*//.*\{" src --include="*.ts" | wc -l
```

### 2. TypeScript Quality

```bash
# Any types explicites
grep -r ": any" src --include="*.ts" | wc -l

# Any types implicites (= )
grep -r "= any" src --include="*.ts" | wc -l

# Fichiers > 500 lignes
find src -name "*.ts" -exec wc -l {} \; | awk '$1 > 500 {print}'

# Fichiers > 300 lignes (warning)
find src -name "*.ts" -exec wc -l {} \; | awk '$1 > 300 && $1 <= 500 {print}'
```

### 3. Angular Patterns

```bash
# Subscriptions potentiellement non nettoyées
grep -r "\.subscribe(" src --include="*.ts" | grep -v "takeUntil\|async\|unsubscribe" | wc -l

# ngOnInit sans ngOnDestroy (potentiel leak)
for f in $(find src -name "*.component.ts"); do
  if grep -q "ngOnInit" "$f" && ! grep -q "ngOnDestroy" "$f"; then
    echo "$f"
  fi
done

# Imports RxJS ancienne syntaxe
grep -r "from 'rxjs/" src --include="*.ts" | grep -v "from 'rxjs'" | wc -l
```

### 4. Sécurité

```bash
# innerHTML (XSS potentiel)
grep -r "innerHTML" src --include="*.ts" --include="*.html" | wc -l

# bypassSecurityTrust
grep -r "bypassSecurityTrust" src --include="*.ts" | wc -l

# eval (jamais en production)
grep -r "eval(" src --include="*.ts" | wc -l

# Vulnérabilités npm
npm audit --json
```

### 5. Performance

```bash
# ChangeDetection non optimisée
grep -r "@Component" src --include="*.ts" | grep -v "ChangeDetectionStrategy.OnPush" | wc -l

# trackBy manquant sur ngFor
grep -r "ngFor" src --include="*.html" | grep -v "trackBy" | wc -l

# Imports lourds
grep -r "import \* as" src --include="*.ts" | wc -l
```

---

## 📊 Template de Rapport

```markdown
# Rapport d'Audit - [REPO_NAME]
Date : [DATE]
Auditeur : Kiro AI

## Résumé Exécutif

| Catégorie | Score | Détails |
|-----------|-------|---------|
| Code Hygiene | 🟢/🟡/🔴 | X issues |
| TypeScript Quality | 🟢/🟡/🔴 | X issues |
| Angular Patterns | 🟢/🟡/🔴 | X issues |
| Sécurité | 🟢/🟡/🔴 | X issues |
| Performance | 🟢/🟡/🔴 | X issues |

**Score Global** : X/100

## Détails par Catégorie

### Code Hygiene
- console.log : X occurrences
- TODO/FIXME : X occurrences
- Recommandation : [...]

### TypeScript Quality
- Types any : X occurrences
- Fichiers volumineux : X fichiers
- Recommandation : [...]

### Angular Patterns
- Subscriptions à risque : X
- Composants sans OnDestroy : X
- Recommandation : [...]

### Sécurité
- innerHTML : X occurrences
- Vulnérabilités npm : X CRITICAL, X HIGH
- Recommandation : [...]

### Performance
- OnPush manquant : X composants
- trackBy manquant : X ngFor
- Recommandation : [...]

## Actions Prioritaires

1. **CRITIQUE** : [Action]
2. **HAUTE** : [Action]
3. **MOYENNE** : [Action]

## Annexes

### Fichiers Problématiques
- [Liste des fichiers]
```

---

## 🎯 Seuils de Qualité

| Métrique | 🟢 Bon | 🟡 Attention | 🔴 Critique |
|----------|--------|--------------|-------------|
| console.log | 0 | 1-10 | >10 |
| TODO/FIXME | 0-5 | 6-20 | >20 |
| any types | 0-5 | 6-20 | >20 |
| Fichiers >500 lignes | 0 | 1-5 | >5 |
| Subscriptions à risque | 0 | 1-10 | >10 |
| innerHTML | 0 | 1-3 | >3 |
| npm CRITICAL | 0 | - | >0 |
| npm HIGH | 0-2 | 3-10 | >10 |

---

## 🔧 Commandes Rapides

```bash
# Audit complet rapide
echo "=== CODE HYGIENE ===" && \
echo "console.log: $(grep -r 'console.log' src --include='*.ts' 2>/dev/null | wc -l)" && \
echo "TODO/FIXME: $(grep -rE 'TODO|FIXME' src --include='*.ts' 2>/dev/null | wc -l)" && \
echo "=== TYPESCRIPT ===" && \
echo "any types: $(grep -r ': any' src --include='*.ts' 2>/dev/null | wc -l)" && \
echo "=== SECURITY ===" && \
echo "innerHTML: $(grep -r 'innerHTML' src --include='*.ts' --include='*.html' 2>/dev/null | wc -l)" && \
npm audit 2>/dev/null | grep -E "CRITICAL|HIGH|found" || echo "npm audit OK"
```

---

## 📞 Suite de l'Audit

Après l'audit, les actions recommandées :

1. **Hardening** : Corriger les issues critiques
2. **Documentation** : Mettre à jour les standards
3. **CI/CD** : Ajouter les checks automatiques
4. **Review** : Planifier la correction des issues moyennes
