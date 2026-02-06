---
inclusion: always
priority: 98
---

# 01 - Vue d'Ensemble du Projet de Migration

## Objectif

Ce document décrit l'architecture globale des deux repositories en cours de migration et leurs interdépendances.

---

## 🏗️ Architecture Multi-Repos

### Vue d'Ensemble

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                         ÉCOSYSTÈME POWERCARD                                  ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                               ║
║   ┌─────────────────────────────────────────────────────────────────────┐     ║
║   │                    pwc-ui-shared-v4-ia                              │     ║
║   │                    (Bibliothèque Partagée)                          │     ║
║   │                                                                     │     ║
║   │   • ~200 composants réutilisables                                   │     ║
║   │   • Services communs (HTTP, Auth, Logger)                           │     ║
║   │   • Directives et Pipes                                             │     ║
║   │   • Entités et modèles de données                                   │     ║
║   │   • Store NgRx partagé                                              │     ║
║   │                                                                     │     ║
║   │   Consommé par : 500+ repositories clients                          │     ║
║   └─────────────────────────────────────────────────────────────────────┘     ║
║                                    │                                          ║
║                                    │ @pwc/shared                              ║
║                                    ▼                                          ║
║   ┌─────────────────────────────────────────────────────────────────────┐     ║
║   │                    pwc-ui-v4-ia                                     │     ║
║   │                    (Application Cliente)                            │     ║
║   │                                                                     │     ║
║   │   • Modules métier spécifiques                                      │     ║
║   │   • Écrans et workflows applicatifs                                 │     ║
║   │   • Configuration spécifique                                        │     ║
║   │                                                                     │     ║
║   │   Dépend de : @pwc/shared (pwc-ui-shared)                           │     ║
║   └─────────────────────────────────────────────────────────────────────┘     ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## 📦 Repo 1 : pwc-ui-shared-v4-ia

### Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Nom** | @pwc/shared |
| **Version actuelle** | 2.6.23-ai |
| **Angular** | 5.2.0 (cible: 20.x) |
| **Rôle** | Bibliothèque de composants |
| **Impact** | 500+ repos dépendants |

### Structure

```
pwc-ui-shared-v4-ia/
├── src/
│   ├── app/                          # App de démo
│   │   └── components/               # ~70 démos
│   │
│   └── lib/shared/                   # BIBLIOTHÈQUE PRINCIPALE
│       ├── abstract/                 # Classes abstraites
│       ├── components/               # ~200 composants
│       ├── directive/                # Directives Angular
│       ├── entity/                   # Modèles de données
│       ├── pipe/                     # Pipes
│       ├── service/                  # Services métier
│       ├── store/                    # NgRx store
│       └── validators/               # Validateurs
│
└── package.json
```

---

## 📦 Repo 2 : pwc-ui-v4-ia

### Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Nom** | pwc-ui |
| **Version actuelle** | 1.0.0-ai |
| **Angular** | 5.2.0 (cible: 20.x) |
| **Rôle** | Application cliente |
| **Dépendance** | @pwc/shared (file:../) |

### Structure

```
pwc-ui-v4-ia/
├── src/
│   └── app/
│       ├── core/                     # Services singleton
│       ├── shared/                   # Composants locaux
│       ├── features/                 # Modules fonctionnels
│       └── app.module.ts
│
└── package.json                      # @pwc/shared: file:../...
```

---

## 🔗 Interdépendances

### Dépendance npm

```json
// pwc-ui-v4-ia/package.json
{
  "dependencies": {
    "@pwc/shared": "file:../pwc-ui-shared-v4-ia"
  }
}
```

### Imports Typiques dans le Client

```typescript
// Import de composants
import { AmountComponent, DateComponent } from '@pwc/shared/components';

// Import de services
import { HttpService, AuthService } from '@pwc/shared/service';

// Import de modèles
import { User, Account } from '@pwc/shared/entity';
```

---

## 🎯 Objectif de la Migration

### État Initial → Final

```
pwc-ui-shared-v4-ia : Angular 5.2.0 → Angular 20.x
pwc-ui-v4-ia        : Angular 5.2.0 → Angular 20.x
```

### Paliers de Migration

```
5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17 → 18 → 19 → 20
```

---

## 📞 Contacts

| Rôle | Responsabilité |
|------|----------------|
| Équipe Shared | Maintenance pwc-ui-shared |
| Équipe Client | Développement applicatif |
| Architecture | Coordination migration |
