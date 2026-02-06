#!/bin/bash
#
# validate-system.sh
# Valide la cohérence du système Skills/MCP/Agents
#
# Usage: ./scripts_outils_ia/validate-system.sh
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "         VALIDATION DU SYSTÈME KIRO                             "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ============================================================================
# VALIDATION DES INDEX
# ============================================================================
echo -e "${BLUE}📋 Validation des Index${NC}"
echo "────────────────────────────────────────"

# Skills index
if [ -f ".kiro/skills/_index.json" ]; then
    echo -n "  Skills _index.json: "
    
    # Vérifier que chaque skill listé existe
    skills=$(cat .kiro/skills/_index.json | grep '"path"' | sed 's/.*: *"\([^"]*\)".*/\1/')
    all_exist=true
    
    for skill_path in $skills; do
        full_path=".kiro/skills/$skill_path"
        if [ ! -f "$full_path" ]; then
            echo ""
            echo -e "    ${RED}❌ Manquant: $full_path${NC}"
            all_exist=false
            ERRORS=$((ERRORS + 1))
        fi
    done
    
    if $all_exist; then
        echo -e "${GREEN}✅ OK${NC}"
    fi
    
    # Vérifier les skills non indexés
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            if ! grep -q "\"$skill_name\"" .kiro/skills/_index.json 2>/dev/null; then
                echo -e "    ${YELLOW}⚠️  Non indexé: $skill_name${NC}"
                WARNINGS=$((WARNINGS + 1))
            fi
        fi
    done
else
    echo -e "  Skills _index.json: ${RED}❌ MANQUANT${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Agents index
if [ -f ".kiro/agents/_index.json" ]; then
    echo -n "  Agents _index.json: "
    
    agents=$(cat .kiro/agents/_index.json | grep '"file"' | sed 's/.*: *"\([^"]*\)".*/\1/')
    all_exist=true
    
    for agent_file in $agents; do
        full_path=".kiro/agents/$agent_file"
        if [ ! -f "$full_path" ]; then
            echo ""
            echo -e "    ${RED}❌ Manquant: $full_path${NC}"
            all_exist=false
            ERRORS=$((ERRORS + 1))
        fi
    done
    
    if $all_exist; then
        echo -e "${GREEN}✅ OK${NC}"
    fi
else
    echo -e "  Agents _index.json: ${RED}❌ MANQUANT${NC}"
    ERRORS=$((ERRORS + 1))
fi

# ============================================================================
# VALIDATION DES TOKENS
# ============================================================================
echo ""
echo -e "${BLUE}📊 Validation des Estimations de Tokens${NC}"
echo "────────────────────────────────────────"

count_tokens() {
    local file=$1
    if [ -f "$file" ]; then
        local chars=$(wc -c < "$file")
        echo $((chars / 4))
    else
        echo 0
    fi
}

