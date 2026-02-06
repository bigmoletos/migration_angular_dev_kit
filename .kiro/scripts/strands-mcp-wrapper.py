#!/usr/bin/env python3
"""
Strands Agents MCP Server Wrapper
AWS Strands Agents SDK pour workflow stateful
"""
import sys
import os
from pathlib import Path

# Configuration
STRANDS_CONFIG = os.environ.get('STRANDS_CONFIG', '.kiro/strands/config.json')
STRANDS_STATE_PATH = os.environ.get('STRANDS_STATE_PATH', '.kiro/state/strands-state.json')

# Nettoyer le PATH pour éviter les problèmes de permissions Windows
if sys.platform == 'win32':
    path_entries = os.environ.get('PATH', '').split(os.pathsep)
    filtered_paths = [
        p for p in path_entries 
        if 'WindowsApps' not in p and 'Administrateur' not in p
    ]
    os.environ['PATH'] = os.pathsep.join(filtered_paths)

# Importer Strands Agents (le package s'appelle 'strands', pas 'strands_agents')
try:
    from strands import mcp
    
    if __name__ == '__main__':
        # Lancer le serveur MCP Strands Agents
        print(f"Démarrage Strands Agents MCP Server...", file=sys.stderr)
        print(f"Config: {STRANDS_CONFIG}", file=sys.stderr)
        print(f"State: {STRANDS_STATE_PATH}", file=sys.stderr)
        
        mcp.run_server()
        
except ImportError as e:
    print(f"Erreur: Module strands non trouvé.", file=sys.stderr)
    print(f"Installez-le avec: Use-Python312; pip install --user strands-agents", file=sys.stderr)
    print(f"Détails: {e}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Erreur lors du démarrage du serveur MCP Strands: {e}", file=sys.stderr)
    import traceback
    traceback.print_exc()
    sys.exit(1)
