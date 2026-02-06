#!/bin/bash
#
# setup-workspace.sh
# Configure le workspace parent pour la coordination multi-repos
#
# Usage: ./setup-workspace.sh
# À exécuter depuis le dossier repo_hps
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "       CONFIGURATION DU WORKSPACE DE COORDINATION               "
echo "           Migration Angular 5 → 20 Multi-Repos                 "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Vérifier que les deux repos existent
echo -e "${BLUE}🔍 Vérification des repos...${NC}"

LIB_REPO="./pwc-ui-shared-v4-ia"
CLIENT_REPO="./pwc-ui-v4-ia"

if [ ! -d "$LIB_REPO" ]; then
    echo -e "${RED}❌ Repo lib non trouvé : $LIB_REPO${NC}"
    echo ""
    echo "Assurez-vous que les deux repos sont clonés dans repo_hps :"
    echo "  repo_hps/"
    echo "  ├── pwc-ui-shared-v4-ia/"
    echo "  └── pwc-ui-v4-ia/"
    exit 1
fi
echo -e "${GREEN}✅ Repo lib trouvé : pwc-ui-shared-v4-ia${NC}"

if [ ! -d "$CLIENT_REPO" ]; then
    echo -e "${RED}❌ Repo client non trouvé : $CLIENT_REPO${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Repo client trouvé : pwc-ui-v4-ia${NC}"

# Vérifier les versions Angular
echo ""
echo -e "${BLUE}📊 Vérification des versions...${NC}"

LIB_ANGULAR=$(cat "$LIB_REPO/package.json" 2>/dev/null | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Non trouvé")
CLIENT_ANGULAR=$(cat "$CLIENT_REPO/package.json" 2>/dev/null | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Non trouvé")

echo "  pwc-ui-shared-v4-ia : Angular $LIB_ANGULAR"
echo "  pwc-ui-v4-ia        : Angular $CLIENT_ANGULAR"

if [ "$LIB_ANGULAR" != "$CLIENT_ANGULAR" ]; then
    echo -e "${YELLOW}⚠️  Les versions Angular sont différentes !${NC}"
else
    echo -e "${GREEN}✅ Versions Angular synchronisées${NC}"
fi

# Vérifier la dépendance @pwc/shared
echo ""
echo -e "${BLUE}🔗 Vérification de la dépendance @pwc/shared...${NC}"

SHARED_DEP=$(cat "$CLIENT_REPO/package.json" 2>/dev/null | grep '"@pwc/shared"' | head -1 || echo "")

if [[ "$SHARED_DEP" == *"file:"* ]]; then
    echo -e "${GREEN}✅ Dépendance @pwc/shared en mode local (file:)${NC}"
    echo "  $SHARED_DEP"
else
    echo -e "${YELLOW}⚠️  Dépendance @pwc/shared NON locale${NC}"
    echo "  $SHARED_DEP"
    echo ""
    echo "  Pour utiliser le fork local, modifiez package.json :"
    echo '  "@pwc/shared": "file:../pwc-ui-shared-v4-ia"'
fi

# Vérifier la structure .kiro
echo ""
echo -e "${BLUE}📁 Vérification de la structure .kiro...${NC}"

check_kiro() {
    local repo=$1
    local name=$2
    
    if [ -d "$repo/.kiro" ]; then
        echo -e "${GREEN}✅ $name/.kiro présent${NC}"
        
        if [ -f "$repo/.kiro/AGENTS.md" ]; then
            echo "     ├── AGENTS.md ✅"
        else
            echo -e "     ├── AGENTS.md ${YELLOW}⚠️  manquant${NC}"
        fi
        
        if [ -d "$repo/.kiro/steering" ]; then
            local count=$(ls -1 "$repo/.kiro/steering"/*.md 2>/dev/null | wc -l)
            echo "     ├── steering/ ($count fichiers)"
        fi
        
        if [ -d "$repo/.kiro/specs" ]; then
            local count=$(ls -1 "$repo/.kiro/specs"/*.md 2>/dev/null | wc -l)
            echo "     └── specs/ ($count fichiers)"
        fi
    else
        echo -e "${RED}❌ $name/.kiro manquant${NC}"
    fi
}

check_kiro "." "repo_hps (workspace)"
check_kiro "$LIB_REPO" "pwc-ui-shared-v4-ia"
check_kiro "$CLIENT_REPO" "pwc-ui-v4-ia"

# Résumé
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}Configuration du workspace terminée !${NC}"
echo ""
echo "Prochaines étapes :"
echo "  1. Ouvrir repo_hps dans Kiro IDE"
echo "  2. Exécuter: .kiro/specs/01-audit-global.md"
echo "  3. Suivre le workflow de coordination"
echo "═══════════════════════════════════════════════════════════════"
