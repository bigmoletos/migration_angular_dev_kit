# Analyse Détaillée du Repository PWC UI Shared V4

## 🎯 Qu'est-ce que ce projet ?

**PWC UI Shared V4** est une **librairie de composants réutilisables** pour des applications web dans le domaine bancaire/financier. Imaginez-la comme une "boîte à outils" contenant des éléments d'interface utilisateur prêts à l'emploi.

### 🏦 Contexte Métier : Powercard
**Powercard** est un système de gestion de cartes bancaires et de paiements électroniques. Cette librairie contient tous les composants visuels (boutons, formulaires, tableaux, etc.) utilisés dans les différentes applications Powercard.

### 🧩 Pourquoi une Librairie Partagée ?
Au lieu que chaque équipe recrée les mêmes composants (un champ de saisie de numéro de carte, un tableau de transactions, etc.), cette librairie centralise tout. Avantages :
- **Cohérence** : Même apparence dans toutes les applications
- **Efficacité** : Pas de duplication de code
- **Maintenance** : Un seul endroit à modifier pour corriger un bug
- **Standards** : Respect des règles bancaires (sécurité, accessibilité)

## 📋 Vue d'ensemble Technique

**Nom du projet** : Powercard UI Shared V4  
**Version** : 2.6.25  
**Type** : Librairie de composants Angular partagés  
**Licence** : MIT  
**Registry** : Nexus privé (https://nexus.pwcv4.com/repository/npm-private/)

### 🎭 Les Deux Visages du Projet
Ce repository contient en fait **deux applications** :

1. **La Librairie** (`src/lib/shared/`) : Les composants réutilisables
2. **L'Application de Démo** (`src/app/`) : Une vitrine qui montre comment utiliser chaque composant

## 🏗️ Architecture et Stack Technique Expliquée

### 🤔 Qu'est-ce qu'Angular ?
**Angular** est un framework JavaScript créé par Google pour construire des applications web. Pensez-y comme à un "kit de construction" qui fournit :
- Des règles pour organiser le code
- Des outils pour créer des interfaces utilisateur
- Des mécanismes pour gérer les données

### 📚 Pourquoi Angular 5.2.0 (Version Ancienne) ?
Cette version date de 2018. Dans le monde bancaire, on utilise souvent des versions stables et éprouvées pour des raisons de :
- **Sécurité** : Versions testées et auditées
- **Stabilité** : Pas de changements inattendus
- **Conformité** : Respect des standards bancaires

### Framework Principal
- **Angular** : Version 5.2.0 (Le "moteur" de l'application)
- **TypeScript** : 2.6.2 (JavaScript "amélioré" avec des types)
- **Node.js** : Version LTS requise (Environnement pour faire tourner les outils)
- **NPM** : Version 5+ (Gestionnaire de packages, comme un "app store" pour développeurs)

### 🧠 Gestion d'État avec NgRx
**Qu'est-ce que la "gestion d'état" ?**
Imaginez une application bancaire qui affiche :
- Le solde du compte
- La liste des transactions
- Les informations du client

L'**état** = toutes ces données à un moment donné. **NgRx** est comme un "coffre-fort centralisé" qui :
- Stocke toutes les données de l'application
- Contrôle qui peut les modifier
- Garde un historique des changements

#### Dépendances NgRx
```json
"@ngrx/effects": "^4.1.1"     // Gère les effets de bord (appels API)
"@ngrx/router-store": "^4.1.1" // Synchronise l'URL avec l'état
"@ngrx/store": "^4.1.1"        // Le "coffre-fort" principal
"@ngrx/store-devtools": "^4.1.1" // Outils de debug
"ngrx-store-localstorage": "^5.0.0" // Sauvegarde locale
```

### 🎨 Composants d'Interface (UI)
```json
"primeng": "^5.2.0"              // Bibliothèque de composants (boutons, tableaux, etc.)
"angular-tree-component": "7.0.2" // Composant arbre (navigation hiérarchique)
"chart.js": "^2.7.2"             // Graphiques et statistiques
"fullpage.js": "^2.9.7"          // Pages plein écran
"jquery": "3.7.1"                // Bibliothèque JavaScript classique
```

**PrimeNG** : C'est comme un "catalogue IKEA" pour interfaces web. Au lieu de construire chaque meuble (composant), on prend des éléments pré-fabriqués.

### 🔐 Sécurité et Cryptographie
```json
"crypto-js": "^3.1.9-1"      // Chiffrement des données sensibles
"jwt-decode": "^2.2.0"       // Décodage des tokens d'authentification
"secure-ls": "1.1.0"         // Stockage sécurisé local
"simple-crypto-js": "^2.0.2" // Chiffrement simplifié
```

**Pourquoi tant de sécurité ?** Dans le bancaire, chaque donnée est sensible. Ces outils chiffrent les informations avant de les stocker ou transmettre.

## 📁 Structure Détaillée du Projet Expliquée

### 🏠 Vue d'Ensemble : Comme une Maison à Plusieurs Étages

```
pwc-ui-shared-v4-ia/
├── 📁 src/                          # 🏠 LA MAISON PRINCIPALE
│   ├── 📁 app/                      # 🎪 SALLE D'EXPOSITION (Application de démo)
│   ├── 📁 lib/shared/               # 🏭 USINE (Librairie de composants)
│   ├── 📁 assets/                   # 📦 ENTREPÔT (Images, CSS, données)
│   └── 📁 environments/             # ⚙️ CONFIGURATIONS (Dev/Prod)
├── 📁 e2e/                          # 🤖 ROBOT TESTEUR (Tests automatiques)
├── 📁 gradle/                       # � OUTILS DE BUILD
├── 📁 docs_outils_ia/               # 📚 MANUEL D'UTILISATION IA
└── 📁 scripts_outils_ia/            # 🛠️ SCRIPTS D'AUTOMATISATION
```

### 🎪 L'Application de Démo (`src/app/`)
**À quoi ça sert ?** C'est comme un "showroom" automobile. Chaque composant de la librairie a sa propre "vitrine" qui montre :
- Comment l'utiliser
- Quelles options sont disponibles
- Des exemples concrets

```
src/app/
├── 📁 components/                   # 60+ VITRINES DE COMPOSANTS
│   ├── 📁 amount/                   # Démo du composant "montant"
│   ├── 📁 bank/                     # Démo du composant "banque"
│   ├── 📁 cardnumber/               # Démo du composant "numéro de carte"
│   └── ... (60+ autres)
├── 📁 core/                         # FONCTIONNALITÉS COMMUNES DE LA DÉMO
├── 📁 entities/                     # OBJETS MÉTIER DE LA DÉMO
├── 📁 service/                      # SERVICES DE LA DÉMO
└── 📁 socle/                        # COMPOSANTS FRAMEWORK DE LA DÉMO
```

**Exemple concret** : Le dossier `src/app/components/amount/` contient :
- `amount-demo.component.html` : La page qui montre le composant montant
- `amount-demo.component.ts` : Le code qui fait fonctionner la démo
- `amount-demo.module.ts` : La configuration du module de démo

### 🏭 La Librairie Principale (`src/lib/shared/`)
**C'est le cœur du projet !** Tous les composants réutilisables sont ici.

```
src/lib/shared/
├── 📁 abstract/                     # 🏗️ FONDATIONS (Classes de base)
├── 📁 components/                   # 🧩 COMPOSANTS RÉUTILISABLES
│   ├── 📁 simple/                   # Composants basiques (bouton, input)
│   ├── 📁 complex/                  # Composants avancés (adresse, montant+devise)
│   ├── 📁 advanced/                 # Composants très avancés (grilles, recherche)
│   ├── 📁 ui/                       # Composants d'interface (navigation, formulaires)
│   └── 📁 specific/                 # Composants métier spécialisés
├── 📁 directive/                    # 🎯 RÈGLES DE COMPORTEMENT
├── 📁 entity/                       # 📋 MODÈLES DE DONNÉES
├── 📁 pipe/                         # 🔄 TRANSFORMATEURS DE DONNÉES
├── 📁 service/                      # 🔧 SERVICES MÉTIER
├── 📁 store/                        # 🏦 GESTION D'ÉTAT (NgRx)
├── 📁 utils/                        # 🛠️ OUTILS UTILITAIRES
└── 📁 validators/                   # ✅ VALIDATEURS DE FORMULAIRES
```

#### 🧩 Les Composants par Catégorie

##### Composants Simples (`simple/`) - Les Briques de Base
- **`form-input/`** : Champ de saisie basique (nom, prénom, etc.)
- **`amount/`** : Champ pour saisir un montant (avec formatage automatique)
- **`date/`** : Sélecteur de date avec calendrier
- **`email/`** : Champ email avec validation automatique
- **`phone/`** : Champ téléphone avec formatage
- **`checkbox/`** : Case à cocher
- **`radiobutton/`** : Bouton radio (choix unique)

**Exemple d'usage** : Au lieu d'écrire 50 lignes de code pour un champ montant avec validation, on écrit : `<pwc-amount [value]="montant"></pwc-amount>`

##### Composants Complexes (`complex/`) - Les Assemblages
- **`address/`** : Formulaire d'adresse complet (rue, ville, code postal, pays)
- **`bank-branch/`** : Sélecteur banque + agence
- **`daterange/`** : Sélection d'une période (du... au...)
- **`cardrange/`** : Plage de numéros de cartes

**Pourquoi "complexe" ?** Ces composants combinent plusieurs éléments simples. L'adresse = rue + ville + code postal + pays + validation.

##### Composants Avancés (`advanced/`) - Les Outils Professionnels
- **`advancedgrid/`** : Tableau avec tri, filtres, pagination, export
- **`editable-datatable/`** : Tableau modifiable en ligne
- **`advancedsearch/`** : Formulaire de recherche multi-critères

**Usage typique** : Afficher 10 000 transactions avec possibilité de trier, filtrer par date, montant, etc.

##### Composants UI (`ui/`) - L'Interface Utilisateur
- **`wizard/`** : Assistant étape par étape (création de compte, etc.)
- **`breadcrumb/`** : Fil d'Ariane (Accueil > Comptes > Détail)
- **`actionbar/`** : Barre d'actions (Nouveau, Modifier, Supprimer)

##### Composants Spécifiques (`specific/`) - Le Métier Bancaire
- **`acq/`** : Composants pour l'**Acquiring** (acceptation des paiements marchands)
- **`iss/`** : Composants pour l'**Issuing** (émission de cartes)
- **`onl/`** : Composants pour l'**Online** (paiements en ligne)
- **`cmpl/`** : Composants pour la **Compliance** (conformité réglementaire)

**Exemple ACQ** : Un marchand veut accepter les cartes Visa. Les composants `acq/` gèrent :
- Les informations du point de vente
- Les tarifs de commission
- Les données réglementaires

### 📦 L'Entrepôt (`src/assets/`)
```
src/assets/
├── 📁 css/                          # 🎨 STYLES VISUELS
│   ├── common.css                   # Styles communs à tout
│   ├── bootstrap.css                # Framework CSS Bootstrap
│   └── componentClasses.css        # Styles spécifiques aux composants
├── 📁 data/                         # 📊 DONNÉES DE TEST
│   ├── auth.json                    # Données d'authentification fictives
│   ├── merchants.json               # Liste de marchands de test
│   └── refs.json                    # Données de référence (pays, devises)
├── 📁 doc/                          # 📚 DOCUMENTATION
│   ├── 📁 components/               # Doc de chaque composant
│   └── 📁 blog/                     # Articles techniques
├── 📁 i18n/                         # 🌍 TRADUCTIONS
│   ├── en.json                      # Textes en anglais
│   └── fr.json                      # Textes en français
└── 📁 images/                       # 🖼️ IMAGES ET ICÔNES
    ├── 📁 common/                   # Icônes communes
    └── 📁 products/                 # Logos des produits
```

**Pourquoi séparer les assets ?** 
- **Performance** : Les images se chargent séparément du code
- **Maintenance** : Facile de changer un logo sans toucher au code
- **Traduction** : Support multilingue (français/anglais)

## 🛠️ Scripts et Commandes Expliqués

### 🤔 Qu'est-ce qu'un "Script NPM" ?
NPM (Node Package Manager) permet de définir des raccourcis pour des commandes complexes. Au lieu de taper une commande de 200 caractères, on tape `npm start`.

### Scripts NPM Disponibles

#### 🚀 Développement
```bash
# Démarrer le serveur de développement
npm start
# ou
ng serve
```
**Ce que ça fait** : Lance un serveur web local sur http://localhost:4200. Quand vous modifiez le code, la page se recharge automatiquement. C'est comme avoir un "aperçu en direct" de vos modifications.

#### 🏗️ Build (Construction)
```bash
# Build de production avec optimisations
npm run build
```
**Traduction de la commande complète** :
```bash
node --max-old-space-size=6144 ./node_modules/@angular/cli/bin/ng build --env=prod --aot=false --sourcemap=false --no-progress --base-href ./
```
**Décryptage** :
- `--max-old-space-size=6144` : Alloue 6GB de mémoire (le projet est gros !)
- `--env=prod` : Utilise la configuration de production
- `--aot=false` : Désactive la compilation "Ahead of Time" (plus rapide)
- `--sourcemap=false` : Pas de fichiers de debug (plus léger)
- `--base-href ./` : Chemin relatif pour les fichiers

**Résultat** : Crée un dossier `dist/` avec tous les fichiers optimisés pour la production.

#### 🧪 Tests
```bash
# Tests unitaires avec couverture
npm test
```
**Ce que ça fait** : Lance tous les tests automatiques et génère un rapport de couverture (quel pourcentage du code est testé).

**Commande complète décryptée** :
```bash
node --max_old_space_size=10192 ./node_modules/@angular/cli/bin/ng test --code-coverage --no-watch --no-progress --no-colors --sm=false --browsers HeadlessChrome
```
- `--max_old_space_size=10192` : 10GB de mémoire pour les tests (encore plus que le build !)
- `--code-coverage` : Calcule la couverture de code
- `--no-watch` : Lance les tests une fois (pas en continu)
- `--browsers HeadlessChrome` : Utilise Chrome sans interface graphique

```bash
# Tests E2E (End-to-End)
npm run e2e
```
**Tests E2E = Tests "de bout en bout"** : Simule un utilisateur réel qui clique, tape, navigue dans l'application. Plus lent mais plus réaliste que les tests unitaires.

#### 🔍 Qualité de Code
```bash
# Linting TypeScript
npm run lint
```
**Le "Linting"** = Vérification automatique du style de code. Comme un correcteur orthographique pour le code :
- Variables non utilisées
- Code mal indenté
- Conventions de nommage non respectées

```bash
# Linting HTML
npm run htmllint
```
**Vérifie le HTML** : Balises fermées, attributs valides, etc.

```bash
# Analyse SonarQube
npm run sonar-scanner
```
**SonarQube** = Outil d'analyse de qualité de code qui détecte :
- Bugs potentiels
- Vulnérabilités de sécurité
- Code dupliqué
- Complexité excessive

#### 📚 Documentation
```bash
# Génération de documentation avec Compodoc
npm run compodoc
```
**Compodoc** = Générateur automatique de documentation. Lit le code TypeScript et crée un site web avec :
- Liste de tous les composants
- Leurs propriétés et méthodes
- Exemples d'utilisation
- Architecture du projet

### 🪟 Scripts Batch Windows

#### `copy-shared.bat` - Le Copieur
```batch
:: Copie la librairie vers un autre projet
del /q "..\pwc\pwc-ui-socle\node_modules\@pwc\shared"
FOR /D %%p IN ("..\pwc\pwc-ui-socle\node_modules\@pwc\shared\*.*") DO rmdir "%%p" /s /q
xcopy /s src\lib\shared\*.* ..\pwc\pwc-ui-socle\node_modules\@pwc\shared
```
**À quoi ça sert ?** Pendant le développement, au lieu de publier la librairie sur NPM à chaque modification, ce script copie directement les fichiers dans un autre projet pour tester.

**Étapes** :
1. Supprime l'ancienne version
2. Copie la nouvelle version
3. L'autre projet peut immédiatement utiliser les modifications

#### `update-doc.bat` - Le Documenteur
```batch
:: Met à jour la documentation des composants
del /q "src\assets\doc\components\"
FOR /D %%p IN ("src\assets\doc\components\*.*") DO rmdir "%%p" /s /q
xcopy /s src\app\components\*.* src\assets\doc\components\
```
**À quoi ça sert ?** Copie les exemples de l'application de démo vers la documentation. Ainsi, la doc reste synchronisée avec les exemples fonctionnels.

## 📚 Documentation Expliquée

### 🤔 Pourquoi Tant de Documentation ?
Dans le monde bancaire, la documentation n'est pas optionnelle. Elle sert à :
- **Conformité réglementaire** : Prouver que le code respecte les normes
- **Maintenance** : Permettre à de nouveaux développeurs de comprendre
- **Audit** : Les auditeurs vérifient que tout est documenté
- **Formation** : Apprendre à utiliser les composants

### 📍 Localisation de la Documentation

#### 📖 Documentation Principale (`src/assets/doc/`)
**C'est la "bibliothèque" du projet** :

```
src/assets/doc/
├── 📊 archi1.png à archi4.png        # SCHÉMAS D'ARCHITECTURE
├── 📁 blog/                          # ARTICLES TECHNIQUES
│   └── catalogv2.md                  # Article sur le système de catalogue
├── 📁 components/                    # DOCUMENTATION PAR COMPOSANT
│   ├── 📁 amount/                    # Doc du composant montant
│   ├── 📁 bank/                      # Doc du composant banque
│   └── ... (60+ dossiers)
├── 📁 ldap/                          # DOCUMENTATION LDAP (authentification)
├── 📁 maker-checker/                 # DOC MAKER-CHECKER (validation à 4 yeux)
└── 📸 screenabstract1.jpg, screenabstract2.jpg  # CAPTURES D'ÉCRAN
```

**Les schémas d'architecture** (`archi1.png` à `archi4.png`) montrent :
- Comment les composants s'assemblent
- Les flux de données
- L'organisation des modules

#### 📋 Documentation par Composant (`src/assets/doc/components/`)
**Chaque composant a son "manuel d'utilisation"** :

```
src/assets/doc/components/amount/
├── README.md                         # Guide d'utilisation
├── examples/                         # Exemples de code
├── api.md                           # Documentation technique
└── screenshots/                     # Captures d'écran
```

**Exemple de contenu** :
- **README.md** : "Le composant Amount permet de saisir des montants avec validation automatique..."
- **api.md** : Liste des propriétés (`@Input`), événements (`@Output`), méthodes
- **examples/** : Code HTML/TypeScript prêt à copier-coller

#### 🔐 Documentation Spécialisée

##### LDAP (`src/assets/doc/ldap/`)
**LDAP** = Lightweight Directory Access Protocol. C'est le système d'authentification d'entreprise.
**Contenu** : Comment configurer l'authentification avec l'Active Directory de l'entreprise.

##### Maker-Checker (`src/assets/doc/maker-checker/`)
**Maker-Checker** = Principe bancaire de "validation à 4 yeux" :
- Le **Maker** crée/modifie une transaction
- Le **Checker** valide avant exécution
**Contenu** : Comment implémenter ce workflow dans les composants.

#### 🤖 Documentation IA/Kiro (`docs_outils_ia/`)
**Kiro** = Assistant IA pour développeurs. Cette documentation explique :
- Comment configurer Kiro pour ce projet
- Les règles de codage à respecter
- Les templates de code à utiliser

```
docs_outils_ia/
├── README.md                        # Guide principal Kiro
├── ANALYSE-ARCHITECTURE-REPO.md     # Analyse automatique du projet
└── deploy-steering.sh               # Script de déploiement des règles
```

### 🏗️ Génération de Documentation

#### 📖 Compodoc (Documentation API Automatique)
**Compodoc** lit le code TypeScript et génère automatiquement :
- Liste de tous les composants avec leurs propriétés
- Diagrammes de dépendances
- Couverture de documentation
- Navigation interactive

```bash
# Installation globale
npm install -g @compodoc/compodoc

# Génération
npm run compodoc
# ou
compodoc -p tsconfig.json -s
```

**Résultat** : Un site web complet dans le dossier `documentation/`

#### 🌐 Accès à la Documentation
- **URL locale** : `http://localhost:8080` (après `compodoc -s`)
- **Fichiers générés** : `documentation/index.html`

**Ce que vous y trouvez** :
- **Overview** : Vue d'ensemble du projet
- **Modules** : Organisation des modules Angular
- **Components** : Liste détaillée de tous les composants
- **Services** : Services disponibles
- **Dependencies** : Graphique des dépendances

### 📝 Types de Documentation

#### 1. Documentation Utilisateur
**Pour qui ?** Les développeurs qui utilisent la librairie
**Contenu** : Comment utiliser chaque composant, exemples, bonnes pratiques

#### 2. Documentation Technique
**Pour qui ?** Les développeurs qui maintiennent la librairie
**Contenu** : Architecture interne, algorithmes, choix techniques

#### 3. Documentation Métier
**Pour qui ?** Les analystes métier, les auditeurs
**Contenu** : Règles bancaires implémentées, conformité réglementaire

#### 4. Documentation de Déploiement
**Pour qui ?** Les équipes d'infrastructure
**Contenu** : Comment installer, configurer, monitorer l'application

## 🧪 Tests Expliqués

### 🤔 Pourquoi Tester ?
Dans le bancaire, un bug peut coûter des millions d'euros. Les tests automatiques :
- **Détectent les bugs** avant la mise en production
- **Garantissent la qualité** du code
- **Facilitent les modifications** (on sait si on casse quelque chose)
- **Respectent la réglementation** (traçabilité des tests)

### 🎭 Les Deux Types de Tests

#### 🔬 Tests Unitaires = Tests au Microscope
**Principe** : Tester chaque composant individuellement, comme tester chaque pièce d'une voiture séparément.

**Exemple concret** :
```typescript
// Test du composant Amount
it('should format 1234.56 as "1 234,56 €"', () => {
  const component = new AmountComponent();
  component.value = 1234.56;
  component.currency = 'EUR';
  expect(component.formattedValue).toBe('1 234,56 €');
});
```

#### 🎪 Tests E2E = Tests de Spectacle Complet
**Principe** : Tester l'application complète comme un utilisateur réel.

**Exemple concret** :
```typescript
// Test E2E : Créer un nouveau compte
it('should create a new account', () => {
  browser.get('/accounts');
  element(by.id('new-account-btn')).click();
  element(by.id('account-name')).sendKeys('Mon Compte Test');
  element(by.id('save-btn')).click();
  expect(element(by.css('.success-message')).getText()).toBe('Compte créé avec succès');
});
```

### ⚙️ Configuration des Tests

#### 🔬 Tests Unitaires (Karma + Jasmine)
**Karma** = Le "chef d'orchestre" qui lance les tests
**Jasmine** = Le "langage" pour écrire les tests

```javascript
// karma.conf.js - Configuration
{
  frameworks: ['parallel', 'jasmine', '@angular/cli'],
  browsers: ['HeadlessChrome'],           // Chrome sans interface
  parallelOptions: {
    executors: 2,                         // 2 tests en parallèle
    shardStrategy: 'round-robin'          // Répartition équilibrée
  }
}
```

**Pourquoi HeadlessChrome ?** Chrome sans interface graphique = plus rapide pour les tests automatiques.

#### 🎪 Tests E2E (Protractor)
**Protractor** = Outil spécialisé pour tester les applications Angular

```javascript
// protractor.conf.js
{
  baseUrl: 'http://localhost:4200/',      // URL de test
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      args: ['--window-size=1700,1000']   // Taille d'écran fixe
    }
  }
}
```

### 📊 Couverture de Code
**Qu'est-ce que c'est ?** Pourcentage du code testé par les tests automatiques.

**Outils** :
- **Istanbul** : Calcule la couverture
- **Rapport HTML** : Interface visuelle dans `dist/coverage/`
- **Format LCOV** : Pour SonarQube

**Métriques** :
- **Lignes** : Pourcentage de lignes de code testées
- **Branches** : Pourcentage de conditions (if/else) testées
- **Fonctions** : Pourcentage de fonctions testées

**Exclusions** (définies dans `.angular-cli.json`) :
```json
"codeCoverage": {
  "exclude": [
    "src/lib/shared/abstract/**/*Screen*",  // Classes abstraites
    "src/lib/shared/entity/**/*",           // Entités (pas de logique)
    "src/lib/shared/mock/**/*",             // Données de test
    "src/lib/shared/test/**/*"              // Utilitaires de test
  ]
}
```

### 🚀 Commandes de Test Détaillées

#### Tests Locaux avec Interface
```bash
# Tests avec interface Chrome (pour débugger)
ng test --browsers=Chrome
```
**Utilisation** : Pendant le développement, pour voir les tests s'exécuter et débugger.

#### Tests CI/CD (Intégration Continue)
```bash
# Tests sans interface (pour Jenkins)
ng test --no-watch
```
**Utilisation** : Dans les pipelines automatiques, plus rapide.

#### Tests E2E
```bash
# Tests de bout en bout
ng e2e
```
**Prérequis** : L'application doit tourner sur `http://localhost:4200/`

