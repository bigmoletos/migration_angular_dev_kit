# 📁 Dossier .kiro/settings - Configuration Kiro

> **Statut** : ✅ Configuration Active  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **configurations actives** utilisées par Kiro pour :
- Paramètres du workspace
- Configuration des serveurs MCP
- Préférences de l'IDE

---

## 📂 Contenu

### `kiro.json` ✅
**Configuration du workspace Kiro** :
```json
{
  "kiro.workspace.root": "c:\\repo_hps\\.kiro",
  "kiro.specs.enabled": true,
  "kiro.specs.path": "specs",
  "kiro.hooks.enabled": true,
  "kiro.hooks.path": "hooks",
  "kiro.steering.enabled": true,
  "kiro.steering.path": "steering",
  "kiro.features.autoDiscovery": true
}
```

**Paramètres** :
- `workspace.root` : Racine du dossier .kiro
- `specs.enabled` : Active les spécifications
- `hooks.enabled` : Active les hooks automatiques
- `steering.enabled` : Active les steering files
- `autoDiscovery` : Découverte automatique des ressources

### `mcp.json` ✅
**Configuration MCP active** utilisée par Kiro :
```json
{
  "mcpServers": {
    "strands-orchestrator": {
      "command": "uv.exe",
      "args": ["tool", "run", "strands-agents-mcp-server"],
      "env": {
        "STRANDS_CONFIG": "c:/repo_hps/.kiro/strands/config.json",
        "STRANDS_STATE_PATH": "c:/repo_hps/.kiro/state/strands-state.json"
      }
    }
  }
}
```

**Serveurs configurés** :
- `strands-orchestrator` : Orchestration multi-agents avec AWS Strands SDK

---

## 🔧 Modification

### Ajouter un Serveur MCP

1. Éditer `.kiro/settings/mcp.json`
2. Ajouter une entrée dans `mcpServers` :
```json
{
  "mcpServers": {
    "strands-orchestrator": { ... },
    "mon-nouveau-serveur": {
      "command": "uvx",
      "args": ["mon-package-mcp"],
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

3. Redémarrer Kiro ou recharger la config MCP

### Modifier les Chemins

Éditer `kiro.json` pour changer les chemins des specs, hooks, steering.

---

## ⚠️ Important

- **Ne PAS supprimer** ces fichiers sans backup
- **Tester** après chaque modification
- **Redémarrer Kiro** après modification de `mcp.json`
- Les chemins doivent être **absolus** ou relatifs au workspace

---

## 🔗 Ressources

- Documentation MCP : Voir `.kiro/README.md`
- Design MCP avancé : `.kiro/mcp/README.md`
- Hooks disponibles : `.kiro/hooks/`
- Steering files : `.kiro/steering/`
