#!/bin/bash
#
# test-keyword-matching.sh
# Simule le matching des keywords pour valider la configuration
#
# Usage: ./scripts_outils_ia/test-keyword-matching.sh "votre prompt"
#    ou: ./scripts_outils_ia/test-keyword-matching.sh --all (lance tous les tests)
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

INDEX_FILE=".kiro/skills/_index.json"
INDEX_V2_FILE=".kiro/skills/_index.v2.json"

# Utiliser v2 si disponible
if [ -f "$INDEX_V2_FILE" ]; then
    INDEX_FILE="$INDEX_V2_FILE"
    echo -e "${CYAN}Utilisation de l'index v2 (matching amélioré)${NC}"
fi

# ============================================================================
# FONCTIONS DE MATCHING
# ============================================================================

match_skill_v1() {
    local prompt="$1"
    local skill_name="$2"
    local keywords="$3"
    
    prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')
    matches=0
    
    # Compter les matches
    for kw in $keywords; do
        kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
        if echo "$prompt_lower" | grep -q "$kw_lower"; then
            matches=$((matches + 1))
        fi
    done
    
    echo $matches
}

match_skill_v2() {
    local prompt="$1"
    local skill_json="$2"
    
    prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')
    score=0
    
    # Extraire les keywords requis
    required=$(echo "$skill_json" | grep -o '"requiredKeywords":\s*\[[^]]*\]' | grep -o '\["[^"]*"' | tr -d '[]"' || echo "")
    optional=$(echo "$skill_json" | grep -o '"optionalKeywords":\s*\[[^]]*\]' | grep -o '"[^"]*"' | tr -d '"' || echo "")
    exclude=$(echo "$skill_json" | grep -o '"excludeKeywords":\s*\[[^]]*\]' | grep -o '"[^"]*"' | tr -d '"' || echo "")
    
    # Vérifier les exclusions d'abord
    for excl in $exclude; do
        excl_lower=$(echo "$excl" | tr '[:upper:]' '[:lower:]')
        if echo "$prompt_lower" | grep -qi "$excl_lower"; then
            echo "-1"  # Exclusion trouvée
            return
        fi
    done
    
    # Vérifier les required (tous doivent matcher)
    if [ -n "$required" ]; then
        for req in $required; do
            req_lower=$(echo "$req" | tr '[:upper:]' '[:lower:]')
            if ! echo "$prompt_lower" | grep -qi "$req_lower"; then
                echo "0"  # Required manquant
                return
            fi
        done
        score=$((score + 50))  # Bonus pour required
    fi
    
    # Compter les optional
    for opt in $optional; do
        opt_lower=$(echo "$opt" | tr '[:upper:]' '[:lower:]')
        if echo "$prompt_lower" | grep -qi "$opt_lower"; then
            score=$((score + 10))
        fi
    done
    
    echo $score
}

# ============================================================================
# TEST D'UN PROMPT UNIQUE
# ============================================================================

test_single_prompt() {
    local prompt="$1"
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "TEST DE MATCHING"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${CYAN}Prompt:${NC} \"$prompt\""
    echo ""
    echo "Résultats:"
    echo "────────────────────────────────────────"
    
    best_skill=""
    best_score=0
    
    # Parser chaque skill (simplifié)
    if [ -f "$INDEX_FILE" ]; then
        # Extraire les noms de skills
        skills=$(grep '"name"' "$INDEX_FILE" | sed 's/.*: *"\([^"]*\)".*/\1/')
        
        for skill in $skills; do
            # Extraire les keywords pour ce skill
            keywords=$(grep -A20 "\"$skill\"" "$INDEX_FILE" | grep -A5 '"keywords"' | grep -o '"[^"]*"' | tr -d '"' | tr '\n' ' ' || echo "")
            
            if [ -n "$keywords" ]; then
                # Matching simple (v1)
                matches=$(match_skill_v1 "$prompt" "$skill" "$keywords")
                
                # Calculer le score
                total_kw=$(echo "$keywords" | wc -w)
                if [ $total_kw -gt 0 ]; then
                    score=$((matches * 100 / total_kw))
                else
                    score=0
                fi
                
                # Afficher le résultat
                if [ $matches -gt 0 ]; then
                    echo -e "  ${GREEN}●${NC} $skill: $matches matches ($score%)"
                    
                    if [ $score -gt $best_score ]; then
                        best_score=$score
                        best_skill=$skill
                    fi
                else
                    echo -e "  ${RED}○${NC} $skill: pas de match"
                fi
            fi
        done
    fi
    
    echo ""
    echo "────────────────────────────────────────"
    
    if [ -n "$best_skill" ]; then
        echo -e "${GREEN}➜ Skill sélectionné: $best_skill (score: $best_score%)${NC}"
    else
        echo -e "${YELLOW}➜ Aucun skill ne matche - demander clarification${NC}"
    fi
    
    echo ""
}

