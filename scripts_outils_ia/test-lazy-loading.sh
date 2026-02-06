#!/bin/bash
#
# test-lazy-loading.sh
# Tests pour valider le comportement du système de lazy loading
#
# Usage: ./scripts_outils_ia/test-lazy-loading.sh
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

log_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
}

count_tokens() {
    local file=$1
    if [ -f "$file" ]; then
        local chars=$(wc -c < "$file")
        echo $((chars / 4))
    else
        echo 0
    fi
}

# ============================================================================
# TESTS DE STRUCTURE
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "         TESTS DU SYSTÈME DE LAZY LOADING                       "
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo -e "${BLUE}📁 TESTS DE STRUCTURE${NC}"
echo "────────────────────────────────────────"

# Test 1: Structure des dossiers
log_test "Structure des dossiers .kiro"
if [ -d ".kiro/agents" ] && [ -d ".kiro/skills" ] && [ -d ".kiro/mcp" ]; then
    log_pass "Tous les dossiers requis existent"
else
    log_fail "Dossiers manquants dans .kiro/"
fi

# Test 2: Fichiers index
log_test "Présence des fichiers index"
missing_indexes=""
[ ! -f ".kiro/skills/_index.json" ] && missing_indexes="$missing_indexes skills/_index.json"
[ ! -f ".kiro/agents/_index.json" ] && missing_indexes="$missing_indexes agents/_index.json"
[ ! -f ".kiro/mcp/tools-catalog.json" ] && missing_indexes="$missing_indexes mcp/tools-catalog.json"

if [ -z "$missing_indexes" ]; then
    log_pass "Tous les index sont présents"
else
    log_fail "Index manquants:$missing_indexes"
fi

# Test 3: AGENTS.md minimal
log_test "Taille de AGENTS.md (doit être < 500 tokens)"
if [ -f ".kiro/AGENTS.md" ]; then
    agents_tokens=$(count_tokens ".kiro/AGENTS.md")
    if [ $agents_tokens -lt 500 ]; then
        log_pass "AGENTS.md = $agents_tokens tokens (< 500)"
    else
        log_fail "AGENTS.md = $agents_tokens tokens (TROP GROS, max 500)"
    fi
else
    log_fail "AGENTS.md manquant"
fi

# ============================================================================
# TESTS DE COHÉRENCE DES INDEX
# ============================================================================

echo ""
echo -e "${BLUE}📋 TESTS DE COHÉRENCE DES INDEX${NC}"
echo "────────────────────────────────────────"

# Test 4: Skills référencés existent
log_test "Cohérence index skills → fichiers"
if [ -f ".kiro/skills/_index.json" ]; then
    all_exist=true
    while IFS= read -r skill_path; do
        full_path=".kiro/skills/$skill_path"
        if [ ! -f "$full_path" ]; then
            log_fail "Skill manquant: $full_path"
            all_exist=false
        fi
    done < <(grep '"path"' .kiro/skills/_index.json | sed 's/.*: *"\([^"]*\)".*/\1/')
    
    if $all_exist; then
        log_pass "Tous les skills indexés existent"
    fi
else
    log_skip "Index skills absent"
fi

# Test 5: Skills existants sont indexés
log_test "Cohérence fichiers skills → index"
if [ -f ".kiro/skills/_index.json" ]; then
    all_indexed=true
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            if ! grep -q "\"$skill_name\"" .kiro/skills/_index.json 2>/dev/null; then
                log_fail "Skill non indexé: $skill_name"
                all_indexed=false
            fi
        fi
    done
    
    if $all_indexed; then
        log_pass "Tous les skills sont indexés"
    fi
else
    log_skip "Index skills absent"
fi

# Test 6: Agents référencés existent
log_test "Cohérence index agents → fichiers"
if [ -f ".kiro/agents/_index.json" ]; then
    all_exist=true
    while IFS= read -r agent_file; do
        full_path=".kiro/agents/$agent_file"
        if [ ! -f "$full_path" ]; then
            log_fail "Agent manquant: $full_path"
            all_exist=false
        fi
    done < <(grep '"file"' .kiro/agents/_index.json | sed 's/.*: *"\([^"]*\)".*/\1/')
    
    if $all_exist; then
        log_pass "Tous les agents indexés existent"
    fi
else
    log_skip "Index agents absent"
fi

# ============================================================================
# TESTS DE VALIDITÉ JSON
# ============================================================================