### 🔧 Configuration Locale Recommandée
Pour éviter les problèmes sur les machines de développement :

```javascript
// karma.conf.js - Version locale
parallelOptions: {
  executors: 1,                    // 1 seul test à la fois (plus stable)
  shardStrategy: 'round-robin'
},
captureTimeout: 20000,             // 20 secondes max pour démarrer
browserDisconnectTimeout: 3000,   // 3 secondes avant déconnexion
browserNoActivityTimeout: 6000,   // 6 secondes d'inactivité max
```

### 🎯 Stratégie de Tests

#### Tests Unitaires (Rapides)
- **Composants simples** : Validation, formatage, calculs
- **Services** : Logique métier, appels API
- **Pipes** : Transformations de données
- **Utilitaires** : Fonctions pures

#### Tests E2E (Lents mais Réalistes)
- **Workflows complets** : Création de compte, transaction
- **Navigation** : Parcours utilisateur typique
- **Intégrations** : Communication entre composants

#### Tests de Non-Régression
- **Avant chaque release** : Tous les tests passent
- **Avant chaque merge** : Tests impactés passent
- **Nightly builds** : Tests complets chaque nuit

## 🔧 Build et Déploiement Expliqués

### 🤔 Qu'est-ce que le "Build" ?
**Build** = Transformer le code source en application utilisable. C'est comme construire une maison à partir des plans d'architecte.

