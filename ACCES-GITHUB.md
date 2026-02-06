# Accès au Repository GitHub

## 📍 Repository

**URL**: https://github.com/bigmoletos/migration_angular_dev_kit

## 🔐 Authentification

Le repository est **public** et accessible sans authentification pour la lecture.

Pour les opérations de push/pull, tu dois être authentifié avec GitHub CLI:

```powershell
# Vérifier l'authentification
gh auth status

# Si nécessaire, se connecter
gh auth login
```

## 📥 Cloner le Repository

```bash
# HTTPS (recommandé)
git clone https://github.com/bigmoletos/migration_angular_dev_kit.git

# SSH (si configuré)
git clone git@github.com:bigmoletos/migration_angular_dev_kit.git

# Aller dans le répertoire
cd migration_angular_dev_kit
```

## 📂 Structure du Repository

```
migration_angular_dev_kit/
├── .kiro/                          # Infrastructure Kiro
│   ├── steering/                   # Règles et guides
│   ├── specs/                      # Spécifications par palier
│   ├── agents/                     # Agents personnalisés
│   ├── skills/                     # Compétences techniques
│   ├── hooks/                      # Hooks automatiques
│   └── state/                      # État de migration
├── outils_communs/                 # Scripts et outils
├── scripts_outils_ia/              # Utilitaires PowerShell
├── Documentation/                  # Journal de bord
├── .gitignore                      # Ignore pwc-ui-shared et pwc-ui
├── README.md                       # Documentation principale
├── GITHUB-SETUP-SUMMARY.md         # Résumé de configuration
└── ACCES-GITHUB.md                 # Ce fichier
```

## ⚠️ Important : Repos Bitbucket

Les deux repositories d'application (`pwc-ui-shared` et `pwc-ui`) ne sont **PAS** inclus dans ce repository GitHub.

Ils doivent être clonés séparément depuis Bitbucket:

```bash
# Cloner pwc-ui-shared depuis Bitbucket
git clone <bitbucket-url-pwc-ui-shared> pwc-ui-shared

# Cloner pwc-ui depuis Bitbucket
git clone <bitbucket-url-pwc-ui> pwc-ui
```

## 🚀 Démarrage Rapide

### 1. Cloner ce Repository

```bash
git clone https://github.com/bigmoletos/migration_angular_dev_kit.git
cd migration_angular_dev_kit
```

### 2. Cloner les Repos Bitbucket

```bash
# Dans le répertoire migration_angular_dev_kit
git clone <bitbucket-url> pwc-ui-shared
git clone <bitbucket-url> pwc-ui
```

### 3. Configurer Node.js

```powershell
# Charger le profil PowerShell pour accéder aux fonctions Use-Node*
. $PROFILE

# Basculer vers Node v10 (Angular 5)
Use-Node10

# Vérifier
node --version  # v10.24.1
```

### 4. Lancer les Applications

```powershell
# Terminal 1 : pwc-ui-shared sur port 4201
.\outils_communs\start-pwc-ui-shared-4201.bat

# Terminal 2 : pwc-ui sur port 4200
.\outils_communs\start-pwc-ui.bat
```

### 5. Lancer les Tests Playwright

```powershell
# Tests visuels
.\outils_communs\run-playwright-visual.bat

# Ou directement
cd pwc-ui-shared/pwc-ui-shared-v4-ia
npx playwright test e2e/tests/components-from-inventory.spec.ts --headed
```

## 📝 Commits Actuels

```
2ae092f (HEAD -> main, origin/main) docs: Ajouter résumé de configuration GitHub
0e7007c docs: Ajouter README complet pour le dev kit
9292c9f feat: [v1.0.0] Palier 0 - Infrastructure de migration Angular 5->20 avec Gate Playwright
```

## 🔄 Workflow Git

### Créer une Branche pour une Nouvelle Fonctionnalité

```bash
git checkout -b feature/nom-de-la-feature
# Faire les modifications
git add .
git commit -m "feat: Description de la fonctionnalité"
git push -u origin feature/nom-de-la-feature
```

### Créer une Branche pour un Palier

```bash
git checkout -b palier/01-angular-5-to-6
# Faire les modifications
git add .
git commit -m "feat: [v1.1.0] Palier 1 - Angular 5→6 migration"
git push -u origin palier/01-angular-5-to-6
```

### Fusionner dans Main

```bash
git checkout main
git pull origin main
git merge palier/01-angular-5-to-6
git push origin main
```

## 📊 Vérifier l'État du Repository

```bash
# Voir le statut
git status

# Voir l'historique
git log --oneline -10

# Voir les branches
git branch -a

# Voir les remotes
git remote -v
```

## 🔗 Ressources

- **Repository**: https://github.com/bigmoletos/migration_angular_dev_kit
- **README**: Voir `README.md` pour la documentation complète
- **Setup Summary**: Voir `GITHUB-SETUP-SUMMARY.md` pour les détails de configuration

## 📞 Support

Pour des questions:
1. Consulter le README.md
2. Vérifier les steering files dans `.kiro/steering/`
3. Consulter les specs dans `.kiro/specs/`
4. Vérifier le journal de bord dans `Documentation/JOURNAL-DE-BORD.md`

## ✅ Checklist d'Accès

- [ ] Repository cloné localement
- [ ] Repos Bitbucket clonés dans les sous-répertoires
- [ ] Node.js v10 configuré avec `Use-Node10`
- [ ] Applications lancées sur ports 4201 et 4200
- [ ] Tests Playwright exécutés avec succès
- [ ] Prêt pour commencer Palier 1

---

**Dernière mise à jour**: 2026-02-06  
**Status**: ✅ Repository prêt à l'emploi