# ============================================================================
# TESTS AUTOMATISÉS
# ============================================================================

run_all_tests() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "         TESTS AUTOMATISÉS DE MATCHING                          "
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    PASS=0
    FAIL=0
    
    # Tests pour angular-migration
    echo -e "${BLUE}📦 Tests: angular-migration${NC}"
    echo "────────────────────────────────────────"
    
    # Devrait matcher
    test_expect_match "Migre le projet vers Angular 6" "angular-migration"
    test_expect_match "Je veux faire un ng update" "angular-migration"
    test_expect_match "Comment upgrader Angular ?" "angular-migration"
    test_expect_match "Migration Angular 5 vers 8" "angular-migration"
    
    # Ne devrait PAS matcher
    test_expect_no_match "Migrer les données SQL" "angular-migration"
    test_expect_no_match "Angular c'est bien" "angular-migration"
    test_expect_no_match "J'ai migré hier" "angular-migration"
    
    echo ""
    
    # Tests pour code-audit
    echo -e "${BLUE}📦 Tests: code-audit${NC}"
    echo "────────────────────────────────────────"
    
    test_expect_match "Fais un audit du code" "code-audit"
    test_expect_match "Analyse la qualité" "code-audit"
    test_expect_match "Review de sécurité" "code-audit"
    
    test_expect_no_match "Audit financier" "code-audit"
    
    echo ""
    
    # Tests pour rxjs-patterns
    echo -e "${BLUE}📦 Tests: rxjs-patterns${NC}"
    echo "────────────────────────────────────────"
    
    test_expect_match "Comment utiliser les pipes RxJS ?" "rxjs-patterns"
    test_expect_match "Pattern pour les observables RxJS" "rxjs-patterns"
    
    test_expect_no_match "Pipe Unix" "rxjs-patterns"
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo -e "Résultats: ${GREEN}$PASS passés${NC}, ${RED}$FAIL échoués${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    
    if [ $FAIL -gt 0 ]; then
        exit 1
    fi
}

test_expect_match() {
    local prompt="$1"
    local expected_skill="$2"
    
    # Simuler le matching
    if [ -f "$INDEX_FILE" ]; then
        keywords=$(grep -A20 "\"$expected_skill\"" "$INDEX_FILE" | grep -A5 '"keywords"' | grep -o '"[^"]*"' | tr -d '"' | tr '\n' ' ' || echo "")
        matches=$(match_skill_v1 "$prompt" "$expected_skill" "$keywords")
        
        if [ $matches -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} \"$prompt\" → $expected_skill"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}✗${NC} \"$prompt\" → DEVRAIT matcher $expected_skill"
            FAIL=$((FAIL + 1))
        fi
    fi
}

test_expect_no_match() {
    local prompt="$1"
    local skill="$2"
    
    if [ -f "$INDEX_FILE" ]; then
        keywords=$(grep -A20 "\"$skill\"" "$INDEX_FILE" | grep -A5 '"keywords"' | grep -o '"[^"]*"' | tr -d '"' | tr '\n' ' ' || echo "")
        matches=$(match_skill_v1 "$prompt" "$skill" "$keywords")
        
        if [ $matches -eq 0 ]; then
            echo -e "  ${GREEN}✓${NC} \"$prompt\" → ne matche pas $skill (correct)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}✗${NC} \"$prompt\" → MATCHE $skill (faux positif!)"
            FAIL=$((FAIL + 1))
        fi
    fi
}

# ============================================================================
# MAIN
# ============================================================================

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  $0 \"votre prompt\"     - Teste un prompt"
    echo "  $0 --all               - Lance tous les tests"
    exit 1
fi

if [ "$1" = "--all" ]; then
    run_all_tests
else
    test_single_prompt "$*"
fi
