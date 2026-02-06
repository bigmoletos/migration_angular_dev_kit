#!/bin/bash
#
# check-sync.sh
# Vérifie que les deux repos sont synchronisés (mêmes versions Angular)
#
# Usage: ./scripts_outils_ia/check-sync.sh
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "🔄 Vérification de la synchronisation des repos..."
echo ""

ERRORS=0

# Fonction pour extraire une version du package.json
get_version() {
    local repo=$1
    local package=$2
    cat "$repo/package.json" 2>/dev/null | grep "\"$package\"" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "N/A"
}

# Repos
LIB="pwc-ui-shared-v4-ia"
CLIENT="pwc-ui-v4-ia"

# Vérifier l'existence des repos
if [ ! -d "$LIB" ]; then
    echo -e "${RED}❌ Repo lib non trouvé : $LIB${NC}"
    exit 1
fi

if [ ! -d "$CLIENT" ]; then
    echo -e "${RED}❌ Repo client non trouvé : $CLIENT${NC}"
    exit 1
fi

# Packages à vérifier
PACKAGES=("@angular/core" "@angular/cli" "rxjs" "typescript" "zone.js")

echo "┌─────────────────────┬───────────────────────┬───────────────────┬──────────┐"
echo "│ Package             │ pwc-ui-shared-v4-ia   │ pwc-ui-v4-ia      │ Status   │"
echo "├─────────────────────┼───────────────────────┼───────────────────┼──────────┤"

for pkg in "${PACKAGES[@]}"; do
    LIB_VER=$(get_version "$LIB" "$pkg")
    CLIENT_VER=$(get_version "$CLIENT" "$pkg")
    
    # Comparer les versions (ignorer les préfixes ^ et ~)
    LIB_VER_CLEAN=$(echo "$LIB_VER" | sed 's/[\^~]//')
    CLIENT_VER_CLEAN=$(echo "$CLIENT_VER" | sed 's/[\^~]//')
    
    if [ "$LIB_VER_CLEAN" == "$CLIENT_VER_CLEAN" ]; then
        STATUS="${GREEN}✅ OK${NC}"
    else
        STATUS="${RED}❌ DIFF${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    printf "│ %-19s │ %-21s │ %-17s │ %b     │\n" "$pkg" "$LIB_VER" "$CLIENT_VER" "$STATUS"
done

echo "└─────────────────────┴───────────────────────┴───────────────────┴──────────┘"

# Vérifier la dépendance @pwc/shared
echo ""
echo "🔗 Dépendance @pwc/shared dans le client :"
SHARED_DEP=$(cat "$CLIENT/package.json" | grep '"@pwc/shared"' | head -1 || echo "Non trouvée")
echo "   $SHARED_DEP"

if [[ "$SHARED_DEP" == *"file:"* ]]; then
    echo -e "   ${GREEN}✅ Mode local (file:) - OK pour dev${NC}"
else
    echo -e "   ${YELLOW}⚠️  Mode Nexus - Attention à la synchronisation${NC}"
fi

# Résultat
echo ""
echo "════════════════════════════════════════════════════════════"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ REPOS SYNCHRONISÉS${NC}"
    echo "   Les deux repos utilisent les mêmes versions."
    exit 0
else
    echo -e "${RED}❌ REPOS DÉSYNCHRONISÉS - $ERRORS différence(s)${NC}"
    echo ""
    echo "   Actions recommandées :"
    echo "   1. Aligner les versions dans pwc-ui-shared-v4-ia EN PREMIER"
    echo "   2. Puis mettre à jour pwc-ui-v4-ia"
    echo "   3. Ne jamais avoir le client en avance sur la lib"
    exit 1
fi
