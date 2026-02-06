# Analyse Détaillée du Repository PWC UI v4 IA

## 📋 Vue d'ensemble du projet

**Nom du projet :** PWC UI v4 IA (PowerCard Socle)  
**Version :** 4.2.4  
**Type :** Application web Angular 5  
**Licence :** MIT  

### 🎯 Qu'est-ce que PowerCard ?

**PowerCard** est une **plateforme bancaire complète** développée par HPS (Hightech Payment Systems) pour gérer l'ensemble des opérations de paiement électronique. Cette application web est l'interface utilisateur (UI) qui permet aux employés des banques et institutions financières de :

- **Gérer les cartes bancaires** (émission, activation, blocage)
- **Superviser les transactions** (paiements, retraits ATM, achats en ligne)
- **Détecter et traiter la fraude** (alertes, enquêtes, blocages)
- **Configurer les systèmes** (paramètres, règles métier, seuils)
- **Administrer la plateforme** (utilisateurs, sécurité, audit)

### 🏦 Contexte Métier

Cette interface sert à plusieurs types d'utilisateurs dans l'écosystème bancaire :

1. **Opérateurs bancaires** : Traitent les transactions au quotidien
2. **Analystes fraude** : Surveillent et enquêtent sur les activités suspectes  
3. **Administrateurs système** : Configurent et maintiennent la plateforme
4. **Gestionnaires de paramètres** : Définissent les règles métier et seuils

### 🔄 Modules PowerCard

L'application couvre 6 modules métier principaux :
- **PowerCARD-Acquirer** : Gestion des commerçants et terminaux de paiement
- **PowerCARD-Issuer** : Émission et gestion des cartes bancaires
- **PowerCARD-Switch** : Routage et traitement des transactions
- **PowerCARD-ATM** : Gestion des distributeurs automatiques
- **PowerCARD-xPOS** : Terminaux de paiement électronique
- **PowerCARD-Fraud** : Détection et prévention de la fraude  

## 🏗️ Architecture et Stack Technique

### 🎯 Pourquoi cette Stack ?

Cette application utilise une architecture moderne adaptée aux besoins bancaires :

### Framework Principal

- **Angular 5.2.10** - Framework frontend principal
  - **Pourquoi Angular ?** Framework robuste pour applications d'entreprise, avec une architecture modulaire parfaite pour les grandes applications bancaires
  - **Avantages :** TypeScript natif, injection de dépendances, composants réutilisables, écosystème riche

- **TypeScript 2.5.3** - Langage de développement
  - **Pourquoi TypeScript ?** Ajoute la sécurité des types à JavaScript, essentiel pour les applications critiques bancaires
  - **Avantages :** Détection d'erreurs à la compilation, meilleure maintenabilité, IntelliSense

- **RxJS 5.5.6** - Programmation réactive
  - **Pourquoi RxJS ?** Gestion élégante des flux de données asynchrones (transactions, notifications en temps réel)
  - **Usage :** Gestion des appels API, événements utilisateur, mises à jour temps réel

- **NgRx 4.1.1** - Gestion d'état Redux pour Angular
  - **Pourquoi NgRx ?** Gestion centralisée de l'état de l'application, crucial pour une app bancaire complexe
  - **Usage :** État utilisateur, cache des données, synchronisation entre composants

### Outils de Build et Bundling

- **Webpack 4.16.5** - Module bundler principal
  - **Rôle :** Assemble tous les fichiers (JS, CSS, images) en bundles optimisés
  - **Avantages :** Code splitting, optimisation automatique, hot reload en développement

- **Webpack Dev Server 3.11.2** - Serveur de développement
  - **Rôle :** Serveur local avec rechargement automatique pendant le développement
  - **Fonctionnalités :** Proxy API, hot module replacement, debugging

- **@ngtools/webpack 1.10.2** - Compilation Angular avec Webpack
  - **Rôle :** Intègre la compilation Angular (templates, styles) dans Webpack
  - **Avantages :** Optimisations spécifiques Angular, tree-shaking

- **Angular CLI 1.7.4** - Outils de ligne de commande Angular
  - **Rôle :** Génération de code, tests, builds, déploiement
  - **Usage :** `ng generate`, `ng test`, `ng build`

### UI/UX et Styling

- **PrimeNG 5.2.4** - Bibliothèque de composants UI
  - **Pourquoi PrimeNG ?** Composants riches adaptés aux applications d'entreprise (tableaux, formulaires, graphiques)
  - **Composants utilisés :** DataTable, Calendar, Dialog, Charts, Tree

- **Bootstrap** - Framework CSS (via assets/css/bootstrap/)
  - **Rôle :** Grille responsive, composants de base, normalisation CSS
  - **Avantages :** Responsive design, compatibilité navigateurs

- **Font Awesome 4.7.0** - Icônes
  - **Usage :** Icônes interface (boutons, menus, statuts)
  - **Avantages :** Vectoriel, personnalisable, large choix

- **Chart.js 2.7.1** - Graphiques et visualisations
  - **Usage :** Dashboards, rapports, statistiques de transactions
  - **Types :** Courbes, barres, camemberts, indicateurs

- **FullPage.js 2.9.7** - Navigation pleine page
  - **Usage :** Écrans d'accueil, présentations, wizards
  - **Avantages :** Navigation fluide, responsive

### Tests

