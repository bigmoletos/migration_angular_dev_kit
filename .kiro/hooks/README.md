# 📁 Dossier .kiro/hooks - Automatisations

> **Statut** : ✅ Actifs (déclenchés automatiquement)  
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-04

---

## 🎯 Objectif

Ce dossier contient les **hooks (automatisations)** qui se déclenchent automatiquement sur certains événements Kiro.

✅ **Important** : Ces hooks s'exécutent en arrière-plan, vous ne les verrez pas dans le chat.

---

## 📂 Contenu

### Hooks Disponibles

| Hook | Événement | Action | Fréquence |
|------|-----------|--------|-----------|
| **cleanup-and-journal.json** | `agentStop` | Nettoie `.kiro/temp/` et propose mise à jour journal | Fin de session |
| **rules-reminder.json** | `promptSubmit` | Rappelle les règles critiques (silencieux) | Tous les 10 messages |
| **sync-kiro-indexes.json** | `agentStop` | Synchronise les index specs/steering | Fin de session |

### `_index.json`
Index des hooks pour synchronisation automatique.

---

## 🔄 Types d'Événements

Les hooks peuvent se déclencher sur :

| Événement | Description | Exemple d'Usage |
|-----------|-------------|-----------------|
| **promptSubmit** | Message envoyé à l'agent | Rappels, validations |
| **agentStop** | Fin d'exécution agent | Nettoyage, synchronisation |
| **fileEdited** | Fichier sauvegardé | Linting, formatage |
| **fileCreated** | Fichier créé | Validation, templates |
| **fileDeleted** | Fichier supprimé | Backup, confirmation |
| **userTriggered** | Déclenché manuellement | Actions sur demande |

---

## 📋 Détail des Hooks

### 1. cleanup-and-journal.json

**Déclencheur** : `agentStop` (fin de session)

**Action** : `askAgent`
```json
{
  "name": "Cleanup & Journal Update",
  "when": { "type": "agentStop" },
  "then": {
    "type": "askAgent",
    "prompt": "Nettoie .kiro/temp/ et propose mise à jour journal"
  }
}
```

**Comportement** :
1. Liste les fichiers dans `.kiro/temp/`
2. Supprime les fichiers temporaires anciens
3. Demande si le journal de bord doit être mis à jour
4. Propose un résumé de la session

### 2. rules-reminder.json

**Déclencheur** : `promptSubmit` (tous les 10 messages)

**Action** : `askAgent` (silencieux)
```json
{
  "name": "Rules Reminder",
  "when": { "type": "promptSubmit" },
  "then": {
    "type": "askAgent",
    "prompt": "Rappel silencieux des règles critiques"
  }
}
```

**Comportement** :
1. Vérifie que les règles critiques sont respectées
2. Rappelle la règle d'or (pwc-ui-shared AVANT pwc-ui)
3. Vérifie l'hygiène du workspace
4. **Silencieux** : pas de message dans le chat

### 3. sync-kiro-indexes.json

**Déclencheur** : `agentStop` (fin de session)

**Action** : `runCommand`
```json
{
  "name": "Sync Kiro Indexes",
  "when": { "type": "agentStop" },
  "then": {
    "type": "runCommand",
    "command": "node .kiro/scripts/sync-all-indexes.js"
  }
}
```

**Comportement** :
1. Exécute le script de synchronisation
2. Met à jour `specs/_index.json`
3. Met à jour `steering/_index.json`
4. Met à jour `agents/_index.json`
5. Met à jour `skills/_index.json`

---

## 🚀 Utilisation

### Hooks Automatiques

Les hooks se déclenchent **automatiquement**, vous n'avez rien à faire.

### Désactiver Temporairement

Pour désactiver un hook temporairement :

1. Ouvrir le fichier JSON du hook
2. Ajouter `"disabled": true`
```json
{
  "name": "Mon Hook",
  "disabled": true,
  "when": { ... }
}
```

### Créer un Nouveau Hook

Utiliser la commande Kiro :
```
Crée un hook qui lint les fichiers TypeScript à chaque sauvegarde
```

Ou créer manuellement un fichier JSON :
```json
{
  "name": "Lint on Save",
  "version": "1.0.0",
  "when": {
    "type": "fileEdited",
    "patterns": ["*.ts", "*.tsx"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Exécute npm run lint sur le fichier modifié"
  }
}
```

---

## ⚙️ Format des Hooks

### Structure JSON

```json
{
  "metadata": {
    "version": "1.0.0",
    "lastUpdate": "2026-02-04",
    "author": "Kiro"
  },
  "name": "Nom du Hook",
  "version": "1.0.0",
  "description": "Description du hook",
  "when": {
    "type": "eventType",
    "patterns": ["*.ts"]  // Optionnel, pour fileEdited/Created/Deleted
  },
  "then": {
    "type": "askAgent|runCommand",
    "prompt": "...",      // Pour askAgent
    "command": "..."      // Pour runCommand
  },
  "disabled": false
}
```

### Types d'Actions

**askAgent** : Envoie un message à l'agent
- Valide avec : `fileEdited`, `fileCreated`, `fileDeleted`, `userTriggered`, `promptSubmit`, `agentStop`

**runCommand** : Exécute une commande shell
- Valide avec : `promptSubmit`, `agentStop` **UNIQUEMENT**

---

## ⚠️ Règles Importantes

### ✅ Bonnes Pratiques

- Utiliser `askAgent` pour les actions nécessitant du contexte
- Utiliser `runCommand` pour les scripts simples
- Tester les hooks avant de les activer
- Documenter le comportement attendu
- Versionner les hooks

### ❌ À Éviter

- Ne PAS utiliser `runCommand` avec des événements fichiers
- Ne PAS créer de hooks trop fréquents (performance)
- Ne PAS oublier de tester les patterns de fichiers
- Ne PAS créer de hooks qui modifient des fichiers sans confirmation

---

## 🔍 Debugging

### Vérifier qu'un Hook Fonctionne

1. Vérifier que le fichier JSON est valide
2. Vérifier que `disabled: false`
3. Déclencher l'événement manuellement
4. Consulter les logs Kiro

### Logs

Les hooks génèrent des logs dans :
- Console Kiro (pour les erreurs)
- `.kiro/temp/hook-logs.txt` (si configuré)

---

## 📝 Notes

- Les hooks sont **asynchrones** et n'attendent pas de réponse
- Les hooks `askAgent` peuvent être silencieux (pas de message visible)
- Les hooks `runCommand` s'exécutent dans le contexte du workspace
- Les hooks sont rechargés automatiquement après modification

---

## 🔗 Ressources

- Scripts disponibles : `.kiro/scripts/`
- Documentation Kiro Hooks : Voir `.kiro/README.md`
- Exemples de hooks : Fichiers JSON dans ce dossier
- Commande palette : "Open Kiro Hook UI"
