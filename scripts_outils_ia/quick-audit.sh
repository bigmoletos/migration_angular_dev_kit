#!/bin/bash
#
# quick-audit.sh
# Audit rapide des deux repos pour vérifier leur état
#
# Usage: ./scripts_outils_ia/quick-audit.sh
# À exécuter depuis repo_hps
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
echo "           AUDIT RAPIDE - MIGRATION ANGULAR                     "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ============================================================================
# AUDIT LIB
# ============================================================================
echo -e "${BLUE}📦 pwc-ui-shared-v4-ia (Bibliothèque)${NC}"
echo "────────────────────────────────────────"

if [ -d "pwc-ui-shared-v4-ia" ]; then
    cd pwc-ui-shared-v4-ia
    
    # Version Angular
    ANGULAR=$(cat package.json | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "Angular     : $ANGULAR"
    
    # Version RxJS
    RXJS=$(cat package.json | grep '"rxjs"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "N/A")
    echo "RxJS        : $RXJS"
    
    # Version TypeScript
    TS=$(cat package.json | grep '"typescript"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "N/A")
    echo "TypeScript  : $TS"
    
    # Compteurs
    echo ""
    COMPONENTS=$(find src -name "*.component.ts" 2>/dev/null | wc -l)
    echo "Composants  : $COMPONENTS"
    
    SERVICES=$(find src -name "*.service.ts" 2>/dev/null | wc -l)
    echo "Services    : $SERVICES"
    
    CONSOLE_LOGS=$(grep -r "console.log" src --include="*.ts" 2>/dev/null | wc -l)
    if [ "$CONSOLE_LOGS" -gt 0 ]; then
        echo -e "console.log : ${YELLOW}$CONSOLE_LOGS${NC}"
    else
        echo -e "console.log : ${GREEN}0${NC}"
    fi
    
    # Imports RxJS ancienne syntaxe
    OLD_RXJS=$(grep -r "from 'rxjs/Observable'" src --include="*.ts" 2>/dev/null | wc -l)
    if [ "$OLD_RXJS" -gt 0 ]; then
        echo -e "RxJS old    : ${YELLOW}$OLD_RXJS imports à migrer${NC}"
    else
        echo -e "RxJS old    : ${GREEN}0${NC}"
    fi
    
    cd ..
else
    echo -e "${RED}❌ Repo non trouvé${NC}"
fi

# ============================================================================
# AUDIT CLIENT
# ============================================================================
echo ""
echo -e "${BLUE}📱 pwc-ui-v4-ia (Application)${NC}"
echo "────────────────────────────────────────"

if [ -d "pwc-ui-v4-ia" ]; then
    cd pwc-ui-v4-ia
    
    # Version Angular
    ANGULAR=$(cat package.json | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "Angular     : $ANGULAR"
    
    # Dépendance @pwc/shared
    SHARED=$(cat package.json | grep '"@pwc/shared"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "@pwc/shared : $SHARED"
    
    # Version RxJS
    RXJS=$(cat package.json | grep '"rxjs"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "N/A")
    echo "RxJS        : $RXJS"
    
    # Compteurs
    echo ""
    COMPONENTS=$(find src -name "*.component.ts" 2>/dev/null | wc -l)
    echo "Composants  : $COMPONENTS"
    
    # Imports depuis @pwc/shared
    SHARED_IMPORTS=$(grep -r "from '@pwc/shared'" src --include="*.ts" 2>/dev/null | wc -l)
    echo "Imports lib : $SHARED_IMPORTS"
    
    CONSOLE_LOGS=$(grep -r "console.log" src --include="*.ts" 2>/dev/null | wc -l)
    if [ "$CONSOLE_LOGS" -gt 0 ]; then
        echo -e "console.log : ${YELLOW}$CONSOLE_LOGS${NC}"
    else
        echo -e "console.log : ${GREEN}0${NC}"
    fi
    
    cd ..
else
    echo -e "${RED}❌ Repo non trouvé${NC}"
fi

# ============================================================================
# RÉSUMÉ
# ============================================================================
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "                         RÉSUMÉ                                 "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Vérifier synchronisation
cd pwc-ui-shared-v4-ia 2>/dev/null
LIB_ANGULAR=$(cat package.json | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
cd ..

cd pwc-ui-v4-ia 2>/dev/null
CLIENT_ANGULAR=$(cat package.json | grep '"@angular/core"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
cd ..

if [ "$LIB_ANGULAR" == "$CLIENT_ANGULAR" ]; then
    echo -e "Synchronisation Angular : ${GREEN}✅ OK (v$LIB_ANGULAR)${NC}"
else
    echo -e "Synchronisation Angular : ${RED}❌ DÉSYNCHRONISÉ${NC}"
    echo "  Lib    : $LIB_ANGULAR"
    echo "  Client : $CLIENT_ANGULAR"
fi

echo ""
echo "Résultats enregistrés dans : docs_outils_ia/ETAT-MIGRATION.md"
echo "═══════════════════════════════════════════════════════════════"