**Processus** :
1. **Code TypeScript** → **JavaScript** (traduction)
2. **Fichiers séparés** → **Bundles optimisés** (assemblage)
3. **Images/CSS** → **Versions compressées** (optimisation)
4. **Résultat** : Dossier `dist/` prêt pour la production

### ⚙️ Configuration de Build

#### 🏗️ Angular CLI (Le Chef de Chantier)
**Angular CLI** = Outil officiel qui automatise tout le processus de build.

```json
// .angular-cli.json - Plan de construction
{
  "project": { "name": "shared" },
  "apps": [{
    "root": "src",                    // Dossier source
    "outDir": "dist",                 // Dossier de sortie
    "main": "main.ts",                // Point d'entrée principal
    "polyfills": "polyfills.ts",      // Compatibilité navigateurs anciens
    "assets": ["assets", "favicon.ico"] // Fichiers à copier tels quels
  }]
}
```

#### 📝 TypeScript (Le Traducteur)
**TypeScript** = JavaScript avec des types. Le compilateur vérifie les erreurs avant l'exécution.

```json
// tsconfig.json - Règles de traduction
{
  "compilerOptions": {
    "target": "es5",                  // Compatible avec vieux navigateurs
    "moduleResolution": "node",       // Résolution des imports
    "experimentalDecorators": true,   // Support des décorateurs Angular
    "emitDecoratorMetadata": true     // Métadonnées pour l'injection
  }
}
```

