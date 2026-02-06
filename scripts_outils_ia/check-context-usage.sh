#!/bin/bash
#
# check-context-usage.sh
# Estime l'usage du context window par les fichiers Kiro
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
echo "         ESTIMATION USAGE CONTEXT WINDOW                        "
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Compteur de tokens (approximation : 1 token ≈ 4 caractères)
count_tokens() {
    local file=$1
    if [ -f "$file" ]; then
        local chars=$(wc -c < "$file")
        echo $((chars / 4))
    else
        echo 0
    fi
}

TOTAL=0
CONTEXT_SIZE=200000  # 200K tokens

echo -e "${BLUE}📊 NIVEAU 0 : TOUJOURS CHARGÉ${NC}"
echo "────────────────────────────────────────"

# AGENTS.md
if [ -f ".kiro/AGENTS.md" ]; then
    AGENTS_TOKENS=$(count_tokens ".kiro/AGENTS.md")
    echo "  AGENTS.md              : ~$AGENTS_TOKENS tokens"
    TOTAL=$((TOTAL + AGENTS_TOKENS))
fi

# Index files (metadata only)
echo ""
echo -e "${BLUE}📊 NIVEAU 1 : INDEX (metadata)${NC}"
echo "────────────────────────────────────────"

for index in .kiro/skills/_index.json .kiro/agents/_index.json .kiro/mcp/tools-catalog.json; do
    if [ -f "$index" ]; then
        tokens=$(count_tokens "$index")
        name=$(basename "$index")
        echo "  $name          : ~$tokens tokens"
        TOTAL=$((TOTAL + tokens))
    fi
done

# Steering avec inclusion_mode: always
echo ""
echo -e "${BLUE}📊 STEERING (always loaded)${NC}"
echo "────────────────────────────────────────"

STEERING_TOTAL=0
if [ -d ".kiro/steering" ]; then
    for file in .kiro/steering/*.md; do
        if [ -f "$file" ]; then
            # Check if always mode (simplified check)
            if grep -q "inclusion_mode: always" "$file" 2>/dev/null || [ "$(basename $file)" = "01-always-loaded.md" ]; then
                tokens=$(count_tokens "$file")
                name=$(basename "$file")
                echo "  $name: ~$tokens tokens"
                STEERING_TOTAL=$((STEERING_TOTAL + tokens))
            fi
        fi
    done
fi
if [ $STEERING_TOTAL -eq 0 ]; then
    echo "  (aucun fichier always loaded)"
fi
TOTAL=$((TOTAL + STEERING_TOTAL))

# Skills (lazy loaded - show potential)
echo ""
echo -e "${BLUE}📊 SKILLS (lazy loaded - NON chargés au démarrage)${NC}"
echo "────────────────────────────────────────"

SKILLS_TOTAL=0
if [ -d ".kiro/skills" ]; then
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_file="${skill_dir}SKILL.md"
            if [ -f "$skill_file" ]; then
                tokens=$(count_tokens "$skill_file")
                name=$(basename "$skill_dir")
                echo "  $name: ~$tokens tokens (si chargé)"
                SKILLS_TOTAL=$((SKILLS_TOTAL + tokens))
            fi
        fi
    done
fi
echo "  TOTAL potentiel: ~$SKILLS_TOTAL tokens"

# MCP estimation
echo ""
echo -e "${BLUE}📊 MCP SERVERS (estimation)${NC}"
echo "────────────────────────────────────────"

if [ -f ".kiro/mcp/mcp.json" ]; then
    # Parse les estimations du fichier mcp.json
    echo "  Profil minimal   : ~2000 tokens"
    echo "  Profil migration : ~8000 tokens"
    echo "  Profil full      : ~50000 tokens ⚠️"
fi

# Résumé
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}RÉSUMÉ${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "Chargé au DÉMARRAGE     : ~$TOTAL tokens"
PERCENT=$((TOTAL * 100 / CONTEXT_SIZE))
echo "Pourcentage du context  : ~$PERCENT%"
echo ""
echo "Skills si TOUS chargés  : ~$SKILLS_TOTAL tokens"
SKILLS_PERCENT=$((SKILLS_TOTAL * 100 / CONTEXT_SIZE))
echo "Pourcentage potentiel   : ~$SKILLS_PERCENT%"

echo ""

# Évaluation
if [ $PERCENT -lt 5 ]; then
    echo -e "${GREEN}✅ EXCELLENT - Démarrage très léger ($PERCENT%)${NC}"
elif [ $PERCENT -lt 10 ]; then
    echo -e "${GREEN}✅ BON - Démarrage acceptable ($PERCENT%)${NC}"
elif [ $PERCENT -lt 15 ]; then
    echo -e "${YELLOW}⚠️  ATTENTION - Démarrage un peu lourd ($PERCENT%)${NC}"
else
    echo -e "${RED}🔴 CRITIQUE - Démarrage trop lourd ($PERCENT%)${NC}"
    echo "   Recommandation: Réduire AGENTS.md et les fichiers always-loaded"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Recommandations :"
echo "  • AGENTS.md < 500 tokens"
echo "  • Index < 1000 tokens chacun"
echo "  • Steering always < 2000 tokens total"
echo "  • MCP tools < 12% du context (24K tokens)"
echo "═══════════════════════════════════════════════════════════════"
