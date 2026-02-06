# Outils communs - Scripts utilitaires

Ce dossier contient des scripts batch pour faciliter le développement sur les projets Angular 5.

## Architecture des projets

```
pwc-ui-shared (Shared Library)
    ↓ (dépendance)
pwc-ui (Main Application)
```

**pwc-ui** dépend de **pwc-ui-shared** (`@pwc/shared`). Il faut donc installer les dépendances dans cet ordre :
1. pwc-ui-shared (bibliothèque partagée)
2. pwc-ui (application principale)

## Scripts disponibles

### 0. Use-Node10.bat
**Alias pour activer Node.js v10.24.1**

Script utilitaire appelé par les autres scripts pour configurer l'environnement Node v10.

**Utilisation directe (optionnelle) :**
```batch
call Use-Node10.bat
node --version
npm --version
```

**Variables définies :**
- `NODE_V10_PATH` : Chemin vers Node v10
- `NODE_PATH` : Alias de NODE_V10_PATH
- `NODE_EXE` : Chemin complet vers node.exe
- `NPM_CMD` : Chemin complet vers npm.cmd
- `PATH` : Modifié pour inclure Node v10 en priorité

**Configuration :**
Le chemin de Node v10 est défini dans ce fichier. Pour changer l'emplacement de Node v10, modifier uniquement ce fichier.

---

### 1. install-dependencies.bat
**Installation des dépendances npm**

Lance l'installation des node_modules pour pwc-ui-shared et/ou pwc-ui.

**Utilisation :**
```batch
install-dependencies.bat
```

Le script propose un menu interactif pour choisir quel projet installer :
1. pwc-ui-shared uniquement
2. pwc-ui uniquement
3. Les deux projets (dans le bon ordre)
4. Quitter

**Ce que fait le script :**
- Active Node v10 via Use-Node10.bat
- Nettoie le cache npm
- Installe les dépendances avec les bonnes options (`--legacy-peer-deps --ignore-scripts`)
- Vérifie les prérequis avant l'installation

**Recommandation :**
Pour une première installation, choisir l'option 3 (les deux projets) pour installer dans le bon ordre.

---

### 2. start-pwc-ui-shared.bat
**Lancement du serveur de développement pwc-ui-shared**

Démarre le serveur Angular pour la bibliothèque partagée.

**Utilisation :**
```batch
start-pwc-ui-shared.bat
```

**Accès :**
- URL : http://localhost:4200
- Arrêt : Ctrl+C dans le terminal

**Prérequis :**
- node_modules installés dans pwc-ui-shared (utiliser install-dependencies.bat)

**Note :**
Ce serveur est principalement utilisé pour tester les composants de la bibliothèque partagée de manière isolée.

---

### 3. start-pwc-ui.bat
**Lancement du serveur de développement pwc-ui**

Démarre le serveur Angular pour l'application principale.

**Utilisation :**
```batch
start-pwc-ui.bat
```

**Accès :**
- URL : http://localhost:4200
- Arrêt : Ctrl+C dans le terminal

**Prérequis :**
- node_modules installés dans pwc-ui-shared ET pwc-ui (utiliser install-dependencies.bat option 3)

**Note :**
C'est le serveur principal pour développer l'application complète.

---

## Configuration

### Chemin Node.js
Le chemin de Node v10 est centralisé dans **Use-Node10.bat** :
```batch
set NODE_V10_PATH=C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64
```

Pour changer l'emplacement de Node v10, modifier **uniquement** ce fichier.

### Chemins des projets
Les chemins des projets sont définis dans chaque script :
```batch
# Dans install-dependencies.bat, start-pwc-ui-shared.bat, start-pwc-ui.bat
set PROJECT_SHARED=C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
set PROJECT_UI=C:\repo_hps\pwc-ui\pwc-ui-v4-ia
```

## Workflow typique

### Première installation (IMPORTANT)
1. Lancer `install-dependencies.bat`
2. **Choisir l'option 3** (Les deux projets)
3. Attendre la fin de l'installation (peut prendre 5-10 minutes)

**Pourquoi les deux ?**
- pwc-ui dépend de pwc-ui-shared (`@pwc/shared`)
- Sans pwc-ui-shared installé, pwc-ui ne peut pas démarrer
- Le script installe automatiquement dans le bon ordre

### Développement quotidien

#### Pour travailler sur l'application principale
1. Lancer `start-pwc-ui.bat`
2. Ouvrir http://localhost:4200 dans le navigateur
3. Développer (hot reload automatique)
4. Arrêter avec Ctrl+C quand terminé

#### Pour travailler sur la bibliothèque partagée
1. Lancer `start-pwc-ui-shared.bat`
2. Ouvrir http://localhost:4200 dans le navigateur
3. Développer les composants partagés
4. Arrêter avec Ctrl+C quand terminé

### Mise à jour des dépendances
Si le package.json change (ajout/suppression de dépendances) :
1. Lancer `install-dependencies.bat`
2. Choisir le projet concerné (ou les deux si les deux ont changé)

## Dépannage

### Erreur "Node.js introuvable"
**Symptôme :**
```
[ERREUR] Node.js v10.24.1 introuvable
```

**Solution :**
Vérifier que Node v10.24.1 est installé dans :
```
C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64
```
Si l'emplacement est différent, modifier `Use-Node10.bat`

### Erreur "node_modules introuvable"
**Symptôme :**
```
[ERREUR] node_modules introuvable
```

**Solution :**
Lancer d'abord `install-dependencies.bat` option 3

### Port 4200 déjà utilisé
**Symptôme :**
```
Port 4200 is already in use
```

**Solution :**
Un autre serveur Angular tourne déjà. L'arrêter ou utiliser un autre port :
```batch
# Modifier temporairement le script start ou lancer manuellement :
npm start -- --port 4201
```

### Erreurs de compilation
**Symptômes :**
```
ERROR in ...
Module not found
```

**Solutions :**
1. Vérifier que Node v10.24.1 est utilisé (pas une version plus récente)
2. Vérifier que les deux projets ont leurs node_modules installés
3. Nettoyer et réinstaller :
   ```batch
   # Supprimer node_modules dans les deux projets
   # Puis relancer install-dependencies.bat option 3
   ```

### pwc-ui ne trouve pas @pwc/shared
**Symptôme :**
```
Cannot find module '@pwc/shared'
```

**Solution :**
pwc-ui-shared n'est pas installé ou mal configuré :
1. Lancer `install-dependencies.bat` option 1 (pwc-ui-shared)
2. Puis option 2 (pwc-ui)

## Commandes manuelles (avancé)

Si tu préfères lancer les commandes manuellement :

### Activer Node v10
```batch
call C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\Use-Node10.bat
```

### Installer pwc-ui-shared
```batch
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm cache clean --force
npm install --legacy-peer-deps --ignore-scripts
```

### Installer pwc-ui
```batch
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm cache clean --force
npm install --legacy-peer-deps --ignore-scripts
```

### Démarrer le serveur
```batch
# Pour pwc-ui-shared
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start

# Pour pwc-ui
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm start
```

## Références

- [Procédure d'installation](../../Documentation/PROCEDURE-INSTALLATION-DEPENDENCIES.md)
- [Journal de bord](../../Documentation/JOURNAL-DE-BORD.md)
- [Configuration Nexus](../../Documentation/modop_nexus.md)

## Historique

| Version | Date | Auteur | Description |
|---------|------|--------|-------------|
| 1.1.0 | 2026-02-02 | Franck Desmedt / Kiro | Refactoring avec Use-Node10.bat |
| 1.0.0 | 2026-02-02 | Franck Desmedt / Kiro | Création des scripts |