**Pourquoi ES5 ?** Standard JavaScript de 2009, compatible avec Internet Explorer (encore utilisé dans certaines banques).

#### 🎨 Styles CSS (L'Architecte d'Intérieur)
**Ordre de chargement** (important pour les priorités CSS) :

```javascript
"styles": [
  "../node_modules/primeng/resources/primeng.min.css",      // 1. Base PrimeNG
  "../node_modules/primeng/resources/themes/omega/theme.css", // 2. Thème
  "../node_modules/font-awesome/css/font-awesome.min.css",   // 3. Icônes
  "./assets/css/common.css",                                 // 4. Styles communs
  "./assets/css/componentClasses.css",                       // 5. Styles composants
  "./assets/css/bootstrap.css",                              // 6. Framework CSS
  // ... autres styles
]
```

**Logique** : Du plus général au plus spécifique. Les derniers styles écrasent les premiers.

### 🏭 Pipeline CI/CD (Chaîne de Production Automatisée)

#### 🤖 Jenkins (Le Contremaître)
**Jenkins** = Serveur d'automatisation qui exécute les tâches répétitives.

```groovy
// Jenkinsfile - Instructions pour Jenkins
pwcKubernetesPipeline(
  toolboxContainerImage: 'pwc-cicd-image:7.3-jdk17',  // Image Docker avec outils
  additionalContainers: [
    containerTemplate(name: 'nodeheadlesschrome'),      // Container pour tests
    containerTemplate(name: 'node')                     // Container pour build
  ]
)
```

