# Configuration Backend Custom - Mounir (4 février 2026)

> Mode opératoire pour connecter le backend custom de Mounir

---

## 🛠️ Outils Requis

- **OpenLens** : Interface Kubernetes
- **kubectl** : Outil CLI Kubernetes
- **kubectl-oidc_login** : Plugin d'authentification OIDC
- **Kubernetes Cluster** : `pwc-angular-migration-ia`

---

## � Étape 0 : Configuration OpenLens - Ajout du Cluster Kubernetes

### Ajouter le Cluster via Kubeconfig

1. **Ouvrir OpenLens**

2. **Ajouter le cluster** :
   - Cliquer sur **"Add Clusters from Kubeconfig"**
   - Coller le contenu du fichier kubeconfig.yaml

voir le fichier outils_communs\kubeconfig.yaml



### Informations du Cluster

| Paramètre | Valeur |
|-----------|--------|
| **Cluster Name** | `pwcv4-kube-pegasus-oidc` |
| **Server** | `https://0tz4w8.c1.gra9.k8s.ovh.net` |
| **Authentification** | OIDC via Keycloak |
| **Issuer URL** | `https://keycloak.pwcv4.com/realms/master` |
| **Client ID** | `hps-k8s-default` |
| **Namespace** | `pwc-angular-migration-ia` |

### Vérification

Une fois le cluster ajouté dans OpenLens :
- Le cluster `pwcv4-kube-pegasus-oidc` doit apparaître dans la liste
- L'authentification OIDC se fera automatiquement via Keycloak
- Vous pourrez naviguer vers le namespace `pwc-angular-migration-ia`

---

## 📂 Étape 1 : Configuration des Dossiers Windows

### Structure à Créer

Dans le profil utilisateur Windows, créer l'arborescence suivante :

```
C:\Users\franck.desmedt\
├── .kube\
│   └── cache\                          # Dossier cache (créé automatiquement)
└── nexus\
    └── bin\
        ├── kubectl.exe                 # Outil kubectl
        └── kubectl-oidc_login.exe      # Plugin OIDC
```

### Actions

1. **Créer le dossier Nexus/BIM** :
   ```powershell
   New-Item -Path "C:\Users\franck.desmedt\nexus\bin" -ItemType Directory -Force
   ```

2. **Copier les exécutables kubectl** :
   - `kubectl.exe`
   - `kubectl-oidc_login.exe`
   
   Dans le dossier `C:\Users\franck.desmedt\nexus\bin\`

3. **Créer le dossier cache Kubernetes** :
   ```powershell
   New-Item -Path "C:\Users\franck.desmedt\.kube\cache" -ItemType Directory -Force
   ```

4. **Ajouter au PATH Windows** :
   - Ouvrir les variables d'environnement système
   - Ajouter `C:\Users\franck.desmedt\nexus\bin` au PATH
   - Redémarrer le terminal

---

## 🔌 Étape 2 : Configuration OpenLens

### Connexion au Pod

1. **Ouvrir OpenLens**

2. **Naviguer vers le pod** :
   - Namespace : `pwc-angular-migration-ia`
   - Pod : `pwc-service-api-gateway-5cf8bf64b9-4qnn5`

3. **Configurer le Port Forwarding** :

| Paramètre | Valeur |
|-----------|--------|
| **Resource Name** | `pwc-service-api-gateway-5cf8bf64b9-4qnn5` |
| **Namespace** | `pwc-angular-migration-ia` |
| **Kind** | `pod` |
| **Pod Port** | `8080` |
| **Local Port** | `8888` |
| **Protocol** | `http` |
| **Status** | `Active` |

4. **Décocher toutes les options supplémentaires**

---

## ✅ Vérification

Une fois configuré, le backend sera accessible sur :

```
http://localhost:8888
```

Le dossier cache `.kube\cache` se remplira automatiquement lors du lancement du backend.

---

## 📝 Notes

- Le port local `8888` est utilisé pour éviter les conflits avec d'autres services


## Connexion interface UI

les logins et pwd de l'interface sont :

login=firstUser
pwd=Policy001*$
 
autre login  
login=ISS004  
pwd=Hps001*$

on peut aussi tester le ISS005 ....
