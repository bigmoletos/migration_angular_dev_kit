#!/bin/bash
#
# generate-indexes.sh
# Génère automatiquement les fichiers _index.json à partir des fichiers existants
#
# Usage: ./scripts_outils_ia/generate-indexes.sh [--dry-run]
#

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "         GÉNÉRATION AUTOMATIQUE DES INDEX                       "
echo "═══════════════════════════════════════════════════════════════"
echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}Mode dry-run - aucune modification ne sera effectuée${NC}"
    echo ""
fi

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

count_tokens() {
    local file=$1
    if [ -f "$file" ]; then
        local chars=$(wc -c < "$file")
        echo $((chars / 4))
    else
        echo 0
    fi
}

extract_frontmatter() {
    local file=$1
    local field=$2
    
    # Extraire le frontmatter YAML
    if head -1 "$file" | grep -q "^---"; then
        # Trouver la fin du frontmatter
        awk '/^---$/{if(f)exit;f=1;next}f' "$file" | grep "^$field:" | sed "s/$field: *//" | tr -d '"' || echo ""
    else
        echo ""
    fi
}

# ============================================================================
# GÉNÉRATION INDEX SKILLS
# ============================================================================

generate_skills_index() {
    echo -e "${BLUE}📋 Génération index Skills${NC}"
    echo "────────────────────────────────────────"
    
    local output=".kiro/skills/_index.generated.json"
    local skills_found=0
    local total_tokens=0
    
    # Début du JSON
    cat > /tmp/skills_index.json << 'EOF'
{
  "version": "1.0",
  "description": "Index des skills - GÉNÉRÉ AUTOMATIQUEMENT",
  "lastUpdated": "TIMESTAMP",
  
  "loadingStrategy": {
    "mode": "lazy",
    "maxSimultaneous": 2,
    "unloadAfterMessages": 5
  },
  
  "skills": [
EOF
    
    # Remplacer le timestamp
    sed -i "s/TIMESTAMP/$(date -Iseconds)/" /tmp/skills_index.json
    
    first=true
    
    # Scanner tous les skills
    for skill_dir in .kiro/skills/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            skill_file="${skill_dir}SKILL.md"
            
            if [ -f "$skill_file" ]; then
                echo "  Trouvé: $skill_name"
                
                # Extraire les infos du frontmatter
                name=$(extract_frontmatter "$skill_file" "name")
                [ -z "$name" ] && name="$skill_name"
                
                description=$(extract_frontmatter "$skill_file" "description")
                [ -z "$description" ] && description="Skill $skill_name"
                
                priority=$(extract_frontmatter "$skill_file" "priority")
                [ -z "$priority" ] && priority="medium"
                
                # Calculer les tokens réels
                tokens=$(count_tokens "$skill_file")
                total_tokens=$((total_tokens + tokens))
                
                # Extraire les keywords (depuis loadOn.keywords si disponible)
                keywords=$(awk '/^  keywords:$/,/^  [a-z]/' "$skill_file" 2>/dev/null | grep "^    - " | sed 's/^    - //' | tr '\n' ',' | sed 's/,$//' || echo "")
                [ -z "$keywords" ] && keywords="$skill_name"
                
                # Formater en JSON
                if ! $first; then
                    echo "," >> /tmp/skills_index.json
                fi
                first=false
                
                cat >> /tmp/skills_index.json << EOF
    {
      "name": "$name",
      "path": "$skill_name/SKILL.md",
      "description": "$description",
      "keywords": [$(echo "$keywords" | sed 's/\([^,]*\)/"\1"/g')],
      "tokenEstimate": $tokens,
      "priority": "$priority"
    }
EOF
                
                skills_found=$((skills_found + 1))
            fi
        fi
    done
    
    # Fin du JSON
    cat >> /tmp/skills_index.json << EOF

  ],
  
  "statistics": {
    "totalSkills": $skills_found,
    "totalTokensIfAllLoaded": $total_tokens,
    "recommendedMaxLoaded": 2,
    "contextBudgetPercent": $(echo "scale=1; $total_tokens * 100 / 200000" | bc)
  }
}
EOF
    
    echo ""
    echo "  Skills trouvés: $skills_found"
    echo "  Tokens totaux: $total_tokens"
    
    if $DRY_RUN; then
        echo ""
        echo -e "${YELLOW}[DRY-RUN] Fichier qui serait généré:${NC}"
        cat /tmp/skills_index.json
    else
        # Valider le JSON
        if python3 -c "import json; json.load(open('/tmp/skills_index.json'))" 2>/dev/null; then
            mv /tmp/skills_index.json "$output"
            echo -e "  ${GREEN}✓${NC} Index généré: $output"
        else
            echo -e "  ${RED}✗${NC} JSON invalide généré!"
            cat /tmp/skills_index.json
            return 1
        fi
    fi
}

# ============================================================================
# GÉNÉRATION INDEX AGENTS
# ============================================================================