- **Karma** - Test runner pour les tests unitaires
  - **Rôle :** Exécute les tests dans différents navigateurs
  - **Configuration :** Tests parallèles, couverture de code

- **Jasmine 2.8.0** - Framework de tests
  - **Usage :** Tests unitaires des composants et services
  - **Syntaxe :** `describe()`, `it()`, `expect()`

- **Protractor 5.1.2** - Tests end-to-end
  - **Rôle :** Tests d'intégration simulant l'utilisateur final
  - **Usage :** Parcours utilisateur complets, validation fonctionnelle

- **Chrome Headless** - Navigateur pour les tests
  - **Avantages :** Tests rapides sans interface graphique
  - **CI/CD :** Intégration dans les pipelines automatisés

### Sécurité et Cryptographie

- **Crypto-JS 3.1.9-1** - Cryptographie côté client
  - **Usage :** Chiffrement des données sensibles avant envoi
  - **Algorithmes :** AES, SHA, HMAC

- **Simple-Crypto-JS 2.0.2** - Chiffrement simplifié
  - **Usage :** Chiffrement rapide de données temporaires
  - **Avantages :** API simple, sécurisé

- **Secure-LS 1.1.0** - LocalStorage sécurisé
  - **Rôle :** Stockage local chiffré des préférences utilisateur
  - **Sécurité :** Chiffrement automatique, expiration

### Utilitaires

- **Lodash 4.17.13** - Utilitaires JavaScript
  - **Usage :** Manipulation de données, fonctions utilitaires
  - **Fonctions :** `map()`, `filter()`, `groupBy()`, `debounce()`

- **Ramda 0.25.0** - Programmation fonctionnelle
  - **Usage :** Transformations de données complexes
  - **Avantages :** Immutabilité, composition de fonctions

- **Moment 2.29.4** - Manipulation des dates
  - **Usage :** Formatage, calculs, fuseaux horaires
  - **Critique :** Gestion des dates de transactions, rapports

- **UUID 8.3.2** - Génération d'identifiants uniques
  - **Usage :** IDs de session, références de transactions
  - **Avantages :** Unicité garantie, sécurisé

## 📁 Structure Détaillée des Dossiers

### 🎯 Organisation Modulaire

L'application suit une architecture modulaire qui sépare clairement les responsabilités :

### Dossiers de Configuration

```
pwc-ui-v4-ia/
├── .angular-cli.json          # Configuration Angular CLI - définit comment builder l'app
├── package.json               # Dépendances npm et scripts - le "carnet d'adresses" des librairies
├── tsconfig.json             # Configuration TypeScript - règles de compilation
├── webpack.dev.config.js     # Configuration Webpack développement - comment assembler l'app en dev
├── webpack.prod.config.js    # Configuration Webpack production - optimisations pour la prod
├── karma.conf.js             # Configuration tests unitaires - comment exécuter les tests
├── protractor.conf.js        # Configuration tests e2e - tests d'intégration
├── tslint.json              # Règles de linting TypeScript - qualité du code
├── .npmrc                   # Configuration registre npm - où télécharger les packages
├── build.gradle             # Configuration Gradle - build Java/Docker
├── gradle.properties        # Propriétés Gradle - versions et paramètres
├── Dockerfile               # Configuration Docker - comment créer l'image
├── docker-compose.yaml      # Orchestration Docker - environnement de dev
└── Jenkinsfile             # Pipeline CI/CD Jenkins - déploiement automatique
```

**Pourquoi tant de fichiers de config ?**
- Chaque outil a ses propres besoins de configuration
- Séparation dev/prod pour des optimisations différentes
- Intégration dans l'écosystème d'entreprise (Jenkins, Docker, Gradle)

### Code Source Principal

```
src/
├── app/                     # Code source Angular - le cœur de l'application
│   ├── admin/              # Module administration - gestion système
│   │   ├── audit/          # Audit et traçabilité - qui a fait quoi, quand
│   │   ├── batch/          # Gestion des batchs - traitements automatisés nocturnes
│   │   ├── compliance/     # Conformité - respect des réglementations bancaires
│   │   ├── hsm-keys-mngt/  # Gestion clés HSM - sécurité cryptographique matérielle
│   │   ├── locale/         # Localisation - traductions et formats régionaux
│   │   ├── password/       # Gestion mots de passe - politiques de sécurité
│   │   └── ...
│   ├── core/               # Fonctionnalités centrales - socle technique
│   │   ├── layouts/        # Layouts de l'application - structure des pages
│   │   ├── pages/          # Pages principales - login, dashboard, accueil
│   │   └── store/          # Store NgRx - état global de l'application
│   ├── operation/          # Module opérations - travail quotidien des opérateurs
│   │   ├── acquiring/      # Acquiring - gestion des commerçants
│   │   ├── atm/           # ATM - distributeurs automatiques
│   │   ├── fraud/         # Fraude - détection et investigation
│   │   ├── issuing/       # Issuing - émission de cartes
│   │   ├── switch/        # Switch - routage des transactions
│   │   └── xpos/          # xPOS - terminaux de paiement
│   ├── parameters/         # Module paramètres - configuration métier
│   │   ├── acquiring/      # Paramètres acquiring - règles commerçants
│   │   ├── atm/           # Paramètres ATM - configuration distributeurs
│   │   ├── fraud/         # Paramètres fraude - seuils et règles de détection
│   │   ├── issuing/       # Paramètres issuing - règles d'émission cartes
│   │   ├── switch/        # Paramètres switch - routage et limites
│   │   └── xpos/          # Paramètres xPOS - configuration terminaux
│   └── shared/            # Composants partagés - réutilisables partout
│       ├── consts/        # Constantes - valeurs fixes de l'application
│       ├── services/      # Services partagés - logique métier commune
│       ├── types/         # Types TypeScript - définitions de données
│       └── utils/         # Utilitaires - fonctions d'aide
├── assets/                # Ressources statiques - tout ce qui n'est pas du code
│   ├── css/              # Feuilles de style - apparence de l'application
│   ├── images/           # Images - logos, icônes, illustrations
│   ├── i18n/             # Fichiers de traduction - textes multilingues
│   ├── js/               # Scripts JavaScript - fonctions spéciales
│   └── data/             # Données statiques - listes de référence
├── conf/                 # Fichiers de configuration - paramètres runtime
├── environments/         # Configurations d'environnement - dev/prod/test
└── ...
```

