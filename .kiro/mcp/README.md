# 📁 Dossier .kiro/mcp - Design MCP Avancé

> **Statut** : 📝 Design/Documentation (non implémenté)  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient le **design** d'un système avancé de gestion MCP avec :
- Lazy loading des outils
- Routage intelligent par keywords
- Profils de chargement
- Catalogue d'outils

⚠️ **Important** : Ce système n'est **pas encore implémenté** dans Kiro.

---

## 📂 Contenu

### `mcp-design.json`
**Design** d'une configuration MCP avancée avec :
- **Profils** : minimal, migration, audit, devops, full
- **Lazy loading** : chargement à la demande selon keywords
- **Routage intelligent** : détection automatique des outils nécessaires
- **Gestion contexte** : limites et déchargement automatique

### `tools-catalog.json`
**Catalogue** des outils MCP disponibles :
- Catégories d'outils (file-operations, version-control, etc.)
- Mapping keywords → outils
- Estimation du coût en tokens
- Exemples d'utilisation

---

## ⚙️ Configuration Active vs Design

| Fichier | Statut | Rôle |
|---------|--------|------|
| **`.kiro/settings/mcp.json`** | ✅ ACTIF | Configuration MCP utilisée par Kiro |
| **`.kiro/mcp/mcp-design.json`** | 📝 DESIGN | Documentation d'un système futur |

**La configuration active** se trouve dans `.kiro/settings/mcp.json` !

---

## 🚀 Implémentation Future

Pour implémenter ce système :

1. **Développer un serveur MCP proxy** qui :
   - Lit `mcp.json` et `tools-catalog.json`
   - Route les requêtes vers les bons serveurs
   - Gère le lazy loading

2. **Intégrer dans Kiro** :
   - Remplacer les serveurs individuels par le proxy
   - Configurer dans `.kiro/settings/mcp.json`

3. **Tester** :
   - Vérifier le routage automatique
   - Mesurer l'impact sur le contexte
   - Valider les profils

---

## 📝 Notes

- Ce design a été créé pour optimiser l'utilisation du contexte
- Le système de profils permet d'adapter les outils selon la tâche
- Le routage par keywords évite de charger tous les outils en permanence

---

## 🔗 Ressources

- Configuration active : `.kiro/settings/mcp.json`
- Documentation Kiro MCP : Voir `.kiro/README.md`
- Steering files : `.kiro/steering/`