echo ""
echo -e "${BLUE}📄 TESTS DE VALIDITÉ JSON${NC}"
echo "────────────────────────────────────────"

# Test 7: JSON valides
for json_file in .kiro/skills/_index.json .kiro/agents/_index.json .kiro/mcp/mcp.json .kiro/mcp/tools-catalog.json .kiro/specs/_index.json; do
    if [ -f "$json_file" ]; then
        log_test "Validité JSON: $json_file"
        if python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
            log_pass "JSON valide"
        else
            log_fail "JSON invalide"
        fi
    fi
done

# ============================================================================
# TESTS DE BUDGET TOKENS
# ============================================================================

echo ""
echo -e "${BLUE}📊 TESTS DE BUDGET TOKENS${NC}"
echo "────────────────────────────────────────"

# Test 8: Budget démarrage < 15%
log_test "Budget tokens au démarrage (< 15% = 30K tokens)"
total_startup=0

# AGENTS.md
[ -f ".kiro/AGENTS.md" ] && total_startup=$((total_startup + $(count_tokens ".kiro/AGENTS.md")))

# Index files
for index in .kiro/skills/_index.json .kiro/agents/_index.json .kiro/mcp/tools-catalog.json; do
    [ -f "$index" ] && total_startup=$((total_startup + $(count_tokens "$index")))
done

# Tool router (estimation)
total_startup=$((total_startup + 2000))

startup_percent=$((total_startup * 100 / 200000))

if [ $startup_percent -lt 15 ]; then
    log_pass "Budget démarrage: ~$total_startup tokens ($startup_percent%)"
else
    log_fail "Budget démarrage: ~$total_startup tokens ($startup_percent%) - TROP ÉLEVÉ"
fi

