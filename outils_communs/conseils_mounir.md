# Conseils Mounir pour la migration  4fev26

Conseils pour la migration il est preferable de commenter les écrans dont on ne sert pas pour les tests ou de les supprimer pour faire les tests car cela consomme beaucoup de ressources. Aprés les tests on peut faire un revert du commit

voir toutes les copies ecrans pour plus de détails dans "C:\Users\franck.desmedt\OneDrive - HPS\Images\Captures d’écran\mounir_4fev26"

par exemple si je veux utiliser l'ecran admin/compliance/user on peut commenter les autres workspace et les autres ecrans de compliance

dans le fichier C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\app\admin\compliance\compliance.routes.ts
```js
export const ComplianceRoutes = [
  {
    path: '',
    children: [
      // Product Routing
      {path: 'users', loadChildren: './product/users/users.module#UsersModule'},
   //    {path: 'profile', loadChildren: './product/profile/profile.module#ProfileModule'},
    //   {path: 'ldap_conf', loadChildren: './product/ldap_conf/ldap_conf.module#LdapConfModule'},
     // {path: 'role', loadChildren: './product/role/role.module#RoleModule'},
    //  {path: 'link-user-reports', loadChildren: './product/link-user-report/linkUserReport.module#LinkUserReportModule'},
    //  {path: 'dataAccessBank', loadChildren: './product/profile-data-access/profileDataAccess.module#ProfileDataAccessModule'}
     
      // Specific Routing
    ]
  }

];
```
Dans le fichier C:\repo_hps\pwc-ui\pwc-ui-v4-ia\src\app\core\route\core.routes.ts on va commenter les 2 lignes des worskspaces "param" et "op"

```js
    children: [
    //  {path: 'param', loadChildren: '@param/parameters.module#ParametersModule'},
    //  {path: 'op', loadChildren: '@op/operation.module#OperationModule'},
      {path: 'admin', loadChildren: '@admin/admin.module#AdminModule'}
    ]
  }
  ,
  {path: '**', redirectTo: '/notfound'},
];
```

 
### Version Webpack 

pour la phase 13 à 14 mounir à prevue de revenir à angular cli et de ne plus utiliser le webpack.dev qui est  une version personnalisé augmentant la taille
de la mémoire NodeJs

Dans le pakage.json on a:

```json
"start": "node --max-old-space-size=6000 ./node_modules/webpack-dev-server/bin/webpack-dev-server --config webpack.dev.config.js --port=4200",
"build": "node --max-old-space-size=12288 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js",
```

Ce code utilise une version personnalisée de webpack, pas la configuration standard Angular CLI.
1. Approche personnalisée (pas Angular CLI standard)
bash"start": "node --max-old-space-size=6000 ./node_modules/webpack-dev-server/bin/webpack-dev-server --config webpack.dev.config.js --port=4200"
Standard Angular CLI :
bash"start": "ng serve"

Différences :

❌ Pas d'utilisation de ng serve (commande Angular CLI)
✅ Appel direct de webpack-dev-server via Node.js
✅ Configuration webpack personnalisée (webpack.dev.config.js)

2. Augmentation mémoire Node.js

```bash
bash--max-old-space-size=6000    # 6 Go pour le dev
--max-old-space-size=12288   # 12 Go pour le build
```

**Pourquoi ?**
- Projet très volumineux (2343 composants !)
- Évite les erreurs "JavaScript heap out of memory"
- Valeurs par défaut Node.js : ~1.4-1.7 Go seulement

#### 3. **Fichiers de configuration personnalisés**

| Fichier | Rôle |
|---------|------|
| `webpack.dev.config.js` | Config webpack pour développement |
| `webpack.prod.config.js` | Config webpack pour production |

Au lieu de :
- `angular.json` (standard Angular CLI)
- `.angular-cli.json` (Angular CLI v1-5)

---

## 🎯 Implications pour la migration

### ⚠️ Points critiques

1. **Pas de `ng update` automatique**
   - La commande `ng update @angular/core` ne fonctionnera probablement pas
   - Il faudra migrer manuellement les configs webpack

2. **Fichiers à migrer**

```bash
   webpack.dev.config.js  → adapter aux nouvelles versions webpack
   webpack.prod.config.js → adapter aux nouvelles versions webpack
   package.json           → mettre à jour les scripts
```
Webpack version

Angular 5 utilisait probablement webpack 3.x
Angular 20 utilise webpack 5.x
Breaking changes majeurs entre webpack 3 → 5


### Intégrer la gestion des dependances non utilisées

Par ex dans package.json certaines dépendances ne sont pas utilisées comme:
 *npm* : *^6.1.0-next.0*;
 
Il faudra donc le gerer pour eviter les surcharges





- Le cache Kubernetes est géré automatiquement
- Le port forwarding doit être actif dans OpenLens pour accéder au backend