# Vérifier que les estimations sont réalistes
if [ -f ".kiro/skills/_index.json" ]; then
    echo "  Comparaison estimations vs réalité:"
    
    # Pour chaque skill
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            skill_file="${skill_dir}SKILL.md"
            
            if [ -f "$skill_file" ]; then
                # Tokens réels
                real_tokens=$(count_tokens "$skill_file")
                
                # Tokens estimés (depuis l'index)
                estimated=$(grep -A5 "\"$skill_name\"" .kiro/skills/_index.json 2>/dev/null | grep "tokenEstimate" | head -1 | sed 's/.*: *\([0-9]*\).*/\1/' || echo "0")
                
                if [ -n "$estimated" ] && [ "$estimated" != "0" ]; then
                    diff=$((real_tokens - estimated))
                    diff_abs=${diff#-}
                    
                    if [ $diff_abs -gt 2000 ]; then
                        echo -e "    ${YELLOW}⚠️  $skill_name: estimé=$estimated, réel=$real_tokens (écart: $diff)${NC}"
                        WARNINGS=$((WARNINGS + 1))
                    else
                        echo -e "    ${GREEN}✅${NC} $skill_name: estimé=$estimated, réel=$real_tokens"
                    fi
                fi
            fi
        fi
    done
fi

# ============================================================================
# VALIDATION MCP
# ============================================================================
echo ""
echo -e "${BLUE}🔧 Validation Configuration MCP${NC}"
echo "────────────────────────────────────────"

if [ -f ".kiro/mcp/mcp.json" ]; then
    echo -n "  mcp.json: "
    
    # Vérifier la syntaxe JSON
    if python3 -c "import json; json.load(open('.kiro/mcp/mcp.json'))" 2>/dev/null; then
        echo -e "${GREEN}✅ JSON valide${NC}"
    else
        echo -e "${RED}❌ JSON invalide${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Vérifier le profil par défaut
    default_profile=$(cat .kiro/mcp/mcp.json | grep '"defaultProfile"' | sed 's/.*: *"\([^"]*\)".*/\1/')
    if [ -n "$default_profile" ]; then
        if grep -q "\"$default_profile\"" .kiro/mcp/mcp.json; then
            echo -e "  Profil par défaut: ${GREEN}✅ $default_profile${NC}"
        else
            echo -e "  Profil par défaut: ${RED}❌ '$default_profile' non défini${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    fi
else
    echo -e "  mcp.json: ${RED}❌ MANQUANT${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -f ".kiro/mcp/tools-catalog.json" ]; then
    echo -n "  tools-catalog.json: "
    if python3 -c "import json; json.load(open('.kiro/mcp/tools-catalog.json'))" 2>/dev/null; then
        echo -e "${GREEN}✅ JSON valide${NC}"
    else
        echo -e "${RED}❌ JSON invalide${NC}"
        ERRORS=$((ERRORS + 1))
    fi
fi

# ============================================================================
# VALIDATION STRUCTURE PARENT/ENFANTS
# ============================================================================
echo ""
echo -e "${BLUE}📁 Validation Structure Parent/Enfants${NC}"
echo "────────────────────────────────────────"

for child in "pwc-ui-shared-v4-ia" "pwc-ui-v4-ia"; do
    if [ -d "$child/.kiro" ]; then
        echo -n "  $child/.kiro: "
        
        if [ -f "$child/.kiro/AGENTS.md" ]; then
            echo -e "${GREEN}✅ AGENTS.md présent${NC}"
        else
            echo -e "${YELLOW}⚠️  AGENTS.md manquant${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        
        if [ -f "$child/.kiro/config.json" ]; then
            # Vérifier l'héritage
            if grep -q '"parent"' "$child/.kiro/config.json"; then
                echo -e "    └── Config héritage: ${GREEN}✅${NC}"
            else
                echo -e "    └── Config héritage: ${YELLOW}⚠️  Non défini${NC}"
                WARNINGS=$((WARNINGS + 1))
            fi
        fi
    else
        echo -e "  $child/.kiro: ${YELLOW}⚠️  Dossier absent (repo non cloné?)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# ============================================================================
# VALIDATION AGENTS.MD MINIMAL
# ============================================================================
echo ""
echo -e "${BLUE}📏 Validation Taille AGENTS.md${NC}"
echo "────────────────────────────────────────"

if [ -f ".kiro/AGENTS.md" ]; then
    agents_tokens=$(count_tokens ".kiro/AGENTS.md")
    
    if [ $agents_tokens -lt 500 ]; then
        echo -e "  AGENTS.md: ${GREEN}✅ $agents_tokens tokens (< 500)${NC}"
    elif [ $agents_tokens -lt 1000 ]; then
        echo -e "  AGENTS.md: ${YELLOW}⚠️  $agents_tokens tokens (devrait être < 500)${NC}"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "  AGENTS.md: ${RED}❌ $agents_tokens tokens (TROP GROS!)${NC}"
        ERRORS=$((ERRORS + 1))
    fi
fi

# ============================================================================
# RÉSUMÉ
# ============================================================================
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "                         RÉSUMÉ                                 "
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ SYSTÈME VALIDE - Aucun problème détecté${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  SYSTÈME OK avec $WARNINGS avertissement(s)${NC}"
    exit 0
else
    echo -e "${RED}❌ SYSTÈME INVALIDE - $ERRORS erreur(s), $WARNINGS avertissement(s)${NC}"
    echo ""
    echo "Actions recommandées:"
    echo "  1. Corriger les erreurs critiques"
    echo "  2. Régénérer les index si fichiers manquants"
    echo "  3. Mettre à jour les estimations de tokens"
    exit 1
fi