**🎯 Logique d'organisation :**

1. **admin/** : Tout ce qui concerne l'administration système
   - Utilisé par les administrateurs IT
   - Fonctions critiques de sécurité et audit

2. **operation/** : Le travail quotidien des opérateurs bancaires
   - Interface principale pour les employés de banque
   - Traitement des transactions et incidents

3. **parameters/** : Configuration métier de la plateforme
   - Utilisé par les gestionnaires métier
   - Définit les règles de fonctionnement

4. **core/** : Infrastructure technique commune
   - Utilisé par tous les autres modules
   - Navigation, authentification, état global

5. **shared/** : Code réutilisable
   - Évite la duplication de code
   - Composants, services, utilitaires communs

### Tests

```
e2e/                        # Tests end-to-end - simulation utilisateur complet
├── pages/                  # Page Objects - représentation des pages pour les tests
│   └── socle/             # Pages du socle - pages communes
├── suites/                # Suites de tests - scénarios organisés par fonctionnalité
│   └── socle/             # Tests du socle - tests des fonctions de base
└── utils.ts               # Utilitaires de test - fonctions d'aide pour les tests

src/assets-test/           # Données de test - jeux de données pour les tests
├── admin/                 # Tests admin - données pour tester l'administration
├── operation/             # Tests opérations - données pour tester les opérations
└── parameters/            # Tests paramètres - données pour tester la configuration
```

**Pourquoi cette organisation des tests ?**
- **Page Objects** : Évite la duplication dans les tests, facilite la maintenance
- **Suites** : Organisation logique par fonctionnalité métier
- **Données de test** : Jeux de données réalistes pour chaque module

### Documentation

```
docs_outils_ia/            # Documentation et outils IA - aide au développement
├── templates/             # Templates de documentation - modèles standardisés
├── ANALYSE-ARCHITECTURE-REPO.md  # Ce fichier - analyse complète du projet
├── AI-WORKSPACE-STRUCTURE.md     # Structure workspace IA - guide pour l'IA
├── README.md              # Documentation principale - guide de démarrage
└── ...
```

**Rôle de la documentation :**
- Guide les nouveaux développeurs
- Explique l'architecture et les choix techniques
- Facilite la maintenance et l'évolution

## 🚀 Installation et Configuration Détaillée

### 🎯 Pourquoi ces Prérequis ?

Cette section explique **pourquoi** chaque outil est nécessaire et **comment** l'installer sans droits administrateur.

### Prérequis Système Expliqués

#### Node.js et npm - Le Runtime JavaScript

**Pourquoi Node.js ?**
- Angular est un framework JavaScript qui a besoin d'un runtime
- Node.js permet d'exécuter JavaScript côté serveur (pour les outils de build)
- npm (Node Package Manager) télécharge et gère les dépendances

**Version spécifique :**
- **Node.js 15.4** (version utilisée dans Docker)
- **npm 6.1.0+** (inclus avec Node.js)

**Installation sans droits admin (Windows) :**
```bash
# 1. Télécharger Node.js portable
# Aller sur https://nodejs.org/dist/v15.4.0/
# Télécharger node-v15.4.0-win-x64.zip

# 2. Extraire dans un dossier utilisateur
# Exemple: C:\Users\[votre_nom]\tools\nodejs

# 3. Ajouter au PATH utilisateur
# Panneau de configuration > Système > Variables d'environnement
# Variables utilisateur > PATH > Ajouter : C:\Users\[votre_nom]\tools\nodejs

# 4. Vérifier l'installation
node --version  # Doit afficher v15.4.0
npm --version   # Doit afficher 6.x.x
```

#### Java - Pour les Outils de Build Gradle

**Pourquoi Java ?**
- Gradle (outil de build) est écrit en Java
- Nécessaire pour les tâches de build Docker et CI/CD
- Intégration avec l'écosystème d'entreprise HPS

**Version requise :**
- **Java 8+** minimum requis pour Gradle
- **Gradle 6.x** (wrapper inclus dans le projet via `gradlew`)

**Installation sans droits admin :**
```bash
# 1. Télécharger OpenJDK portable
# Aller sur https://adoptopenjdk.net/
# Choisir OpenJDK 8 ou 11, format ZIP

# 2. Extraire dans un dossier utilisateur
# Exemple: C:\Users\[votre_nom]\tools\java

# 3. Définir JAVA_HOME
# Variables d'environnement utilisateur
# JAVA_HOME = C:\Users\[votre_nom]\tools\java

# 4. Ajouter au PATH
# PATH += %JAVA_HOME%\bin

# 5. Vérifier
java -version
```

#### Git - Gestion de Version

**Pourquoi Git ?**
- Code source hébergé sur Bitbucket (Git)
- Collaboration en équipe
- Historique des modifications

**Installation sans droits admin :**
```bash
# 1. Télécharger Git portable
# https://git-scm.com/download/win
# Choisir "Portable" version

# 2. Extraire et utiliser
# Pas besoin d'installation, juste extraire et utiliser
```

#### Chrome/Chromium - Pour les Tests

**Pourquoi Chrome ?**
- Tests automatisés avec Protractor
- ChromeDriver pour l'automatisation
- Debugging des applications Angular

**Versions :**
- **Chrome 90+** pour les tests Protractor
- **ChromeDriver** (géré automatiquement par Protractor)

### Configuration du Registre npm Expliquée

**Qu'est-ce qu'un registre npm ?**
Un registre npm est un serveur qui héberge les packages JavaScript. Par défaut, npm utilise le registre public, mais les entreprises utilisent souvent des registres privés.

**Pourquoi un registre privé ?**
- Sécurité : contrôle des packages autorisés
- Performance : cache local des packages
- Packages internes : `@pwc/shared` n'existe que sur le registre HPS

**Configuration actuelle :**
```bash
# Fichier .npmrc dans le projet
registry=https://nexus.pwcv4.com/repository/npm-public/
```

**Configuration manuelle si nécessaire :**
```bash
# Configurer le registre
npm config set registry https://nexus.pwcv4.com/repository/npm-public/

# Si authentification requise (demander les credentials à l'équipe)
npm config set _auth [base64_encoded_credentials]

# Vérifier la configuration
npm config list
```

### Installation des Dépendances Expliquée

**Processus d'installation :**
```bash
# 1. Cloner le repository (avec les bonnes credentials)
git clone ssh://git@bitbucket.hps.int:7999/plut/pwc-ui-socle.git
cd pwc-ui-socle

# 2. Installer les dépendances (peut prendre 5-10 minutes)
npm install

# 3. En cas de problème (conflits de versions)
npm install --force
```

**Que fait `npm install` ?**
1. Lit le fichier `package.json`
2. Télécharge toutes les dépendances listées
3. Les place dans le dossier `node_modules/`
4. Crée un fichier `package-lock.json` (verrous de versions)

**Taille typique :** Le dossier `node_modules` fait environ 500MB-1GB

## 🛠️ Commandes de Développement

### Scripts npm Disponibles

#### Développement
```bash
# Démarrer le serveur de développement
npm start
# Équivalent à : node --max-old-space-size=4096 ./node_modules/webpack-dev-server/bin/webpack-dev-server --config webpack.dev.config.js --port=4200

# Serveur Angular CLI (alternatif)
ng serve
```
**URL :** http://localhost:4200/

#### Build
```bash
# Build de production
npm run build
# Équivalent à : node --max-old-space-size=12288 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js

# Build Angular CLI
ng build --prod
```

#### Tests
```bash
# Tests unitaires
npm test
# Équivalent à : karma start ./karma.conf.js

# Tests unitaires avec Angular CLI
ng test

# Tests end-to-end
npm run e2e
# Équivalent à : protractor ./protractor.conf.js

# Préparer les tests e2e (mise à jour WebDriver)
npm run pree2e
```

#### Linting
```bash
# Vérification du code TypeScript
ng lint
```

### Commandes Gradle

```bash
# Build avec Gradle (Windows)
gradlew.bat build

# Build avec Gradle (Unix/Linux)
./gradlew build

# Build Docker
gradlew.bat docker

# Génération du changelog
gradlew.bat generateGitChangelog
```

### Configuration Docker

#### Build Docker
```bash
# Build de l'image Docker
docker build -t pwc-ui:latest .

# Build avec arguments
docker build \
  --build-arg uiCommitHash=v4.2.4 \
  --build-arg nexusUser=your_user \
  --build-arg nexusPassword=your_password \
  --build-arg nexusRegistry=https://nexus.pwcv4.com/repository/npm-public/ \
  -t pwc-ui:latest .
```

#### Docker Compose (Développement)
```bash
émarrer l'environnement de développement
docker-compose up

# Arrêter l'environnement
docker-compose down
```

## 🔧 Configuration des Environnements

### Fichiers d'Environnement
```
src/environments/
├── environment.ts          # Développement
├── environment.prod.ts     # Production
└── environment.mock.ts     # Tests avec mocks
```

### Configuration de Base (environment.ts)
```typescript
export const environment = {
    production: false,
    name: 'UAT',
    apiUrl: '/rest/',
    webappVersion: '4.2.4',
    ldapAuthentication: false,
    // ... autres configurations
};
```

### Proxy de Développement
Configuration dans `webpack.dev.config.js` :
```javascript
devServer: {
    historyApiFallback: true,
    proxy: {
        "/rest": {
            "target": "http://localhost:8888/",
            "secure": false,
            "changeOrigin": true,
            "pathRewrite": {
                "^/rest": ""
            }
        }
    }
}
```

## 📚 Documentation et Ressources

### Documentation Interne
- **README.md** - Documentation principale du projet
- **docs_outils_ia/** - Documentation et outils IA
  - **AI-WORKSPACE-STRUCTURE.md** - Structure du workspace IA
  - **templates/** - Templates de documentation
  - **MIGRATION-CHECKLIST.md** - Checklist de migration
  - **AUDIT-MASTER-REPORT.md** - Template de rapport d'audit

### Documentation Externe
- **Angular 5 Documentation :** https://v5.angular.io/docs
- **PrimeNG Documentation :** https://www.primefaces.org/primeng/v5/
- **NgRx Documentation :io/
- **Webpack Documentation :** https://webpack.js.org/

### Générateur de Code
```bash
# Générer un écran standard
ng g pwc-screen path --module=MODULE --service=SERVICE --screen=SCREEN --collection=@pwc/generator
```
**Documentation :** https://bitbucket.hps.int/projects/PLUT/repos/pwc-ui-generator/browse

## 🔍 Tests et Qualité

### Tests Unitaires
- **Framework :** Jasmine 2.8.0
- **Runner :** Karma
- **Navigateur :** Chrome Headless
- **Couverture :** Istanbul

**Configuration :**
```javascript
// karma.conf.js
parallelOptions: {
    parrallelThreads: 2,
    executors: 10,
    shardStrategy: 'round-robin'
}
```

### Tests End-to-End
- **Framework :** Protractor 5.1.2
- **Navigateur :** Chrome
- **Timeout :** 600 secondes

**Structure des tests :**
```
e2e/
├── pages/socle/           # Page Objects
├── suites/socle/          # Suites de tests
└── params.js              # Paramètres de test
```

### Linting et Qualité
- **TSLint 5.7.0** - Analyse statique TypeScript
- **HTMLLint 0.7.0** - Validation HTML
- **SonarQube** - Analyse de qualité de code

## 🐳 Déploiement et CI/CD

### Pipeline Jenkins
```groovy
@Library('pwc-cicd@master') _
pwcGradleDockerPipeline() {}
```

### Configuration Docker Production
- **Image de base :** nginx:1.29.3
- **Port :** 80 (nginx)
- **Utilisateur :** 1001 (non-root)
- **Volumes :** /usr/share/nginx/html/

### Variables d'Environnement Docker
```dockerfile
ENV UI_COMMIT_HASH=$uiCommitHash
```

## 🔐 Sécurité

### Authentification
- **LDAP** - Authentification LDAP (configurable)
- **OAuth2** - Authentification OAuth2 (configurable)
- **SAML** - Authentification SAML (configurable)

### Chiffrement
- **Crypto-JS** - Chiffrement côté client
- **Secure-LS** - LocalStorage sécurisé
- **HSM Keys Management** - Gestion des clés HSM

### Sécurité Docker
- **Utilisateur non-root** (1001)
- **Permissions restreintes**
- **Pas de privilèges élevés**

## 🌐 Internationalisation

### Langues Supportées
- **Français (fr_FR)** - Langue par défaut
- **Anglais (en_US)**
- **Espagnol (es_ES)**
- **Grec (el_GR)**

### Fichiers de Traduction
```
src/assets/i18n/
├── fr.json               # Français
├── en.json               # Anglais
└── el.json               # Grec
```

### Configuration i18n
```typescript
defaultLanguages: [
    { label: 'Français', code: 'fr_FR' },
    { label: 'English', code: 'en_US' },
    { label: 'Español', code: 'es_ES' },
    { label: 'Ελληνικά', code: 'el_GR' }
]
```

## 📊 Modules Métier Détaillés

### 🎯 Comprendre l'Écosystème Bancaire

Pour comprendre cette application, il faut d'abord comprendre comment fonctionne le paiement électronique :

1. **Une transaction** commence quand vous payez avec votre carte
2. **Le terminal** (ATM ou TPE) envoie la demande au **Switch**
3. **Le Switch** route vers la **banque émettrice** (votre banque)
4. **La banque** vérifie et autorise (ou refuse)
5. **L'argent** est transféré entre les comptes

Cette application PowerCard gère **tous ces éléments** !

### Administration (admin/) - Le Centre de Contrôle

**Qui l'utilise :** Administrateurs IT, responsables sécurité, auditeurs

#### 🔍 **Audit** (`admin/audit/`)
- **Rôle :** Traçabilité complète de toutes les actions
- **Fonctionnalités :**
  - Qui a fait quoi, quand, depuis où
  - Historique des modifications de paramètres
  - Logs de connexion et déconnexion
  - Rapports d'activité pour la conformité
- **Pourquoi critique :** Exigences réglementaires bancaires, investigation d'incidents

#### 🔄 **Batch** (`admin/batch/`)
- **Rôle :** Traitements automatisés nocturnes
- **Fonctionnalités :**
  - Calcul des commissions quotidiennes
  - Génération des rapports de fin de journée
  - Synchronisation avec les systèmes externes
  - Archivage des données anciennes
- **Timing :** Généralement entre 23h et 6h du matin

#### 📋 **Compliance** (`admin/compliance/`)
- **Rôle :** Respect des réglementations bancaires
- **Fonctionnalités :**
  - Vérification des limites réglementaires
  - Rapports pour les autorités (Banque Centrale)
  - Contrôles anti-blanchiment (AML)
  - Conformité PCI-DSS (sécurité cartes)
- **Enjeu :** Éviter les amendes et sanctions

#### 🔐 **HSM Keys Management** (`admin/hsm-keys-mngt/`)
- **Rôle :** Gestion des clés cryptographiques matérielles
- **Qu'est-ce qu'un HSM :** Hardware Security Module - boîtier sécurisé pour les clés
- **Fonctionnalités :**
  - Génération de clés de chiffrement
  - Rotation périodique des clés
  - Sauvegarde sécurisée
  - Audit des accès aux clés
- **Criticité :** Si compromis, toute la sécurité est en danger

#### 🌍 **Locale** (`admin/locale/`)
- **Rôle :** Adaptation aux différents pays/régions
- **Fonctionnalités :**
  - Formats de dates (DD/MM/YYYY vs MM/DD/YYYY)
  - Devises et taux de change
  - Fuseaux horaires
  - Règles de validation locales
- **Exemple :** Une banque au Maroc vs une banque en France

#### 🔑 **Password** (`admin/password/`)
- **Rôle :** Politique de sécurité des mots de passe
- **Fonctionnalités :**
  - Complexité minimale (8 caractères, majuscules, chiffres)
  - Expiration automatique (ex: tous les 90 jours)
  - Historique (interdire les 5 derniers mots de passe)
  - Tentatives de connexion (blocage après 3 échecs)

### Opérations (operation/) - Le Cœur Métier

**Qui l'utilise :** Opérateurs bancaires, analystes fraude, superviseurs

#### 💳 **Acquiring** (`operation/acquiring/`)
- **Rôle :** Gestion des commerçants qui acceptent les cartes
- **Fonctionnalités :**
  - Inscription de nouveaux commerçants
  - Gestion des terminaux de paiement (TPE)
  - Suivi des transactions commerçants
  - Calcul et versement des commissions
- **Exemple :** Quand Carrefour installe un nouveau TPE

#### 🏧 **ATM** (`operation/atm/`)
- **Rôle :** Gestion des distributeurs automatiques
- **Fonctionnalités :**
  - Surveillance du niveau de billets
  - Gestion des pannes et incidents
  - Configuration des écrans et messages
  - Statistiques d'utilisation
- **Criticité :** Un ATM en panne = clients mécontents

#### 🚨 **Fraud** (`operation/fraud/`)
- **Rôle :** Détection et investigation de la fraude
- **Fonctionnalités :**
  - Alertes automatiques (transactions suspectes)
  - Investigation manuelle des cas
  - Blocage préventif de cartes
  - Rapports de fraude
- **Exemples d'alertes :**
  - 5 retraits en 10 minutes
  - Achat à Paris puis New York en 2h
  - Montant inhabituel pour ce client

#### 🏦 **Issuing** (`operation/issuing/`)
- **Rôle :** Émission et gestion des cartes bancaires
- **Fonctionnalités :**
  - Création de nouvelles cartes
  - Activation/désactivation
  - Renouvellement automatique
  - Gestion des oppositions
- **Cycle de vie :** Demande → Fabrication → Envoi → Activation → Utilisation → Expiration

#### 🔄 **Switch** (`operation/switch/`)
- **Rôle :** Routage et traitement des transactions
- **Fonctionnalités :**
  - Routage intelligent (quelle banque contacter ?)
  - Gestion des timeouts et erreurs
  - Statistiques de performance
  - Monitoring temps réel
- **Analogie :** Comme un central téléphonique pour les paiements

#### 💰 **xPOS** (`operation/xpos/`)
- **Rôle :** Gestion des terminaux de paiement électronique
- **Fonctionnalités :**
  - Configuration des terminaux
  - Mise à jour des logiciels
  - Gestion des clés de sécurité
  - Support technique
- **Types :** TPE fixes, mobiles, sans contact

### Paramètres (parameters/) - La Configuration Métier

**Qui l'utilise :** Gestionnaires métier, responsables produits, risk managers

#### ⚙️ **Rôle Global des Paramètres**
Les paramètres définissent **comment** le système fonctionne :
- Limites de transaction (ex: max 1000€ par jour)
- Règles de validation (ex: PIN obligatoire > 50€)
- Commissions (ex: 0.5% par transaction)
- Seuils d'alerte fraude (ex: > 3 retraits/heure)

#### 🎯 **Paramètres par Module**

**Acquiring Parameters :**
- Commission par type de commerçant
- Limites par terminal
- Règles de settlement (versement)

**ATM Parameters :**
- Limites de retrait par carte
- Messages d'écran personnalisés
- Horaires de fonctionnement

**Fraud Parameters :**
- Seuils de détection automatique
- Règles de scoring de risque
- Listes blanches/noires

**Issuing Parameters :**
- Profils de cartes (Classic, Gold, Platinum)
- Limites par type de carte
- Règles d'autorisation

**Switch Parameters :**
- Routage par BIN (numéro de carte)
- Timeouts de communication
- Règles de fallback

**xPOS Parameters :**
- Configuration par modèle de terminal
- Clés de chiffrement
- Paramètres de communication

## 🔧 Outils de Développement

### Génération de Code
```bash
# Installer le générateur PWC
npm install -g @pwc/generator

# Générer un écran
ng g pwc-screen my-screen --module=admin --service=MyService --screen=MyScreen
```

### Debugging
- **Source Maps** activées en développement
- **Angular DevTools** compatible
- **Redux DevTools** pour NgRx

### Obfuscation (Production)
```bash
# Activer l'obfuscation
docker build --build-arg toBeObfuscated=true -t pwc-ui:obfuscated .
```

## 📈 Performance

### Optimisations Webpack
- **Code Splitting** - Division du code en chunks
- **Tree Shaking** - Élimination du code mort
- **Minification** - UglifyJS pour la production
- **Lazy Loading** - Chargement paresseux des modules

### Optimisations Angular
- **OnPush Change Detection** - Détection de changement optimisée
- **TrackBy Functions** - O listes
- **Async Pipe** - Gestion automatique des observables

### Mémoire
- **--max-old-space-size=4096** - Développement
- **--max-old-space-size=12288** - Build production

## 🚨 Dépannage

### Problèmes Courants

#### Erreur de mémoire lors du build
```bash
# Augmenter la mémoire allouée à Node.js
node --max-old-space-size=16384 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js
```

#### Problèmes de registre npm
```bash
# Vérifier la configuration
npm config list

# Réinitialiser le che
npm cache clean --force

# Réinstaller les dépendances
rm -rf node_modules package-lock.json
npm install
```

#### Erreurs de tests
```bash
# Mettre à jour WebDriver
npm run pree2e

# Tests en mode debug
ng test --watch=false --browsers=Chrome
```

### Logs et Monitoring
- **Console logs** - Niveaux configurables
- **Error tracking** - Gestion centralisée des erreurs
- **Performance monitoring** - Métriques de performance

## 📝 Maintenance

### Mise à jour des Dépendances
```bash
# Vérifier les dépendances obsolètes
npm outdated

# Mettre à jour les dépendances mineures
npm update

# Mettre à jour Angular (avec précaution)
ng update @angular/core @angular/cli
```

### Nettoyage
```bash
# Nettoyer le cache npm
npm cache clean --force

# Nettoyer les builds
rm -rf dist/ node_modules/
npm install
```

---

**Dernière mise à jour :** Janvier 2026  
**Version du document :** 1.0  
**Auteur :** Analyse automatisée du repository PWC UI v4 IA

## 🔧 Flux de Travail Typique

### 👨‍💻 Journée Type d'un Développeur

**Matin - Démarrage :**
```bash
# 1. Récupérer les dernières modifications
git pull origin develop

# 2. Installer les nouvelles dépendances (si package.json a changé)
npm install

# 3. Démarrer le serveur de développement
npm start

# 4. Ouvrir http://localhost:4200 dans le navigateur
```

**Développement :**
```bash
# 5. Créer une nouvelle branche pour la fonctionnalité
git checkout -b feature/nouvelle-fonctionnalite

# 6. Générer un nouveau composant (si nécessaire)
ng generate component admin/nouveau-module

# 7. Développer et tester en continu (hot reload automatique)
```

**Avant de commiter :**
```bash
# 8. Vérifier la qualité du code
ng lint

# 9. Lancer les tests unitaires
npm test

# 10. Tester manuellement les fonctionnalités modifiées
```

**Fin de journée :**
```bash
# 11. Commiter les modifications
git add .
git commit -m "feat: ajout du module de gestion des utilisateurs"

# 12. Pousser vers le serveur
git push origin feature/nouvelle-fonctionnalite

# 13. Créer une Pull Request sur Bitbucket
```

### 🚀 Processus de Déploiement

**1. Développement Local :**
- Code sur sa machine
- Tests unitaires et manuels
- Commit sur une branche feature

**2. Intégration Continue (Jenkins) :**
- Pull Request créée
- Jenkins lance automatiquement :
  - `npm install`
  - `ng lint`
  - `npm test`
  - `npm run build`
  - Tests e2e sur environnement de test

**3. Review et Merge :**
- Review de code par les pairs
- Merge vers la branche develop
- Déploiement automatique sur l'environnement de test

**4. Release :**
- Merge develop vers master
- Build Docker automatique
- Déploiement en production

## 🎯 Cas d'Usage Concrets

### Scénario 1 : Ajouter une Nouvelle Règle de Fraude

**Contexte :** La banque veut bloquer automatiquement les cartes avec plus de 5 retraits en 1 heure.

**Modules concernés :**
1. **Parameters/Fraud** : Définir le nouveau paramètre (seuil = 5, durée = 1h)
2. **Operation/Fraud** : Interface pour voir les alertes générées
3. **Admin/Audit** : Tracer qui a modifié ce paramètre

**Fichiers à modifier :**
```
src/app/parameters/fraud/frd-rule-exception/
├── frd-rule-exception.component.ts    # Interface de configuration
├── frd-rule-exception.service.ts      # Appels API
└── frd-rule-exception.model.ts        # Modèle de données

src/app/operation/fraud/frd-case/
├── frd-case-list.component.ts         # Liste des alertes
└── frd-case-detail.component.ts       # Détail d'une alerte
```

### Scénario 2 : Nouveau Type de Carte (Carte Étudiante)

**Contexte :** Lancer une carte spéciale pour les étudiants avec des limites réduites.

**Modules concernés :**
1. **Parameters/Issuing** : Définir le profil "Étudiant" (limite 500€/jour)
2. **Operation/Issuing** : Interface pour émettre ces cartes
3. **Operation/Switch** : Règles d'autorisation spécifiques

**Impact technique :**
- Nouveau type dans la base de données
- Nouvelles règles de validation
- Interface utilisateur adaptée
- Tests spécifiques

### Scénario 3 : Intégration d'un Nouveau Pays

**Contexte :** La banque s'implante au Sénégal, il faut adapter l'application.

**Modules concernés :**
1. **Admin/Locale** : Ajouter le Sénégal (devise CFA, format dates)
2. **Parameters/General** : Codes pays, réglementations locales
3. **Assets/i18n** : Traductions en français sénégalais si nécessaire

**Adaptations nécessaires :**
- Devise : Franc CFA (XOF)
- Réglementation : BCEAO (Banque Centrale des États de l'Afrique de l'Ouest)
- Formats : Numéros de téléphone, adresses
- Fuseaux horaires : GMT+0

## 🔍 Debugging et Dépannage

### Problèmes Courants et Solutions

#### 1. "Cannot GET /" après `npm start`

**Cause :** Problème de configuration du serveur de développement

**Solution :**
```bash
# Vérifier que le port 4200 n'est pas utilisé
netstat -an | findstr :4200

# Redémarrer avec un port différent
ng serve --port 4201

# Ou nettoyer le cache
npm cache clean --force
rm -rf node_modules
npm install
```

#### 2. Erreurs de compilation TypeScript

**Cause :** Versions incompatibles ou erreurs de syntaxe

**Solution :**
```bash
# Vérifier la version de TypeScript
npx tsc --version

# Recompiler depuis zéro
rm -rf dist/
npm run build

# Vérifier les erreurs avec plus de détails
ng build --verbose
```

#### 3. Tests qui échouent

**Cause :** Environnement de test mal configuré

**Solution :**
```bash
# Mettre à jour ChromeDriver
npm run pree2e

# Lancer les tests en mode debug
ng test --watch=false --browsers=Chrome --code-coverage

# Vérifier les logs détaillés
ng test --verbose
```

#### 4. Problèmes de mémoire lors du build

**Cause :** Application trop volumineuse pour la mémoire allouée

**Solution :**
```bash
# Augmenter la mémoire Node.js
node --max-old-space-size=16384 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js

# Ou modifier le script dans package.json
"build": "node --max-old-space-size=16384 ./node_modules/webpack/bin/webpack --config webpack.prod.config.js"
```

### Outils de Debugging

#### 1. Chrome DevTools
- **F12** dans le navigateur
- **Sources** : Debugging avec breakpoints
- **Network** : Analyser les appels API
- **Console** : Logs et erreurs JavaScript

#### 2. Angular DevTools (Extension Chrome)
- Inspection des composants Angular
- État NgRx en temps réel
- Performance des change detection

#### 3. Redux DevTools (Extension Chrome)
- Historique des actions NgRx
- Time-travel debugging
- État de l'application à tout moment

#### 4. Logs Applicatifs
```typescript
// Dans le code TypeScript
console.log('Debug info:', data);
console.error('Erreur:', error);

// Configuration des niveaux de log (environment.ts)
logLevels: ["log", "error", "warn", "info"]
```

## 📈 Métriques et Monitoring

### Indicateurs de Performance

#### Build Time
- **Développement :** ~30 secondes
- **Production :** ~5-10 minutes
- **Docker :** ~15-20 minutes

#### Taille de l'Application
- **Source :** ~50MB
- **node_modules :** ~500MB-1GB
- **Build prod :** ~10-15MB
- **Image Docker :** ~100MB

#### Tests
- **Tests unitaires :** ~200-500 tests
- **Temps d'exécution :** ~2-5 minutes
- **Couverture cible :** >80%

### Monitoring en Production

#### Métriques Techniques
- Temps de chargement des pages
- Erreurs JavaScript
- Utilisation mémoire navigateur
- Taille des bundles

#### Métriques Métier
- Nombre d'utilisateurs connectés
- Transactions traitées par minute
- Taux d'erreur des opérations
- Temps de réponse des API

## 🎓 Formation et Montée en Compétences

### Pour un Nouveau Développeur

#### Semaine 1 : Découverte
- Comprendre le métier bancaire (paiements électroniques)
- Installation de l'environnement de développement
- Premier build et lancement de l'application
- Navigation dans l'interface utilisateur

#### Semaine 2 : Architecture
- Étude de l'architecture Angular/NgRx
- Compréhension des modules métier
- Lecture du code existant
- Premiers petits correctifs

#### Semaine 3-4 : Développement
- Première fonctionnalité simple
- Tests unitaires
- Review de code avec l'équipe
- Déploiement sur environnement de test

#### Mois 2-3 : Autonomie
- Fonctionnalités plus complexes
- Compréhension des enjeux métier
- Participation aux décisions techniques
- Mentoring d'autres nouveaux

### Ressources d'Apprentissage

#### Documentation Technique
- **Angular 5 :** https://v5.angular.io/docs
- **NgRx 4 :** https://v4.ngrx.io/
- **PrimeNG 5 :** https://www.primefaces.org/primeng/v5/
- **TypeScript :** https://www.typescriptlang.org/docs/

#### Formation Métier
- Fonctionnement des systèmes de paiement
- Réglementations bancaires (PCI-DSS, PSD2)
- Sécurité des transactions
- Détection de fraude

#### Outils de Développement
- Git et workflows de développement
- Docker et conteneurisation
- Jenkins et CI/CD
- Tests automatisés

---

**Dernière mise à jour :** Janvier 2026  
**Version du document :** 2.0  
**Auteur :** Analyse détaillée avec explications métier et techniques