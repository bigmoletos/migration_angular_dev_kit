# Règle 1 : Gestion des forks avec suffixe

## Contexte

Nous utilisons actuellement un **fork du projet initial** avec les repositories suffixés par **`-v4-ia`** :
- `pwc-ui-v4-ia`
- `pwc-ui-shared-v4-ia`

## Points d'attention

### Risques potentiels
Le suffixe `-v4-ia` peut entraîner des erreurs dans :
- Les chemins de fichiers
- Les imports de modules
- Les configurations
- Les scripts

### Principe de modification minimale

**Objectif** : Faire un minimum de changements sur le code des repositories car notre méthode doit pouvoir s'appliquer à **n'importe quel autre repository**.

## Règles de modification du code

### 1. Toujours commenter l'ancien code
```typescript
// ORIGINAL CODE (before fork modification)
// import { SharedModule } from '@pwc/shared';

// MODIFIED for fork -v4-ia
import { SharedModule } from '@pwc/shared-v4-ia';
```

### 2. Documenter la raison
```json
{
  "dependencies": {
    // ORIGINAL: "@pwc/shared": "2.6.23",
    // MODIFIED for local development (fork -v4-ia)
    // Reason: @pwc/shared not available on npmjs.org, using local link
    "@pwc/shared": "file:C:/repo_hps/pwc-ui-shared/pwc-ui-shared-v4-ia/src/lib/shared"
  }
}
```

### 3. Faciliter le rollback
Toute modification doit pouvoir être annulée facilement en décommentant l'ancien code et en supprimant/commentant le nouveau.

## Checklist avant modification

- [ ] La modification est-elle vraiment nécessaire ?
- [ ] Peut-on utiliser une configuration au lieu de modifier le code ?
- [ ] L'ancien code est-il commenté (pas supprimé) ?
- [ ] La raison de la modification est-elle documentée ?
- [ ] La modification est-elle réversible facilement ?
- [ ] La modification fonctionnera-t-elle sur d'autres forks ?

## Exemples de modifications acceptables

### ✅ Bon : Configuration avec commentaires
```javascript
// ORIGINAL: const API_URL = 'http://api.example.com';
// MODIFIED for fork -v4-ia: Using local development URL
const API_URL = 'http://localhost:3000';
```

### ✅ Bon : Chemin adapté avec variable
```bash
# ORIGINAL: PROJECT_PATH=C:\repo_hps\pwc-ui
# MODIFIED for fork -v4-ia
PROJECT_PATH=C:\repo_hps\pwc-ui\pwc-ui-v4-ia
```

### ❌ Mauvais : Suppression sans commentaire
```javascript
const API_URL = 'http://localhost:3000';
```

### ❌ Mauvais : Modification hardcodée non documentée
```javascript
import { SharedModule } from '@pwc/shared-v4-ia';
```

## Application à d'autres repositories

Pour appliquer la même méthode à un autre fork (ex: `-v5-test`) :
1. Rechercher tous les commentaires `MODIFIED for fork -v4-ia`
2. Adapter les chemins avec le nouveau suffixe
3. Vérifier que les modifications fonctionnent
4. Documenter les changements spécifiques au nouveau fork

## Voir aussi

- [MODIFICATIONS-CODE-FORK.md](../../Documentation/MODIFICATIONS-CODE-FORK.md) : Liste complète des modifications
- [JOURNAL-DE-BORD.md](../../Documentation/JOURNAL-DE-BORD.md) : Historique des changements