**Pourquoi des containers ?** Environnement isolé et reproductible. Même résultat sur toutes les machines.

#### 🔄 Étapes du Pipeline (Chaîne de Montage)

##### 1. **Init** - Préparation de l'Atelier
```bash
# Configuration NPM avec Nexus (registry privé)
nexusAuth=`echo -n "$NEXUS_USER:$NEXUS_PASSWORD" | base64`
echo "registry=$NEXUS_URL/repository/npm-public/" > .npmrc
```
**Nexus** = "Magasin privé" de packages NPM de l'entreprise.

##### 2. **Install** - Approvisionnement des Matériaux
```bash
npm install --unsafe-perm --force
```
- `--unsafe-perm` : Autorise l'exécution en tant que root (containers)
- `--force` : Force l'installation même en cas de conflits

##### 3. **Build** - Construction
```bash
npm run build --unsafe-perm
```
**Résultat** : Dossier `dist/` avec l'application optimisée.

##### 4. **makeVersion** - Numérotation (Branches Spéciales)
```bash
gradle updateAllPackageJsonVersion
```
**Gradle** = Outil de build Java qui gère aussi les versions NPM.
**Quand ?** Seulement sur les branches `makeVersion/*` (préparation de release).

##### 5. **Test** - Contrôle Qualité
```bash
export CHROME_BIN=/usr/bin/google-chrome
npm test
```
**Container spécialisé** avec Chrome headless pour les tests.