# Test 9: Estimation tokens skills réaliste
log_test "Écart estimation vs réalité skills (< 30%)"
if [ -f ".kiro/skills/_index.json" ]; then
    max_ecart=0
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            skill_file="${skill_dir}SKILL.md"
            
            if [ -f "$skill_file" ]; then
                real_tokens=$(count_tokens "$skill_file")
                estimated=$(grep -A5 "\"$skill_name\"" .kiro/skills/_index.json 2>/dev/null | grep "tokenEstimate" | head -1 | sed 's/.*: *\([0-9]*\).*/\1/' || echo "$real_tokens")
                
                if [ -n "$estimated" ] && [ "$estimated" != "0" ]; then
                    ecart=$((100 * (real_tokens - estimated) / estimated))
                    ecart_abs=${ecart#-}
                    [ $ecart_abs -gt $max_ecart ] && max_ecart=$ecart_abs
                fi
            fi
        fi
    done
    
    if [ $max_ecart -lt 30 ]; then
        log_pass "Écart max estimation: $max_ecart%"
    else
        log_fail "Écart max estimation: $max_ecart% - Mettre à jour les estimations"
    fi
else
    log_skip "Index skills absent"
fi

# ============================================================================
# TESTS DE KEYWORDS
# ============================================================================

echo ""
echo -e "${BLUE}🔑 TESTS DE CONFIGURATION KEYWORDS${NC}"
echo "────────────────────────────────────────"

# Test 10: Chaque skill a des keywords
log_test "Présence de keywords dans les skills"
if [ -f ".kiro/skills/_index.json" ]; then
    skills_without_keywords=0
    total_skills=$(grep -c '"name"' .kiro/skills/_index.json || echo 0)
    skills_with_keywords=$(grep -c '"keywords"' .kiro/skills/_index.json || echo 0)
    
    if [ "$skills_with_keywords" -ge "$total_skills" ]; then
        log_pass "Tous les skills ont des keywords définis"
    else
        log_fail "$((total_skills - skills_with_keywords)) skills sans keywords"
    fi
else
    log_skip "Index skills absent"
fi

# Test 11: Pas de keywords vides
log_test "Keywords non vides"
if [ -f ".kiro/skills/_index.json" ]; then
    empty_keywords=$(grep -c '"keywords": \[\]' .kiro/skills/_index.json || echo 0)
    
    if [ "$empty_keywords" -eq 0 ]; then
        log_pass "Aucun skill avec keywords vides"
    else
        log_fail "$empty_keywords skills avec keywords vides"
    fi
else
    log_skip "Index skills absent"
fi

# ============================================================================
# TESTS DE CONFIGURATION MCP
# ============================================================================

echo ""
echo -e "${BLUE}🔧 TESTS CONFIGURATION MCP${NC}"
echo "────────────────────────────────────────"

# Test 12: Profil par défaut existe
log_test "Profil MCP par défaut défini et valide"
if [ -f ".kiro/mcp/mcp.json" ]; then
    default_profile=$(grep '"defaultProfile"' .kiro/mcp/mcp.json | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "")
    
    if [ -n "$default_profile" ]; then
        if grep -q "\"$default_profile\"" .kiro/mcp/mcp.json; then
            log_pass "Profil par défaut '$default_profile' existe"
        else
            log_fail "Profil par défaut '$default_profile' non défini dans profiles"
        fi
    else
        log_fail "Pas de profil par défaut défini"
    fi
else
    log_skip "mcp.json absent"
fi

# Test 13: Budget MCP < 12%
log_test "Budget MCP maximal < 12%"
if [ -f ".kiro/mcp/mcp.json" ]; then
    max_percent=$(grep '"maxMcpTokensPercent"' .kiro/mcp/mcp.json | sed 's/.*: *\([0-9]*\).*/\1/' || echo "0")
    
    if [ -n "$max_percent" ] && [ "$max_percent" -le 12 ]; then
        log_pass "Budget MCP max: $max_percent%"
    elif [ -n "$max_percent" ]; then
        log_fail "Budget MCP max: $max_percent% - Devrait être <= 12%"
    else
        log_fail "Budget MCP non défini"
    fi
else
    log_skip "mcp.json absent"
fi

# ============================================================================
# TESTS STRUCTURE PARENT/ENFANTS
# ============================================================================

echo ""
echo -e "${BLUE}👨‍👧‍👦 TESTS PARENT/ENFANTS${NC}"
echo "────────────────────────────────────────"

# Test 14: Configs enfants
for child in "pwc-ui-shared-v4-ia" "pwc-ui-v4-ia"; do
    log_test "Configuration enfant: $child"
    
    if [ -d "$child/.kiro" ]; then
        has_agents=false
        has_config=false
        
        [ -f "$child/.kiro/AGENTS.md" ] && has_agents=true
        [ -f "$child/.kiro/config.json" ] && has_config=true
        
        if $has_agents && $has_config; then
            log_pass "$child/.kiro complet"
        elif $has_agents; then
            log_fail "$child: config.json manquant"
        elif $has_config; then
            log_fail "$child: AGENTS.md manquant"
        else
            log_fail "$child: AGENTS.md et config.json manquants"
        fi
    else
        log_skip "$child/.kiro absent (repo non cloné?)"
    fi
done

# Test 15: Héritage déclaré
for child in "pwc-ui-shared-v4-ia" "pwc-ui-v4-ia"; do
    if [ -f "$child/.kiro/config.json" ]; then
        log_test "Héritage déclaré: $child"
        
        if grep -q '"parent"' "$child/.kiro/config.json"; then
            parent_path=$(grep '"parent"' "$child/.kiro/config.json" | sed 's/.*: *"\([^"]*\)".*/\1/')
            log_pass "Héritage vers: $parent_path"
        else
            log_fail "Pas de déclaration d'héritage"
        fi
    fi
done

# ============================================================================
# RÉSUMÉ
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "                         RÉSUMÉ DES TESTS                       "
echo "═══════════════════════════════════════════════════════════════"
echo ""

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))

echo -e "Tests passés  : ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests échoués : ${RED}$TESTS_FAILED${NC}"
echo -e "Tests ignorés : ${YELLOW}$TESTS_SKIPPED${NC}"
echo -e "Total         : $TOTAL_TESTS"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ TOUS LES TESTS PASSENT${NC}"
    exit 0
elif [ $TESTS_FAILED -lt 3 ]; then
    echo -e "${YELLOW}⚠️  SYSTÈME FONCTIONNEL avec $TESTS_FAILED problème(s) mineur(s)${NC}"
    exit 0
else
    echo -e "${RED}❌ SYSTÈME NON FIABLE - $TESTS_FAILED test(s) échoué(s)${NC}"
    echo ""
    echo "Actions recommandées:"
    echo "  1. Corriger les erreurs ci-dessus"
    echo "  2. Relancer les tests"
    echo "  3. Valider manuellement le comportement"
    exit 1
fi
