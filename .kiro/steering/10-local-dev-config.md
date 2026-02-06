---
inclusion: conditional
priority: 90
patterns:
  - "app.module.ts"
  - "test/**/*"
  - "development"
---

# Configuration Développement Local

> **Contexte** : Configurations spécifiques pour le développement et les tests en local

---

## 🎯 Objectif

Documenter les configurations nécessaires pour tester et développer les bibliothèques shared en local, notamment les ajustements requis pour éviter les erreurs de modules.

---

## 🔧 Configuration pour Tests Local de pwc-ui-shared

### Problème : Erreur TreeDemoModule

Lorsque vous testez `pwc-ui-shared` en local, vous pouvez rencontrer une erreur liée au `TreeDemoModule` dans `main.ts`.

### Solution : Désactivation Temporaire du TreeDemoModule

Pour afficher l'écran de demo et corriger l'erreur de main.ts concernant le treemodule, vous devez **temporairement** supprimer les références au `TreeDemoModule` dans le fichier `app.module.ts` de pwc-ui-shared.

#### Fichier : `C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\src\app\app.module.ts`

**Ligne 8 - À SUPPRIMER** :
```typescript
import { TreeDemoModule } from './components/tree/tree-demo.module';
```

**Ligne 116 - À SUPPRIMER** :
```typescript
TreeDemoModule,
```

#### Exemple de Modification

**AVANT** :
```typescript
// ligne 8
import { TreeDemoModule } from './components/tree/tree-demo.module';

// ...

@NgModule({
  imports: [
    // ...
    TreeDemoModule,  // ligne 116
    // ...
  ]
})
export class AppModule { }
```

**APRÈS** :
```typescript
// ligne 8 - import supprimé

// ...

@NgModule({
  imports: [
    // ...
    // TreeDemoModule supprimé (ligne 116)
    // ...
  ]
})
export class AppModule { }
```

---

## ⚠️ Avertissements Importants

### 🔴 Modifications Temporaires Uniquement

Ces modifications sont **UNIQUEMENT pour les tests en local** :
- ❌ Ne JAMAIS commiter ces changements
- ❌ Ne JAMAIS pousser sur le repo distant
- ✅ Rétablir les imports avant tout commit
- ✅ Utiliser git stash si nécessaire

### 🔄 Workflow Recommandé

```bash
# 1. Faire les modifications temporaires pour les tests
# Supprimer les lignes 8 et 116 dans app.module.ts de pwc-ui-shared

# 2. Tester en local sur port 4201

# Option A : Utiliser le script batch (RECOMMANDÉ)
C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat

# Option B : Manuel
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm start -- --port 4201

# 3. AVANT de commiter, rétablir les changements
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
git checkout src/app/app.module.ts

# OU utiliser git stash
git stash  # Sauvegarder les modifications temporaires
# ... faire vos commits normaux ...
git stash pop  # Restaurer les modifications pour continuer à tester
```

**Avantages du script batch** :
- ✅ Active automatiquement Node v10
- ✅ Vérifie que node_modules existe
- ✅ Configure le port 4201 automatiquement
- ✅ Messages d'erreur clairs si problème

---

## 📋 Checklist Configuration Locale

### Avant de Tester pwc-ui-shared en Local

- [ ] Se placer dans le répertoire pwc-ui-shared-v4-ia
- [ ] Appliquer les modifications temporaires dans `src/app/app.module.ts` (supprimer lignes 8 et 116)
- [ ] Builder la bibliothèque si nécessaire (`npm run build`)
- [ ] Tester l'application de demo (`npm start`)

### Avant de Commiter

- [ ] Rétablir `src/app/app.module.ts` à son état d'origine
- [ ] Vérifier avec `git diff` qu'aucune modification temporaire n'est présente
- [ ] Vérifier que le build fonctionne avec les imports originaux
- [ ] Commiter uniquement les changements pertinents

---

## 🛠️ Autres Configurations Locales

### Link NPM Local

Pour tester `pwc-ui-shared` en local dans `pwc-ui` sans publier sur Nexus :

```bash
# Dans pwc-ui-shared-v4-ia
cd C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia
npm run build
npm link

# Dans pwc-ui-v4-ia
cd C:\repo_hps\pwc-ui\pwc-ui-v4-ia
npm link pwc-ui-shared
```

### Unlink NPM Local

Pour revenir à la version Nexus :

```bash
# Dans pwc-ui-v4-ia
npm unlink pwc-ui-shared
npm install
```

---

## 📝 Notes Complémentaires

### Pourquoi TreeDemoModule Pose Problème ?

Le `TreeDemoModule` peut causer des erreurs lors des tests locaux pour plusieurs raisons :
- Dépendances manquantes ou non résolues
- Conflit de versions ou de chemins d'imports
- Module de demo non nécessaire en production

### Alternative : Utilisation de Flags de Build

Au lieu de supprimer manuellement, vous pouvez également utiliser des flags de build :

```typescript
// app.module.ts
import { environment } from '../environments/environment';

@NgModule({
  imports: [
    // ...
    ...(environment.production ? [] : [TreeDemoModule]),
    // ...
  ]
})
export class AppModule { }
```

---

## ✅ Bonnes Pratiques

### DO
- ✅ Documenter toutes les modifications temporaires
- ✅ Utiliser git stash pour gérer les modifications temporaires
- ✅ Vérifier avant chaque commit
- ✅ Tester avec et sans les modifications

### DON'T
- ❌ Commiter des configurations de dev local
- ❌ Oublier de rétablir les modifications
- ❌ Pousser du code qui ne fonctionne qu'en local
- ❌ Modifier directement les fichiers sans backup

---

## 🎯 Résumé

Pour tester `pwc-ui-shared` en local et éviter l'erreur TreeDemoModule :
1. **Fichier** : `C:\repo_hps\pwc-ui-shared\pwc-ui-shared-v4-ia\src\app\app.module.ts`
2. **Supprimer temporairement** :
   - Ligne 8 : `import { TreeDemoModule } from './components/tree/tree-demo.module';`
   - Ligne 116 : `TreeDemoModule,`
3. **Lancer l'application de demo (RECOMMANDÉ)** :
   ```bash
   C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\start-pwc-ui-shared-4201.bat
   ```
4. **Rétablir les modifications avant tout commit**

**RAPPEL** : Ces modifications sont **TEMPORAIRES** et ne doivent **JAMAIS** être commitées.

---

## 📁 Scripts Batch Utiles

### Localisation
`C:\Users\franck.desmedt\dev\kiro_migration_angular\outils_communs\`

### Scripts Disponibles
| Script | Port | Description |
|--------|------|-------------|
| `start-pwc-ui-shared-4201.bat` | 4201 | Lance Shared avec Node v10 |
| `start-pwc-ui.bat` | 4200 | Lance UI avec Node v10 |