##### 6. **Publish** - Mise sur le Marché
```bash
npm publish src/lib/shared --verbose
```
**Quand ?** Seulement pour les tags Git et branches `makeVersion/*`.
**Où ?** Sur le registry Nexus privé de l'entreprise.

### 🏷️ Gestion des Versions avec Gradle

#### 🤔 Pourquoi Gradle dans un Projet NPM ?
**Gradle** = Outil de build Java, mais ici utilisé pour :
- **Synchroniser les versions** entre `package.json` et `src/lib/shared/package.json`
- **Générer le changelog** automatiquement
- **Intégrer avec l'écosystème Java** de l'entreprise

```gradle
// build.gradle - Tâches de versioning
task updateAllPackageJsonVersion {
  doLast {
    updatePackageJsonVersion(new File(project.rootDir, "package.json"))
    updatePackageJsonVersion(new File(project.rootDir, "src/lib/shared/package.json"))
  }
}
```

#### 📝 Génération Automatique du Changelog
```gradle
task generateGitChangelog(type: GitChangelogTask) {
  fromRepo = "$projectDir"
  ignoreCommitsIfMessageMatches = "^\\[Gradle Release Plugin\\].*|^Merge.*"
  file = new File("$projectDir/CHANGELOG.md")
  templateContent = file('changelog.mustache').text
}
```
**Résultat** : Fichier `CHANGELOG.md` généré automatiquement à partir des commits Git.

### 📦 Publication NPM

#### 🏪 Registry Nexus (Magasin Privé)
**Nexus** = Serveur privé qui stocke les packages NPM de l'entreprise.

**Avantages** :
- **Sécurité** : Packages internes non exposés publiquement
- **Contrôle** : Validation avant publication
- **Performance** : Cache local des packages publics
- **Audit** : Traçabilité des téléchargements

#### 🔐 Configuration Automatique
```bash
# Dans Jenkins, configuration automatique
nexusAuth=`echo -n "$NEXUS_USER:$NEXUS_PASSWORD" | base64`
echo "registry=$NEXUS_URL/repository/npm-private/" > .npmrc
echo "_auth=$nexusAuth" >> .npmrc
echo "always-auth=true" >> .npmrc
```

#### 📤 Publication de la Librairie
```bash
# Publication uniquement du dossier shared (pas de l'app de démo)
npm publish src/lib/shared --verbose
```

**Résultat** : Package `@pwc/shared@2.6.25` disponible pour les autres projets.

### 🎯 Stratégie de Déploiement

#### 🌿 Branches et Environnements
- **`develop`** : Développement continu, tests automatiques
- **`makeVersion/*`** : Préparation de release, publication automatique
- **Tags Git** : Versions officielles, déploiement en production

#### 🚀 Processus de Release
1. **Développement** sur `develop`
2. **Création branche** `makeVersion/2.6.26`
3. **Tests complets** + **mise à jour version**
4. **Merge** vers `master`
5. **Tag** `v2.6.26`
6. **Publication** automatique sur Nexus
7. **Déploiement** dans les applications clientes

## 🔍 Analyse SonarQube

### Configuration (`sonar-project.properties`)
```properties
sonar.projectKey=pwc-ui:shared
sonar.projectName=Shared Library
sonar.sources=src/lib/shared/
sonar.exclusions=**/*.spec.ts
sonar.tests=src/lib/shared/
sonar.test.inclusions=**/*.spec.ts
sonar.typescript.lcov.reportPaths=dist/coverage/lcov.info
```

### Métriques Surveillées
- Couverture de code
- Bugs et vulnérabilités
- Code smells
- Duplication de code
- Complexité cyclomatique

## 🌐 Environnements

### Configuration des Environnements

#### Développement (`src/environments/environment.ts`)
```typescript
export const environment = {
  production: false,
  ename: 'UAT',
  apiUrl: 'http://powercardangular.aix.hps.int:9180/v3_31-web/rest/',
  cachedDependencies: ['Country', 'Mcc', 'Currency_table', 'Bank', 'Bank_network', 'Network'],
  cachedBundles: ['Header_menu', 'Dashboard', 'Notification'],
  defaultUserPreferences: { bank: '000001', dt_row_count: '10', language: 'fr_FR' }
};
```

#### Production (`src/environments/environment.prod.ts`)
```typescript
export const environment = {
  production: true,
  name: 'Prod',
  apiUrl: 'http://powercardangular.aix.hps.int:28080/v3_31-web/rest/',
  // ... même structure que dev avec URLs de prod
};
```

## 💻 Installation et Configuration du Poste de Travail Expliquée

### 🤔 Pourquoi Ces Outils Spécifiques ?

#### Node.js - Le Moteur JavaScript
**Node.js** = Environnement qui permet d'exécuter JavaScript en dehors du navigateur.
**Pourquoi nécessaire ?** Angular CLI, les outils de build, et les tests ont besoin de Node.js pour fonctionner.

#### NPM - Le Gestionnaire de Packages
**NPM** = "App Store" pour développeurs. Télécharge et gère les bibliothèques (comme PrimeNG, Angular, etc.).
**Version 5+** requise pour la compatibilité avec les scripts du projet.

