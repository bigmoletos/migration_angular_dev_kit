---
inclusion: always
priority: 100
---

# Agent Router - Routage Intelligent

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04  
> **Auteur** : Kiro  

---

## 🎯 Principe : Lazy Loading

**Ne charge PAS tout.** Route vers les bons outils selon le prompt.

---

## 📋 Index à Consulter

| Index | Chemin |
|-------|--------|
| Agents | `.kiro/agents/_index.json` |
| Skills | `.kiro/skills/_index.json` |
| Specs | `.kiro/specs/_index.json` |

---

## 🔀 Routage Automatique par Keywords

### Migration Angular
**Keywords** : `migration`, `angular`, `upgrade`, `ng update`, `palier`

**Action** :
1. Charger `.kiro/steering/02-migration-angular-rules.md`
2. Charger `.kiro/steering/03-rxjs-migration-patterns.md` si RxJS mentionné
3. Consulter `.kiro/specs/02-plan-migration.md` pour le plan

### Audit Code
**Keywords** : `audit`, `analyze`, `quality`, `security`, `review`, `lint`

**Action** :
1. Charger `.kiro/steering/06-testing-strategy.md`
2. Utiliser les skills de code-audit

### Coordination Multi-Repos
**Keywords** : `coordinate`, `sync`, `both`, `ensemble`, `shared`, `ui`

**Action** :
1. Charger `.kiro/steering/01-project-overview.md`
2. Appliquer la règle d'or : **pwc-ui-shared AVANT pwc-ui**

---

## 🔴 RÈGLE D'OR

```
pwc-ui-shared-v4-ia (lib)  →  pwc-ui-v4-ia (client)
       MIGRER AVANT               MIGRER APRÈS
```

---

## 📂 Structure du Workspace

```
repo_hps/
├── .kiro/
│   ├── steering/          # Règles et guides (chargés automatiquement)
│   ├── specs/             # Spécifications (chargés sur demande)
│   ├── agents/            # Agents personnalisés (référence uniquement)
│   └── skills/            # Skills personnalisés (référence uniquement)
├── pwc-ui-shared-v4-ia/   # Bibliothèque (migrer EN PREMIER)
└── pwc-ui-v4-ia/          # Client (migrer APRÈS la lib)
```

---

## 📞 Commandes Disponibles

### Charger une Spec
```
Charge la spec 02-plan-migration
```

### Charger un Steering File
```
Applique les règles de migration Angular
```

### Lister les Ressources
```
Liste les specs disponibles
Liste les steering files
```

---

## ⚠️ Budget Contexte

- Steering files max : **15%** du contexte
- Specs max : **1 à la fois**
- Si saturation >70% : décharger les ressources inutilisées

---

## 🎯 Workflow Recommandé

1. **Identifier le besoin** via keywords
2. **Charger les ressources** appropriées (steering + specs)
3. **Exécuter l'action** avec les règles chargées
4. **Décharger** les ressources après usage

---

## 📝 Notes

- Les agents JSON dans `.kiro/agents/` sont des **références** uniquement
- Les skills JSON dans `.kiro/skills/` sont des **références** uniquement
- Kiro utilise les **steering files** (markdown) pour les instructions
- Les specs sont chargées **sur demande explicite** uniquement
