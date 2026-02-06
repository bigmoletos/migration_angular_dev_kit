# AGENTS.md - Routeur Intelligent

> **Workspace** : `repo_hps` | Ce fichier reste MINIMAL (<400 tokens)

---

## 🎯 Principe : Lazy Loading

**Ne charge PAS tout.** Route vers les bons outils selon le prompt.

## 📋 Index à Consulter

| Index | Chemin |
|-------|--------|
| Agents | `.kiro/agents/_index.json` |
| Skills | `.kiro/skills/_index.json` |
| MCP | `.kiro/mcp/tools-catalog.json` |

## 🔀 Routage Rapide

| Keywords | → Action |
|----------|----------|
| migration, angular, upgrade | `#migration-agent` + skill angular-migration |
| audit, quality, security | `#audit-agent` + skill code-audit |
| coordinate, sync, both | `#coordinator-agent` (défaut) |
| rxjs, observable | skill rxjs-patterns |

## 🔴 RÈGLE D'OR

```
pwc-ui-shared-v4-ia (lib)  →  pwc-ui-v4-ia (client)
       MIGRER AVANT               MIGRER APRÈS
```

**Séquence** : Lib build OK → Lib test OK → Client migration → Intégration

## ⚠️ Budget Contexte

- MCP max : **12%** du context
- Skills max : **2 simultanés**
- Si saturation >70% : décharger les ressources inutilisées

## 📂 Structure

```
repo_hps/
├── pwc-ui-shared-v4-ia/  # Bibliothèque (migrer EN PREMIER)
└── pwc-ui-v4-ia/         # Client (migrer APRÈS la lib)
```

## 📞 Commandes

- `#list-skills` / `#list-agents` / `#context-status`
- Détails : `docs_outils_ia/GUIDE-CONTEXT-OPTIMIZER.md`