### 🏢 Contraintes Entreprise

#### 🔒 Environnement Sans Droits Administrateur
Dans les entreprises, les développeurs n'ont souvent pas les droits admin. Solutions :
- **Versions portables** : Applications qui s'installent dans le dossier utilisateur
- **Configuration utilisateur** : Variables d'environnement PATH personnelles
- **Proxy d'entreprise** : Configuration réseau spécifique

### 🛠️ Prérequis Système Détaillés

#### Node.js et NPM (Installation Sans Admin)
```bash
# Version requise : Node.js LTS (Long Term Support)
# Recommandé : 16.x ou 18.x (versions stables)

# 🪟 Installation Windows sans droits admin :
# 1. Télécharger Node.js portable depuis https://nodejs.org/
# 2. Extraire dans C:\Users\[username]\nodejs
# 3. Ajouter au PATH utilisateur :
#    - Ouvrir "Variables d'environnement utilisateur"
#    - Modifier PATH
#    - Ajouter C:\Users\[username]\nodejs

# Vérification
node --version    # Doit afficher v16.x.x ou v18.x.x
npm --version     # Doit afficher 8.x.x ou plus
```

**Pourquoi LTS ?** Les versions LTS (Long Term Support) sont :
- **Stables** : Moins de bugs
- **Supportées** : Mises à jour de sécurité garanties
- **Compatibles** : Avec les outils d'entreprise

#### Git (Gestion de Version)
```bash
# 🪟 Installation portable Git pour Windows
# 1. Télécharger depuis https://git-scm.com/download/win
# 2. Choisir "Portable" version
# 3. Extraire dans C:\Users\[username]\git
# 4. Ajouter C:\Users\[username]\git\bin au PATH
```

**Git** = Système de contrôle de version. Indispensable pour :
- Récupérer le code source
- Suivre les modifications
- Collaborer avec l'équipe

#### Chrome/Chromium (Tests Automatiques)
```bash
# Requis pour les tests Karma avec HeadlessChrome
# Installation standard ou version portable
# Alternative : Chromium (version open-source)
```

**Pourquoi Chrome ?** Les tests automatiques simulent un navigateur. Chrome headless = Chrome sans interface, plus rapide pour les tests.

### 📥 Installation du Projet

#### 🔄 Clonage et Setup Initial
```bash
# 1. Cloner le repository (récupérer le code)
git clone http://10.1.50.26/powercard/pwc-ui-shared.git
cd pwc-ui-shared

# 2. Configuration NPM pour Nexus (registry privé entreprise)
npm config set registry https://nexus.pwcv4.com/repository/npm-public/
# Alternative : créer un fichier .npmrc local

# 3. Installation des dépendances (télécharger toutes les bibliothèques)
npm install
```

**Qu'est-ce que `npm install` fait ?**
1. Lit le fichier `package.json`
2. Télécharge toutes les dépendances listées
3. Les installe dans le dossier `node_modules/`
4. Crée un fichier `package-lock.json` (verrous de versions)

### 🏢 Configuration Réseau Entreprise

#### 🌐 Proxy NPM (Réseau d'Entreprise)
```bash
# Si l'entreprise utilise un proxy pour Internet
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080

# Certificats d'entreprise (si nécessaire)
npm config set cafile /path/to/certificate.pem
npm config set strict-ssl false  # ⚠️ En dernier recours seulement
```

**Pourquoi un proxy ?** Les entreprises filtrent et contrôlent l'accès Internet pour la sécurité.

#### 🏪 Registry Nexus (Magasin Privé)
```bash
# Configuration registry privé (packages internes)
npm config set registry https://nexus.pwcv4.com/repository/npm-public/
npm config set @pwc:registry https://nexus.pwcv4.com/repository/npm-private/
```

**Explication** :
- **Registry public** : Packages NPM standards (Angular, etc.)
- **Registry privé** : Packages internes à l'entreprise (`@pwc/shared`)

### 🖥️ Configuration IDE (Environnement de Développement)

#### Visual Studio Code (Recommandé)
```json
// .vscode/extensions.json - Extensions recommandées
{
  "recommendations": [
    "angular.ng-template",              // Support templates Angular
    "ms-vscode.vscode-typescript-next", // TypeScript avancé
    "bradlc.vscode-tailwindcss",        // Support CSS
    "esbenp.prettier-vscode",           // Formatage automatique
    "ms-vscode.vscode-json"             // Support JSON
  ]
}
```

**Configuration utilisateur** (`settings.json`) :
```json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.organizeImports": true
  }
}
```

#### WebStorm/IntelliJ (Alternative)
**Plugins nécessaires** :
- **Angular** : Support du framework
- **TypeScript** : Coloration syntaxique et autocomplétion
- **ESLint/TSLint** : Vérification de qualité de code

### 🔧 Outils de Développement

#### Angular CLI (Interface en Ligne de Commande)
```bash
# Installation globale (si droits admin)
npm install -g @angular/cli@1.6.3

# Installation locale (sans droits admin)
npm install @angular/cli@1.6.3
# Utilisation : npx ng ou ./node_modules/.bin/ng
```

**Angular CLI** = Couteau suisse pour Angular :
- Créer des composants : `ng generate component`
- Lancer le serveur : `ng serve`
- Builder l'app : `ng build`
- Lancer les tests : `ng test`

#### Compodoc (Générateur de Documentation)
```bash
# Installation globale
npm install -g @compodoc/compodoc@1.1.1

# Installation locale
npm install @compodoc/compodoc@1.1.1
# Utilisation : npx compodoc
```

#### Outils de Qualité
```bash
# TSLint (vérificateur de code TypeScript)
npm install tslint@5.7.0

# HTMLLint (vérificateur de code HTML)
npm install htmllint-cli@0.0.7

# Prettier (formatage automatique)
npm install prettier@1.16.1
```

### 🚀 Commandes de Démarrage Rapide Expliquées

