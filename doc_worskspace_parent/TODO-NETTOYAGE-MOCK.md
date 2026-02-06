# ⚠️ TODO : NETTOYAGE DES FICHIERS MOCK

**Date création** : 02/02/2026  
**Raison** : Tests frontend sans backend  
**Action requise** : SUPPRIMER ces fichiers après validation de l'IHM

---

## Fichiers à SUPPRIMER après tests

### 1. Intercepteur Mock (NOUVEAU FICHIER)
```
pwc-ui-v4-ia/src/app/core/interceptors/mock-http.interceptor.ts
```
**Action** : `git rm` ou supprimer manuellement

### 2. Configuration Mock (NOUVEAU FICHIER)
```
pwc-ui-v4-ia/src/app/core/config/mock.config.ts
```
**Action** : `git rm` ou supprimer manuellement

---

## Modifications à ANNULER dans fichiers existants

### 3. environment.ts
**Fichier** : `pwc-ui-v4-ia/src/environments/environment.ts`  
**Ligne modifiée** : Ajout de `mock: true,`

**Action** : Supprimer la ligne :
```typescript
mock: true, // AJOUT: Active le mode mock pour dev frontend sans backend
```

### 4. app.module.ts
**Fichier** : `pwc-ui-v4-ia/src/app/app.module.ts`

**Modifications à annuler** :
1. **Import** (ligne ~23) : Supprimer
   ```typescript
   import { MOCK_PROVIDERS } from './core/config/mock.config';
   ```

2. **Provider** (dans le tableau providers) : Supprimer
   ```typescript
   ...MOCK_PROVIDERS // AJOUT: Active l'intercepteur mock si environment.mock = true
   ```

---

## Commande de nettoyage rapide

```bash
# Depuis pwc-ui-v4-ia/
git checkout src/environments/environment.ts
git checkout src/app/app.module.ts
rm -rf src/app/core/interceptors/mock-http.interceptor.ts
rm -rf src/app/core/config/mock.config.ts
```

Ou sous Windows PowerShell :
```powershell
# Depuis pwc-ui-v4-ia/
git checkout src/environments/environment.ts
git checkout src/app/app.module.ts
Remove-Item src/app/core/interceptors/mock-http.interceptor.ts
Remove-Item src/app/core/config/mock.config.ts
```

---

## Vérification après nettoyage

```bash
git status
# Doit afficher : "nothing to commit, working tree clean"
```

---

## ⚠️ IMPORTANT

Ces fichiers mock sont **temporaires** et ne doivent **JAMAIS** être committés dans le repo principal.  
Ils servent uniquement pour les tests frontend en local sans backend.

Une fois le backend `pwc-backend-v4` disponible, supprimer immédiatement ces fichiers.