generate_agents_index() {
    echo ""
    echo -e "${BLUE}🤖 Génération index Agents${NC}"
    echo "────────────────────────────────────────"
    
    local output=".kiro/agents/_index.generated.json"
    local agents_found=0
    
    # Début du JSON
    cat > /tmp/agents_index.json << 'EOF'
{
  "version": "1.0",
  "description": "Index des agents - GÉNÉRÉ AUTOMATIQUEMENT",
  "lastUpdated": "TIMESTAMP",
  
  "routingStrategy": {
    "mode": "keyword-match",
    "fallback": "coordinator-agent",
    "allowManualSwitch": true
  },
  
  "agents": [
EOF
    
    sed -i "s/TIMESTAMP/$(date -Iseconds)/" /tmp/agents_index.json
    
    first=true
    default_agent=""
    
    # Scanner tous les agents
    for agent_file in .kiro/agents/*.json; do
        if [ -f "$agent_file" ] && [ "$(basename $agent_file)" != "_index.json" ] && [ "$(basename $agent_file)" != "_index.generated.json" ]; then
            agent_name=$(basename "$agent_file" .json)
            
            echo "  Trouvé: $agent_name"
            
            # Extraire les infos du fichier
            name=$(grep '"name"' "$agent_file" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "$agent_name")
            display_name=$(grep '"displayName"' "$agent_file" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "$name")
            description=$(grep '"description"' "$agent_file" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Agent $name")
            
            # Détecter si c'est le default (coordinator)
            is_default=false
            if echo "$agent_name" | grep -q "coordinator"; then
                is_default=true
                default_agent="$name"
            fi
            
            if ! $first; then
                echo "," >> /tmp/agents_index.json
            fi
            first=false
            
            cat >> /tmp/agents_index.json << EOF
    {
      "name": "$name",
      "displayName": "$display_name",
      "description": "$description",
      "file": "$(basename $agent_file)",
      "isDefault": $is_default
    }
EOF
            
            agents_found=$((agents_found + 1))
        fi
    done
    
    # Fin du JSON
    cat >> /tmp/agents_index.json << EOF

  ],
  
  "statistics": {
    "totalAgents": $agents_found,
    "defaultAgent": "$default_agent"
  }
}
EOF
    
    echo ""
    echo "  Agents trouvés: $agents_found"
    
    if $DRY_RUN; then
        echo ""
        echo -e "${YELLOW}[DRY-RUN] Fichier qui serait généré:${NC}"
        cat /tmp/agents_index.json
    else
        if python3 -c "import json; json.load(open('/tmp/agents_index.json'))" 2>/dev/null; then
            mv /tmp/agents_index.json "$output"
            echo -e "  ${GREEN}✓${NC} Index généré: $output"
        else
            echo -e "  ${RED}✗${NC} JSON invalide généré!"
            return 1
        fi
    fi
}

# ============================================================================
# GÉNÉRATION INDEX SPECS
# ============================================================================

generate_specs_index() {
    echo ""
    echo -e "${BLUE}📝 Génération index Specs${NC}"
    echo "────────────────────────────────────────"
    
    local output=".kiro/specs/_index.generated.json"
    local specs_found=0
    local total_tokens=0
    
    # Début du JSON
    cat > /tmp/specs_index.json << 'EOF'
{
  "version": "1.0",
  "description": "Index des specs - GÉNÉRÉ AUTOMATIQUEMENT",
  "lastUpdated": "TIMESTAMP",
  
  "loadingStrategy": {
    "mode": "explicit",
    "note": "Les specs ne sont chargées que sur demande explicite"
  },
  
  "specs": [
EOF
    
    sed -i "s/TIMESTAMP/$(date -Iseconds)/" /tmp/specs_index.json
    
    first=true
    
    # Scanner toutes les specs
    for spec_file in .kiro/specs/*.md; do
        if [ -f "$spec_file" ]; then
            spec_name=$(basename "$spec_file" .md)
            
            echo "  Trouvé: $spec_name"
            
            # Extraire la première ligne de titre
            description=$(head -5 "$spec_file" | grep "^#" | head -1 | sed 's/^#* *//' || echo "Spec $spec_name")
            
            tokens=$(count_tokens "$spec_file")
            total_tokens=$((total_tokens + tokens))
            
            if ! $first; then
                echo "," >> /tmp/specs_index.json
            fi
            first=false
            
            cat >> /tmp/specs_index.json << EOF
    {
      "name": "$spec_name",
      "path": "$(basename $spec_file)",
      "description": "$description",
      "tokenEstimate": $tokens
    }
EOF
            
            specs_found=$((specs_found + 1))
        fi
    done
    
    # Fin du JSON
    cat >> /tmp/specs_index.json << EOF

  ],
  
  "statistics": {
    "totalSpecs": $specs_found,
    "totalTokensIfAllLoaded": $total_tokens
  }
}
EOF
    
    echo ""
    echo "  Specs trouvées: $specs_found"
    
    if $DRY_RUN; then
        echo ""
        echo -e "${YELLOW}[DRY-RUN] Fichier qui serait généré:${NC}"
        cat /tmp/specs_index.json
    else
        if python3 -c "import json; json.load(open('/tmp/specs_index.json'))" 2>/dev/null; then
            mv /tmp/specs_index.json "$output"
            echo -e "  ${GREEN}✓${NC} Index généré: $output"
        else
            echo -e "  ${RED}✗${NC} JSON invalide généré!"
            return 1
        fi
    fi
}

# ============================================================================
# MAIN
# ============================================================================

generate_skills_index
generate_agents_index
generate_specs_index

echo ""
echo "═══════════════════════════════════════════════════════════════"
if $DRY_RUN; then
    echo -e "${YELLOW}Mode dry-run terminé - aucun fichier modifié${NC}"
    echo ""
    echo "Pour appliquer les changements:"
    echo "  $0"
else
    echo -e "${GREEN}Index générés avec succès !${NC}"
    echo ""
    echo "Fichiers créés:"
    echo "  - .kiro/skills/_index.generated.json"
    echo "  - .kiro/agents/_index.generated.json"
    echo "  - .kiro/specs/_index.generated.json"
    echo ""
    echo "Pour remplacer les index existants:"
    echo "  mv .kiro/skills/_index.generated.json .kiro/skills/_index.json"
    echo "  mv .kiro/agents/_index.generated.json .kiro/agents/_index.json"
    echo "  mv .kiro/specs/_index.generated.json .kiro/specs/_index.json"
fi
echo "═══════════════════════════════════════════════════════════════"