#### 🏃‍♂️ Développement Local
```bash
# 1. Installation des dépendances
npm install
# ⏱️ Durée : 2-5 minutes selon la connexion

# 2. Démarrage du serveur de développement
npm start
# 🌐 Accès : http://localhost:4200
# ⏱️ Démarrage : 30-60 secondes
# 🔄 Rechargement automatique à chaque modification

# 3. Tests en continu (optionnel)
npm test -- --browsers=Chrome
# 🖥️ Ouvre Chrome avec l'interface de tests
# 🔄 Relance les tests à chaque modification

# 4. Build de développement (optionnel)
ng build
# 📁 Résultat dans dist/ (non optimisé)
```

#### 🧪 Tests et Qualité
```bash
# Tests unitaires complets
npm test
# ⏱️ Durée : 2-5 minutes
# 📊 Génère un rapport de couverture

# Tests E2E (End-to-End)
npm run e2e
# ⚠️ Prérequis : serveur lancé sur localhost:4200
# ⏱️ Durée : 5-10 minutes

# Vérification du code
npm run lint          # TypeScript
npm run htmllint       # HTML
# ⏱️ Durée : 30 secondes chacun

# Génération de documentation
npm run compodoc
# 📚 Crée un site web de documentation
# 🌐 Accès : http://localhost:8080
```

#### 🏗️ Build et Publication
```bash
# Build de production
npm run build
# ⏱️ Durée : 3-5 minutes
# 💾 Utilise 6GB de RAM
# 📁 Résultat optimisé dans dist/

# Publication (nécessite accès Nexus)
npm publish src/lib/shared
# 📤 Publie uniquement la librairie (pas l'app de démo)
# 🔐 Nécessite authentification Nexus
```

### 🎯 Workflow de Développement Typique

#### 🌅 Démarrage de Journée
```bash
# 1. Récupérer les dernières modifications
git pull origin develop

# 2. Installer les nouvelles dépendances (si package.json modifié)
npm install

# 3. Lancer le serveur de développement
npm start
```

#### 💻 Développement
```bash
# 1. Créer une branche pour la fonctionnalité
git checkout -b feature/nouveau-composant

# 2. Développer (serveur en cours d'exécution)
# Modifications automatiquement rechargées

# 3. Tester régulièrement
npm test -- --browsers=Chrome

# 4. Vérifier la qualité
npm run lint
```

#### 📤 Fin de Développement
```bash
# 1. Tests complets
npm test
npm run e2e

# 2. Build de vérification
npm run build

# 3. Commit et push
git add .
git commit -m "feat: nouveau composant XYZ"
git push origin feature/nouveau-composant

# 4. Créer une Pull Request
```

### 🔍 Dépannage Courant

#### ❌ Erreurs d'Installation
```bash
# Erreur : "EACCES: permission denied"
# Solution : Installation locale
npm install --prefix ./local-node-modules

# Erreur : "network timeout"
# Solution : Augmenter le timeout
npm config set timeout 60000

# Erreur : "certificate error"
# Solution : Configuration proxy/certificat
npm config set strict-ssl false
```

#### ❌ Erreurs de Build
```bash
# Erreur : "JavaScript heap out of memory"
# Solution : Augmenter la mémoire
node --max-old-space-size=8192 ./node_modules/.bin/ng build

# Erreur : "Module not found"
# Solution : Réinstaller les dépendances
rm -rf node_modules package-lock.json
npm install
```

#### ❌ Erreurs de Tests
```bash
# Erreur : "Chrome not found"
# Solution : Spécifier le chemin Chrome
export CHROME_BIN=/path/to/chrome
npm test

# Erreur : "Timeout"
# Solution : Augmenter les timeouts dans karma.conf.js
```

## 📊 Métriques et Monitoring

### Couverture de Code Cible
- **Tests unitaires** : > 80%
- **Branches** : > 70%
- **Fonctions** : > 85%

### Performance
- **Build time** : < 5 minutes
- **Test time** : < 10 minutes
- **Bundle size** : Optimisé avec tree-shaking

### Qualité SonarQube
- **Bugs** : 0
- **Vulnerabilities** : 0
- **Code Smells** : < 50
- **Duplication** : < 3%

## 🔗 Liens et Ressources

### Documentation Officielle
- **Angular 5** : https://v5.angular.io/
- **PrimeNG 5** : https://www.primefaces.org/primeng-v5-lts/
- **NgRx 4** : https://v4.ngrx.io/

### Outils de Développement
- **Node.js** : https://nodejs.org/
- **Angular CLI** : https://cli.angular.io/
- **Compodoc** : https://compodoc.app/

### Infrastructure
- **Nexus Repository** : https://nexus.pwcv4.com/
- **SonarQube** : http://powercardangular.aix.hps.int:39000
- **Jenkins** : Pipeline CI/CD intégré

---

*Document généré le 28 janvier 2026 - Version 1.0*

## 🎓 Glossaire des Termes Techniques

### 🅰️ Angular
**Framework JavaScript** créé par Google pour construire des applications web. Fournit une structure et des outils pour organiser le code.

### 🧩 Composant
**Élément réutilisable** d'interface utilisateur. Comme un "widget" qui combine HTML, CSS et logique JavaScript.

### 📦 NPM (Node Package Manager)
**Gestionnaire de packages** pour JavaScript. Comme un "app store" pour développeurs qui télécharge et gère les bibliothèques.

### 🏪 Registry
**Serveur** qui stocke les packages NPM. Nexus est le registry privé de l'entreprise.

### 🔄 CI/CD (Continuous Integration/Continuous Deployment)
**Pipeline automatisé** qui teste, build et déploie le code à chaque modification.

### 🧪 Tests Unitaires
**Tests automatiques** qui vérifient chaque composant individuellement.

### 🎪 Tests E2E (End-to-End)
**Tests automatiques** qui simulent un utilisateur réel naviguant dans l'application.

### 🏗️ Build
**Processus** qui transforme le code source en application utilisable par les navigateurs.

### 🎯 TypeScript
**JavaScript amélioré** avec des types. Détecte les erreurs avant l'exécution.

### 🏦 NgRx
**Bibliothèque** pour gérer l'état de l'application de manière centralisée et prévisible.

---

*Document enrichi avec explications détaillées - Version 2.0*
*Généré le 28 janvier 2026*